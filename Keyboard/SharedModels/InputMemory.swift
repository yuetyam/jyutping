import Foundation
import SQLite3
import CoreIME
import CommonExtensions

struct InputMemory {

        // MARK: - Migration

        private static func performMigration() async {
                guard isLegacyDatabaseExist else {
                        missionAccomplished()
                        return
                }
                switch savedInputMemoryVersion {
                case definedInputMemoryVersion:
                        missionAccomplished()
                case 1:
                        fetchLegacy(lower: 0, upper: 1).forEach(migrate(_:))
                        missionAccomplished()
                case 5:
                        fetchLegacy(lower: 1, upper: 5).forEach(migrate(_:))
                        UserDefaults.standard.set(1, forKey: kInputMemoryVersion)

                        fetchLegacy(lower: 0, upper: 1).forEach(migrate(_:))
                        missionAccomplished()
                case 20:
                        fetchLegacy(lower: 5, upper: 20).forEach(migrate(_:))
                        UserDefaults.standard.set(5, forKey: kInputMemoryVersion)

                        fetchLegacy(lower: 1, upper: 5).forEach(migrate(_:))
                        UserDefaults.standard.set(1, forKey: kInputMemoryVersion)

                        fetchLegacy(lower: 0, upper: 1).forEach(migrate(_:))
                        missionAccomplished()
                default:
                        fetchLegacy(lower: 20, upper: 10_0000).forEach(migrate(_:))
                        UserDefaults.standard.set(20, forKey: kInputMemoryVersion)

                        fetchLegacy(lower: 5, upper: 20).forEach(migrate(_:))
                        UserDefaults.standard.set(5, forKey: kInputMemoryVersion)

                        fetchLegacy(lower: 1, upper: 5).forEach(migrate(_:))
                        UserDefaults.standard.set(1, forKey: kInputMemoryVersion)

                        fetchLegacy(lower: 0, upper: 1).forEach(migrate(_:))
                        missionAccomplished()
                }
        }
        private static func missionAccomplished() {
                UserDefaults.standard.set(definedInputMemoryVersion, forKey: kInputMemoryVersion)
        }

