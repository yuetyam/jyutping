import Foundation
import SQLite3
import CommonExtensions

struct UnihanDefinition {
        static func generate() -> [(UInt32, String)] {
                prepare()
                guard let url = Bundle.module.url(forResource: "jyutping", withExtension: "txt") else { return [] }
                guard let sourceContent = try? String(contentsOf: url, encoding: .utf8) else { return [] }
                let sourceLines: [String] = sourceContent.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let words = sourceLines.compactMap({ line -> String.SubSequence? in
                        guard let word = line.split(separator: "\t").first else { return nil }
                        guard word.count == 1 else { return nil }
                        return word
                })
                let entries = words.distinct().compactMap { word -> (UInt32, String)? in
                        guard let matched = match(text: word) else { return nil }
                        guard let decimalCode = word.first?.unicodeScalars.first?.value else { return nil }
                        return (decimalCode, matched)
                }
                sqlite3_close_v2(database)
                return entries
        }

        private static func match<T: StringProtocol>(text: T) -> String? {
                let command: String = "SELECT definition FROM definitiontable WHERE word = '\(text)' LIMIT 1;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return nil }
                guard sqlite3_step(statement) == SQLITE_ROW else { return nil }
                let definition: String = String(cString: sqlite3_column_text(statement, 0))
                return definition.isEmpty ? "(None)" : definition
        }

        nonisolated(unsafe) private static let database: OpaquePointer? = {
                var db: OpaquePointer? = nil
                guard sqlite3_open_v2(":memory:", &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, nil) == SQLITE_OK else { return nil }
                return db
        }()
        private static func prepare() {
                // guard sqlite3_open_v2(":memory:", &database, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, nil) == SQLITE_OK else { return }
                createTable()
                insertValues()
                createIndexes()
        }
        private static func createTable() {
                let command: String = "CREATE TABLE definitiontable(word TEXT NOT NULL, definition TEXT NOT NULL);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }
        private static func insertValues() {
                guard let url = Bundle.module.url(forResource: "definition", withExtension: "txt") else { return }
                guard let sourceContent = try? String(contentsOf: url, encoding: .utf8) else { return }
                let sourceLines: [String] = sourceContent.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let entries = sourceLines.compactMap { line -> String? in
                        let parts = line.split(separator: "\t").map({ $0.trimmingCharacters(in: .whitespaces) }).filter({ !$0.isEmpty })
                        guard parts.count == 3 else { return nil }
                        let word = parts[0]
                        let definition = parts[2].replacingOccurrences(of: "'", with: "’")
                        return "('\(word)', '\(definition)')"
                }
                let values: String = entries.joined(separator: ", ")
                let command: String = "INSERT INTO definitiontable (word, definition) VALUES \(values);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }
        private static func createIndexes() {
                let command: String = "CREATE INDEX definitionwordindex ON definitiontable(word);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }
}
