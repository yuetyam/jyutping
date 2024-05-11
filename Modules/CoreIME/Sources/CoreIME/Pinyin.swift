import Foundation
import SQLite3

extension Engine {

        public static func pinyinReverseLookup(text: String, schemes: [[String]]) -> [Candidate] {
                return process(pinyin: text, schemes: schemes)
                        .map({ Engine.reveresLookup(text: $0.text, input: $0.input, mark: $0.mark) })
                        .flatMap({ $0 })
        }

        private static func processVerbatim(pinyin text: String, limit: Int? = nil) -> [PinyinLexicon] {
                let rounds = (0..<text.count).map({ number -> [PinyinLexicon] in
                        let leading: String = String(text.dropLast(number))
                        return match(pinyin: leading, limit: limit) + shortcut(pinyin: leading, limit: limit)
                })
                return rounds.flatMap({ $0 }).uniqued()
        }

        private static func process(pinyin text: String, schemes: [[String]], limit: Int? = nil) -> [PinyinLexicon] {
                let textCount = text.count
                let primary = query(pinyin: text, schemes: schemes, limit: limit)
                guard let firstInputCount = primary.first?.input.count else { return processVerbatim(pinyin: text, limit: limit) }
                guard firstInputCount != textCount else { return primary }
                let prefixes: [PinyinLexicon] = {
                        let hasPrefectSchemes: Bool = schemes.contains(where: { $0.summedLength == textCount })
                        guard !hasPrefectSchemes else { return [] }
                        let shortcuts = schemes.map({ scheme -> [PinyinLexicon] in
                                let tail = text.dropFirst(scheme.summedLength)
                                guard let lastAnchor = tail.first else { return [] }
                                let schemeAnchors = scheme.compactMap(\.first)
                                let anchors: String = String(schemeAnchors + [lastAnchor])
                                let text2mark: String = scheme.joined(separator: " ") + " " + tail
                                return shortcut(pinyin: anchors, limit: limit)
                                        .filter({ $0.pinyin.hasPrefix(text2mark) })
                                        .map({ PinyinLexicon(text: $0.text, pinyin: $0.pinyin, input: text, mark: text2mark) })
                        })
                        return shortcuts.flatMap({ $0 })
                }()
                guard prefixes.isEmpty else { return prefixes + primary }
                let headTexts = primary.map(\.input).uniqued()
                let concatenated = headTexts.map { headText -> [PinyinLexicon] in
                        let headInputCount = headText.count
                        let tailText = String(text.dropFirst(headInputCount))
                        let tailSegmentation = PinyinSegmentor.segment(text: tailText)
                        let tailCandidates = process(pinyin: tailText, schemes: tailSegmentation, limit: 8).prefix(100)
                        guard !(tailCandidates.isEmpty) else { return [] }
                        let headCandidates = primary.filter({ $0.input == headText }).prefix(8)
                        let combines = headCandidates.map({ head -> [PinyinLexicon] in
                                return tailCandidates.map({ head + $0 })
                        })
                        return combines.flatMap({ $0 })
                }
                let preferredConcatenated = concatenated.flatMap({ $0 }).uniqued().preferred(with: text).prefix(1)
                return preferredConcatenated + primary
        }

        private static func query(pinyin text: String, schemes: [[String]], limit: Int? = nil) -> [PinyinLexicon] {
                let textCount = text.count
                let searches = search(pinyin: text, schemes: schemes, limit: limit)
                let preferredSearches = searches.filter({ $0.input.count == textCount })
                let matched = match(pinyin: text, limit: limit)
                return (matched + preferredSearches + shortcut(pinyin: text, limit: limit) + searches).uniqued()
        }

        private static func search(pinyin text: String, schemes: [[String]], limit: Int? = nil) -> [PinyinLexicon] {
                let textCount: Int = text.count
                let perfectSchemes = schemes.filter({ $0.summedLength == textCount })
                if !(perfectSchemes.isEmpty) {
                        let matches = perfectSchemes.map({ scheme -> [PinyinLexicon] in
                                var queries: [[PinyinLexicon]] = []
                                for number in (0..<scheme.count) {
                                        let pingText = scheme.dropLast(number).joined()
                                        let matched = match(pinyin: pingText, limit: limit)
                                        queries.append(matched)
                                }
                                return queries.flatMap({ $0 })
                        })
                        return matches.flatMap({ $0 }).ordered(with: textCount)
                } else {
                        return schemes.map({ match(pinyin: $0.joined(), limit: limit) }).flatMap({ $0 }).ordered(with: textCount)
                }
        }

