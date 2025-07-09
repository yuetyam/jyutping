import Foundation
import SQLite3
import CoreIME
import CommonExtensions

struct UserLexicon {

        nonisolated(unsafe) private static let database: OpaquePointer? = {
                var db: OpaquePointer? = nil
                let path: String? = {
                        let fileName: String = "userlexicon.sqlite3"
                        if #available(macOS 13.0, *) {
                                return URL.libraryDirectory.appending(path: fileName, directoryHint: .notDirectory).path()
                        } else {
                                guard let libraryDirectoryUrl: URL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else { return nil }
                                return libraryDirectoryUrl.appendingPathComponent(fileName, isDirectory: false).path
                        }
                }()
                guard let path else { return nil }
                guard sqlite3_open_v2(path, &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX, nil) == SQLITE_OK else { return nil }
                return db
        }()

        static func prepare() {
                let command: String = "CREATE TABLE IF NOT EXISTS lexicon(id INTEGER NOT NULL PRIMARY KEY,input INTEGER NOT NULL,ping INTEGER NOT NULL,prefix INTEGER NOT NULL,shortcut INTEGER NOT NULL,frequency INTEGER NOT NULL,word TEXT NOT NULL,jyutping TEXT NOT NULL);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }

        static func handle(_ candidate: Candidate?) {
                guard let candidate else { return }
                let id: Int = (candidate.lexiconText + candidate.romanization).hash
                if let frequency = find(by: id) {
                        update(id: id, frequency: frequency + 1)
                } else {
                        let romanization: String = candidate.romanization
                        let entry = LexiconEntry(
                                id: id,
                                input: candidate.input.hash,
                                ping: romanization.pingCode,
                                prefix: romanization.shortcutCode,
                                shortcut: romanization.shortcutCode,
                                frequency: 1,
                                word: candidate.lexiconText,
                                jyutping: romanization
                        )
                        insert(entry: entry)
                }
        }
        private static func find(by id: Int) -> Int64? {
                let command: String = "SELECT frequency FROM lexicon WHERE id = \(id) LIMIT 1;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return nil }
                guard sqlite3_step(statement) == SQLITE_ROW else { return nil }
                let frequency: Int64 = sqlite3_column_int64(statement, 0)
                return frequency
        }
        private static func update(id: Int, frequency: Int64) {
                let command: String = "UPDATE lexicon SET frequency = \(frequency) WHERE id = \(id);"
                var statement: OpaquePointer?
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }
        private static func insert(entry: LexiconEntry) {
                // INSERT INTO lexicon (id, input, ping, prefix, shortcut, frequency, word, jyutping) VALUES (?, ?, ?, ?, ?, ?, ?, ?);
                let leading: String = "INSERT INTO lexicon (id, input, ping, prefix, shortcut, frequency, word, jyutping) VALUES ("
                let trailing: String = ");"
                let values: String = "\(entry.id), \(entry.input), \(entry.ping), \(entry.prefix), \(entry.shortcut), \(entry.frequency), '\(entry.word)', '\(entry.jyutping)'"
                let command: String = leading + values + trailing
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
                        let latest: Int64 = 1 // sqlite3_column_int64(statement, 3)
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
                        let latest: Int64 = 1 // sqlite3_column_int64(statement, 3)
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
                        let latest: Int64 = 1 // sqlite3_column_int64(statement, 3)
                        let romanization: String = String(cString: romanizationText)
                        let mark: String = mark ?? romanization.removedTones()
                        let instance = InternalLexicon(word: String(cString: word), romanization: romanization, frequency: frequency, latest: latest, input: input, mark: mark)
                        items.append(instance)
                }
                return items
        }

        private static let shortcutQuery: String = "SELECT word, jyutping, frequency FROM lexicon WHERE shortcut = ? ORDER BY frequency DESC LIMIT ?;"
        static func prepareShortcutStatement() -> OpaquePointer? {
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(database, shortcutQuery, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }
        private static let pingQuery: String = "SELECT word, jyutping, frequency FROM lexicon WHERE ping = ? ORDER BY frequency DESC LIMIT ?;"
        static func preparePingStatement() -> OpaquePointer? {
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(database, pingQuery, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }
        private static let strictQuery: String = "SELECT word, jyutping, frequency FROM lexicon WHERE ping = ? AND shortcut = ? ORDER BY frequency DESC LIMIT ?;"
        static func prepareStrictStatement() -> OpaquePointer? {
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(database, strictQuery, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }

        /// Delete one lexicon entry
        static func removeItem(candidate: Candidate) {
                let id: Int = (candidate.lexiconText + candidate.romanization).hash
                let command: String = "DELETE FROM lexicon WHERE id = \(id);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }

        /// Clear User Lexicon
        static func deleteAll() {
                let command: String = "DELETE FROM lexicon;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
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

private struct LexiconEntry {

        /// (Candidate.lexiconText + Candidate.jyutping).hash
        let id: Int

        /// input.hash
        let input: Int

        /// jyutping.withoutTonesAndSpaces.hash
        let ping: Int

        /// (deprecated)
        let prefix: Int

        /// jyutping.anchors.hash
        let shortcut: Int

        let frequency: Int

        /// Candidate.lexiconText
        let word: String

        let jyutping: String
}
