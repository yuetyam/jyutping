import Foundation
import SQLite3

extension Engine {

        /// Pinyin Reverse Lookup
        /// - Parameter text: Input text, e.g. "nihao"
        /// - Returns: An Array of CoreCandidate
        public static func pinyinLookup(for text: String) -> [Candidate] {
                guard !text.isEmpty else { return [] }
                let words = search(pinyin: text)
                let candidates = words.map { item -> [CoreCandidate] in
                        let romanizations: [String] = lookup(item.text)
                        let candidates: [CoreCandidate] = romanizations.map({ CoreCandidate(text: item.text, romanization: $0, input: item.input) })
                        return candidates
                }
                return candidates.flatMap({ $0 })
        }

        private static func search(pinyin text: String) -> [CoreLexicon] {
                let schemes: [[String]] = PinyinSplitter.split(text)
                let schemesMatches = schemes.map({ match(for: $0.joined()) })
                let matches: [CoreLexicon] = schemesMatches.flatMap({ $0 })
                let candidates: [CoreLexicon] = match(for: text) + shortcut(for: text) + matches
                return candidates.uniqued()
        }

        private static func match(for text: String) -> [CoreLexicon] {
                guard !text.isEmpty else { return [] }
                var candidates: [CoreLexicon] = []
                let queryString = "SELECT word FROM pinyintable WHERE pin = \(text.hash);"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(Engine.database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(cString: sqlite3_column_text(queryStatement, 0))
                                let candidate = CoreLexicon(input: text, text: word)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
        private static func shortcut(for text: String, count: Int = 100) -> [CoreLexicon] {
                var candidates: [CoreLexicon] = []
                let queryString = "SELECT word FROM pinyintable WHERE shortcut = \(text.hash) LIMIT \(count);"
                var queryStatement: OpaquePointer? = nil
                if sqlite3_prepare_v2(Engine.database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let word: String = String(cString: sqlite3_column_text(queryStatement, 0))
                                let candidate = CoreLexicon(input: text, text: word)
                                candidates.append(candidate)
                        }
                }
                sqlite3_finalize(queryStatement)
                return candidates
        }
}
