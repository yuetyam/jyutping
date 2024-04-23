import Foundation
import SQLite3

extension Engine {
        static func fetchTextMark(text: String) -> [Candidate] {
                var candidates: [Candidate] = []
                let code: Int = text.hash
                let command: String = "SELECT mark FROM marktable WHERE code = \(code);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return candidates }
                while sqlite3_step(statement) == SQLITE_ROW {
                        let textMark: String = String(cString: sqlite3_column_text(statement, 0))
                        let candidate = Candidate(input: text, text: textMark)
                        candidates.append(candidate)
                }
                return candidates
        }
}
