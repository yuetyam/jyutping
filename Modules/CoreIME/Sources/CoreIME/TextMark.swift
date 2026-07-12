import Foundation
import SQLite3
import CommonExtensions

extension Engine {
        public static func searchTextMarks<T: RandomAccessCollection<VirtualInputKey>>(for keys: T) -> [Lexicon] {
                let spell = keys.conjoinedCode.toInt64()
                let complex = keys.count.toInt64()
                let command: String = "SELECT mark FROM mark_table WHERE spell = ? AND complex = ? ORDER BY rowid;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                guard sqlite3_bind_int64(statement, 1, spell) == SQLITE_OK else { return [] }
                guard sqlite3_bind_int64(statement, 2, complex) == SQLITE_OK else { return [] }
                var marks: [String] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        guard let mark = sqlite3_column_text(statement, 0) else { continue }
                        marks.append(String(cString: mark))
                }
                guard marks.isNotEmpty else { return [] }
                let input: String = keys.map(\.text).joined()
                return marks.map({ Lexicon(input: input, text: $0) })
        }
        public static func queryTextMarks<T: RandomAccessCollection<Combo>>(for combos: T) -> [Lexicon] {
                let code = combos.map(\.digit).decimalOverflowed().toInt64()
                let complex = combos.count.toInt64()
                let command: String = "SELECT input, mark FROM mark_table WHERE nine_key_code = ? AND complex = ? ORDER BY rowid;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                guard sqlite3_bind_int64(statement, 1, code) == SQLITE_OK else { return [] }
                guard sqlite3_bind_int64(statement, 2, complex) == SQLITE_OK else { return [] }
                var items: [Lexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        guard let input = sqlite3_column_text(statement, 0) else { continue }
                        guard let textMark = sqlite3_column_text(statement, 1) else { continue }
                        let instance = Lexicon(input: String(cString: input), text: String(cString: textMark))
                        items.append(instance)
                }
                return items
        }
}
