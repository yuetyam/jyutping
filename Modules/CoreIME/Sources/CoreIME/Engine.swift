import Foundation
import SQLite3

// MARK: - Preparing Databases

public struct Engine {
        public static func prepare() {
                Segmentor.prepare()
                let statement = prepareShortcutStatement()
                defer { sqlite3_finalize(statement) }
                let testCode: Int64 = 20
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, testCode)
                guard sqlite3_step(statement) == SQLITE_ROW else { return }
        }
        #if os(macOS)
        nonisolated(unsafe) static let database: OpaquePointer? = {
                var db: OpaquePointer? = nil
                guard let path: String = Bundle.module.path(forResource: "imedb", ofType: "sqlite3") else { return nil }
                var storageDatabase: OpaquePointer? = nil
                defer { sqlite3_close_v2(storageDatabase) }
                guard sqlite3_open_v2(path, &storageDatabase, SQLITE_OPEN_READONLY, nil) == SQLITE_OK else { return nil }
                guard sqlite3_open_v2(":memory:", &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX, nil) == SQLITE_OK else { return nil }
                let backup = sqlite3_backup_init(db, "main", storageDatabase, "main")
                guard sqlite3_backup_step(backup, -1) == SQLITE_DONE else { return nil }
                guard sqlite3_backup_finish(backup) == SQLITE_OK else { return nil }
                return db
        }()
        #else
        nonisolated(unsafe) static let database: OpaquePointer? = {
                var db: OpaquePointer? = nil
                guard let path: String = Bundle.module.path(forResource: "imedb", ofType: "sqlite3") else { return nil }
                guard sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY | SQLITE_OPEN_FULLMUTEX, nil) == SQLITE_OK else { return nil }
                return db
        }()
        #endif

        /// SQLITE_TRANSIENT replacement
        static let transientDestructorType = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
}


// MARK: - TenKey Suggestions

extension Engine {

