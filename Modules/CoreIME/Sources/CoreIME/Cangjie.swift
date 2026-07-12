import Foundation
import SQLite3
import CommonExtensions

extension Engine {

        /// Cangjie / Quick(Sucheng) Reverse Lookup
        /// - Parameters:
        ///   - keys: User input keys
        ///   - variant: Cangjie / Quick version
        /// - Returns: Lookup transformed Lexicons
        public static func cangjieReverseLookup<T: RandomAccessCollection<VirtualInputKey>>(keys: T, variant: CangjieVariant) -> [Lexicon] {
                switch variant {
                case .cangjie5:
                        return cangjie5ReverseLookup(keys: keys)
                case .cangjie3:
                        return cangjie3ReverseLookup(keys: keys)
                case .quick5:
                        return quick5ReverseLookup(keys: keys)
                case .quick3:
                        return quick3ReverseLookup(keys: keys)
                }
        }
}

private extension Engine {
        static func cangjie5ReverseLookup<T: RandomAccessCollection<VirtualInputKey>>(keys: T) -> [Lexicon] {
                let code = keys.conjoinedCode
                let text = keys.map(\.text).joined()
                let complex = keys.count
                return (match(c5code: code, input: text, complex: complex) + glob(cangjie5: text))
                        .distinct()
                        .flatMap({ Engine.reveresLookup(text: $0.text, input: $0.input) })
        }
        private static func match(c5code: Int, input: String, complex: Int) -> [ShapeLexicon] {
                let command: String = "SELECT rowid, word FROM cangjie_table WHERE c5code = \(c5code);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                var items: [ShapeLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let rowID: Int = Int(sqlite3_column_int64(statement, 0))
                        guard let word = sqlite3_column_text(statement, 1) else { continue }
                        let instance = ShapeLexicon(text: String(cString: word), input: input, complex: complex, number: rowID)
                        items.append(instance)
                }
                return items
        }
        private static func glob(cangjie5 text: String) -> [ShapeLexicon] {
                let command: String = "SELECT rowid, word, c5complex FROM cangjie_table WHERE cangjie5 GLOB '\(text)*' ORDER BY c5complex ASC LIMIT 100;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                var items: [ShapeLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let rowID: Int = Int(sqlite3_column_int64(statement, 0))
                        guard let word = sqlite3_column_text(statement, 1) else { continue }
                        let complex: Int = Int(sqlite3_column_int64(statement, 2))
                        let instance = ShapeLexicon(text: String(cString: word), input: text, complex: complex, number: rowID)
                        items.append(instance)
                }
                return items.sorted()
        }
}

private extension Engine {
        static func cangjie3ReverseLookup<T: RandomAccessCollection<VirtualInputKey>>(keys: T) -> [Lexicon] {
                let code = keys.conjoinedCode
                let text = keys.map(\.text).joined()
                let complex = keys.count
                return (match(c3code: code, input: text, complex: complex) + glob(cangjie3: text))
                        .distinct()
                        .flatMap({ Engine.reveresLookup(text: $0.text, input: $0.input) })
        }
        private static func match(c3code: Int, input: String, complex: Int) -> [ShapeLexicon] {
                let command: String = "SELECT rowid, word FROM cangjie_table WHERE c3code = \(c3code);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                var items: [ShapeLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let rowID: Int = Int(sqlite3_column_int64(statement, 0))
                        guard let word = sqlite3_column_text(statement, 1) else { continue }
                        let instance = ShapeLexicon(text: String(cString: word), input: input, complex: complex, number: rowID)
                        items.append(instance)
                }
                return items
        }
        private static func glob(cangjie3 text: String) -> [ShapeLexicon] {
                let command: String = "SELECT rowid, word, c3complex FROM cangjie_table WHERE cangjie3 GLOB '\(text)*' ORDER BY c3complex ASC LIMIT 100;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                var items: [ShapeLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let rowID: Int = Int(sqlite3_column_int64(statement, 0))
                        guard let word = sqlite3_column_text(statement, 1) else { continue }
                        let complex: Int = Int(sqlite3_column_int64(statement, 2))
                        let instance = ShapeLexicon(text: String(cString: word), input: text, complex: complex, number: rowID)
                        items.append(instance)
                }
                return items.sorted()
        }
}

