import Foundation
import SQLite3
import CommonExtensions

extension Engine {
        public static func strokeReverseLookup<T: RandomAccessCollection<VirtualInputKey>>(_ keys: T) -> [Lexicon] {
                let strokeKeys = keys.compactMap(\.strokeKey)
                let isWildcard: Bool = strokeKeys.contains(where: \.isWildcard)
                let input: String = strokeKeys.map(\.code.description).joined()
                let text: String = isWildcard ? input.replacingOccurrences(of: "6", with: "[12345]") : input
                let matched: [ShapeLexicon] = isWildcard ? strokeWildcardMatch(text: text, input: input) : strokeMatch(keys: strokeKeys, text: text)
                return (matched + strokeGlob(text: text, input: input))
                        .distinct()
                        .flatMap({ Engine.reveresLookup(text: $0.text, input: $0.input) })
        }
        private static func strokeMatch<T: RandomAccessCollection<StrokeVirtualKey>>(keys: T, text: String) -> [ShapeLexicon] {
                let complex: Int = keys.count
                let isLongSequence: Bool = (complex >= 19)
                let column: String = isLongSequence ? "spell" : "code"
                let codeValue: Int = isLongSequence ? Int(text.hashCode()) : keys.map(\.code).decimalCombined()
                let command: String = "SELECT rowid, word FROM stroke_table WHERE \(column) = \(codeValue);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                var items: [ShapeLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let order: Int = Int(sqlite3_column_int64(statement, 0))
                        guard let word = sqlite3_column_text(statement, 1) else { continue }
                        let instance = ShapeLexicon(text: String(cString: word), input: text, complex: complex, order: order)
                        items.append(instance)
                }
                return items
        }
        private static func strokeWildcardMatch(text: String, input: String) -> [ShapeLexicon] {
                let command: String = "SELECT rowid, word, complex FROM stroke_table WHERE stroke LIKE '\(text)' LIMIT 100;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                var items: [ShapeLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let order: Int = Int(sqlite3_column_int64(statement, 0))
                        guard let word = sqlite3_column_text(statement, 1) else { continue }
                        let complex: Int = Int(sqlite3_column_int64(statement, 2))
                        let instance = ShapeLexicon(text: String(cString: word), input: input, complex: complex, order: order)
                        items.append(instance)
                }
                return items.sorted()
        }
        private static func strokeGlob(text: String, input: String) -> [ShapeLexicon] {
                let command: String = "SELECT rowid, word, complex FROM stroke_table WHERE stroke GLOB '\(text)*' ORDER BY complex ASC LIMIT 100;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                var items: [ShapeLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let order: Int = Int(sqlite3_column_int64(statement, 0))
                        guard let word = sqlite3_column_text(statement, 1) else { continue }
                        let complex: Int = Int(sqlite3_column_int64(statement, 2))
                        let instance = ShapeLexicon(text: String(cString: word), input: input, complex: complex, order: order)
                        items.append(instance)
                }
                return items.sorted()
        }
}
