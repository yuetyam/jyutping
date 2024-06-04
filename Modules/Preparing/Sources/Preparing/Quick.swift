import Foundation
import SQLite3

struct Quick {
        static func generate() -> [String] {
                prepare()
                guard let url = Bundle.module.url(forResource: "jyutping", withExtension: "txt") else { return [] }
                guard let sourceContent = try? String(contentsOf: url) else { return [] }
                let sourceLines: [String] = sourceContent.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let words = sourceLines.compactMap { line -> String.SubSequence? in
                        guard let word = line.split(separator: "\t").first else { return nil }
                        return word
                }
                let entries = words.uniqued().map { word -> [String] in
                        switch word.count {
                        case 1:
                                let cangjie5Matches = match(cangjie5: word)
                                let cangjie3Matches = match(cangjie3: word)
                                guard !(cangjie5Matches.isEmpty && cangjie3Matches.isEmpty) else { return [] }
                                var instances: [String] = []
                                let upperBound: Int = max(cangjie5Matches.count, cangjie3Matches.count)
                                for index in 0..<upperBound {
                                        let cangjie5: String = cangjie5Matches.fetch(index) ?? "X"
                                        let cangjie3: String = cangjie3Matches.fetch(index) ?? "X"
                                        let quick5: String = (cangjie5.count > 2) ? "\(cangjie5.first!)\(cangjie5.last!)" : cangjie5
                                        let quick3: String = (cangjie3.count > 2) ? "\(cangjie3.first!)\(cangjie3.last!)" : cangjie3
                                        let q5complex: Int = quick5.count
                                        let q3complex: Int = quick3.count
                                        let q5code: Int = quick5.charcode ?? 47
                                        let q3code: Int = quick3.charcode ?? 47
                                        let instance: String = "\(word)\t\(quick5)\t\(q5complex)\t\(q5code)\t\(quick3)\t\(q3complex)\t\(q3code)"
                                        instances.append(instance)
                                }
                                return instances
                        default:
                                let characters: [String] = word.map({ String($0) })
                                let cangjie5Sequence: [String] = characters.map({ match(cangjie5: $0).first ?? "X" })
                                let cangjie3Sequence: [String] = characters.map({ match(cangjie3: $0).first ?? "X" })
                                let quick5Sequence: [String] = cangjie5Sequence.map({ $0.count > 2 ? "\($0.first!)\($0.last!)" : $0 })
                                let quick3Sequence: [String] = cangjie3Sequence.map({ $0.count > 2 ? "\($0.first!)\($0.last!)" : $0 })
                                let quick5 = quick5Sequence.joined()
                                let quick3 = quick3Sequence.joined()
                                let q5complex = quick5.count
                                let q3complex = quick3.count
                                let q5code: Int = quick5.charcode ?? 47
                                let q3code: Int = quick3.charcode ?? 47
                                let instance: String = "\(word)\t\(quick5)\t\(q5complex)\t\(q5code)\t\(quick3)\t\(q3complex)\t\(q3code)"
                                return [instance]
                        }
                }
                sqlite3_close_v2(database)
                return entries.flatMap({ $0 }).uniqued()
        }

        private static func match<T: StringProtocol>(cangjie5 text: T) -> [String] {
                var items: [String] = []
                let command: String = "SELECT cangjie FROM cangjie5table WHERE word = '\(text)';"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                while sqlite3_step(statement) == SQLITE_ROW {
                        let cangjie: String = String(cString: sqlite3_column_text(statement, 0))
                        items.append(cangjie)
                }
                return items
        }
        private static func match<T: StringProtocol>(cangjie3 text: T) -> [String] {
                var items: [String] = []
                let command: String = "SELECT cangjie FROM cangjie3table WHERE word = '\(text)';"
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
                createCangjie5Table()
                insertCangjie5Values()
                createCangjie3Table()
                insertCangjie3Values()
                createIndies()
        }
        private static func createCangjie5Table() {
                let command: String = "CREATE TABLE cangjie5table(word TEXT NOT NULL, cangjie TEXT NOT NULL);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }
        private static func insertCangjie5Values() {
                guard let url = Bundle.module.url(forResource: "cangjie5", withExtension: "txt") else { return }
                guard let sourceContent = try? String(contentsOf: url) else { return }
                let sourceLines: [String] = sourceContent.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let entries = sourceLines.compactMap { sourceLine -> String? in
                        let parts = sourceLine.split(separator: "\t")
                        guard parts.count == 2 else { return nil }
                        let word = parts[0]
                        let cangjie = parts[1]
                        return "('\(word)', '\(cangjie)')"
                }
                let values: String = entries.joined(separator: ", ")
                let command: String = "INSERT INTO cangjie5table (word, cangjie) VALUES \(values);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }
        private static func createCangjie3Table() {
                let command: String = "CREATE TABLE cangjie3table(word TEXT NOT NULL, cangjie TEXT NOT NULL);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }
        private static func insertCangjie3Values() {
                guard let url = Bundle.module.url(forResource: "cangjie3", withExtension: "txt") else { return }
                guard let sourceContent = try? String(contentsOf: url) else { return }
                let sourceLines: [String] = sourceContent.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let entries = sourceLines.compactMap { sourceLine -> String? in
                        let parts = sourceLine.split(separator: "\t")
                        guard parts.count == 2 else { return nil }
                        let word = parts[0]
                        let cangjie = parts[1]
                        return "('\(word)', '\(cangjie)')"
                }
                let values: String = entries.joined(separator: ", ")
                let command: String = "INSERT INTO cangjie3table (word, cangjie) VALUES \(values);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }
        private static func createIndies() {
                let commands: [String] = [
                        "CREATE INDEX cangjie5wordindex ON cangjie5table(word);",
                        "CREATE INDEX cangjie3wordindex ON cangjie3table(word);"
                ]
                for command in commands {
                        var statement: OpaquePointer? = nil
                        defer { sqlite3_finalize(statement) }
                        guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                        guard sqlite3_step(statement) == SQLITE_DONE else { return }
                }
        }
}
