import Foundation
import SQLite3

extension Engine {
        public static func pinyinReverseLookup(text: String, schemes: [[String]]) -> [Candidate] {
                let anchorsStatement: OpaquePointer? = prepareAnchorsStatement()
                let pingStatement: OpaquePointer? = preparePingStatement()
                defer {
                        sqlite3_finalize(anchorsStatement)
                        sqlite3_finalize(pingStatement)
                }
                let canSegment: Bool = schemes.subelementCount > 0
                if canSegment {
                        return process(pinyin: text, schemes: schemes, anchorsStatement: anchorsStatement, pingStatement: pingStatement)
                                .flatMap({ Engine.reveresLookup(text: $0.text, input: $0.input, mark: $0.mark) })
                } else {
                        return processVerbatim(pinyin: text, anchorsStatement: anchorsStatement, pingStatement: pingStatement)
                                .flatMap({ Engine.reveresLookup(text: $0.text, input: $0.input, mark: $0.mark) })
                }
        }

        private static func processVerbatim(pinyin text: String, anchorsStatement: OpaquePointer?, pingStatement: OpaquePointer?, limit: Int64? = nil) -> [PinyinLexicon] {
                return (0..<text.count).flatMap({ number -> [PinyinLexicon] in
                        let leading: String = String(text.dropLast(number))
                        return pingMatch(pinyin: leading, statement: pingStatement, limit: limit) + anchorMatch(pinyin: leading, statement: anchorsStatement, limit: limit)
                }).uniqued()
        }

        private static func process(pinyin text: String, schemes: [[String]], anchorsStatement: OpaquePointer?, pingStatement: OpaquePointer?, limit: Int64? = nil) -> [PinyinLexicon] {
                let textCount = text.count
                let primary = query(pinyin: text, schemes: schemes, anchorsStatement: anchorsStatement, pingStatement: pingStatement, limit: limit)
                guard let firstInputCount = primary.first?.inputCount else { return processVerbatim(pinyin: text, anchorsStatement: anchorsStatement, pingStatement: pingStatement, limit: limit) }
                guard firstInputCount != textCount else { return primary }
                let prefixes: [PinyinLexicon] = {
                        let hasPrefectSchemes: Bool = schemes.contains(where: { $0.summedLength == textCount })
                        guard hasPrefectSchemes.negative else { return [] }
                        let anchorLimit: Int64 = (limit == nil) ? 500 : 200
                        return schemes.flatMap({ scheme -> [PinyinLexicon] in
                                let tail = text.dropFirst(scheme.summedLength)
                                guard let lastAnchor = tail.first else { return [] }
                                let schemeAnchors = scheme.compactMap(\.first)
                                let anchors: String = String(schemeAnchors + [lastAnchor])
                                let text2mark: String = scheme.joined(separator: String.space) + String.space + tail
                                return anchorMatch(pinyin: anchors, statement: anchorsStatement, limit: anchorLimit)
                                        .filter({ $0.pinyin.hasPrefix(text2mark) })
                                        .map({ PinyinLexicon(text: $0.text, pinyin: $0.pinyin, input: text, mark: text2mark) })
                        })
                }()
                guard prefixes.isEmpty else { return prefixes + primary }
                let headTexts = primary.map(\.input).uniqued()
                let concatenated = headTexts.compactMap { headText -> PinyinLexicon? in
                        let headInputCount = headText.count
                        let tailText = String(text.dropFirst(headInputCount))
                        let tailSegmentation = PinyinSegmentor.segment(text: tailText)
                        guard let tail = process(pinyin: tailText, schemes: tailSegmentation, anchorsStatement: anchorsStatement, pingStatement: pingStatement, limit: 50).sorted().first else { return nil }
                        guard let head = primary.filter({ $0.input == headText }).sorted().first else { return nil }
                        let conjoined = head + tail
                        return conjoined
                }
                let preferredConcatenated = concatenated.uniqued().sorted().prefix(1)
                return preferredConcatenated + primary
        }

        private static func query(pinyin text: String, schemes: [[String]], anchorsStatement: OpaquePointer?, pingStatement: OpaquePointer?, limit: Int64? = nil) -> [PinyinLexicon] {
                let textCount = text.count
                let pinyinMatched = pingMatch(pinyin: text, statement: pingStatement, limit: limit)
                let anchorsMatch = anchorMatch(pinyin: text, statement: anchorsStatement, limit: limit)
                let searches = search(pinyin: text, schemes: schemes, pingStatement: pingStatement, limit: limit)
                return (pinyinMatched + anchorsMatch + searches).ordered(with: textCount)
        }

