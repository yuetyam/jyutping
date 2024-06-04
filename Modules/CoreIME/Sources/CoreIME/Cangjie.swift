import Foundation
import SQLite3

extension Engine {

        /// Cangjie / Quick(Sucheng) Reverse Lookup
        /// - Parameters:
        ///   - text: User input
        ///   - variant: Cangjie / Quick version
        /// - Returns: Candidates
        public static func cangjieReverseLookup(text: String, variant: CangjieVariant) -> [Candidate] {
                switch variant {
                case .cangjie5:
                        return cangjie5ReverseLookup(text: text)
                case .cangjie3:
                        return cangjie3ReverseLookup(text: text)
                case .quick5:
                        return quick5ReverseLookup(text: text)
                case .quick3:
                        return quick3ReverseLookup(text: text)
                }
        }
}

private extension Engine {
        static func cangjie5ReverseLookup(text: String) -> [Candidate] {
                let matched = match(cangjie5: text)
                let globed = glob(cangjie5: text).sorted(by: { (lhs, rhs) -> Bool in
                        guard lhs.complex == rhs.complex else { return lhs.complex < rhs.complex }
                        return lhs.order < rhs.order
                })
                let combined = (matched + globed).uniqued()
                let candidates = combined.map({ Engine.reveresLookup(text: $0.text, input: $0.input) })
                return candidates.flatMap({ $0 })
        }
        private static func match(cangjie5 text: String) -> [ShapeLexicon] {
                var items: [ShapeLexicon] = []
                guard let code = text.charcode else { return [] }
                let command: String = "SELECT rowid, word FROM cangjietable WHERE cj5code = \(code);"
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
        private static func glob(cangjie5 text: String) -> [ShapeLexicon] {
                var items: [ShapeLexicon] = []
                let command: String = "SELECT rowid, word, cj5complex FROM cangjietable WHERE cangjie5 GLOB '\(text)*' ORDER BY cj5complex ASC LIMIT 100;"
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
private extension Engine {
        static func cangjie3ReverseLookup(text: String) -> [Candidate] {
                let matched = match(cangjie3: text)
                let globed = glob(cangjie3: text).sorted(by: { (lhs, rhs) -> Bool in
                        guard lhs.complex == rhs.complex else { return lhs.complex < rhs.complex }
                        return lhs.order < rhs.order
                })
                let combined = (matched + globed).uniqued()
                let candidates = combined.map({ Engine.reveresLookup(text: $0.text, input: $0.input) })
                return candidates.flatMap({ $0 })
        }
        private static func match(cangjie3 text: String) -> [ShapeLexicon] {
                var items: [ShapeLexicon] = []
                guard let code = text.charcode else { return [] }
                let command: String = "SELECT rowid, word FROM cangjietable WHERE cj3code = \(code);"
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
        private static func glob(cangjie3 text: String) -> [ShapeLexicon] {
                var items: [ShapeLexicon] = []
                let command: String = "SELECT rowid, word, cj3complex FROM cangjietable WHERE cangjie3 GLOB '\(text)*' ORDER BY cj3complex ASC LIMIT 100;"
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