        public static func tenKeySuggest(combos: [Combo], segmentation: Segmentation) async -> [Candidate] {
                lazy var shortcutStatement = prepareShortcutStatement()
                lazy var pingStatement = preparePingStatement()
                lazy var strictStatement = prepareStrictStatement()
                defer {
                        sqlite3_finalize(shortcutStatement)
                        sqlite3_finalize(pingStatement)
                        sqlite3_finalize(strictStatement)
                }
                guard segmentation.maxSchemeLength > 0 else { return tenKeyDeepProcess(combos: combos, shortcutStatement: shortcutStatement) }
                async let search = tenKeySearch(combos: combos, segmentation: segmentation, strictStatement: strictStatement)
                async let fullShortcuts = tenKeyProcess(combos: combos, shortcutStatement: shortcutStatement)
                return await (search + fullShortcuts).sorted()

                /*
                guard segmentation.maxSchemeLength > 0 else { return tenKeyDeepProcess(combos: combos, shortcutStatement: shortcutStatement) }
                let search = tenKeySearch(combos: combos, segmentation: segmentation, strictStatement: strictStatement)
                guard search.isNotEmpty else { return tenKeyDeepProcess(combos: combos, shortcutStatement: shortcutStatement) }
                return (search + tenKeyProcess(combos: combos, shortcutStatement: shortcutStatement)).sorted()
                */
                /*
                guard segmentation.maxSchemeLength > 0 else { return tenKeyDeepProcess(combos: combos, shortcutStatement: shortcutStatement) }
                let search = tenKeySearch(combos: combos, segmentation: segmentation, strictStatement: strictStatement)
                let comboCount = combos.count
                let hasFullMatch: Bool = search.contains(where: { $0.input.count == comboCount })
                let fullShortcuts = tenKeyProcess(combos: combos, shortcutStatement: shortcutStatement)
                if (hasFullMatch.negative && fullShortcuts.isEmpty) {
                        return (search + tenKeyDeepProcess(combos: combos, shortcutStatement: shortcutStatement)).sorted()
                } else {
                        return (search + fullShortcuts).sorted()
                }
                */
        }
        private static func tenKeySearch(combos: [Combo], segmentation: Segmentation, limit: Int64? = nil, strictStatement: OpaquePointer?) -> [Candidate] {
                let textCount: Int = combos.count
                let perfectSchemes = segmentation.filter({ $0.length == textCount })
                if perfectSchemes.isNotEmpty {
                        let matches = perfectSchemes.map({ scheme -> [Candidate] in
                                var queries: [[Candidate]] = []
                                for number in (0..<scheme.count) {
                                        let slice = scheme.dropLast(number)
                                        guard let shortcutCode = slice.compactMap(\.text.first).shortcutCode else { continue }
                                        let pingCode = slice.map(\.origin).joined().hash
                                        let input = slice.map(\.text).joined()
                                        let mark = slice.map(\.text).joined(separator: String.space)
                                        let matched = strictMatch(shortcut: shortcutCode, ping: pingCode, input: input, mark: mark, limit: limit, statement: strictStatement)
                                        queries.append(matched)
                                }
                                return queries.flatMap({ $0 })
                        })
                        return matches.flatMap({ $0 })
                } else {
                        let matches = segmentation.map({ scheme -> [Candidate] in
                                guard let shortcutCode = scheme.compactMap(\.text.first).shortcutCode else { return [] }
                                let pingCode = scheme.map(\.origin).joined().hash
                                let input = scheme.map(\.text).joined()
                                let mark = scheme.map(\.text).joined(separator: String.space)
                                return strictMatch(shortcut: shortcutCode, ping: pingCode, input: input, mark: mark, limit: limit, statement: strictStatement)
                        })
                        return matches.flatMap({ $0 })
                }
        }
        private static func tenKeyProcess(combos: [Combo], shortcutStatement: OpaquePointer?) -> [Candidate] {
                guard combos.count > 0 && combos.count < 9 else { return [] }
                let firstCodes = combos.first!.letters.compactMap(\.intercode)
                guard combos.count > 1 else { return firstCodes.map({ shortcut(code: $0, statement: shortcutStatement) }).flatMap({ $0 }) }
                typealias CodeSequence = [Int]
                var sequences: [CodeSequence] = firstCodes.map({ [$0] })
                for combo in combos.dropFirst() {
                        let appended = combo.letters.compactMap(\.intercode).map { code -> [CodeSequence] in
                                return sequences.map({ $0 + [code] })
                        }
                        sequences = appended.flatMap({ $0 })
                }
                return sequences.map({ shortcut(codes: $0, statement: shortcutStatement) }).flatMap({ $0 }).sorted(by: { $0.order < $1.order })
        }
        private static func tenKeyDeepProcess(combos: [Combo], shortcutStatement: OpaquePointer?) -> [Candidate] {
                guard let firstCodes = combos.first?.letters.compactMap(\.intercode) else { return [] }
                guard combos.count > 1 else { return firstCodes.map({ shortcut(code: $0, statement: shortcutStatement) }).flatMap({ $0 }) }
                typealias CodeSequence = [Int]
                var sequences: [CodeSequence] = firstCodes.map({ [$0] })
                var candidates: [Candidate] = sequences.map({ shortcut(codes: $0, statement: shortcutStatement) }).flatMap({ $0 })
                for combo in combos.dropFirst().prefix(8) {
                        let appended = combo.letters.compactMap(\.intercode).map { code -> [CodeSequence] in
                                let newSequences: [CodeSequence] = sequences.map({ $0 + [code] })
                                let newCandidates: [Candidate] = newSequences.map({ shortcut(codes: $0, statement: shortcutStatement) }).flatMap({ $0 })
                                candidates.append(contentsOf: newCandidates)
                                return newSequences
                        }
                        sequences = appended.flatMap({ $0 })
                }
                return candidates.sorted()
        }
}


// MARK: - Suggestions

extension Engine {

