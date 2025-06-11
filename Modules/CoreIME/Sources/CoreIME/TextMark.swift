import Foundation
import SQLite3

extension Engine {
        static func fetchTextMarks(text: String) -> [Candidate] {
                let command: String = "SELECT mark FROM marktable WHERE ping = ?;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                guard sqlite3_bind_int64(statement, 1, Int64(text.hash)) == SQLITE_OK else { return [] }
                var textMarks: [String] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        guard let textMark = sqlite3_column_text(statement, 0) else { continue }
                        textMarks.append(String(cString: textMark))
                }
                return textMarks.map({ Candidate(input: text, text: $0) })
        }
        static func fetchTextMarks(combos: [Combo]) -> [Candidate] {
                let tenKeyCode = combos.map(\.rawValue).decimalCombined()
                guard tenKeyCode > 0 else { return [] }
                let command: String = "SELECT mark FROM marktable WHERE tenkeycode = ?;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                guard sqlite3_bind_int64(statement, 1, Int64(tenKeyCode)) == SQLITE_OK else { return [] }
                var candidates: [Candidate] = []
                let comboCount = combos.count
                while sqlite3_step(statement) == SQLITE_ROW {
                        guard let textMark = sqlite3_column_text(statement, 0) else { continue }
                        let text = String(cString: textMark)
                        let input = text.filter(\.isBasicLatinLetter).lowercased()
                        guard input.count == comboCount else { continue }
                        candidates.append(Candidate(input: input, text: text))
                }
                return candidates
        }
}
