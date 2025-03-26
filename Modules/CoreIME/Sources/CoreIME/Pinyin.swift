import Foundation
import SQLite3

extension Engine {
        public static func pinyinReverseLookup(text: String, schemes: [[String]]) -> [Candidate] {
                let shortcutStatement: OpaquePointer? = prepareShortcutStatement()
                let matchStatement: OpaquePointer? = prepareMatchStatement()
                defer {
                        sqlite3_finalize(shortcutStatement)
                        sqlite3_finalize(matchStatement)
                }
                let canSegment: Bool = schemes.subelementCount > 0
                if canSegment {
                        return process(pinyin: text, schemes: schemes, shortcutStatement: shortcutStatement, matchStatement: matchStatement)
                                .map({ Engine.reveresLookup(text: $0.text, input: $0.input, mark: $0.mark) })
                                .flatMap({ $0 })
                } else {
                        return processVerbatim(pinyin: text, shortcutStatement: shortcutStatement, matchStatement: matchStatement)
                                .map({ Engine.reveresLookup(text: $0.text, input: $0.input, mark: $0.mark) })
                                .flatMap({ $0 })
                }
        }

        private static func processVerbatim(pinyin text: String, shortcutStatement: OpaquePointer?, matchStatement: OpaquePointer?, limit: Int64? = nil) -> [PinyinLexicon] {
                let rounds = (0..<text.count).map({ number -> [PinyinLexicon] in
                        let leading: String = String(text.dropLast(number))
                        return match(pinyin: leading, statement: matchStatement, limit: limit) + shortcut(pinyin: leading, statement: shortcutStatement, limit: limit)
                })
                return rounds.flatMap({ $0 }).uniqued()
        }

        private static func process(pinyin text: String, schemes: [[String]], shortcutStatement: OpaquePointer?, matchStatement: OpaquePointer?, limit: Int64? = nil) -> [PinyinLexicon] {
                let textCount = text.count
                let primary = query(pinyin: text, schemes: schemes, shortcutStatement: shortcutStatement, matchStatement: matchStatement, limit: limit)
                guard let firstInputCount = primary.first?.input.count else { return processVerbatim(pinyin: text, shortcutStatement: shortcutStatement, matchStatement: matchStatement, limit: limit) }
                guard firstInputCount != textCount else { return primary }
                let prefixes: [PinyinLexicon] = {
                        let hasPrefectSchemes: Bool = schemes.contains(where: { $0.summedLength == textCount })
                        guard hasPrefectSchemes.negative else { return [] }
                        let shortcuts = schemes.map({ scheme -> [PinyinLexicon] in
                                let tail = text.dropFirst(scheme.summedLength)
                                guard let lastAnchor = tail.first else { return [] }
                                let schemeAnchors = scheme.compactMap(\.first)
                                let anchors: String = String(schemeAnchors + [lastAnchor])
                                let text2mark: String = scheme.joined(separator: String.space) + String.space + tail
                                return shortcut(pinyin: anchors, statement: shortcutStatement, limit: limit)
                                        .filter({ $0.pinyin.hasPrefix(text2mark) })
                                        .map({ PinyinLexicon(text: $0.text, pinyin: $0.pinyin, input: text, mark: text2mark) })
                        })
                        return shortcuts.flatMap({ $0 })
                }()
                guard prefixes.isEmpty else { return prefixes + primary }
                let headTexts = primary.map(\.input).uniqued()
                let concatenated = headTexts.compactMap { headText -> PinyinLexicon? in
                        let headInputCount = headText.count
                        let tailText = String(text.dropFirst(headInputCount))
                        let tailSegmentation = PinyinSegmentor.segment(text: tailText)
                        guard let tail = process(pinyin: tailText, schemes: tailSegmentation, shortcutStatement: shortcutStatement, matchStatement: matchStatement, limit: 50).sorted().first else { return nil }
                        guard let head = primary.filter({ $0.input == headText }).sorted().first else { return nil }
                        let conjoined = head + tail
                        return conjoined
                }
                let preferredConcatenated = concatenated.uniqued().sorted().prefix(1)
                return preferredConcatenated + primary
        }

        private static func query(pinyin text: String, schemes: [[String]], shortcutStatement: OpaquePointer?, matchStatement: OpaquePointer?, limit: Int64? = nil) -> [PinyinLexicon] {
                let textCount = text.count
                let searches = search(pinyin: text, schemes: schemes, matchStatement: matchStatement, limit: limit)
                let preferredSearches = searches.filter({ $0.input.count == textCount })
                let matched = match(pinyin: text, statement: matchStatement, limit: limit)
                return (matched + preferredSearches + shortcut(pinyin: text, statement: shortcutStatement, limit: limit) + searches).uniqued()
        }

        private static func search(pinyin text: String, schemes: [[String]], matchStatement: OpaquePointer?, limit: Int64? = nil) -> [PinyinLexicon] {
                let textCount: Int = text.count
                let perfectSchemes = schemes.filter({ $0.summedLength == textCount })
                if perfectSchemes.isNotEmpty {
                        let matches = perfectSchemes.map({ scheme -> [PinyinLexicon] in
                                var queries: [[PinyinLexicon]] = []
                                for number in (0..<scheme.count) {
                                        let pingText = scheme.dropLast(number).joined()
                                        let matched = match(pinyin: pingText, statement: matchStatement, limit: limit)
                                        queries.append(matched)
                                }
                                return queries.flatMap({ $0 })
                        })
                        return matches.flatMap({ $0 }).ordered(with: textCount)
                } else {
                        return schemes.map({ match(pinyin: $0.joined(), statement: matchStatement, limit: limit) }).flatMap({ $0 }).ordered(with: textCount)
                }
        }

        private static func prepareMatchStatement() -> OpaquePointer? {
                let command: String = "SELECT rowid, word, pinyin FROM pinyintable WHERE ping = ? LIMIT ?;"
                var statement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }
        private static func match(pinyin text: String, statement: OpaquePointer?, limit: Int64? = nil) -> [PinyinLexicon] {
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
        private static func prepareShortcutStatement() -> OpaquePointer? {
                let command: String = "SELECT rowid, word, pinyin FROM pinyintable WHERE shortcut = ? LIMIT ?;"
                var statement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }
        private static func shortcut(pinyin text: String, statement: OpaquePointer?, limit: Int64? = nil) -> [PinyinLexicon] {
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

private struct PinyinLexicon: Hashable, Comparable {

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

        // Comparable
        static func < (lhs: PinyinLexicon, rhs: PinyinLexicon) -> Bool {
                guard lhs.input.count == rhs.input.count else { return lhs.input.count > rhs.input.count }
                return lhs.text.count < rhs.text.count
        }

        static func + (lhs: PinyinLexicon, rhs: PinyinLexicon) -> PinyinLexicon {
                let newText: String = lhs.text + rhs.text
                let newPinyin: String = lhs.pinyin + String.space + rhs.pinyin
                let newInput: String = lhs.input + rhs.input
                let newMark: String = lhs.mark + String.space + rhs.mark
                return PinyinLexicon(text: newText, pinyin: newPinyin, input: newInput, mark: newMark)
        }
}
