import Foundation
import SQLite3

struct Cangjie {
        static func generate() -> [String] {
                prepare()
                guard let url = Bundle.module.url(forResource: "jyutping", withExtension: "txt") else { return [] }
                guard let sourceContent = try? String(contentsOf: url) else { return [] }
                let sourceLines: [String] = sourceContent.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let characters = sourceLines.compactMap { line -> String.SubSequence? in
                        guard let word = line.split(separator: "\t").first else { return nil }
                        guard word.count == 1 else { return nil }
                        return word
                }
                let items = characters.uniqued().map { item -> [String] in
                        let cangjies = match(text: item)
                        guard !(cangjies.isEmpty) else { return [] }
                        let entries = cangjies.compactMap { cangjie -> String? in
                                guard let code = cangjie.charcode else { return nil }
                                let complex = cangjie.count
                                return "\(item)\t\(cangjie)\t\(complex)\t\(code)"
                        }
                        return entries
                }
                sqlite3_close_v2(database)
                return items.flatMap({ $0 })
        }

        private static func match<T: StringProtocol>(text: T) -> [String] {
                var items: [String] = []
                let command: String = "SELECT cangjie FROM cangjietable WHERE word = '\(text)';"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                while sqlite3_step(statement) == SQLITE_ROW {
                        let cangjie: String = String(cString: sqlite3_column_text(statement, 0))
                        items.append(cangjie)
                }
                return items
        }

        private static var database: OpaquePointer? = nil
        private static func prepare() {
                guard sqlite3_open_v2(":memory:", &database, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, nil) == SQLITE_OK else { return }
                createTable()
                insertValues()
                createIndies()
        }
        private static func createTable() {
                let command: String = "CREATE TABLE cangjietable(word TEXT NOT NULL, cangjie TEXT NOT NULL);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }
        private static func insertValues() {
                guard let url = Bundle.module.url(forResource: "cangjie", withExtension: "txt") else { return }
                guard let sourceContent = try? String(contentsOf: url) else { return }
                let sourceLines: [String] = sourceContent.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let entries = sourceLines.map { sourceLine -> String? in
                        let parts = sourceLine.split(separator: "\t")
                        guard parts.count == 2 else { return nil }
                        let word = parts[0]
                        let cangjie = parts[1]
                        return "('\(word)', '\(cangjie)')"
                }
                let values: String = entries.compactMap({ $0 }).joined(separator: ", ")
                let command: String = "INSERT INTO cangjietable (word, cangjie) VALUES \(values);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }
        private static func createIndies() {
                let command: String = "CREATE INDEX cangjiewordindex ON cangjietable(word);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }
}
