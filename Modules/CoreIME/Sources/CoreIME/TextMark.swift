import Foundation
import SQLite3

extension Engine {
        static func fetchTextMark(text: String) -> [Candidate] {
                let command: String = "SELECT mark FROM marktable WHERE code = ?;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                let code = Int64(text.lowercased().hash)
                guard sqlite3_bind_int64(statement, 1, code) == SQLITE_OK else { return [] }
                var textMarks: [String] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let textMark: String = String(cString: sqlite3_column_text(statement, 0))
                        textMarks.append(textMark)
                }
                return textMarks.map({ Candidate(input: text, text: $0) })
        }
}