        nonisolated(unsafe) private static let legacyDatabase: OpaquePointer? = {
                var db: OpaquePointer? = nil
                let path: String? = {
                        let fileName: String = "userlexicon.sqlite3"
                        if #available(iOSApplicationExtension 16.0, *) {
                                return URL.libraryDirectory.appending(path: fileName, directoryHint: .notDirectory).path()
                        } else {
                                guard let libraryDirectoryUrl: URL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else { return nil }
                                return libraryDirectoryUrl.appendingPathComponent(fileName, isDirectory: false).path
                        }
                }()
                guard let path else { return nil }
                guard sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY | SQLITE_OPEN_FULLMUTEX, nil) == SQLITE_OK else { return nil }
                return db
        }()

        private static var isLegacyDatabaseExist: Bool {
                let command: String = "SELECT frequency FROM lexicon WHERE frequency = 1 LIMIT 1;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(legacyDatabase, command, -1, &statement, nil) == SQLITE_OK else { return false }
                guard sqlite3_step(statement) == SQLITE_ROW else { return false }
                let frequency: Int64 = sqlite3_column_int64(statement, 0)
                return frequency == 1
        }

        // lexicon(id INTEGER,input INTEGER,ping INTEGER,prefix INTEGER,shortcut INTEGER,frequency INTEGER,word TEXT,jyutping TEXT)

        private static func fetchLegacy(lower: Int, upper: Int) -> [MemoryLexicon] {
                let command: String = "SELECT frequency, word, jyutping FROM lexicon WHERE frequency > \(lower) AND frequency <= \(upper);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(legacyDatabase, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                var items: [MemoryLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let frequency: Int64 = sqlite3_column_int64(statement, 0)
                        guard let word = sqlite3_column_text(statement, 1) else { continue }
                        guard let jyutping = sqlite3_column_text(statement, 2) else { continue }
                        let instance = MemoryLexicon(word: String(cString: word), romanization: String(cString: jyutping), frequency: Int(frequency))
                        items.append(instance)
                }
                return items
        }

        private static let definedInputMemoryVersion: Int = 2025
        private static let kInputMemoryVersion: String = "InputMemoryVersion"
        private static var savedInputMemoryVersion: Int {
                return UserDefaults.standard.integer(forKey: kInputMemoryVersion)
        }


        // MARK: - Preparing

        static func prepare() {
                ensureMemoryTable()
                let isMigrated: Bool = (savedInputMemoryVersion == definedInputMemoryVersion)
                guard isMigrated.negative else { return }
                Task {
                        await performMigration()
                }
        }

        private static let pathToDatabase: String? = {
                let fileName: String = "memory.sqlite3"
                if #available(iOSApplicationExtension 16.0, *) {
                        return URL.libraryDirectory.appending(path: fileName, directoryHint: .notDirectory).path()
                } else {
                        guard let libraryDirectoryUrl: URL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else { return nil }
                        return libraryDirectoryUrl.appendingPathComponent(fileName, isDirectory: false).path
                }
        }()
        nonisolated(unsafe) private static let database: OpaquePointer? = {
                var db: OpaquePointer? = nil
                guard let path = pathToDatabase else { return nil }
                guard sqlite3_open_v2(path, &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX, nil) == SQLITE_OK else { return nil }
                return db
        }()
        private static func ensureMemoryTable() {
                let command: String = "CREATE TABLE IF NOT EXISTS memory(identifier INTEGER NOT NULL PRIMARY KEY, word TEXT NOT NULL, romanization TEXT NOT NULL, frequency INTEGER NOT NULL, latest INTEGER NOT NULL, anchors INTEGER NOT NULL, shortcut INTEGER NOT NULL, ping INTEGER NOT NULL, tenkeyanchors INTEGER NOT NULL, tenkeycode INTEGER NOT NULL);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }


        // MARK: - Candidate Handling

        static func handle(_ candidate: Candidate) {
                let identifier: Int = candidate.identifier
                if let frequency = find(by: identifier) {
                        update(identifier: identifier, frequency: frequency + 1)
                } else {
                        let entry = MemoryLexicon(word: candidate.lexiconText, romanization: candidate.romanization, frequency: 1)
                        insert(entry: entry)
                }
        }

        private static func migrate(_ entry: MemoryLexicon) {
                if let frequency = find(by: entry.identifier) {
                        let newFrequency: Int64 = max(frequency, Int64(entry.frequency))
                        update(identifier: entry.identifier, frequency: newFrequency)
                } else {
                        insert(entry: entry)
                }
        }

        private static func find(by identifier: Int) -> Int64? {
                let command: String = "SELECT frequency FROM memory WHERE identifier = \(identifier) LIMIT 1;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return nil }
                guard sqlite3_step(statement) == SQLITE_ROW else { return nil }
                return sqlite3_column_int64(statement, 0)
        }
        private static func update(identifier: Int, frequency: Int64) {
                let latest: Int = Int(Date.now.timeIntervalSince1970 * 1000)
                let command: String = "UPDATE memory SET frequency = \(frequency), latest = \(latest) WHERE identifier = \(identifier);"
                var statement: OpaquePointer?
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }
        private static func insert(entry: MemoryLexicon) {
                let leading: String = "INSERT INTO memory (identifier, word, romanization, frequency, latest, anchors, shortcut, ping, tenkeyanchors, tenkeycode) VALUES ("
                let trailing: String = ");"
                let values: String = "\(entry.identifier), '\(entry.word)', '\(entry.romanization)', \(entry.frequency), \(entry.latest), \(entry.anchors), \(entry.shortcut), \(entry.ping), \(entry.tenKeyAnchors), \(entry.tenKeyCode)"
                let command: String = leading + values + trailing
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }

        /// Delete a Candidate from InputMemory
        static func remove(candidate: Candidate) {
                let identifier: Int = candidate.identifier
                let command: String = "DELETE FROM memory WHERE identifier = \(identifier);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }

        /// Clear Input Memory
        static func deleteAll() {
                let command: String = "DELETE FROM memory;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }


        // MARK: - Suggestions

        static func suggest<T: RandomAccessCollection<InputEvent>>(events: T, segmentation: Segmentation) async -> [Candidate] {
                guard events.contains(where: \.isSyllableLetter.negative).negative else { return [] }
                lazy var shortcutStatement = prepareShortcutStatement()
                lazy var pingStatement = preparePingStatement()
                lazy var strictStatement = prepareStrictStatement()
                defer {
                        sqlite3_finalize(shortcutStatement)
                        sqlite3_finalize(pingStatement)
                        sqlite3_finalize(strictStatement)
                }
                let inputLength = events.count
                let text = events.map(\.text).joined()
                let matches = pingMatch(text: text, input: text, statement: pingStatement)
                let shortcuts = shortcutMatch(text: text, input: text, statement: shortcutStatement)
                let idealSchemes = segmentation.filter({ $0.length == inputLength })
                let searched: [InternalLexicon] = idealSchemes.isEmpty ? [] : idealSchemes.flatMap({ scheme -> [InternalLexicon] in
                        let pingCode: Int = scheme.originText.hash
                        let shortcutCode: Int = scheme.originAnchorsText.hash
                        let matched = strictMatch(ping: pingCode, shortcut: shortcutCode, input: text, statement: strictStatement)
                        guard matched.isNotEmpty else { return [] }
                        let mark = scheme.mark
                        let syllables = scheme.syllableText
                        return matched.compactMap({ item -> InternalLexicon? in
                                guard item.mark == syllables else { return nil }
                                return InternalLexicon(word: item.word, romanization: item.romanization, frequency: item.frequency, latest: item.latest, input: text, mark: mark)
                        })
                })
                let shouldMatchPrefixes: Bool = {
                        guard matches.isEmpty && shortcuts.isEmpty && searched.isEmpty else { return false }
                        guard idealSchemes.isNotEmpty else { return true }
                        return (events.last == .letterM) || (events.first == .letterM)
                }()
                guard shouldMatchPrefixes else {
                        return (matches + shortcuts + searched)
                                .uniqued()
                                .sorted()
                                .prefix(5)
                                .map({ Candidate(text: $0.word, romanization: $0.romanization, input: text, mark: $0.mark, order: -1) })
                }
                let prefixMatched: [InternalLexicon] = segmentation.flatMap({ scheme -> [InternalLexicon] in
                        let tail = events.dropFirst(scheme.length)
                        guard let lastAnchor = tail.first else { return [] }
                        let schemeAnchors = scheme.aliasAnchors
                        let conjoinedText: String = (schemeAnchors + tail).map(\.text).joined()
                        let anchorsText: String = (schemeAnchors + [lastAnchor]).map(\.text).joined()
                        let schemeMark: String = scheme.mark
                        let mark: String = schemeMark + String.space + tail.map(\.text).joined()
                        let conjoinedMatched = shortcutMatch(text: conjoinedText, input: conjoinedText, statement: shortcutStatement)
                                .compactMap({ item -> InternalLexicon? in
                                        let toneFreeRomanization = item.romanization.removedTones()
                                        guard toneFreeRomanization.hasPrefix(schemeMark) else { return nil }
                                        let tailAnchors = toneFreeRomanization.dropFirst(schemeMark.count).split(separator: Character.space).compactMap(\.first)
                                        guard tailAnchors == tail.compactMap(\.text.first) else { return nil }
                                        return InternalLexicon(word: item.word, romanization: item.romanization, frequency: item.frequency, latest: item.latest, input: text, mark: mark)
                                })
                        let anchorsMatched = shortcutMatch(text: anchorsText, input: anchorsText, statement: shortcutStatement)
                                .compactMap({ item -> InternalLexicon? in
                                        guard item.romanization.removedTones().hasPrefix(mark) else { return nil }
                                        return InternalLexicon(word: item.word, romanization: item.romanization, frequency: item.frequency, latest: item.latest, input: text, mark: mark)
                                })
                        return conjoinedMatched + anchorsMatched
                })
                let gainedMatched: [InternalLexicon] = (1..<inputLength)
                        .flatMap({ number -> [InternalLexicon] in
                                let leadingText = events.dropLast(number).map(\.text).joined()
                                return shortcutMatch(text: leadingText, input: leadingText, statement: shortcutStatement)
                        })
                        .compactMap({ item -> InternalLexicon? in
                                guard item.romanization.hasPrefix(text).negative else {
                                        return InternalLexicon(word: item.word, romanization: item.romanization, frequency: item.frequency, latest: item.latest, input: text, mark: text)
                                }
                                let syllables = item.romanization.removedTones().split(separator: Character.space)
                                guard let lastSyllable = syllables.last else { return nil }
                                guard text.hasSuffix(lastSyllable) else { return nil }
                                let isMatched: Bool = ((syllables.count - 1) + lastSyllable.count) == inputLength
                                guard isMatched else { return nil }
                                return InternalLexicon(word: item.word, romanization: item.romanization, frequency: item.frequency, latest: item.latest, input: text, mark: text)
                        })
                return (prefixMatched + gainedMatched)
                        .uniqued()
                        .sorted()
                        .prefix(5)
                        .map({ Candidate(text: $0.word, romanization: $0.romanization, input: text, mark: $0.mark, order: -1) })
        }

        private static func shortcutMatch<T: StringProtocol>(text: T, input: String, limit: Int64? = nil, statement: OpaquePointer?) -> [InternalLexicon] {
                let code = text.replacingOccurrences(of: "y", with: "j").hash
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(code))
                sqlite3_bind_int64(statement, 2, (limit ?? 100))
                var items: [InternalLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        guard let word = sqlite3_column_text(statement, 0) else { continue }
                        guard let romanizationText = sqlite3_column_text(statement, 1) else { continue }
                        let frequency = sqlite3_column_int64(statement, 2)
                        let latest = sqlite3_column_int64(statement, 3)
                        let romanization: String = String(cString: romanizationText)
                        let instance = InternalLexicon(word: String(cString: word), romanization: romanization, frequency: frequency, latest: latest, input: input, mark: input)
                        items.append(instance)
                }
                return items
        }
        private static func pingMatch<T: StringProtocol>(text: T, input: String, mark: String? = nil, limit: Int64? = nil, statement: OpaquePointer?) -> [InternalLexicon] {
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(text.hash))
                sqlite3_bind_int64(statement, 2, (limit ?? 100))
                var items: [InternalLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        guard let word = sqlite3_column_text(statement, 0) else { continue }
                        guard let romanizationText = sqlite3_column_text(statement, 1) else { continue }
                        let frequency = sqlite3_column_int64(statement, 2)
                        let latest = sqlite3_column_int64(statement, 3)
                        let romanization: String = String(cString: romanizationText)
                        let mark: String = mark ?? romanization.removedTones()
                        let instance = InternalLexicon(word: String(cString: word), romanization: romanization, frequency: frequency, latest: latest, input: input, mark: mark)
                        items.append(instance)
                }
                return items
        }
        private static func strictMatch(ping: Int, shortcut: Int, input: String, mark: String? = nil, limit: Int64? = nil, statement: OpaquePointer?) -> [InternalLexicon] {
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(ping))
                sqlite3_bind_int64(statement, 2, Int64(shortcut))
                sqlite3_bind_int64(statement, 3, (limit ?? 100))
                var items: [InternalLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        guard let word = sqlite3_column_text(statement, 0) else { continue }
                        guard let romanizationText = sqlite3_column_text(statement, 1) else { continue }
                        let frequency = sqlite3_column_int64(statement, 2)
                        let latest = sqlite3_column_int64(statement, 3)
                        let romanization: String = String(cString: romanizationText)
                        let mark: String = mark ?? romanization.removedTones()
                        let instance = InternalLexicon(word: String(cString: word), romanization: romanization, frequency: frequency, latest: latest, input: input, mark: mark)
                        items.append(instance)
                }
                return items
        }

        private static let shortcutQuery: String = "SELECT word, romanization, frequency, latest FROM memory WHERE shortcut = ? ORDER BY frequency DESC LIMIT ?;"
        static func prepareShortcutStatement() -> OpaquePointer? {
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(database, shortcutQuery, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }
        private static let pingQuery: String = "SELECT word, romanization, frequency, latest FROM memory WHERE ping = ? ORDER BY frequency DESC LIMIT ?;"
        static func preparePingStatement() -> OpaquePointer? {
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(database, pingQuery, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }
        private static let strictQuery: String = "SELECT word, romanization, frequency, latest FROM memory WHERE ping = ? AND shortcut = ? ORDER BY frequency DESC LIMIT ?;"
        static func prepareStrictStatement() -> OpaquePointer? {
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(database, strictQuery, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }


        // MARK: - TenKey Suggestions

        static func tenKeySuggest(combos: [Combo]) async -> [Candidate] {
                let inputLength: Int = combos.count
                guard inputLength < 19 else { return [] }
                let code: Int = combos.map(\.rawValue).decimalCombined()
                let command: String = "SELECT word, romanization FROM memory WHERE tenkeycode = \(code) OR tenkeyanchors = \(code) ORDER BY frequency DESC LIMIT 6;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                var candidates: [Candidate] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        guard let word = sqlite3_column_text(statement, 0) else { continue }
                        guard let romanizationText = sqlite3_column_text(statement, 1) else { continue }
                        let romanization: String = String(cString: romanizationText)
                        let letterText: String = romanization.filter(\.isLowercaseBasicLatinLetter)
                        let isFullMatched: Bool = (letterText.count == inputLength)
                        lazy var anchorText: String = String(romanization.split(separator: Character.space).compactMap(\.first))
                        let input: String = isFullMatched ? letterText : anchorText
                        let mark: String = isFullMatched ? romanization.removedTones() : anchorText
                        let instance = Candidate(text: String(cString: word), romanization: romanization, input: input, mark: mark, order: -1)
                        candidates.append(instance)
                }
                return candidates
        }
}

private struct InternalLexicon: Hashable, Comparable {
        let word: String
        let romanization: String
        let frequency: Int64
        let latest: Int64
        let input: String
        let mark: String
        static func == (lhs: InternalLexicon, rhs: InternalLexicon) -> Bool {
                return (lhs.word == rhs.word) && (lhs.romanization == rhs.romanization)
        }
        func hash(into hasher: inout Hasher) {
                hasher.combine(word)
                hasher.combine(romanization)
        }
        static func < (lhs: InternalLexicon, rhs: InternalLexicon) -> Bool {
                guard lhs.frequency == rhs.frequency else { return lhs.frequency > rhs.frequency }
                return lhs.latest > rhs.latest
        }
}

private extension Candidate {
        /// MemoryLexicon identifier
        var identifier: Int {
                return (lexiconText + String.period + romanization).hash
        }
}
