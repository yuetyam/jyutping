import Foundation
import SQLite3
import CommonExtensions

extension Engine {
        public static func strokeReverseLookup<T: RandomAccessCollection<VirtualInputKey>>(events: T) -> [Candidate] {
                let strokeEvents = events.compactMap(\.strokeEvent)
                let isWildcard: Bool = strokeEvents.contains(where: \.isWildcard)
                let text: String = isWildcard ? strokeEvents.sequenceText.replacingOccurrences(of: "6", with: "[12345]") : strokeEvents.sequenceText
                let matched: [ShapeLexicon] = isWildcard ? wildcardMatch(strokeText: text) : match(events: strokeEvents, text: text)
                return (matched + glob(strokeText: text))
                        .distinct()
                        .flatMap({ Engine.reveresLookup(text: $0.text, input: $0.input) })
        }
        private static func match<T: RandomAccessCollection<StrokeEvent>>(events: T, text: String) -> [ShapeLexicon] {
                let complex: Int = events.count
                let isLongSequence: Bool = complex >= 19
                let column: String = isLongSequence ? "ping" : "code"
                let codeValue: Int = isLongSequence ? Int(text.hashCode()) : events.map(\.code).decimalCombined()
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
        private static func wildcardMatch(strokeText: String) -> [ShapeLexicon] {
                let command: String = "SELECT rowid, word, complex FROM stroke_table WHERE stroke LIKE '\(strokeText)' LIMIT 100;"
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
                let command: String = "SELECT rowid, word, complex FROM stroke_table WHERE stroke GLOB '\(strokeText)*' ORDER BY complex ASC LIMIT 100;"
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