        /// Suggestion
        /// - Parameters:
        ///   - origin: Original user input text.
        ///   - text: Formatted user input text.
        ///   - segmentation: Segmentation of user input text.
        ///   - needsSymbols: Needs Emoji/Symbol Candidates.
        ///   - asap: Should be fast, shouldn't go deep.
        /// - Returns: Candidates
        public static func suggest(origin: String, text: String, segmentation: Segmentation, needsSymbols: Bool, asap: Bool = false) -> [Candidate] {
                lazy var shortcutStatement = prepareShortcutStatement()
                lazy var pingStatement = preparePingStatement()
                lazy var strictStatement = prepareStrictStatement()
                defer {
                        sqlite3_finalize(shortcutStatement)
                        sqlite3_finalize(pingStatement)
                        sqlite3_finalize(strictStatement)
                }
                switch text.count {
                case 0:
                        return []
                case 1:
                        switch text {
                        case "a":
                                return pingMatch(text: text, input: text, statement: pingStatement) + pingMatch(text: "aa", input: text, mark: text, statement: pingStatement) + shortcutMatch(text: text, limit: 100, statement: shortcutStatement)
                        case "o", "m", "e":
                                return pingMatch(text: text, input: text, statement: pingStatement) + shortcutMatch(text: text, limit: 100, statement: shortcutStatement)
                        default:
                                return shortcutMatch(text: text, limit: 100, statement: shortcutStatement)
                        }
                default:
                        let textMarkCandidates = fetchTextMark(text: origin)
                        guard asap else { return textMarkCandidates + dispatch(text: text, segmentation: segmentation, needsSymbols: needsSymbols, shortcutStatement: shortcutStatement, pingStatement: pingStatement, strictStatement: strictStatement) }
                        guard segmentation.maxSchemeLength > 0 else { return textMarkCandidates + processVerbatim(text: text, shortcutStatement: shortcutStatement, pingStatement: pingStatement) }
                        let candidates = query(text: text, segmentation: segmentation, needsSymbols: needsSymbols, shortcutStatement: shortcutStatement, pingStatement: pingStatement, strictStatement: strictStatement)
                        return candidates.isEmpty ? (textMarkCandidates + processVerbatim(text: text, shortcutStatement: shortcutStatement, pingStatement: pingStatement)) : (textMarkCandidates + candidates)
                }
        }

