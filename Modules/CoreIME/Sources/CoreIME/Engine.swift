import Foundation
import SQLite3

// MARK: - Preparing Databases

public struct Engine {
        public static func prepare() {
                let statement = prepareAnchorsStatement()
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


// MARK: - Suggestions

extension Engine {

        /// Suggestion
        /// - Parameters:
        ///   - origin: Original user input text.
        ///   - text: Formatted user input text.
        ///   - segmentation: Segmentation of user input text.
        /// - Returns: Candidates
        public static func suggest(origin: String, text: String, segmentation: Segmentation) -> [Candidate] {
                lazy var anchorsStatement = prepareAnchorsStatement()
                lazy var pingStatement = preparePingStatement()
                lazy var strictStatement = prepareStrictStatement()
                defer {
                        sqlite3_finalize(anchorsStatement)
                        sqlite3_finalize(pingStatement)
                        sqlite3_finalize(strictStatement)
                }
                switch text.count {
                case 0:
                        return []
                case 1:
                        switch text {
                        case "a":
                                return pingMatch(text: text, input: text, statement: pingStatement) + pingMatch(text: "aa", input: text, mark: text, statement: pingStatement) + anchorsMatch(text: text, limit: 100, statement: anchorsStatement)
                        case "o", "m", "e":
                                return pingMatch(text: text, input: text, statement: pingStatement) + anchorsMatch(text: text, limit: 100, statement: anchorsStatement)
                        default:
                                return anchorsMatch(text: text, limit: 100, statement: anchorsStatement)
                        }
                default:
                        return fetchTextMarks(text: origin) + dispatch(text: text, segmentation: segmentation, anchorsStatement: anchorsStatement, pingStatement: pingStatement, strictStatement: strictStatement)
                }
        }

        private static func dispatch(text: String, segmentation: Segmentation, anchorsStatement: OpaquePointer?, pingStatement: OpaquePointer?, strictStatement: OpaquePointer?) -> [Candidate] {
                switch (text.hasSeparators, text.hasTones) {
                case (true, true):
                        let syllable = text.removedSeparatorsTones()
                        return pingMatch(text: syllable, input: text, statement: pingStatement).filter({ text.hasPrefix($0.romanization) })
                case (false, true):
                        let textTones = text.tones
                        let rawText: String = text.removedTones()
                        let candidates: [Candidate] = query(text: rawText, segmentation: segmentation, anchorsStatement: anchorsStatement, pingStatement: pingStatement, strictStatement: strictStatement)
                        let qualified = candidates.compactMap({ item -> Candidate? in
                                let continuous = item.romanization.removedSpaces()
                                let continuousTones = continuous.tones
                                switch (textTones.count, continuousTones.count) {
                                case (1, 1):
                                        guard textTones == continuousTones else { return nil }
                                        let isCorrectPosition: Bool = text.dropFirst(item.inputCount).first?.isTone ?? false
                                        guard isCorrectPosition else { return nil }
                                        let combinedInput = item.input + textTones
                                        return Candidate(text: item.text, romanization: item.romanization, input: combinedInput)
                                case (1, 2):
                                        let isToneLast: Bool = text.last?.isTone ?? false
                                        if isToneLast {
                                                guard continuousTones.hasSuffix(textTones) else { return nil }
                                                let isCorrectPosition: Bool = text.dropFirst(item.inputCount).first?.isTone ?? false
                                                guard isCorrectPosition else { return nil }
                                                return Candidate(text: item.text, romanization: item.romanization, input: text)
                                        } else {
                                                guard continuous.hasPrefix(text) else { return nil }
                                                return Candidate(text: item.text, romanization: item.romanization, input: text)
                                        }
                                case (2, 1):
                                        guard textTones.hasPrefix(continuousTones) else { return nil }
                                        let isCorrectPosition: Bool = text.dropFirst(item.inputCount).first?.isTone ?? false
                                        guard isCorrectPosition else { return nil }
                                        let combinedInput = item.input + continuousTones
                                        return Candidate(text: item.text, romanization: item.romanization, input: combinedInput)
                                case (2, 2):
                                        guard textTones == continuousTones else { return nil }
                                        let isToneLast: Bool = text.last?.isTone ?? false
                                        if isToneLast {
                                                guard item.inputCount == (text.count - 2) else { return nil }
                                                return Candidate(text: item.text, romanization: item.romanization, input: text)
                                        } else {
                                                let tail = text.dropFirst(item.inputCount + 1)
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
                        return qualified.sorted()
                case (true, false):
                        let textSeparators = text.filter(\.isSeparator)
                        let textParts = text.split(separator: Character.separator)
                        let isHeadingSeparator: Bool = text.first?.isSeparator ?? false
                        let isTrailingSeparator: Bool = text.last?.isSeparator ?? false
                        let rawText: String = text.removedSeparators()
                        let candidates: [Candidate] = query(text: rawText, segmentation: segmentation, anchorsStatement: anchorsStatement, pingStatement: pingStatement, strictStatement: strictStatement)
                        let qualified = candidates.compactMap({ item -> Candidate? in
                                let syllables = item.romanization.removedTones().split(separator: Character.space)
                                guard syllables != textParts else { return Candidate(text: item.text, romanization: item.romanization, input: text) }
                                guard isHeadingSeparator.negative else { return nil }
                                switch textSeparators.count {
                                case 1 where isTrailingSeparator:
                                        guard syllables.count == 1 else { return nil }
                                        let isLengthMatched: Bool = item.inputCount == (text.count - 1)
                                        guard isLengthMatched else { return nil }
                                        return Candidate(text: item.text, romanization: item.romanization, input: text)
                                case 1:
                                        switch syllables.count {
                                        case 1:
                                                guard item.input == textParts.first! else { return nil }
                                                let combinedInput: String = item.input + String.separator
                                                return Candidate(text: item.text, romanization: item.romanization, input: combinedInput)
                                        case 2:
                                                guard syllables.first == textParts.first else { return nil }
                                                let combinedInput: String = item.input + String.separator
                                                return Candidate(text: item.text, romanization: item.romanization, input: combinedInput)
                                        default:
                                                return nil
                                        }
                                case 2 where isTrailingSeparator:
                                        switch syllables.count {
                                        case 1:
                                                guard item.input == textParts.first! else { return nil }
                                                let combinedInput: String = item.input + String.separator
                                                return Candidate(text: item.text, romanization: item.romanization, input: combinedInput)
                                        case 2:
                                                let isLengthMatched: Bool = item.inputCount == (text.count - 2)
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
                        guard qualified.isEmpty else { return qualified.sorted() }
                        let anchors = textParts.compactMap(\.first)
                        let anchorCount = anchors.count
                        return anchorsMatch(text: String(anchors), statement: anchorsStatement)
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
                        guard segmentation.maxSchemeLength > 0 else { return processVerbatim(text: text, anchorsStatement: anchorsStatement, pingStatement: pingStatement) }
                        return process(text: text, segmentation: segmentation, anchorsStatement: anchorsStatement, pingStatement: pingStatement, strictStatement: strictStatement)
                }
        }

        private static func process(text: String, segmentation: Segmentation, limit: Int64? = nil, anchorsStatement: OpaquePointer?, pingStatement: OpaquePointer?, strictStatement: OpaquePointer?) -> [Candidate] {
                guard canProcess(text, statement: anchorsStatement) else { return [] }
                let textCount = text.count
                let primary: [Candidate] = query(text: text, segmentation: segmentation, limit: limit, anchorsStatement: anchorsStatement, pingStatement: pingStatement, strictStatement: strictStatement)
                guard let firstInputCount = primary.first?.inputCount else { return processVerbatim(text: text, limit: limit, anchorsStatement: anchorsStatement, pingStatement: pingStatement) }
                guard firstInputCount != textCount else { return primary }
                let prefixes: [Candidate] = {
                        guard segmentation.maxSchemeLength < textCount else { return [] }
                        let matches = segmentation.map({ scheme -> [Candidate] in
                                let tail = text.dropFirst(scheme.length)
                                guard let lastAnchor = tail.first else { return [] }
                                let schemeAnchors: String = String(scheme.compactMap(\.text.first))
                                let conjoined: String = schemeAnchors + tail
                                let anchors: String = schemeAnchors + String(lastAnchor)
                                let schemeMark: String = scheme.map(\.text).joined(separator: String.space)
                                let spacedMark: String = schemeMark + String.space + tail.spaceSeparated()
                                let anchorMark: String = schemeMark + String.space + tail
                                let conjoinedMatches = anchorsMatch(text: conjoined, limit: limit, statement: anchorsStatement)
                                        .filter({ item -> Bool in
                                                let rawRomanization = item.romanization.removedTones()
                                                guard rawRomanization.hasPrefix(schemeMark) else { return false }
                                                let tailAnchors = rawRomanization.dropFirst(schemeMark.count).split(separator: Character.space).compactMap(\.first)
                                                return tailAnchors == tail.map({ $0 })
                                        })
                                        .map({ Candidate(text: $0.text, romanization: $0.romanization, input: text, mark: spacedMark, order: $0.order) })
                                let anchorMatches = anchorsMatch(text: anchors, limit: limit, statement: anchorsStatement)
                                        .filter({ $0.romanization.removedTones().hasPrefix(anchorMark) })
                                        .map({ Candidate(text: $0.text, romanization: $0.romanization, input: text, mark: anchorMark, order: $0.order) })
                                return conjoinedMatches + anchorMatches
                        })
                        return matches.flatMap({ $0 })
                }()
                guard prefixes.isEmpty else { return prefixes + primary }
                let headTexts = primary.map(\.input).uniqued()
                let concatenated = headTexts.compactMap { headText -> Candidate? in
                        let headInputCount = headText.count
                        let tailText = text.dropFirst(headInputCount)
                        guard canProcess(tailText, statement: anchorsStatement) else { return nil }
                        let tailSegmentation = Segmentor.segment(text: tailText)
                        guard let tailCandidate = process(text: String(tailText), segmentation: tailSegmentation, limit: 50, anchorsStatement: anchorsStatement, pingStatement: pingStatement, strictStatement: strictStatement).sorted().first else { return nil }
                        guard let headCandidate = primary.filter({ $0.input == headText }).sorted().first else { return nil }
                        let conjoined = headCandidate + tailCandidate
                        return conjoined
                }
                let preferredConcatenated = concatenated.uniqued().sorted().prefix(1)
                return preferredConcatenated + primary
        }

        private static func processVerbatim(text: String, limit: Int64? = nil, anchorsStatement: OpaquePointer?, pingStatement: OpaquePointer?) -> [Candidate] {
                guard canProcess(text, statement: anchorsStatement) else { return [] }
                let textCount: Int = text.count
                return (0..<textCount)
                        .map({ number -> [Candidate] in
                                let leading: String = String(text.dropLast(number))
                                return pingMatch(text: leading, input: leading, limit: limit, statement: pingStatement) + anchorsMatch(text: leading, limit: limit, statement: anchorsStatement)
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

        private static func query(text: String, segmentation: Segmentation, limit: Int64? = nil, anchorsStatement: OpaquePointer?, pingStatement: OpaquePointer?, strictStatement: OpaquePointer?) -> [Candidate] {
                let textCount = text.count
                let pingMatched = pingMatch(text: text, input: text, limit: limit, statement: pingStatement)
                let anchorsMatched = anchorsMatch(text: text, limit: limit, statement: anchorsStatement)
                let searches = search(text: text, segmentation: segmentation, limit: limit, strictStatement: strictStatement)
                lazy var queried = (pingMatched + anchorsMatched + searches).ordered(with: textCount)
                let shouldContinue: Bool = (limit == nil) && queried.isNotEmpty
                guard shouldContinue else { return queried }
                let symbols: [Candidate] = Engine.searchSymbols(text: text, segmentation: segmentation)
                guard symbols.isNotEmpty else { return queried }
                for symbol in symbols.reversed() {
                        if let index = queried.firstIndex(where: { $0.lexiconText == symbol.lexiconText && $0.romanization == symbol.romanization }) {
                                queried.insert(symbol, at: index + 1)
                        }
                }
                return queried
        }

        private static func search(text: String, segmentation: Segmentation, limit: Int64? = nil, strictStatement: OpaquePointer?) -> [Candidate] {
                let textCount: Int = text.count
                let perfectSchemes = segmentation.filter({ $0.length == textCount })
                if perfectSchemes.isNotEmpty {
                        let matches = perfectSchemes.map({ scheme -> [Candidate] in
                                var queries: [[Candidate]] = []
                                for number in (0..<scheme.count) {
                                        let slice = scheme.dropLast(number)
                                        guard let anchorsCode = slice.compactMap(\.text.first).anchorsCode else { continue }
                                        let pingCode = slice.map(\.origin).joined().hash
                                        let input = slice.map(\.text).joined()
                                        let mark = slice.map(\.text).joined(separator: String.space)
                                        let matched = strictMatch(anchors: anchorsCode, ping: pingCode, input: input, mark: mark, limit: limit, statement: strictStatement)
                                        queries.append(matched)
                                }
                                return queries.flatMap({ $0 })
                        })
                        return matches.flatMap({ $0 })
                } else {
                        let matches = segmentation.map({ scheme -> [Candidate] in
                                guard let anchorsCode = scheme.compactMap(\.text.first).anchorsCode else { return [] }
                                let pingCode = scheme.map(\.origin).joined().hash
                                let input = scheme.map(\.text).joined()
                                let mark = scheme.map(\.text).joined(separator: String.space)
                                return strictMatch(anchors: anchorsCode, ping: pingCode, input: input, mark: mark, limit: limit, statement: strictStatement)
                        })
                        return matches.flatMap({ $0 })
                }
        }
}

extension Array where Element == Candidate {
        /// Sort Candidates for Qwerty and Triple-Stroke layouts
        func ordered(with textCount: Int) -> [Candidate] {
                let matched = filter({ $0.inputCount == textCount }).sorted(by: { $0.order < $1.order }).uniqued()
                let others = filter({ $0.inputCount != textCount }).sorted().uniqued()
                let primary = matched.prefix(15)
                let secondary = others.prefix(10)
                let tertiary = others.sorted(by: { $0.order < $1.order }).prefix(7)
                return (primary + secondary + tertiary + matched + others).uniqued()
        }
}


// MARK: - SQLite Statement Preparing

// CREATE TABLE lexicontable(word TEXT NOT NULL, romanization TEXT NOT NULL, anchors INTEGER NOT NULL, ping INTEGER NOT NULL, tenkeyanchors INTEGER NOT NULL, tenkeycode INTEGER NOT NULL);

private extension Engine {
        private static let anchorsQuery: String = "SELECT rowid, word, romanization FROM lexicontable WHERE anchors = ? LIMIT ?;"
        static func prepareAnchorsStatement() -> OpaquePointer? {
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(database, anchorsQuery, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }

        private static let pingQuery: String = "SELECT rowid, word, romanization FROM lexicontable WHERE ping = ? LIMIT ?;"
        static func preparePingStatement() -> OpaquePointer? {
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(database, pingQuery, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }

        private static let strictQuery: String = "SELECT rowid, word, romanization FROM lexicontable WHERE ping = ? AND anchors = ? LIMIT ?;"
        static func prepareStrictStatement() -> OpaquePointer? {
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(database, strictQuery, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }

        private static let tenKeyAnchorsQuery: String = "SELECT rowid, word, romanization FROM lexicontable WHERE tenkeyanchors = ? LIMIT ?;"
        static func prepareTenKeyAnchorsStatement() -> OpaquePointer? {
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(database, tenKeyAnchorsQuery, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }

        private static let tenKeyCodeQuery: String = "SELECT rowid, word, romanization FROM lexicontable WHERE tenkeycode = ? LIMIT ?;"
        static func prepareTenKeyCodeStatement() -> OpaquePointer? {
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(database, tenKeyCodeQuery, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }
}


// MARK: - SQLite Querying

private extension Engine {
        static func canProcess<T: StringProtocol>(_ text: T, statement: OpaquePointer?) -> Bool {
                guard let value = text.first?.intercode else { return false }
                let code = (value == 44) ? 29 : value // Replace 'y' with 'j'
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(code))
                sqlite3_bind_int64(statement, 2, 1)
                return sqlite3_step(statement) == SQLITE_ROW
        }
        static func anchorsMatch(text: String, limit: Int64? = nil, statement: OpaquePointer?) -> [Candidate] {
                guard let code = text.anchorsCode else { return [] }
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(code))
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
        static func strictMatch(anchors: Int, ping: Int, input: String, mark: String? = nil, limit: Int64? = nil, statement: OpaquePointer?) -> [Candidate] {
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(ping))
                sqlite3_bind_int64(statement, 2, Int64(anchors))
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


// MARK: - TenKey Suggestions

extension Engine {
        public static func tenKeySuggest(combos: [Combo]) async -> [Candidate] {
                lazy var tenKeyAnchorsStatement = prepareTenKeyAnchorsStatement()
                lazy var tenKeyCodeStatement = prepareTenKeyCodeStatement()
                defer {
                        sqlite3_finalize(tenKeyAnchorsStatement)
                        sqlite3_finalize(tenKeyCodeStatement)
                }
                let textMarkCandidates = fetchTextMarks(combos: combos)
                lazy var queried = (0..<combos.count)
                        .map { number -> [Candidate] in
                                let tenKeyCode = combos.dropLast(number).map(\.rawValue).decimalCombined()
                                guard tenKeyCode > 0 else { return [] }
                                return tenKeyCodeMatch(code: tenKeyCode, statement: tenKeyCodeStatement) + tenKeyAnchorsMatch(code: tenKeyCode, statement: tenKeyAnchorsStatement)
                        }
                        .flatMap({ $0 })
                        .sorted()
                guard queried.isNotEmpty else { return textMarkCandidates + queried }
                let symbols = tenKeySearchSymbols(combos: combos)
                guard symbols.isNotEmpty else { return textMarkCandidates + queried }
                for symbol in symbols.reversed() {
                        if let index = queried.firstIndex(where: { $0.lexiconText == symbol.lexiconText && $0.romanization == symbol.romanization }) {
                                queried.insert(symbol, at: index + 1)
                        }
                }
                return textMarkCandidates + queried
        }
        private static func tenKeyAnchorsMatch(code: Int, limit: Int64? = nil, statement: OpaquePointer?) -> [Candidate] {
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(code))
                sqlite3_bind_int64(statement, 2, (limit ?? 50))
                var candidates: [Candidate] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let order: Int = Int(sqlite3_column_int64(statement, 0))
                        let word: String = String(cString: sqlite3_column_text(statement, 1))
                        let romanization: String = String(cString: sqlite3_column_text(statement, 2))
                        let anchors = romanization.split(separator: Character.space).compactMap(\.first)
                        let anchorText = String(anchors)
                        let candidate = Candidate(text: word, romanization: romanization, input: anchorText, mark: anchorText, order: order)
                        candidates.append(candidate)
                }
                return candidates
        }
        private static func tenKeyCodeMatch(code: Int, limit: Int64? = nil, statement: OpaquePointer?) -> [Candidate] {
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(code))
                sqlite3_bind_int64(statement, 2, (limit ?? -1))
                var candidates: [Candidate] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let order: Int = Int(sqlite3_column_int64(statement, 0))
                        let word: String = String(cString: sqlite3_column_text(statement, 1))
                        let romanization: String = String(cString: sqlite3_column_text(statement, 2))
                        let mark: String = romanization.removedTones()
                        let candidate = Candidate(text: word, romanization: romanization, input: mark.removedSpaces(), mark: mark, order: order)
                        candidates.append(candidate)
                }
                return candidates
        }
}
