import Foundation
import SQLite3
import CoreIME
import CommonExtensions

struct InputMemory {

        nonisolated(unsafe) private static let database: OpaquePointer? = {
                var db: OpaquePointer? = nil
                let path: String = URL.libraryDirectory.appending(path: "memory.sqlite3", directoryHint: .notDirectory).path()
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
                let values: String = "\(entry.identifier), '\(entry.word)', '\(entry.romanization)', \(entry.frequency), \(entry.latest), \(entry.anchors), \(entry.shortcut), \(entry.ping), \(entry.nineKeyAnchors), \(entry.nineKeyCode)"
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
                let fullMatched = pingMatch(text: text, input: text, statement: pingStatement)
                let idealSchemes = segmentation.filter({ $0.length == eventLength })
                let idealQueried: [InternalLexicon] = idealSchemes.flatMap({ scheme -> [InternalLexicon] in
                        let pingCode: Int = scheme.originText.hash
                        let shortcutCode: Int = scheme.originAnchorsText.hash
                        return strictMatch(ping: pingCode, shortcut: shortcutCode, input: text, mark: scheme.mark, statement: strictStatement)
                })
                let queried = query(segmentation: segmentation, idealSchemes: idealSchemes, strictStatement: strictStatement)
                guard fullMatched.isEmpty && idealQueried.isEmpty else {
                        return (fullMatched + idealQueried).distinct().map({ Candidate(text: $0.word, romanization: $0.romanization, input: text, mark: $0.mark, order: -1) }) + queried
                }
                let shortcuts = shortcutMatch(text: text, input: text, limit: 5, statement: shortcutStatement)
                guard shortcuts.isEmpty else {
                        return shortcuts.map({ Candidate(text: $0.word, romanization: $0.romanization, input: text, mark: $0.mark, order: -1) }) + queried
                }
                let shouldPartiallyMatch: Bool = idealSchemes.isEmpty || (events.last == InputEvent.letterM) || (events.first == InputEvent.letterM)
                guard shouldPartiallyMatch else { return queried }
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
                let partialMatched = (prefixMatched + gainedMatched)
                        .distinct()
                        .sorted()
                        .prefix(5)
                        .map({ Candidate(text: $0.word, romanization: $0.romanization, input: text, mark: $0.mark, order: -1) })
                return partialMatched + queried
        }
        private static func query(segmentation: Segmentation, idealSchemes: [Scheme], strictStatement: OpaquePointer?) -> [Candidate] {
                guard segmentation.isNotEmpty else { return [] }
                if idealSchemes.isEmpty {
                        return segmentation.flatMap({ perform(scheme: $0, strictStatement: strictStatement) })
                                .distinct()
                                .sorted()
                                .prefix(6)
                                .map({ Candidate(text: $0.word, romanization: $0.romanization, input: $0.input, mark: $0.mark, order: -2) })
                } else {
                        return idealSchemes.flatMap({ scheme -> [InternalLexicon] in
                                guard scheme.count > 1 else { return [] }
                                return (1..<scheme.count).reversed().map({ scheme.prefix($0) }).flatMap({ perform(scheme: $0, strictStatement: strictStatement) })
                        })
                        .distinct()
                        .sorted()
                        .prefix(6)
                        .map({ Candidate(text: $0.word, romanization: $0.romanization, input: $0.input, mark: $0.mark, order: -2) })
                }
        }
        private static func perform<T: RandomAccessCollection<Syllable>>(scheme: T, strictStatement: OpaquePointer?) -> [InternalLexicon] {
                let pingCode = scheme.originText.hash
                let shortcutCode = scheme.originAnchorsText.hash
                return strictMatch(ping: pingCode, shortcut: shortcutCode, input: scheme.aliasText, mark: scheme.mark, limit: 5, statement: strictStatement)
        }

        private static func shortcutMatch<T: StringProtocol>(text: T, input: String, limit: Int64 = 100, statement: OpaquePointer?) -> [InternalLexicon] {
                let code = text.replacingOccurrences(of: "y", with: "j").hash
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(code))
                sqlite3_bind_int64(statement, 2, limit)
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
        private static func pingMatch<T: StringProtocol>(text: T, input: String, mark: String? = nil, limit: Int64 = 100, statement: OpaquePointer?) -> [InternalLexicon] {
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(text.hash))
                sqlite3_bind_int64(statement, 2, limit)
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
        private static func strictMatch(ping: Int, shortcut: Int, input: String, mark: String? = nil, limit: Int64 = 100, statement: OpaquePointer?) -> [InternalLexicon] {
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(ping))
                sqlite3_bind_int64(statement, 2, Int64(shortcut))
                sqlite3_bind_int64(statement, 3, limit)
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