        private static func dispatch(text: String, segmentation: Segmentation, needsSymbols: Bool, shortcutStatement: OpaquePointer?, pingStatement: OpaquePointer?, strictStatement: OpaquePointer?) -> [Candidate] {
                switch (text.hasSeparators, text.hasTones) {
                case (true, true):
                        let syllable = text.removedSeparatorsTones()
                        return pingMatch(text: syllable, input: text, statement: pingStatement).filter({ text.hasPrefix($0.romanization) })
                case (false, true):
                        let textTones = text.tones
                        let rawText: String = text.removedTones()
                        let candidates: [Candidate] = query(text: rawText, segmentation: segmentation, needsSymbols: false, shortcutStatement: shortcutStatement, pingStatement: pingStatement, strictStatement: strictStatement)
                        let qualified = candidates.compactMap({ item -> Candidate? in
                                let continuous = item.romanization.removedSpaces()
                                let continuousTones = continuous.tones
                                switch (textTones.count, continuousTones.count) {
                                case (1, 1):
                                        guard textTones == continuousTones else { return nil }
                                        let isCorrectPosition: Bool = text.dropFirst(item.input.count).first?.isTone ?? false
                                        guard isCorrectPosition else { return nil }
                                        let combinedInput = item.input + textTones
                                        return Candidate(text: item.text, romanization: item.romanization, input: combinedInput)
                                case (1, 2):
                                        let isToneLast: Bool = text.last?.isTone ?? false
                                        if isToneLast {
                                                guard continuousTones.hasSuffix(textTones) else { return nil }
                                                let isCorrectPosition: Bool = text.dropFirst(item.input.count).first?.isTone ?? false
                                                guard isCorrectPosition else { return nil }
                                                return Candidate(text: item.text, romanization: item.romanization, input: text)
                                        } else {
                                                guard continuous.hasPrefix(text) else { return nil }
                                                return Candidate(text: item.text, romanization: item.romanization, input: text)
                                        }
                                case (2, 1):
                                        guard textTones.hasPrefix(continuousTones) else { return nil }
                                        let isCorrectPosition: Bool = text.dropFirst(item.input.count).first?.isTone ?? false
                                        guard isCorrectPosition else { return nil }
                                        let combinedInput = item.input + continuousTones
                                        return Candidate(text: item.text, romanization: item.romanization, input: combinedInput)
                                case (2, 2):
                                        guard textTones == continuousTones else { return nil }
                                        let isToneLast: Bool = text.last?.isTone ?? false
                                        if isToneLast {
                                                guard item.input.count == (text.count - 2) else { return nil }
                                                return Candidate(text: item.text, romanization: item.romanization, input: text)
                                        } else {
                                                let tail = text.dropFirst(item.input.count + 1)
                                                let isCorrectPosition: Bool = tail.first == textTones.last
                                                guard isCorrectPosition else { return nil }
                                                let combinedInput = item.input + textTones
                                                return Candidate(text: item.text, romanization: item.romanization, input: combinedInput)
                                        }
                                default:
                                        if continuous.hasPrefix(text) {
                                                return Candidate(text: item.text, romanization: item.romanization, input: text)
                                        } else if text.hasPrefix(continuous) {
                                                return Candidate(text: item.text, romanization: item.romanization, input: continuous)
                                        } else {
                                                return nil
                                        }
                                }
                        })
                        return qualified.sorted(by: { $0.input.count > $1.input.count })
                case (true, false):
                        let textSeparators = text.filter(\.isSeparator)
                        let textParts = text.split(separator: "'")
                        let isHeadingSeparator: Bool = text.first?.isSeparator ?? false
                        let isTrailingSeparator: Bool = text.last?.isSeparator ?? false
                        let rawText: String = text.removedSeparators()
                        let candidates: [Candidate] = query(text: rawText, segmentation: segmentation, needsSymbols: false, shortcutStatement: shortcutStatement, pingStatement: pingStatement, strictStatement: strictStatement)
                        let qualified = candidates.compactMap({ item -> Candidate? in
                                let syllables = item.romanization.removedTones().split(separator: " ")
                                guard syllables != textParts else { return Candidate(text: item.text, romanization: item.romanization, input: text) }
                                guard isHeadingSeparator.negative else { return nil }
                                switch textSeparators.count {
                                case 1 where isTrailingSeparator:
                                        guard syllables.count == 1 else { return nil }
                                        let isLengthMatched: Bool = item.input.count == (text.count - 1)
                                        guard isLengthMatched else { return nil }
                                        return Candidate(text: item.text, romanization: item.romanization, input: text)
                                case 1:
                                        switch syllables.count {
                                        case 1:
                                                guard item.input == textParts.first! else { return nil }
                                                let combinedInput: String = item.input + "'"
                                                return Candidate(text: item.text, romanization: item.romanization, input: combinedInput)
                                        case 2:
                                                guard syllables.first == textParts.first else { return nil }
                                                let combinedInput: String = item.input + "'"
                                                return Candidate(text: item.text, romanization: item.romanization, input: combinedInput)
                                        default:
                                                return nil
                                        }
                                case 2 where isTrailingSeparator:
                                        switch syllables.count {
                                        case 1:
                                                guard item.input == textParts.first! else { return nil }
                                                let combinedInput: String = item.input + "'"
                                                return Candidate(text: item.text, romanization: item.romanization, input: combinedInput)
                                        case 2:
                                                let isLengthMatched: Bool = item.input.count == (text.count - 2)
                                                guard isLengthMatched else { return nil }
                                                guard syllables.first == textParts.first else { return nil }
                                                return Candidate(text: item.text, romanization: item.romanization, input: text)
                                        default:
                                                return nil
                                        }
                                default:
                                        let textPartCount = textParts.count
                                        let syllableCount = syllables.count
                                        guard syllableCount < textPartCount else { return nil }
                                        let checks = (0..<syllableCount).map { index -> Bool in
                                                return syllables[index] == textParts[index]
                                        }
                                        let isMatched = checks.reduce(true, { $0 && $1 })
                                        guard isMatched else { return nil }
                                        let tail: [Character] = Array(repeating: "i", count: syllableCount - 1)
                                        let combinedInput: String = item.input + tail
                                        return Candidate(text: item.text, romanization: item.romanization, input: combinedInput)
                                }
                        })
                        guard qualified.isEmpty else { return qualified.sorted(by: { $0.input.count > $1.input.count }) }
                        let anchors = textParts.compactMap(\.first)
                        let anchorCount = anchors.count
                        return shortcutMatch(text: String(anchors), statement: shortcutStatement)
                                .filter({ item -> Bool in
                                        let syllables = item.romanization.split(separator: Character.space).map({ $0.dropLast() })
                                        guard syllables.count == anchorCount else { return false }
                                        let checks = (0..<anchorCount).map({ index -> Bool in
                                                let part = textParts[index]
                                                let isAnchorOnly = part.count == 1
                                                return isAnchorOnly ? syllables[index].hasPrefix(part) : syllables[index] == part
                                        })
                                        return checks.reduce(true, { $0 && $1 })
                                })
                                .map { Candidate(text: $0.text, romanization: $0.romanization, input: text) }
                case (false, false):
                        guard segmentation.maxSchemeLength > 0 else { return processVerbatim(text: text, shortcutStatement: shortcutStatement, pingStatement: pingStatement) }
                        return process(text: text, segmentation: segmentation, needsSymbols: needsSymbols, shortcutStatement: shortcutStatement, pingStatement: pingStatement, strictStatement: strictStatement)
                }
        }

