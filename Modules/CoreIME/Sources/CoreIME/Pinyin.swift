import Foundation
import SQLite3

extension Engine {

        public static func pinyinReverseLookup(text: String, schemes: [[String]]) -> [Candidate] {
                let candidates = search(pinyin: text, schemes: schemes).map({ Engine.reveresLookup(text: $0.text, input: $0.input) })
                return candidates.flatMap({ $0 })
        }

        private static func search(pinyin text: String, schemes: [[String]]) -> [CoreLexicon] {
                let fullProcessed = match(text: text) + shortcut(text: text)
                guard schemes.subelementCount > 0 else { return fullProcessed.uniqued() }
                let matches = schemes.map({ match(text: $0.joined()) }).flatMap({ $0 })
                return (fullProcessed + matches).uniqued()
        }

        private static func match(text: String) -> [CoreLexicon] {
                var items: [CoreLexicon] = []
                let query = "SELECT word FROM pinyintable WHERE pin = \(text.hash);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, query, -1, &statement, nil) == SQLITE_OK else { return items }
                while sqlite3_step(statement) == SQLITE_ROW {
                        let word: String = String(cString: sqlite3_column_text(statement, 0))
                        let candidate = CoreLexicon(input: text, text: word)
                        items.append(candidate)
                }
                return items
        }
        private static func shortcut(text: String) -> [CoreLexicon] {
                var items: [CoreLexicon] = []
                let query = "SELECT word FROM pinyintable WHERE shortcut = \(text.hash) LIMIT 100;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, query, -1, &statement, nil) == SQLITE_OK else { return items }
                while sqlite3_step(statement) == SQLITE_ROW {
                        let word: String = String(cString: sqlite3_column_text(statement, 0))
                        let candidate = CoreLexicon(input: text, text: word)
                        items.append(candidate)
                }
                return items
        }
}