        // MARK: - NineKey suggestions

        private static let nineKeyAnchorsCommand: String = "SELECT word, romanization, frequency, latest FROM memory WHERE tenkeyanchors = ? ORDER BY frequency DESC LIMIT ?;"
        private static func prepareNineKeyAnchorsStatement() -> OpaquePointer? {
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(database, nineKeyAnchorsCommand, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }
        private static let nineKeyCodeCommand: String = "SELECT word, romanization, frequency, latest FROM memory WHERE tenkeycode = ? ORDER BY frequency DESC LIMIT ?;"
        private static func prepareNineKeyCodeStatement() -> OpaquePointer? {
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(database, nineKeyCodeCommand, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }
        private static func nineKeyAnchorsMatch(code: Int, limit: Int64 = 5, statement: OpaquePointer?) -> [InternalLexicon] {
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(code))
                sqlite3_bind_int64(statement, 2, limit)
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
        private static func nineKeyCodeMatch(code: Int, limit: Int64 = 100, statement: OpaquePointer?) -> [InternalLexicon] {
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(code))
                sqlite3_bind_int64(statement, 2, limit)
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
        static func nineKeySearch<T: RandomAccessCollection<Combo>>(combos: T) async -> [Candidate] {
                guard combos.isNotEmpty else { return [] }
                let eventLength = combos.count
                lazy var anchorsStatement = prepareNineKeyAnchorsStatement()
                lazy var codeStatement = prepareNineKeyCodeStatement()
                defer {
                        sqlite3_finalize(anchorsStatement)
                        sqlite3_finalize(codeStatement)
                }
                guard eventLength > 1 else {
                        let code: Int = combos.first?.rawValue ?? -1
                        let codeMatched = nineKeyCodeMatch(code: code, limit: 100, statement: codeStatement)
                        let anchorsMatched = nineKeyAnchorsMatch(code: code, limit: 100, statement: anchorsStatement)
                        return (codeMatched + anchorsMatched)
                                .distinct()
                                .map({ Candidate(text: $0.word, romanization: $0.romanization, input: $0.input, mark: $0.mark, order: -1) })
                }
                let fullCode: Int = combos.map(\.rawValue).decimalCombined()
                let fullCodeMatched = nineKeyCodeMatch(code: fullCode, limit: 100, statement: codeStatement)
                let fullAnchorsMatched = nineKeyAnchorsMatch(code: fullCode, limit: 5, statement: anchorsStatement)
                let ideal = (fullCodeMatched.prefix(10) + (fullCodeMatched + fullAnchorsMatched).sorted())
                        .distinct()
                        .map({ Candidate(text: $0.word, romanization: $0.romanization, input: $0.input, mark: $0.mark, order: -1) })
                let queried = (1..<eventLength)
                        .flatMap({ number -> [InternalLexicon] in
                                let code = combos.dropLast(number).map(\.rawValue).decimalCombined()
                                guard code > 0 else { return [] }
                                return nineKeyCodeMatch(code: code, limit: 4, statement: codeStatement)
                        })
                        .distinct()
                        .prefix(6)
                        .map({ Candidate(text: $0.word, romanization: $0.romanization, input: $0.input, mark: $0.mark, order: -2) })
                return ideal + queried
        }
}

private struct InternalLexicon: Hashable, Comparable {
        let word: String
        let romanization: String
        let frequency: Int64
        let latest: Int64
        let input: String
        let inputCount: Int
        let mark: String
        init(word: String, romanization: String, frequency: Int64, latest: Int64, input: String, mark: String) {
                self.word = word
                self.romanization = romanization
                self.frequency = frequency
                self.latest = latest
                self.input = input
                self.inputCount = input.count
                self.mark = mark
        }
        static func == (lhs: InternalLexicon, rhs: InternalLexicon) -> Bool {
                return (lhs.word == rhs.word) && (lhs.romanization == rhs.romanization)
        }
        func hash(into hasher: inout Hasher) {
                hasher.combine(word)
                hasher.combine(romanization)
        }
        static func < (lhs: InternalLexicon, rhs: InternalLexicon) -> Bool {
                guard lhs.inputCount == rhs.inputCount else { return lhs.inputCount > rhs.inputCount }
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