        private static func process(text: String, segmentation: Segmentation, needsSymbols: Bool, limit: Int64? = nil, shortcutStatement: OpaquePointer?, pingStatement: OpaquePointer?, strictStatement: OpaquePointer?) -> [Candidate] {
                guard canProcess(text, statement: shortcutStatement) else { return [] }
                let textCount = text.count
                let primary: [Candidate] = query(text: text, segmentation: segmentation, needsSymbols: needsSymbols, limit: limit, shortcutStatement: shortcutStatement, pingStatement: pingStatement, strictStatement: strictStatement)
                guard let firstInputCount = primary.first?.input.count else { return processVerbatim(text: text, limit: limit, shortcutStatement: shortcutStatement, pingStatement: pingStatement) }
                guard firstInputCount != textCount else { return primary }
                let prefixes: [Candidate] = {
                        guard segmentation.maxSchemeLength < textCount else { return [] }
                        let shortcuts = segmentation.map({ scheme -> [Candidate] in
                                let tail = text.dropFirst(scheme.length)
                                guard let lastAnchor = tail.first else { return [] }
                                let schemeAnchors: String = String(scheme.compactMap(\.text.first))
                                let conjoined: String = schemeAnchors + tail
                                let anchors: String = schemeAnchors + String(lastAnchor)
                                let schemeMark: String = scheme.map(\.text).joined(separator: String.space)
                                let spacedMark: String = schemeMark + String.space + tail.spaceSeparated()
                                let anchorMark: String = schemeMark + String.space + tail
                                let conjoinedShortcuts = shortcutMatch(text: conjoined, limit: limit, statement: shortcutStatement)
                                        .filter({ item -> Bool in
                                                let rawRomanization = item.romanization.removedTones()
                                                guard rawRomanization.hasPrefix(schemeMark) else { return false }
                                                let tailAnchors = rawRomanization.dropFirst(schemeMark.count).split(separator: Character.space).compactMap(\.first)
                                                return tailAnchors == tail.map({ $0 })
                                        })
                                        .map({ Candidate(text: $0.text, romanization: $0.romanization, input: text, mark: spacedMark, order: $0.order) })
                                let anchorShortcuts = shortcutMatch(text: anchors, limit: limit, statement: shortcutStatement)
                                        .filter({ $0.romanization.removedTones().hasPrefix(anchorMark) })
                                        .map({ Candidate(text: $0.text, romanization: $0.romanization, input: text, mark: anchorMark, order: $0.order) })
                                return conjoinedShortcuts + anchorShortcuts
                        })
                        return shortcuts.flatMap({ $0 })
                }()
                guard prefixes.isEmpty else { return prefixes + primary }
                let headTexts = primary.map(\.input).uniqued()
                let concatenated = headTexts.compactMap { headText -> Candidate? in
                        let headInputCount = headText.count
                        let tailText = text.dropFirst(headInputCount)
                        guard canProcess(tailText, statement: shortcutStatement) else { return nil }
                        let tailSegmentation = Segmentor.segment(text: tailText)
                        guard let tailCandidate = process(text: String(tailText), segmentation: tailSegmentation, needsSymbols: false, limit: 50, shortcutStatement: shortcutStatement, pingStatement: pingStatement, strictStatement: strictStatement).sorted().first else { return nil }
                        guard let headCandidate = primary.filter({ $0.input == headText }).sorted().first else { return nil }
                        let conjoined = headCandidate + tailCandidate
                        return conjoined
                }
                let preferredConcatenated = concatenated.uniqued().sorted().prefix(1)
                return preferredConcatenated + primary
        }

