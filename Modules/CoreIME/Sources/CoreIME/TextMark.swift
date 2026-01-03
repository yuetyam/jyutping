import Foundation
import SQLite3
import CommonExtensions

extension Engine {
        public static func searchTextMarks<T: RandomAccessCollection<InputEvent>>(for events: T) -> [Candidate] {
                let text: String = events.map(\.text).joined()
                let command: String = "SELECT mark FROM mark_table WHERE spell = ?;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                guard sqlite3_bind_int64(statement, 1, Int64(text.hashCode())) == SQLITE_OK else { return [] }
                var marks: [String] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        guard let mark = sqlite3_column_text(statement, 0) else { continue }
                        marks.append(String(cString: mark))
                }
                return marks.map({ Candidate(input: text, text: $0) })
        }
        public static func queryTextMarks<T: RandomAccessCollection<Combo>>(for combos: T) -> [Candidate] {
                let nineKeyCode = combos.map(\.code).decimalCombined()
                guard nineKeyCode > 0 else { return [] }
                let command: String = "SELECT input, mark FROM mark_table WHERE nine_key_code = ?;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                guard sqlite3_bind_int64(statement, 1, Int64(nineKeyCode)) == SQLITE_OK else { return [] }
                var candidates: [Candidate] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        guard let input = sqlite3_column_text(statement, 0) else { continue }
                        guard let mark = sqlite3_column_text(statement, 1) else { continue }
                        candidates.append(Candidate(input: String(cString: input), text: String(cString: mark)))
                }
                return candidates
        }
}
