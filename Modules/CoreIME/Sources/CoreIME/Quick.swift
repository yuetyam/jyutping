import Foundation
import SQLite3

extension Engine {
        static func quick5ReverseLookup(text: String) -> [Candidate] {
                let matched = match(quick5: text)
                let globed = glob(quick5: text).sorted(by: { (lhs, rhs) -> Bool in
                        guard lhs.complex == rhs.complex else { return lhs.complex < rhs.complex }
                        return lhs.order < rhs.order
                })
                let candidates = (matched + globed).uniqued().map({ Engine.reveresLookup(text: $0.text, input: $0.input) })
                return candidates.flatMap({ $0 })
        }
        private static func match(quick5 text: String) -> [ShapeLexicon] {
                var items: [ShapeLexicon] = []
                guard let code = text.charcode else { return [] }
                let command: String = "SELECT rowid, word FROM quicktable WHERE q5code = \(code);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return items }
                while sqlite3_step(statement) == SQLITE_ROW {
                        let order: Int = Int(sqlite3_column_int64(statement, 0))
                        let word: String = String(cString: sqlite3_column_text(statement, 1))
                        let instance = ShapeLexicon(text: word, input: text, complex: text.count, order: order)
                        items.append(instance)
                }
                return items
        }
        private static func glob(quick5 text: String) -> [ShapeLexicon] {
                var items: [ShapeLexicon] = []
                let command: String = "SELECT rowid, word, q5complex FROM quicktable WHERE quick5 GLOB '\(text)*' ORDER BY q5complex ASC LIMIT 100;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return items }
                while sqlite3_step(statement) == SQLITE_ROW {
                        let order: Int = Int(sqlite3_column_int64(statement, 0))
                        let word: String = String(cString: sqlite3_column_text(statement, 1))
                        let complex: Int = Int(sqlite3_column_int64(statement, 2))
                        let instance = ShapeLexicon(text: word, input: text, complex: complex, order: order)
                        items.append(instance)
                }
                return items
        }
}

extension Engine {
        static func quick3ReverseLookup(text: String) -> [Candidate] {
                let matched = match(quick3: text)
                let globed = glob(quick3: text).sorted(by: { (lhs, rhs) -> Bool in
                        guard lhs.complex == rhs.complex else { return lhs.complex < rhs.complex }
                        return lhs.order < rhs.order
                })
                let candidates = (matched + globed).uniqued().map({ Engine.reveresLookup(text: $0.text, input: $0.input) })
                return candidates.flatMap({ $0 })
        }
        private static func match(quick3 text: String) -> [ShapeLexicon] {
                var items: [ShapeLexicon] = []
                guard let code = text.charcode else { return [] }
                let command: String = "SELECT rowid, word FROM quicktable WHERE q3code = \(code);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return items }
                while sqlite3_step(statement) == SQLITE_ROW {
                        let order: Int = Int(sqlite3_column_int64(statement, 0))
                        let word: String = String(cString: sqlite3_column_text(statement, 1))
                        let instance = ShapeLexicon(text: word, input: text, complex: text.count, order: order)
                        items.append(instance)
                }
                return items
        }
        private static func glob(quick3 text: String) -> [ShapeLexicon] {
                var items: [ShapeLexicon] = []
                let command: String = "SELECT rowid, word, q3complex FROM quicktable WHERE quick3 GLOB '\(text)*' ORDER BY q3complex ASC LIMIT 100;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return items }
                while sqlite3_step(statement) == SQLITE_ROW {
                        let order: Int = Int(sqlite3_column_int64(statement, 0))
                        let word: String = String(cString: sqlite3_column_text(statement, 1))
                        let complex: Int = Int(sqlite3_column_int64(statement, 2))
                        let instance = ShapeLexicon(text: word, input: text, complex: complex, order: order)
                        items.append(instance)
                }
                return items
        }
}
