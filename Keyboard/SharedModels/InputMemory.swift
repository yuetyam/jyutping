import Foundation
import SQLite3
import CoreIME
import CommonExtensions

struct InputMemory {

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

        static func prepare() {
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
                switch (events.contains(where: \.isApostrophe), events.contains(where: \.isToneEvent)) {
                case (false, false):
                        return search(events: events, segmentation: segmentation)
                case (true, true):
                        let syllableEvents = events.filter(\.isSyllableLetter)
                        let candidates = search(events: syllableEvents, segmentation: segmentation)
                        let inputText = events.map(\.text).joined()
                        let text = inputText.toneConverted()
                        return candidates.compactMap({ item -> Candidate? in
                                guard text.hasPrefix(item.romanization) else { return nil }
                                return item.replacedInput(with: inputText)
                        })
                case (false, true):
                        let syllableEvents = events.filter(\.isSyllableLetter)
                        let candidates = search(events: syllableEvents, segmentation: segmentation)
                        let inputText = events.map(\.text).joined()
                        let text = inputText.toneConverted()
                        let textTones = text.tones
                        let qualified: [Candidate] = candidates.compactMap({ item -> Candidate? in
                                let syllableText = item.romanization.filter(\.isSpace.negative)
                                guard syllableText != text else { return item.replacedInput(with: inputText) }
                                let tones = syllableText.tones
                                switch (textTones.count, tones.count) {
                                case (1, 1):
                                        guard (text.last?.isCantoneseToneDigit ?? false) else { return nil }
                                        guard textTones == tones else { return nil }
                                        return item.replacedInput(with: inputText)
                                case (1, 2):
                                        let isToneLast: Bool = text.last?.isCantoneseToneDigit ?? false
                                        if isToneLast {
                                                guard tones.hasSuffix(textTones) else { return nil }
                                                let isCorrectPosition: Bool = text.dropFirst(item.inputCount).first?.isCantoneseToneDigit ?? false
                                                guard isCorrectPosition else { return nil }
                                                return item.replacedInput(with: inputText)
                                        } else {
                                                guard tones.hasPrefix(textTones) else { return nil }
                                                return item.replacedInput(with: inputText)
                                        }
                                case (2, 2):
                                        guard (text.last?.isCantoneseToneDigit ?? false) else { return nil }
                                        guard textTones == tones else { return nil }
                                        guard item.inputCount == (text.count - 2) else { return nil }
                                        return item.replacedInput(with: inputText)
                                default:
                                        guard inputText != syllableText else { return item.replacedInput(with: inputText) }
                                        return nil
                                }
                        })
                        return qualified
                case (true, false):
                        let syllableEvents = events.filter(\.isSyllableLetter)
                        let candidates = search(events: syllableEvents, segmentation: segmentation)
                        let isHeadingSeparator: Bool = events.first?.isApostrophe ?? false
                        let isTrailingSeparator: Bool = events.last?.isApostrophe ?? false
                        guard isHeadingSeparator.negative else { return [] }
                        let inputSeparatorCount = events.count(where: \.isApostrophe)
                        let eventLength = events.count
                        let text = events.map(\.text).joined()
                        let textParts = text.split(separator: Character.apostrophe)
                        let qualified: [Candidate] = candidates.compactMap({ item -> Candidate? in
                                let syllables = item.romanization.removedTones().split(separator: Character.space)
                                guard syllables != textParts else { return item.replacedInput(with: text) }
                                switch inputSeparatorCount {
                                case 1 where isTrailingSeparator:
                                        guard syllables.count == 1 else { return nil }
                                        guard item.inputCount == (eventLength - 1) else { return nil }
                                        return item.replacedInput(with: text)
                                case 1:
                                        guard syllables.count == 2 else { return nil }
                                        let isMatched: Bool = {
                                                guard eventLength != 3 else { return true }
                                                guard syllables.first != textParts.first else { return true }
                                                guard textParts.first?.count == 1 else { return false }
                                                guard textParts.first?.first == syllables.first?.first else { return false }
                                                guard let lastSyllable = syllables.last else { return false }
                                                return textParts.last?.hasPrefix(lastSyllable) ?? false
                                        }()
                                        guard isMatched else { return nil }
                                        return item.replacedInput(with: text)
                                case 2 where isTrailingSeparator:
                                        guard syllables.count == 2 else { return nil }
                                        guard item.inputCount == (eventLength - 2) else { return nil }
                                        let isMatched: Bool = {
                                                guard eventLength != 4 else { return true }
                                                guard syllables.first != textParts.first else { return true }
                                                guard textParts.first?.count == 1 else { return false }
                                                guard textParts.first?.first == syllables.first?.first else { return false }
                                                return textParts.last == syllables.last
                                        }()
                                        guard isMatched else { return nil }
                                        return item.replacedInput(with: text)
                                case 2 where eventLength == 5 && textParts.count == 3,
                                        3 where eventLength == 6 && textParts.count == 3:
                                        guard syllables.count == 3 else { return nil }
                                        return item.replacedInput(with: text)
                                default:
                                        return nil
                                }
                        })
                        return qualified
                }
        }
        private static func search<T: RandomAccessCollection<InputEvent>>(events: T, segmentation: Segmentation) -> [Candidate] {
                lazy var shortcutStatement = prepareShortcutStatement()
                lazy var pingStatement = preparePingStatement()
                lazy var strictStatement = prepareStrictStatement()
                defer {
                        sqlite3_finalize(shortcutStatement)
                        sqlite3_finalize(pingStatement)
                        sqlite3_finalize(strictStatement)
                }
                let eventLength = events.count
                let text = events.map(\.text).joined()
                let matches = pingMatch(text: text, input: text, statement: pingStatement)
                let idealSchemes = segmentation.filter({ $0.length == eventLength })
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
                guard matches.isEmpty && searched.isEmpty else {
                        return (matches + searched).distinct().map({ Candidate(text: $0.word, romanization: $0.romanization, input: text, mark: $0.mark, order: -1) })
                }
                let shortcuts = shortcutMatch(text: text, input: text, limit: 5, statement: shortcutStatement)
                guard shortcuts.isEmpty else {
                        return shortcuts.map({ Candidate(text: $0.word, romanization: $0.romanization, input: text, mark: $0.mark, order: -1) })
                }
                let shouldContinue: Bool = idealSchemes.isEmpty || (events.last == InputEvent.letterM) || (events.first == InputEvent.letterM)
                guard shouldContinue else { return [] }
                let prefixMatched: [InternalLexicon] = segmentation.flatMap({ scheme -> [InternalLexicon] in
                        guard scheme.isNotEmpty else { return [] }
                        let tail = events.dropFirst(scheme.length)
                        guard tail.isNotEmpty else { return [] }
                        let schemeAnchors = scheme.aliasAnchors
                        let conjoinedText: String = (schemeAnchors + tail).map(\.text).joined()
                        let schemeSyllableText: String = scheme.syllableText
                        let mark: String = scheme.mark + String.space + tail.map(\.text).joined()
                        let tailAsAnchorText = tail.compactMap({ $0 == InputEvent.letterY ? InputEvent.letterJ.text.first : $0.text.first })
                        let conjoinedMatched = shortcutMatch(text: conjoinedText, input: conjoinedText, statement: shortcutStatement)
                                .compactMap({ item -> InternalLexicon? in
                                        let toneFreeRomanization = item.romanization.removedTones()
                                        guard toneFreeRomanization.hasPrefix(schemeSyllableText) else { return nil }
                                        let suffixAnchorText = toneFreeRomanization.dropFirst(schemeSyllableText.count).split(separator: Character.space).compactMap(\.first)
                                        guard suffixAnchorText == tailAsAnchorText else { return nil }
                                        return InternalLexicon(word: item.word, romanization: item.romanization, frequency: item.frequency, latest: item.latest, input: text, mark: mark)
                                })
                        let transformedTailText = tail.enumerated().map({ $0.offset == 0 && $0.element == InputEvent.letterY ? InputEvent.letterJ.text : $0.element.text }).joined()
                        let syllableText: String = schemeSyllableText + String.space + transformedTailText
                        let anchorsText: String = schemeAnchors.map(\.text).joined() + (tail.first?.text ?? String.empty)
                        let anchorsMatched = shortcutMatch(text: anchorsText, input: anchorsText, statement: shortcutStatement)
                                .compactMap({ item -> InternalLexicon? in
                                        guard item.romanization.removedTones().hasPrefix(syllableText) else { return nil }
                                        return InternalLexicon(word: item.word, romanization: item.romanization, frequency: item.frequency, latest: item.latest, input: text, mark: mark)
                                })
                        return conjoinedMatched + anchorsMatched
                })
                let gainedMatched: [InternalLexicon] = (1..<eventLength).reversed()
                        .flatMap({ number -> [InternalLexicon] in
                                let leadingText = events.prefix(number).map(\.text).joined()
                                return shortcutMatch(text: leadingText, input: leadingText, statement: shortcutStatement)
                        })
                        .compactMap({ item -> InternalLexicon? in
                                // TODO: Cache tails and syllables ?
                                let tail = events.dropFirst(item.input.count - 1)
                                guard tail.count <= 6 else { return nil }
                                lazy var converted: InternalLexicon = InternalLexicon(word: item.word, romanization: item.romanization, frequency: item.frequency, latest: item.latest, input: text, mark: text)
                                guard item.romanization.removedSpacesTones().hasPrefix(text).negative else { return converted }
                                guard let lastSyllable = item.romanization.split(separator: Character.space).last?.filter(\.isCantoneseToneDigit.negative) else { return nil }
                                if let tailSyllable = Segmenter.syllableText(of: tail) {
                                        return lastSyllable == tailSyllable ? converted : nil
                                } else {
                                        let tailText = tail.map(\.text).joined()
                                        return lastSyllable.hasPrefix(tailText) ? converted : nil
                                }
                        })
                return (prefixMatched + gainedMatched)
                        .distinct()
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
                let fullMatched = tenKeyCodeMatch(code: code)
                let anchorsMatched = tenKeyAnchorsMatch(code: code)
                guard anchorsMatched.isNotEmpty else {
                        return fullMatched.map({ Candidate(text: $0.word, romanization: $0.romanization, input: $0.input, mark: $0.mark, order: -1) })
                }
                guard fullMatched.isNotEmpty else {
                        return anchorsMatched.map({ Candidate(text: $0.word, romanization: $0.romanization, input: $0.input, mark: $0.mark, order: -1) })
                }
                guard fullMatched.count > 10 else {
                        return (fullMatched + anchorsMatched)
                                .distinct()
                                .map({ Candidate(text: $0.word, romanization: $0.romanization, input: $0.input, mark: $0.mark, order: -1) })
                }
                return (fullMatched.prefix(10) + (fullMatched + anchorsMatched).sorted())
                        .distinct()
                        .map({ Candidate(text: $0.word, romanization: $0.romanization, input: $0.input, mark: $0.mark, order: -1) })
        }
        private static func tenKeyCodeMatch(code: Int) -> [InternalLexicon] {
                let command: String = "SELECT word, romanization, frequency, latest FROM memory WHERE tenkeycode = \(code) ORDER BY frequency DESC LIMIT 100;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                var items: [InternalLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        guard let word = sqlite3_column_text(statement, 0) else { continue }
                        guard let romanizationText = sqlite3_column_text(statement, 1) else { continue }
                        let frequency = sqlite3_column_int64(statement, 2)
                        let latest = sqlite3_column_int64(statement, 3)
                        let romanization: String = String(cString: romanizationText)
                        let input: String = romanization.filter(\.isLowercaseBasicLatinLetter)
                        let mark: String = romanization.removedTones()
                        let instance = InternalLexicon(word: String(cString: word), romanization: romanization, frequency: frequency, latest: latest, input: input, mark: mark)
                        items.append(instance)
                }
                return items
        }
        private static func tenKeyAnchorsMatch(code: Int) -> [InternalLexicon] {
                let command: String = "SELECT word, romanization, frequency, latest FROM memory WHERE tenkeyanchors = \(code) ORDER BY frequency DESC LIMIT 6;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                var items: [InternalLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        guard let word = sqlite3_column_text(statement, 0) else { continue }
                        guard let romanizationText = sqlite3_column_text(statement, 1) else { continue }
                        let frequency = sqlite3_column_int64(statement, 2)
                        let latest = sqlite3_column_int64(statement, 3)
                        let romanization: String = String(cString: romanizationText)
                        let anchorText: String = String(romanization.split(separator: Character.space).compactMap(\.first))
                        let instance = InternalLexicon(word: String(cString: word), romanization: romanization, frequency: frequency, latest: latest, input: anchorText, mark: anchorText)
                        items.append(instance)
                }
                return items
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