private extension Engine {
        static func quick5ReverseLookup<T: RandomAccessCollection<VirtualInputKey>>(keys: T) -> [Lexicon] {
                let code = keys.conjoinedCode
                let text = keys.map(\.text).joined()
                let complex = keys.count
                return (match(q5code: code, input: text, complex: complex) + glob(quick5: text))
                        .distinct()
                        .flatMap({ Engine.reveresLookup(text: $0.text, input: $0.input) })
        }
        private static func match(q5code: Int, input: String, complex: Int) -> [ShapeLexicon] {
                let command: String = "SELECT rowid, word, q5complex FROM quick_table WHERE q5code = \(q5code);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                var items: [ShapeLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let rowID: Int = Int(sqlite3_column_int64(statement, 0))
                        let word = String(cString: sqlite3_column_text(statement, 1))
                        let q5complex: Int = Int(sqlite3_column_int64(statement, 2))
                        guard q5complex == complex else { continue }
                        let instance = ShapeLexicon(text: word, input: input, complex: complex, number: rowID)
                        items.append(instance)
                }
                return items
        }
        private static func glob(quick5 text: String) -> [ShapeLexicon] {
                let command: String = "SELECT rowid, word, q5complex FROM quick_table WHERE quick5 GLOB '\(text)*' ORDER BY q5complex ASC LIMIT 100;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                var items: [ShapeLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let rowID: Int = Int(sqlite3_column_int64(statement, 0))
                        let word = String(cString: sqlite3_column_text(statement, 1))
                        let q5complex: Int = Int(sqlite3_column_int64(statement, 2))
                        let instance = ShapeLexicon(text: word, input: text, complex: q5complex, number: rowID)
                        items.append(instance)
                }
                return items.sorted()
        }
}

private extension Engine {
        static func quick3ReverseLookup<T: RandomAccessCollection<VirtualInputKey>>(keys: T) -> [Lexicon] {
                let code = keys.conjoinedCode
                let text = keys.map(\.text).joined()
                let complex = keys.count
                return (match(q3code: code, input: text, complex: complex) + glob(quick3: text))
                        .distinct()
                        .flatMap({ Engine.reveresLookup(text: $0.text, input: $0.input) })
        }
        private static func match(q3code: Int, input: String, complex: Int) -> [ShapeLexicon] {
                let command: String = "SELECT rowid, word, q3complex FROM quick_table WHERE q3code = \(q3code);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                var items: [ShapeLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let rowID: Int = Int(sqlite3_column_int64(statement, 0))
                        let word = String(cString: sqlite3_column_text(statement, 1))
                        let q3complex: Int = Int(sqlite3_column_int64(statement, 2))
                        guard q3complex == complex else { continue }
                        let instance = ShapeLexicon(text: word, input: input, complex: complex, number: rowID)
                        items.append(instance)
                }
                return items
        }
        private static func glob(quick3 text: String) -> [ShapeLexicon] {
                let command: String = "SELECT rowid, word, q3complex FROM quick_table WHERE quick3 GLOB '\(text)*' ORDER BY q3complex ASC LIMIT 100;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                var items: [ShapeLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let rowID: Int = Int(sqlite3_column_int64(statement, 0))
                        let word = String(cString: sqlite3_column_text(statement, 1))
                        let q3complex: Int = Int(sqlite3_column_int64(statement, 2))
                        let instance = ShapeLexicon(text: word, input: text, complex: q3complex, number: rowID)
                        items.append(instance)
                }
                return items.sorted()
        }
}