        private static func processVerbatim(text: String, limit: Int64? = nil, shortcutStatement: OpaquePointer?, pingStatement: OpaquePointer?) -> [Candidate] {
                guard canProcess(text, statement: shortcutStatement) else { return [] }
                let textCount: Int = text.count
                return (0..<textCount)
                        .map({ number -> [Candidate] in
                                let leading: String = String(text.dropLast(number))
                                return pingMatch(text: leading, input: leading, limit: limit, statement: pingStatement) + shortcutMatch(text: leading, limit: limit, statement: shortcutStatement)
                        })
                        .flatMap({ $0 })
                        .map({ item -> Candidate in
                                let syllables = item.romanization.removedTones().split(separator: Character.space)
                                guard let lastSyllable = syllables.last else { return item }
                                guard text.hasSuffix(lastSyllable) else { return item }
                                let isMatched: Bool = ((syllables.count - 1) + lastSyllable.count) == textCount
                                guard isMatched else { return item }
                                let mark: String = syllables.compactMap(\.first).dropLast().spaceSeparated() + String.space + lastSyllable
                                return Candidate(text: item.text, romanization: item.romanization, input: text, mark: mark, order: item.order)
                        })
                        .uniqued()
                        .sorted()
        }

        private static func query(text: String, segmentation: Segmentation, needsSymbols: Bool, limit: Int64? = nil, shortcutStatement: OpaquePointer?, pingStatement: OpaquePointer?, strictStatement: OpaquePointer?) -> [Candidate] {
                let textCount = text.count
                let fullPing = pingMatch(text: text, input: text, limit: limit, statement: pingStatement)
                let fullShortcut = shortcutMatch(text: text, limit: limit, statement: shortcutStatement)
                let searches = search(text: text, segmentation: segmentation, limit: limit, strictStatement: strictStatement)
                let preferredSearches = searches.filter({ $0.input.count == textCount })
                lazy var fallback = (fullPing + preferredSearches + fullShortcut + searches).uniqued()
                let shouldContinue: Bool = needsSymbols && (limit == nil) && (fullPing.isNotEmpty || preferredSearches.isNotEmpty)
                guard shouldContinue else { return fallback }
                let symbols: [Candidate] = Engine.searchSymbols(text: text, segmentation: segmentation)
                guard symbols.isNotEmpty else { return fallback }
                var regular = fullPing + preferredSearches
                for symbol in symbols.reversed() {
                        if let index = regular.firstIndex(where: { $0.lexiconText == symbol.lexiconText && $0.romanization == symbol.romanization }) {
                                regular.insert(symbol, at: index + 1)
                        }
                }
                return (regular + fullShortcut + searches).uniqued()
        }

