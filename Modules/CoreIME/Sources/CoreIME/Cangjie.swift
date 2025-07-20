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
                return (match(cangjie5: text) + glob(cangjie5: text)).uniqued().flatMap({ Engine.reveresLookup(text: $0.text, input: $0.input) })
        }
        private static func match(cangjie5 text: String) -> [ShapeLexicon] {
                guard let code = text.charCode else { return [] }
                let command: String = "SELECT rowid, word FROM cangjietable WHERE c5code = \(code);"
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
        private static func glob(cangjie5 text: String) -> [ShapeLexicon] {
                let command: String = "SELECT rowid, word, c5complex FROM cangjietable WHERE cangjie5 GLOB '\(text)*' ORDER BY c5complex ASC LIMIT 100;"
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
private extension Engine {
        static func cangjie3ReverseLookup(text: String) -> [Candidate] {
                return (match(cangjie3: text) + glob(cangjie3: text))
                        .uniqued()
                        .flatMap({ Engine.reveresLookup(text: $0.text, input: $0.input) })
        }
        private static func match(cangjie3 text: String) -> [ShapeLexicon] {
                guard let code = text.charCode else { return [] }
                let command: String = "SELECT rowid, word FROM cangjietable WHERE c3code = \(code);"
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
        private static func glob(cangjie3 text: String) -> [ShapeLexicon] {
                let command: String = "SELECT rowid, word, c3complex FROM cangjietable WHERE cangjie3 GLOB '\(text)*' ORDER BY c3complex ASC LIMIT 100;"
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