        private static func search(pinyin text: String, schemes: [[String]], pingStatement: OpaquePointer?, limit: Int64? = nil) -> [PinyinLexicon] {
                let textCount: Int = text.count
                let perfectSchemes = schemes.filter({ $0.summedLength == textCount })
                if perfectSchemes.isNotEmpty {
                        return perfectSchemes.flatMap({ scheme -> [PinyinLexicon] in
                                var queries: [[PinyinLexicon]] = []
                                for number in (0..<scheme.count) {
                                        let pingText = scheme.dropLast(number).joined()
                                        let matched = pingMatch(pinyin: pingText, statement: pingStatement, limit: limit)
                                        queries.append(matched)
                                }
                                return queries.flatMap({ $0 })
                        })
                } else {
                        return schemes.flatMap({ pingMatch(pinyin: $0.joined(), statement: pingStatement, limit: limit) })
                }
        }

        private static func preparePingStatement() -> OpaquePointer? {
                let command: String = "SELECT rowid, word, romanization FROM pinyintable WHERE ping = ? LIMIT ?;"
                var statement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }
        private static func pingMatch(pinyin text: String, statement: OpaquePointer?, limit: Int64? = nil) -> [PinyinLexicon] {
                let limit: Int64 = limit ?? -1
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(text.hash))
                sqlite3_bind_int64(statement, 2, limit)
                var items: [PinyinLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let rowID = sqlite3_column_int64(statement, 0)
                        guard let word = sqlite3_column_text(statement, 1) else { continue }
                        guard let pinyinText = sqlite3_column_text(statement, 2) else { continue }
                        let pinyinString = String(cString: pinyinText)
                        let instance = PinyinLexicon(text: String(cString: word), pinyin: pinyinString, input: text, mark: pinyinString, order: Int(rowID))
                        items.append(instance)
                }
                return items
        }
        private static func prepareAnchorsStatement() -> OpaquePointer? {
                let command: String = "SELECT rowid, word, romanization FROM pinyintable WHERE anchors = ? LIMIT ?;"
                var statement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }
        private static func anchorMatch(pinyin text: String, statement: OpaquePointer?, limit: Int64? = nil) -> [PinyinLexicon] {
                guard let code = text.charcode else { return [] }
                let limit: Int64 = limit ?? 50
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(code))
                sqlite3_bind_int64(statement, 2, limit)
                var items: [PinyinLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let rowID = sqlite3_column_int64(statement, 0)
                        guard let word = sqlite3_column_text(statement, 1) else { continue }
                        guard let pinyinText = sqlite3_column_text(statement, 2) else { continue }
                        let instance = PinyinLexicon(text: String(cString: word), pinyin: String(cString: pinyinText), input: text, mark: text, order: Int(rowID))
                        items.append(instance)
                }
                return items
        }
}

private extension Array where Element == PinyinLexicon {
        func ordered(with textCount: Int) -> [PinyinLexicon] {
                let matched = filter({ $0.inputCount == textCount }).sorted(by: { $0.order < $1.order }).uniqued()
                let others = filter({ $0.inputCount != textCount }).sorted().uniqued()
                let primary = matched.prefix(15)
                let secondary = others.prefix(10)
                let tertiary = others.sorted(by: { $0.order < $1.order }).prefix(7)
                return (primary + secondary + tertiary + matched + others).uniqued()
        }
}

private struct PinyinLexicon: Hashable, Comparable {

        /// Cantonese Chinese word.
        let text: String

        /// Pinyin romanization for word text.
        let pinyin: String

        /// User input.
        let input: String

        /// Character count of self.input
        let inputCount: Int

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
                self.inputCount = input.count
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

        // Comparable
        static func < (lhs: PinyinLexicon, rhs: PinyinLexicon) -> Bool {
                guard lhs.inputCount == rhs.inputCount else { return lhs.inputCount > rhs.inputCount }
                return lhs.order < rhs.order
        }

        static func + (lhs: PinyinLexicon, rhs: PinyinLexicon) -> PinyinLexicon {
                let newText: String = lhs.text + rhs.text
                let newPinyin: String = lhs.pinyin + String.space + rhs.pinyin
                let newInput: String = lhs.input + rhs.input
                let newMark: String = lhs.mark + String.space + rhs.mark
                return PinyinLexicon(text: newText, pinyin: newPinyin, input: newInput, mark: newMark)
        }
}