        private static func search(text: String, segmentation: Segmentation, limit: Int64? = nil, strictStatement: OpaquePointer?) -> [Candidate] {
                let textCount: Int = text.count
                let perfectSchemes = segmentation.filter({ $0.length == textCount })
                if perfectSchemes.isNotEmpty {
                        let matches = perfectSchemes.map({ scheme -> [Candidate] in
                                var queries: [[Candidate]] = []
                                for number in (0..<scheme.count) {
                                        let slice = scheme.dropLast(number)
                                        guard let shortcutCode = slice.compactMap(\.text.first).shortcutCode else { continue }
                                        let pingCode = slice.map(\.origin).joined().hash
                                        let input = slice.map(\.text).joined()
                                        let mark = slice.map(\.text).joined(separator: String.space)
                                        let matched = strictMatch(shortcut: shortcutCode, ping: pingCode, input: input, mark: mark, limit: limit, statement: strictStatement)
                                        queries.append(matched)
                                }
                                return queries.flatMap({ $0 })
                        })
                        return matches.flatMap({ $0 }).ordered(with: textCount)
                } else {
                        let matches = segmentation.map({ scheme -> [Candidate] in
                                guard let shortcutCode = scheme.compactMap(\.text.first).shortcutCode else { return [] }
                                let pingCode = scheme.map(\.origin).joined().hash
                                let input = scheme.map(\.text).joined()
                                let mark = scheme.map(\.text).joined(separator: String.space)
                                return strictMatch(shortcut: shortcutCode, ping: pingCode, input: input, mark: mark, limit: limit, statement: strictStatement)
                        })
                        return matches.flatMap({ $0 }).ordered(with: textCount)
                }
        }
}

private extension Array where Element == Candidate {

        /// Sort Candidates with UserInputTextCount and Candidate.order
        /// - Parameter textCount: User input text count
        /// - Returns: Sorted Candidates
        func ordered(with textCount: Int) -> [Candidate] {
                return self.sorted { (lhs, rhs) -> Bool in
                        switch (lhs.input.count - rhs.input.count) {
                        case ..<0:
                                return lhs.order < (rhs.order - 50000) && lhs.text.count == rhs.text.count
                        case 0:
                                return lhs.order < rhs.order
                        default:
                                return lhs.text.count >= rhs.text.count
                        }
                }
        }
}

// deprecated
/*
private extension Array where Element == Candidate {
        func ordered(with textCount: Int) -> [Candidate] {
                return self.sorted { (lhs, rhs) -> Bool in
                        let lhsInputCount: Int = lhs.input.count
                        let rhsInputCount: Int = rhs.input.count
                        if lhsInputCount == textCount && rhsInputCount != textCount {
                                return true
                        } else if lhsInputCount == rhsInputCount || lhs.text.count == rhs.text.count {
                                return lhs.order < rhs.order
                        } else if lhs.order < (rhs.order - 50000) {
                                return true
                        } else {
                                return lhsInputCount > rhsInputCount
                        }
                }
        }
}
*/


// MARK: - SQLite Statement Preparing

// CREATE TABLE lexicontable(word TEXT NOT NULL, romanization TEXT NOT NULL, shortcut INTEGER NOT NULL, ping INTEGER NOT NULL);

