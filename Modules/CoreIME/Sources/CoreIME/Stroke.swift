import Foundation
import SQLite3

extension Engine {
        public static func strokeReverseLookup(text: String) -> [Candidate] {
                let isWildcardSearch: Bool = text.contains("x")
                let keyText: String = isWildcardSearch ? text.replacingOccurrences(of: "x", with: "[wsadz]") : text
                let matched: [ShapeLexicon] = isWildcardSearch ? wildcardMatch(strokeText: keyText) : match(strokeText: keyText)
                return (matched + glob(strokeText: keyText))
                        .uniqued()
                        .flatMap({ Engine.reveresLookup(text: $0.text, input: $0.input) })
        }
        private static func match(strokeText: String) -> [ShapeLexicon] {
                let code = strokeText.hash
                let command: String = "SELECT rowid, word FROM stroketable WHERE code = \(code);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                var items: [ShapeLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let order: Int = Int(sqlite3_column_int64(statement, 0))
                        guard let word = sqlite3_column_text(statement, 1) else { continue }
                        let instance = ShapeLexicon(text: String(cString: word), input: strokeText, complex: strokeText.count, order: order)
                        items.append(instance)
                }
                return items
        }
        private static func wildcardMatch(strokeText: String) -> [ShapeLexicon] {
                let command: String = "SELECT rowid, word, complex FROM stroketable WHERE stroke LIKE '\(strokeText)' LIMIT 100;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                var items: [ShapeLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let order: Int = Int(sqlite3_column_int64(statement, 0))
                        guard let word = sqlite3_column_text(statement, 1) else { continue }
                        let complex: Int = Int(sqlite3_column_int64(statement, 2))
                        let instance = ShapeLexicon(text: String(cString: word), input: strokeText, complex: complex, order: order)
                        items.append(instance)
                }
                return items.sorted()
        }
        private static func glob(strokeText: String) -> [ShapeLexicon] {
                let command: String = "SELECT rowid, word, complex FROM stroketable WHERE stroke GLOB '\(strokeText)*' ORDER BY complex ASC LIMIT 100;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                var items: [ShapeLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let order: Int = Int(sqlite3_column_int64(statement, 0))
                        guard let word = sqlite3_column_text(statement, 1) else { continue }
                        let complex: Int = Int(sqlite3_column_int64(statement, 2))
                        let instance = ShapeLexicon(text: String(cString: word), input: strokeText, complex: complex, order: order)
                        items.append(instance)
                }
                return items.sorted()
        }
}
