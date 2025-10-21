import Foundation
import SQLite3
import CommonExtensions

struct StrokeEntry: Hashable {
        let word: String
        let stroke: String
        let complex: Int
        let ping: Int
        let code: Int
        static func == (lhs: StrokeEntry, rhs: StrokeEntry) -> Bool {
                return lhs.word == rhs.word && lhs.stroke == rhs.stroke
        }
        func hash(into hasher: inout Hasher) {
                hasher.combine(word)
                hasher.combine(stroke)
        }
}

struct Stroke {
        private static let codeMap: [Character : Int] = [
                "w" : 1,
                "s" : 2,
                "a" : 3,
                "d" : 4,
                "z" : 5,

                "h" : 1,
                // "s" : 2,
                "p" : 3,
                "n" : 4,
                // "z" : 5,

                "1" : 1,
                "2" : 2,
                "3" : 3,
                "4" : 4,
                "5" : 5,
        ]
        static func generate() -> [StrokeEntry] {
                prepare()
                guard let url = Bundle.module.url(forResource: "jyutping", withExtension: "txt") else { return [] }
                guard let sourceContent = try? String(contentsOf: url, encoding: .utf8) else { return [] }
                let sourceLines: [String] = sourceContent.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let characters = sourceLines.compactMap { line -> String? in
                        guard let word = line.split(separator: "\t").first else { return nil }
                        guard word.count == 1 else { return nil }
                        return String(word)
                }
                defer {
                        sqlite3_close_v2(database)
                }
                return characters.distinct().flatMap({ word -> [StrokeEntry] in
                        let matches = match(text: word)
                        guard !(matches.isEmpty) else { return [] }
                        let entries = matches.map { text -> StrokeEntry in
                                let codes = text.compactMap({ codeMap[$0] })
                                guard codes.count == text.count else { fatalError("bad stroke format: \(word) = \(text)") }
                                let stroke = codes.map({ String($0) }).joined()
                                let code = codes.decimalCombined()
                                return StrokeEntry(word: word, stroke: stroke, complex: stroke.count, ping: Int(stroke.hashCode()), code: code)
                        }
                        return entries
                }).distinct()
        }

        private static func match<T: StringProtocol>(text: T) -> [String] {
                var items: [String] = []
                let command: String = "SELECT stroke FROM stroketable WHERE word = '\(text)';"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                while sqlite3_step(statement) == SQLITE_ROW {
                        let stroke: String = String(cString: sqlite3_column_text(statement, 0))
                        items.append(stroke)
                }
                return items
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
                createIndies()
        }
        private static func createTable() {
                let command: String = "CREATE TABLE stroketable(word TEXT NOT NULL, stroke TEXT NOT NULL);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }
        private static func insertValues() {
                guard let url = Bundle.module.url(forResource: "stroke", withExtension: "txt") else { return }
                guard let sourceContent = try? String(contentsOf: url, encoding: .utf8) else { return }
                let sourceLines: [String] = sourceContent.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let entries = sourceLines.compactMap { sourceLine -> String? in
                        let parts = sourceLine.split(separator: "\t")
                        guard parts.count == 2 else { return nil }
                        let word = parts[0]
                        let stroke = parts[1]
                        return "('\(word)', '\(stroke)')"
                }
                let values: String = entries.joined(separator: ", ")
                let command: String = "INSERT INTO stroketable (word, stroke) VALUES \(values);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }
        private static func createIndies() {
                let command: String = "CREATE INDEX strokewordindex ON stroketable(word);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(statement) == SQLITE_DONE else { return }
        }
}
