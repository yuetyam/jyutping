import Foundation
import SQLite3

private struct ShapeLexicon: Hashable {

        /// Cantonese word
        let text: String

        /// User input
        let input: String

        /// Complexity, the count of Cangjie/Stroke code
        let complex: Int

        /// Rank. Smaller is preferred.
        let order: Int

        // Equatable
        static func ==(lhs: ShapeLexicon, rhs: ShapeLexicon) -> Bool {
                return lhs.text == rhs.text
        }

        // Hashable
        func hash(into hasher: inout Hasher) {
                hasher.combine(text)
        }
}

extension Engine {
        public static func cangjieReverseLookup(text: String) -> [Candidate] {
                let matched = match(cangjie: text)
                let globed = glob(cangjie: text).sorted(by: { (lhs, rhs) -> Bool in
                        guard lhs.complex == rhs.complex else { return lhs.complex < rhs.complex }
                        return lhs.order < rhs.order
                })
                let combined = (matched + globed).uniqued()
                let candidates = combined.map({ Engine.reveresLookup(text: $0.text, input: $0.input) })
                return candidates.flatMap({ $0 })
        }
        private static func match(cangjie: String) -> [ShapeLexicon] {
                var items: [ShapeLexicon] = []
                guard let code = cangjie.charcode else { return [] }
                let command: String = "SELECT rowid, word FROM cangjietable WHERE code = \(code);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return items }
                while sqlite3_step(statement) == SQLITE_ROW {
                        let order: Int = Int(sqlite3_column_int64(statement, 0))
                        let word: String = String(cString: sqlite3_column_text(statement, 1))
                        let instance = ShapeLexicon(text: word, input: cangjie, complex: cangjie.count, order: order)
                        items.append(instance)
                }
                return items
        }
        private static func glob(cangjie: String) -> [ShapeLexicon] {
                var items: [ShapeLexicon] = []
                let command: String = "SELECT rowid, word, complex FROM cangjietable WHERE cangjie GLOB '\(cangjie)*' ORDER BY complex ASC LIMIT 100;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return items }
                while sqlite3_step(statement) == SQLITE_ROW {
                        let order: Int = Int(sqlite3_column_int64(statement, 0))
                        let word: String = String(cString: sqlite3_column_text(statement, 1))
                        let complex: Int = Int(sqlite3_column_int64(statement, 2))
                        let instance = ShapeLexicon(text: word, input: cangjie, complex: complex, order: order)
                        items.append(instance)
                }
                return items
        }
}

extension Engine {
        public static func strokeReverseLookup(text: String) -> [Candidate] {
                let matched = match(stroke: text)
                let globed = glob(stroke: text).sorted(by: { (lhs, rhs) -> Bool in
                        guard lhs.complex == rhs.complex else { return lhs.complex < rhs.complex }
                        return lhs.order < rhs.order
                })
                let combined = (matched + globed).uniqued()
                let candidates = combined.map({ Engine.reveresLookup(text: $0.text, input: $0.input) })
                return candidates.flatMap({ $0 })
        }
        private static func match(stroke: String) -> [ShapeLexicon] {
                var items: [ShapeLexicon] = []
                let code = stroke.hash
                let command: String = "SELECT rowid, word FROM stroketable WHERE code = \(code);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return items }
                while sqlite3_step(statement) == SQLITE_ROW {
                        let order: Int = Int(sqlite3_column_int64(statement, 0))
                        let word: String = String(cString: sqlite3_column_text(statement, 1))
                        let instance = ShapeLexicon(text: word, input: stroke, complex: stroke.count, order: order)
                        items.append(instance)
                }
                return items
        }
        private static func glob(stroke: String) -> [ShapeLexicon] {
                var items: [ShapeLexicon] = []
                let command: String = "SELECT rowid, word, complex FROM stroketable WHERE stroke GLOB '\(stroke)*' ORDER BY complex ASC LIMIT 100;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return items }
                while sqlite3_step(statement) == SQLITE_ROW {
                        let order: Int = Int(sqlite3_column_int64(statement, 0))
                        let word: String = String(cString: sqlite3_column_text(statement, 1))
                        let complex: Int = Int(sqlite3_column_int64(statement, 2))
                        let instance = ShapeLexicon(text: word, input: stroke, complex: complex, order: order)
                        items.append(instance)
                }
                return items
        }
}
