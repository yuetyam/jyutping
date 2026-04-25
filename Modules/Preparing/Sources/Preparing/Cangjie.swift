import Foundation
import SQLite3
import CommonExtensions

struct CangjieEntry: Hashable {
        let word: String
        let cangjie5: String
        let cangjie3: String
        let c5complex: Int
        let c3complex: Int
        let c5code: Int
        let c3code: Int
}

struct Cangjie {
        static func generate() -> [CangjieEntry] {
                let characters = LexiconConverter.jyutpingSourceLines.compactMap({ line -> String? in
                        guard let word = line.split(separator: "\t").first else { return nil }
                        guard word.count == 1 else { return nil }
                        return word.trimmingCharacters(in: .whitespaces)
                }).distinct()
                return characters.flatMap({ item -> [CangjieEntry] in
                        let cangjie5Matches = match(cangjie5: item)
                        let cangjie3Matches = match(cangjie3: item)
                        guard !(cangjie5Matches.isEmpty && cangjie3Matches.isEmpty) else { return [] }
                        var instances: [CangjieEntry] = []
                        let upperBound: Int = max(cangjie5Matches.count, cangjie3Matches.count)
                        for index in 0..<upperBound {
                                let cangjie5: String = cangjie5Matches.fetch(index) ?? "X"
                                let cangjie3: String = cangjie3Matches.fetch(index) ?? "X"
                                let c5code = cangjie5.charCode ?? 0
                                let c3code: Int = cangjie3.charCode ?? 0
                                let c5complex = cangjie5.count
                                let c3complex = cangjie3.count
                                let instance = CangjieEntry(word: item, cangjie5: cangjie5, cangjie3: cangjie3, c5complex: c5complex, c3complex: c3complex, c5code: c5code, c3code: c3code)
                                instances.append(instance)
                        }
                        return instances
                }).distinct()
        }

        static func match<T: StringProtocol>(cangjie5 text: T) -> [String] {
                var items: [String] = []
                let command: String = "SELECT cangjie FROM cangjie5_table WHERE word = '\(text)';"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(cangjieDatabase, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                while sqlite3_step(statement) == SQLITE_ROW {
                        let cangjie: String = String(cString: sqlite3_column_text(statement, 0))
                        items.append(cangjie)
                }
                return items
        }
        static func match<T: StringProtocol>(cangjie3 text: T) -> [String] {
                var items: [String] = []
                let command: String = "SELECT cangjie FROM cangjie3_table WHERE word = '\(text)';"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(cangjieDatabase, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                while sqlite3_step(statement) == SQLITE_ROW {
                        let cangjie: String = String(cString: sqlite3_column_text(statement, 0))
                        items.append(cangjie)
                }
                return items
        }

        static func closeCangjieDatabase() {
                sqlite3_close_v2(cangjieDatabase)
        }
        /// In-memory shared database for cangjie5, cangjie3, quick5, and quick3
        nonisolated(unsafe) static let cangjieDatabase: OpaquePointer? = {
                var db: OpaquePointer? = nil
                guard sqlite3_open_v2(":memory:", &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX, nil) == SQLITE_OK else { return nil }
                return db
        }()
        static func prepareCangjieDatabase() {
                createCangjie5Table()
                insertCangjie5Values()
                createCangjie3Table()
                insertCangjie3Values()
                createIndexes()
        }
        private static func createCangjie5Table() {
                let command: String = "CREATE TABLE cangjie5_table (id INTEGER PRIMARY KEY AUTOINCREMENT, word TEXT NOT NULL, cangjie TEXT NOT NULL);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(cangjieDatabase, command, -1, &statement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }
        private static func insertCangjie5Values() {
                guard let url = Bundle.module.url(forResource: "cangjie5", withExtension: "txt") else { return }
                guard let sourceContent = try? String(contentsOf: url, encoding: .utf8) else { return }
                let sourceLines: [String] = sourceContent.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let entries = sourceLines.compactMap { sourceLine -> String? in
                        let parts = sourceLine.split(separator: "\t")
                        guard parts.count == 2 else { return nil }
                        let word = parts[0]
                        let cangjie = parts[1]
                        return "('\(word)', '\(cangjie)')"
                }
                let values: String = entries.joined(separator: ", ")
                let command: String = "INSERT INTO cangjie5_table (word, cangjie) VALUES \(values);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(cangjieDatabase, command, -1, &statement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }
        private static func createCangjie3Table() {
                let command: String = "CREATE TABLE cangjie3_table (id INTEGER PRIMARY KEY AUTOINCREMENT, word TEXT NOT NULL, cangjie TEXT NOT NULL);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(cangjieDatabase, command, -1, &statement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }
        private static func insertCangjie3Values() {
                guard let url = Bundle.module.url(forResource: "cangjie3", withExtension: "txt") else { return }
                guard let sourceContent = try? String(contentsOf: url, encoding: .utf8) else { return }
                let sourceLines: [String] = sourceContent.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let entries = sourceLines.compactMap { sourceLine -> String? in
                        let parts = sourceLine.split(separator: "\t")
                        guard parts.count == 2 else { return nil }
                        let word = parts[0]
                        let cangjie = parts[1]
                        return "('\(word)', '\(cangjie)')"
                }
                let values: String = entries.joined(separator: ", ")
                let command: String = "INSERT INTO cangjie3_table (word, cangjie) VALUES \(values);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(cangjieDatabase, command, -1, &statement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }
        private static func createIndexes() {
                let commands: [String] = [
                        "CREATE INDEX ix_cangjie5_word ON cangjie5_table (word);",
                        "CREATE INDEX ix_cangjie3_word ON cangjie3_table (word);"
                ]
                for command in commands {
                        var statement: OpaquePointer? = nil
                        defer { sqlite3_finalize(statement) }
                        guard sqlite3_prepare_v2(cangjieDatabase, command, -1, &statement, nil) == SQLITE_OK else { return }
                        guard sqlite3_step(statement) == SQLITE_DONE else { return }
                }
        }
}