private extension Engine {
        private static let shortcutQuery: String = "SELECT rowid, word, romanization FROM lexicontable WHERE shortcut = ? LIMIT ?;"
        static func prepareShortcutStatement() -> OpaquePointer? {
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(database, shortcutQuery, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }

        private static let pingQuery: String = "SELECT rowid, word, romanization FROM lexicontable WHERE ping = ? LIMIT ?;"
        static func preparePingStatement() -> OpaquePointer? {
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(database, pingQuery, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }

        private static let strictQuery: String = "SELECT rowid, word, romanization FROM lexicontable WHERE ping = ? AND shortcut = ? LIMIT ?;"
        static func prepareStrictStatement() -> OpaquePointer? {
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(database, strictQuery, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }
}


// MARK: - SQLite Querying

private extension Engine {
        static func canProcess<T: StringProtocol>(_ text: T, statement: OpaquePointer?) -> Bool {
                guard let value: Int = text.first?.intercode else { return false }
                let shortcutCode: Int = (value == 44) ? 29 : value // Replace 'y' with 'j'
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(shortcutCode))
                sqlite3_bind_int64(statement, 2, 1)
                return sqlite3_step(statement) == SQLITE_ROW
        }
        static func shortcut(code: Int? = nil, codes: [Int] = [], limit: Int64? = nil, statement: OpaquePointer?) -> [Candidate] {
                let shortcutCode: Int = {
                        if let code {
                                return code == 44 ? 29 : code  // Replace 'y' with 'j'
                        } else if codes.isEmpty {
                                return 0
                        } else {
                                return codes.map({ $0 == 44 ? 29 : $0 }).combined()  // Replace 'y' with 'j'
                        }
                }()
                guard shortcutCode != 0 else { return [] }
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(shortcutCode))
                sqlite3_bind_int64(statement, 2, (limit ?? 50))
                let input: String = {
                        if let char = code?.convertedCharacter {
                                return String(char)
                        } else {
                                let chars = codes.compactMap(\.convertedCharacter)
                                return String(chars)
                        }
                }()
                let mark: String = input.spaceSeparated()
                var candidates: [Candidate] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let order: Int = Int(sqlite3_column_int64(statement, 0))
                        let word: String = String(cString: sqlite3_column_text(statement, 1))
                        let romanization: String = String(cString: sqlite3_column_text(statement, 2))
                        let candidate = Candidate(text: word, romanization: romanization, input: input, mark: mark, order: order)
                        candidates.append(candidate)
                }
                return candidates
        }
        static func shortcutMatch(text: String, limit: Int64? = nil, statement: OpaquePointer?) -> [Candidate] {
                guard let shortcutCode = text.shortcutCode else { return [] }
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(shortcutCode))
                sqlite3_bind_int64(statement, 2, (limit ?? 50))
                var candidates: [Candidate] = []
                let mark: String = text.spaceSeparated()
                while sqlite3_step(statement) == SQLITE_ROW {
                        let order: Int = Int(sqlite3_column_int64(statement, 0))
                        let word: String = String(cString: sqlite3_column_text(statement, 1))
                        let romanization: String = String(cString: sqlite3_column_text(statement, 2))
                        let candidate = Candidate(text: word, romanization: romanization, input: text, mark: mark, order: order)
                        candidates.append(candidate)
                }
                return candidates
        }
        static func pingMatch<T: StringProtocol>(text: T, input: String, mark: String? = nil, limit: Int64? = nil, statement: OpaquePointer?) -> [Candidate] {
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(text.hash))
                sqlite3_bind_int64(statement, 2, (limit ?? -1))
                var candidates: [Candidate] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let order: Int = Int(sqlite3_column_int64(statement, 0))
                        let word: String = String(cString: sqlite3_column_text(statement, 1))
                        let romanization: String = String(cString: sqlite3_column_text(statement, 2))
                        let mark: String = mark ?? romanization.removedTones()
                        let candidate = Candidate(text: word, romanization: romanization, input: input, mark: mark, order: order)
                        candidates.append(candidate)
                }
                return candidates
        }
        static func strictMatch(shortcut: Int, ping: Int, input: String, mark: String? = nil, limit: Int64? = nil, statement: OpaquePointer?) -> [Candidate] {
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(ping))
                sqlite3_bind_int64(statement, 2, Int64(shortcut))
                sqlite3_bind_int64(statement, 3, (limit ?? -1))
                var candidates: [Candidate] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let order: Int = Int(sqlite3_column_int64(statement, 0))
                        let word: String = String(cString: sqlite3_column_text(statement, 1))
                        let romanization: String = String(cString: sqlite3_column_text(statement, 2))
                        let mark: String = mark ?? romanization.removedTones()
                        let candidate = Candidate(text: word, romanization: romanization, input: input, mark: mark, order: order)
                        candidates.append(candidate)
                }
                return candidates
        }
}
