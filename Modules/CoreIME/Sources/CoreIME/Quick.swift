import Foundation
import SQLite3
import CommonExtensions

extension Engine {
        static func quick5ReverseLookup(text: String) -> [Candidate] {
                return (match(quick5: text) + glob(quick5: text))
                        .distinct()
                        .flatMap({ Engine.reveresLookup(text: $0.text, input: $0.input) })
        }
        private static func match(quick5 text: String) -> [ShapeLexicon] {
                guard let code = text.charCode else { return [] }
                let command: String = "SELECT rowid, word FROM quicktable WHERE q5code = \(code);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                var items: [ShapeLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let order: Int = Int(sqlite3_column_int64(statement, 0))
                        guard let word = sqlite3_column_text(statement, 1) else { continue }
                        let instance = ShapeLexicon(text: String(cString: word), input: text, complex: text.count, order: order)
                        items.append(instance)
                }
                return items
        }
        private static func glob(quick5 text: String) -> [ShapeLexicon] {
                let command: String = "SELECT rowid, word, q5complex FROM quicktable WHERE quick5 GLOB '\(text)*' ORDER BY q5complex ASC LIMIT 100;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                var items: [ShapeLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let order: Int = Int(sqlite3_column_int64(statement, 0))
                        guard let word = sqlite3_column_text(statement, 1) else { continue }
                        let complex: Int = Int(sqlite3_column_int64(statement, 2))
                        let instance = ShapeLexicon(text: String(cString: word), input: text, complex: complex, order: order)
                        items.append(instance)
                }
                return items.sorted()
        }
}

extension Engine {
        static func quick3ReverseLookup(text: String) -> [Candidate] {
                return (match(quick3: text) + glob(quick3: text))
                        .distinct()
                        .flatMap({ Engine.reveresLookup(text: $0.text, input: $0.input) })
        }
        private static func match(quick3 text: String) -> [ShapeLexicon] {
                guard let code = text.charCode else { return [] }
                let command: String = "SELECT rowid, word FROM quicktable WHERE q3code = \(code);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                var items: [ShapeLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let order: Int = Int(sqlite3_column_int64(statement, 0))
                        guard let word = sqlite3_column_text(statement, 1) else { continue }
                        let instance = ShapeLexicon(text: String(cString: word), input: text, complex: text.count, order: order)
                        items.append(instance)
                }
                return items
        }
        private static func glob(quick3 text: String) -> [ShapeLexicon] {
                let command: String = "SELECT rowid, word, q3complex FROM quicktable WHERE quick3 GLOB '\(text)*' ORDER BY q3complex ASC LIMIT 100;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                var items: [ShapeLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let order: Int = Int(sqlite3_column_int64(statement, 0))
                        guard let word = sqlite3_column_text(statement, 1) else { continue }
                        let complex: Int = Int(sqlite3_column_int64(statement, 2))
                        let instance = ShapeLexicon(text: String(cString: word), input: text, complex: complex, order: order)
                        items.append(instance)
                }
                return items.sorted()
        }
}