        private static func match(pinyin text: String, limit: Int? = nil) -> [PinyinLexicon] {
                var items: [PinyinLexicon] = []
                let code: Int = text.hash
                let limit: Int = limit ?? -1
                let command: String = "SELECT rowid, word, pinyin FROM pinyintable WHERE ping = \(code) LIMIT \(limit);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return items }
                while sqlite3_step(statement) == SQLITE_ROW {
                        let rowID: Int = Int(sqlite3_column_int64(statement, 0))
                        let word: String = String(cString: sqlite3_column_text(statement, 1))
                        let pinyin: String = String(cString: sqlite3_column_text(statement, 2))
                        let instance = PinyinLexicon(text: word, pinyin: pinyin, input: text, mark: pinyin, order: rowID)
                        items.append(instance)
                }
                return items
        }
        private static func shortcut(pinyin text: String, limit: Int? = nil) -> [PinyinLexicon] {
                guard let code: Int = text.charcode else { return [] }
                var items: [PinyinLexicon] = []
                let limit: Int = limit ?? 50
                let command: String = "SELECT rowid, word, pinyin FROM pinyintable WHERE shortcut = \(code) LIMIT \(limit);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return items }
                while sqlite3_step(statement) == SQLITE_ROW {
                        let rowID: Int = Int(sqlite3_column_int64(statement, 0))
                        let word: String = String(cString: sqlite3_column_text(statement, 1))
                        let pinyin: String = String(cString: sqlite3_column_text(statement, 2))
                        let instance = PinyinLexicon(text: word, pinyin: pinyin, input: text, mark: text, order: rowID)
                        items.append(instance)
                }
                return items
        }
}

private extension Array where Element == PinyinLexicon {
        func preferred(with text: String) -> [PinyinLexicon] {
                let sortedSelf = self.sorted { (lhs, rhs) -> Bool in
                        let lhsInputCount: Int = lhs.input.count
                        let rhsInputCount: Int = rhs.input.count
                        guard lhsInputCount == rhsInputCount else {
                                return lhsInputCount > rhsInputCount
                        }
                        return lhs.text.count < rhs.text.count
                }
                let matched = sortedSelf.filter({ $0.input.count == text.count })
                return matched.isEmpty ? sortedSelf : matched
        }
        func ordered(with textCount: Int) -> [PinyinLexicon] {
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
}

private struct PinyinLexicon: Hashable {

        /// Cantonese Chinese word.
        let text: String

        /// Pinyin romanization for word text.
        let pinyin: String

        /// User input.
        let input: String

        /// Formatted user input for pre-edit display
        let mark: String

        /// Rank, smaller is preferred.
        let order: Int

        /// Create a PinyinLexicon.
        /// - Parameters:
        ///   - text: Cantonese Chinese word.
        ///   - pinyin: Pinyin romanization for word text.
        ///   - input: User input.
        ///   - order: Rank, smaller is preferred.
        init(text: String, pinyin: String? = nil, input: String, mark: String? = nil, order: Int? = nil) {
                self.text = text
                self.pinyin = pinyin ?? input
                self.input = input
                self.mark = mark ?? input
                self.order = order ?? 0
        }

        // Equatable
        static func ==(lhs: PinyinLexicon, rhs: PinyinLexicon) -> Bool {
                return lhs.text == rhs.text && lhs.input == rhs.input
        }

        // Hashable
        func hash(into hasher: inout Hasher) {
                hasher.combine(text)
                hasher.combine(input)
        }

        static func +(lhs: PinyinLexicon, rhs: PinyinLexicon) -> PinyinLexicon {
                let newText: String = lhs.text + rhs.text
                let newPinyin: String = lhs.pinyin + " " + rhs.pinyin
                let newInput: String = lhs.input + rhs.input
                let newMark: String = lhs.mark + " " + rhs.mark
                return PinyinLexicon(text: newText, pinyin: newPinyin, input: newInput, mark: newMark)
        }
}
