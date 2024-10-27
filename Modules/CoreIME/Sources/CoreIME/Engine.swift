import Foundation
import SQLite3

// MARK: - Preparing Databases

public struct Engine {
        public static func prepare() {
                #if os(iOS)
                Segmentor.prepare()
                #endif
                let command: String = "SELECT rowid FROM lexicontable WHERE shortcut = 20 LIMIT 1;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
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
}

extension Engine {

        // MARK: - TenKey

        public static func tenKeySuggest(combos: [Combo], segmentation: Segmentation) async -> [Candidate] {
                guard segmentation.maxSchemeLength > 0 else { return tenKeyDeepProcess(combos: combos) }
                async let search = tenKeySearch(combos: combos, segmentation: segmentation)
                async let fullShortcuts = tenKeyProcess(combos: combos)
                return await (search + fullShortcuts).tenKeySorted()
                /*
                guard segmentation.maxSchemeLength > 0 else { return tenKeyDeepProcess(combos: combos) }
                let search = tenKeySearch(combos: combos, segmentation: segmentation)
                guard search.isNotEmpty else { return tenKeyDeepProcess(combos: combos) }
                return (search + tenKeyProcess(combos: combos)).tenKeySorted()
                */
                /*
                guard segmentation.maxSchemeLength > 0 else { return tenKeyDeepProcess(combos: combos) }
                let search = tenKeySearch(combos: combos, segmentation: segmentation)
                let comboCount = combos.count
                let hasFullMatch: Bool = search.contains(where: { $0.input.count == comboCount })
                let fullShortcuts = tenKeyProcess(combos: combos)
                if (hasFullMatch.negative && fullShortcuts.isEmpty) {
                        return (search + tenKeyDeepProcess(combos: combos)).tenKeySorted()
                } else {
                        return (search + fullShortcuts).tenKeySorted()
                }
                */
        }
        private static func tenKeySearch(combos: [Combo], segmentation: Segmentation, limit: Int? = nil) -> [Candidate] {
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
                                        let matched = strictMatch(shortcut: shortcutCode, ping: pingCode, input: input, mark: mark, limit: limit)
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
                                return strictMatch(shortcut: shortcutCode, ping: pingCode, input: input, mark: mark, limit: limit)
                        })
                        return matches.flatMap({ $0 })
                }
        }
        private static func tenKeyProcess(combos: [Combo]) -> [Candidate] {
                guard combos.count > 0 && combos.count < 9 else { return [] }
                let firstCodes = combos.first!.letters.compactMap(\.intercode)
                guard combos.count > 1 else { return firstCodes.map({ shortcut(code: $0) }).flatMap({ $0 }) }
                typealias CodeSequence = [Int]
                var sequences: [CodeSequence] = firstCodes.map({ [$0] })
                for combo in combos.dropFirst() {
                        let appended = combo.letters.compactMap(\.intercode).map { code -> [CodeSequence] in
                                return sequences.map({ $0 + [code] })
                        }
                        sequences = appended.flatMap({ $0 })
                }
                return sequences.map({ shortcut(codes: $0) }).flatMap({ $0 }).sorted(by: { $0.order < $1.order })
        }
        private static func tenKeyDeepProcess(combos: [Combo]) -> [Candidate] {
                guard let firstCodes = combos.first?.letters.compactMap(\.intercode) else { return [] }
                guard combos.count > 1 else { return firstCodes.map({ shortcut(code: $0) }).flatMap({ $0 }) }
                typealias CodeSequence = [Int]
                var sequences: [CodeSequence] = firstCodes.map({ [$0] })
                var candidates: [Candidate] = sequences.map({ shortcut(codes: $0) }).flatMap({ $0 })
                for combo in combos.dropFirst().prefix(8) {
                        let appended = combo.letters.compactMap(\.intercode).map { code -> [CodeSequence] in
                                let newSequences: [CodeSequence] = sequences.map({ $0 + [code] })
                                let newCandidates: [Candidate] = newSequences.map({ shortcut(codes: $0) }).flatMap({ $0 })
                                candidates.append(contentsOf: newCandidates)
                                return newSequences
                        }
                        sequences = appended.flatMap({ $0 })
                }
                return candidates.tenKeySorted()
        }


        // MARK: - Suggestions

        /// Suggestion
        /// - Parameters:
        ///   - origin: Original user input text.
        ///   - text: Formatted user input text.
        ///   - segmentation: Segmentation of user input text.
        ///   - needsSymbols: Needs Emoji/Symbol Candidates.
        ///   - asap: Should be fast, shouldn't go deep.
        /// - Returns: Candidates
        public static func suggest(origin: String, text: String, segmentation: Segmentation, needsSymbols: Bool, asap: Bool = false) -> [Candidate] {
                switch text.count {
                case 0:
                        return []
                case 1:
                        switch text {
                        case "a":
                                return pingMatch(text: text, input: text) + pingMatch(text: "aa", input: text, mark: text) + shortcutMatch(text: text)
                        case "o", "m", "e":
                                return pingMatch(text: text, input: text) + shortcutMatch(text: text)
                        default:
                                return shortcutMatch(text: text)
                        }
                default:
                        let textMarkCandidates = fetchTextMark(text: origin)
                        guard asap else { return textMarkCandidates + dispatch(text: text, segmentation: segmentation, needsSymbols: needsSymbols) }
                        guard segmentation.maxSchemeLength > 0 else { return textMarkCandidates + processVerbatim(text: text) }
                        let candidates = query(text: text, segmentation: segmentation, needsSymbols: needsSymbols)
                        return candidates.isEmpty ? (textMarkCandidates + processVerbatim(text: text)) : (textMarkCandidates + candidates)
                }
        }

        private static func dispatch(text: String, segmentation: Segmentation, needsSymbols: Bool) -> [Candidate] {
                switch (text.hasSeparators, text.hasTones) {
                case (true, true):
                        let syllable = text.removedSeparatorsTones()
                        return pingMatch(text: syllable, input: text).filter({ text.hasPrefix($0.romanization) })
                case (false, true):
                        let textTones = text.tones
                        let rawText: String = text.removedTones()
                        let candidates: [Candidate] = query(text: rawText, segmentation: segmentation, needsSymbols: false)
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
                        let candidates: [Candidate] = query(text: rawText, segmentation: segmentation, needsSymbols: false)
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
                        return shortcutMatch(text: String(anchors))
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
                        guard segmentation.maxSchemeLength > 0 else { return processVerbatim(text: text) }
                        return process(text: text, segmentation: segmentation, needsSymbols: needsSymbols)
                }
        }

        private static func process(text: String, segmentation: Segmentation, needsSymbols: Bool, limit: Int? = nil) -> [Candidate] {
                guard canProcess(text) else { return [] }
                let textCount = text.count
                let primary: [Candidate] = query(text: text, segmentation: segmentation, needsSymbols: needsSymbols, limit: limit)
                guard let firstInputCount = primary.first?.input.count else { return processVerbatim(text: text, limit: limit) }
                guard firstInputCount != textCount else { return primary }
                let prefixes: [Candidate] = {
                        guard segmentation.maxSchemeLength < textCount else { return [] }
                        let shortcuts = segmentation.map({ scheme -> [Candidate] in
                                let tail = text.dropFirst(scheme.length)
                                guard let lastAnchor = tail.first else { return [] }
                                let schemeAnchors = scheme.compactMap(\.text.first)
                                let anchors: String = String(schemeAnchors + [lastAnchor])
                                let text2mark: String = scheme.map(\.text).joined(separator: " ") + " " + tail
                                return shortcutMatch(text: anchors, limit: limit)
                                        .filter({ $0.romanization.removedTones().hasPrefix(text2mark) })
                                        .map({ Candidate(text: $0.text, romanization: $0.romanization, input: text, mark: text2mark) })
                        })
                        return shortcuts.flatMap({ $0 })
                }()
                guard prefixes.isEmpty else { return prefixes + primary }
                let headTexts = primary.map(\.input).uniqued()
                let concatenated = headTexts.map { headText -> [Candidate] in
                        let headInputCount = headText.count
                        let tailText = String(text.dropFirst(headInputCount))
                        guard canProcess(tailText) else { return [] }
                        let tailSegmentation = Segmentor.segment(text: tailText)
                        let tailCandidates = process(text: tailText, segmentation: tailSegmentation, needsSymbols: false, limit: 8).prefix(100)
                        guard tailCandidates.isNotEmpty else { return [] }
                        let headCandidates = primary.filter({ $0.input == headText }).prefix(8)
                        let combines = headCandidates.map({ head -> [Candidate] in
                                return tailCandidates.compactMap({ head + $0 })
                        })
                        return combines.flatMap({ $0 })
                }
                let preferredConcatenated = concatenated.flatMap({ $0 }).uniqued().preferred(with: text).prefix(1)
                return preferredConcatenated + primary
        }

        private static func processVerbatim(text: String, limit: Int? = nil) -> [Candidate] {
                guard canProcess(text) else { return [] }
                let rounds = (0..<text.count).map({ number -> [Candidate] in
                        let leading: String = String(text.dropLast(number))
                        return pingMatch(text: leading, input: leading, limit: limit) + shortcutMatch(text: leading, limit: limit)
                })
                return rounds.flatMap({ $0 }).uniqued()
        }

        private static func query(text: String, segmentation: Segmentation, needsSymbols: Bool, limit: Int? = nil) -> [Candidate] {
                let textCount = text.count
                let fullPing = pingMatch(text: text, input: text, limit: limit)
                let fullShortcut = shortcutMatch(text: text, limit: limit)
                let searches = search(text: text, segmentation: segmentation, limit: limit)
                let preferredSearches = searches.filter({ $0.input.count == textCount })
                lazy var fallback = (fullPing + preferredSearches + fullShortcut + searches).uniqued()
                let shouldContinue: Bool = needsSymbols && (limit == nil) && (fullPing.isNotEmpty || preferredSearches.isNotEmpty)
                guard shouldContinue else { return fallback }
                let symbols: [Candidate] = Engine.searchSymbols(text: text, segmentation: segmentation)
                guard symbols.isNotEmpty else { return fallback }
                var regular = fullPing + preferredSearches
                for symbol in symbols.reversed() {
                        if let index = regular.firstIndex(where: { $0.lexiconText == symbol.lexiconText }) {
                                regular.insert(symbol, at: index + 1)
                        }
                }
                return (regular + fullShortcut + searches).uniqued()
        }

        private static func search(text: String, segmentation: Segmentation, limit: Int? = nil) -> [Candidate] {
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
                                        let matched = strictMatch(shortcut: shortcutCode, ping: pingCode, input: input, mark: mark, limit: limit)
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
                                return strictMatch(shortcut: shortcutCode, ping: pingCode, input: input, mark: mark, limit: limit)
                        })
                        return matches.flatMap({ $0 }).ordered(with: textCount)
                }
        }


        // MARK: - SQLite

        // CREATE TABLE lexicontable(word TEXT NOT NULL, romanization TEXT NOT NULL, shortcut INTEGER NOT NULL, ping INTEGER NOT NULL);

        private static func canProcess(_ text: String) -> Bool {
                guard let value: Int = text.first?.intercode else { return false }
                let code: Int = (value == 44) ? 29 : value // Replace 'y' with 'j'
                let query: String = "SELECT rowid FROM lexicontable WHERE shortcut = \(code) LIMIT 1;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK else { return false }
                guard sqlite3_step(statement) == SQLITE_ROW else { return false }
                return true
        }
        private static func shortcut(code: Int? = nil, codes: [Int] = [], limit: Int? = nil) -> [Candidate] {
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
                let input: String = {
                        if let char = code?.convertedCharacter {
                                return String(char)
                        } else {
                                let chars = codes.compactMap(\.convertedCharacter)
                                return String(chars)
                        }
                }()
                var candidates: [Candidate] = []
                let limit: Int = limit ?? 50
                let command: String = "SELECT rowid, word, romanization FROM lexicontable WHERE shortcut = \(shortcutCode) LIMIT \(limit);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return candidates }
                while sqlite3_step(statement) == SQLITE_ROW {
                        let order: Int = Int(sqlite3_column_int64(statement, 0))
                        let word: String = String(cString: sqlite3_column_text(statement, 1))
                        let romanization: String = String(cString: sqlite3_column_text(statement, 2))
                        let candidate = Candidate(text: word, romanization: romanization, input: input, mark: input, order: order)
                        candidates.append(candidate)
                }
                return candidates
        }
        private static func shortcutMatch(text: String, limit: Int? = nil) -> [Candidate] {
                guard let shortcutCode = text.shortcutCode else { return [] }
                var candidates: [Candidate] = []
                let limit: Int = limit ?? 50
                let command: String = "SELECT rowid, word, romanization FROM lexicontable WHERE shortcut = \(shortcutCode) LIMIT \(limit);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return candidates }
                while sqlite3_step(statement) == SQLITE_ROW {
                        let order: Int = Int(sqlite3_column_int64(statement, 0))
                        let word: String = String(cString: sqlite3_column_text(statement, 1))
                        let romanization: String = String(cString: sqlite3_column_text(statement, 2))
                        let candidate = Candidate(text: word, romanization: romanization, input: text, mark: text, order: order)
                        candidates.append(candidate)
                }
                return candidates
        }
        private static func pingMatch(text: String, input: String, mark: String? = nil, limit: Int? = nil) -> [Candidate] {
                var candidates: [Candidate] = []
                let code: Int = text.hash
                let limit: Int = limit ?? -1
                let command: String = "SELECT rowid, word, romanization FROM lexicontable WHERE ping = \(code) LIMIT \(limit);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return candidates }
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
        private static func strictMatch(shortcut: Int, ping: Int, input: String, mark: String? = nil, limit: Int? = nil) -> [Candidate] {
                var candidates: [Candidate] = []
                let limit: Int = limit ?? -1
                let command: String = "SELECT rowid, word, romanization FROM lexicontable WHERE ping = \(ping) AND shortcut = \(shortcut) LIMIT \(limit);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return candidates }
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


// MARK: - Sorting Candidates

private extension Array where Element == Candidate {

        /// Sort Candidates with input text, input.count and text.count
        /// - Parameter text: Input text
        /// - Returns: Preferred Candidates
        func preferred(with text: String) -> [Candidate] {
                let sortedSelf = self.sorted { (lhs, rhs) -> Bool in
                        let lhsInputCount: Int = lhs.input.count
                        let rhsInputCount: Int = rhs.input.count
                        guard lhsInputCount == rhsInputCount else {
                                return lhsInputCount > rhsInputCount
                        }
                        return lhs.text.count < rhs.text.count
                }
                let matched = sortedSelf.filter({ $0.romanization.removedSpacesTones() == text })
                return matched.isEmpty ? sortedSelf : matched
        }

        /// Sort Candidates with UserInputTextCount and Candidate.order
        /// - Parameter textCount: User input text count
        /// - Returns: Sorted Candidates
        func ordered(with textCount: Int) -> [Candidate] {
                return self.sorted { (lhs, rhs) -> Bool in
                        let lhsInputCount: Int = lhs.input.count
                        let rhsInputCount: Int = rhs.input.count
                        if lhsInputCount == textCount && rhsInputCount != textCount {
                                return true
                        } else if lhs.order < rhs.order - 50000 {
                                return true
                        } else {
                                return lhsInputCount > rhsInputCount
                        }
                }
        }

        func tenKeySorted() -> [Candidate] {
                return self.sorted { (lhs, rhs) -> Bool in
                        let lhsInputCount: Int = lhs.input.count
                        let rhsInputCount: Int = rhs.input.count
                        guard lhsInputCount == rhsInputCount else {
                                return lhsInputCount > rhsInputCount
                        }
                        let lhsTextCount: Int = lhs.text.count
                        let rhsTextCount: Int = rhs.text.count
                        guard lhsTextCount == rhsTextCount else {
                                return lhsTextCount < rhsTextCount
                        }
                        return lhs.order < rhs.order
                }
        }
}
