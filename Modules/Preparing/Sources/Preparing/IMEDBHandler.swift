import Foundation
import SQLite3

struct IMEDBHandler {

        private static var database: OpaquePointer? = nil

        static func prepare() {
                guard sqlite3_open_v2(":memory:", &database, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, nil) == SQLITE_OK else { return }
                createLexiconTable()
                createT2STable()
                createComposeTable()
                createPinyinTable()
                createCangjieTable()
                createStrokeTable()
                createSymbolTable()
                createTextMarkTable()
                createIndies()
                backupInMemoryDatabase()
                sqlite3_close_v2(database)
        }
        private static func backupInMemoryDatabase() {
                let path = "../CoreIME/Sources/CoreIME/Resources/imedb.sqlite3"
                if FileManager.default.fileExists(atPath: path) {
                        try? FileManager.default.removeItem(atPath: path)
                }
                var destination: OpaquePointer? = nil
                defer { sqlite3_close_v2(destination) }
                guard sqlite3_open_v2(path, &destination, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, nil) == SQLITE_OK else { return }
                let backup = sqlite3_backup_init(destination, "main", database, "main")
                guard sqlite3_backup_step(backup, -1) == SQLITE_DONE else { return }
                guard sqlite3_backup_finish(backup) == SQLITE_OK else { return }
        }

        private static func createIndies() {
                let commands: [String] = [
                        "CREATE INDEX lexiconpingindex ON lexicontable(ping);",
                        "CREATE INDEX lexiconshortcutindex ON lexicontable(shortcut);",
                        "CREATE INDEX lexiconwordindex ON lexicontable(word);",
                        "CREATE INDEX composepingindex ON composetable(ping);",
                        "CREATE INDEX pinyinshortcutindex ON pinyintable(shortcut);",
                        "CREATE INDEX pinyinpingindex ON pinyintable(ping);",
                        "CREATE INDEX cangjiecangjieindex ON cangjietable(cangjie);",
                        "CREATE INDEX cangjiecodeindex ON cangjietable(code);",
                        "CREATE INDEX strokestrokeindex ON stroketable(stroke);",
                        "CREATE INDEX strokecodeindex ON stroketable(code);",
                        "CREATE INDEX symbolshortcutindex ON symboltable(shortcut);",
                        "CREATE INDEX symbolpingindex ON symboltable(ping);"
                ]
                for command in commands {
                        var statement: OpaquePointer? = nil
                        defer { sqlite3_finalize(statement) }
                        guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                        guard sqlite3_step(statement) == SQLITE_DONE else { return }
                }
        }

        private static func createLexiconTable() {
                let createTable: String = "CREATE TABLE lexicontable(word TEXT NOT NULL, romanization TEXT NOT NULL, shortcut INTEGER NOT NULL, ping INTEGER NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                let sourceLines: [String] = Jyutping2Lexicon.convert()
                func insert(values: String) {
                        let insert: String = "INSERT INTO lexicontable (word, romanization, shortcut, ping) VALUES \(values);"
                        var insertStatement: OpaquePointer? = nil
                        defer { sqlite3_finalize(insertStatement) }
                        guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                        guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
                }
                let range: Range<Int> = 0..<2000
                let distance: Int = sourceLines.count / 2000
                for number in range {
                        let bound: Int = number == 1999 ? sourceLines.count : ((number + 1) * distance)
                        let part = sourceLines[(number * distance)..<bound]
                        let entries = part.compactMap { line -> String? in
                                let parts = line.split(separator: "\t")
                                guard parts.count == 4 else { return nil }
                                let word = parts[0]
                                let romanization = parts[1]
                                let shortcut = parts[2]
                                let ping = parts[3]
                                return "('\(word)', '\(romanization)', \(shortcut), \(ping))"
                        }
                        let values: String = entries.joined(separator: ", ")
                        insert(values: values)
                }
        }

        private static func createT2STable() {
                let createTable: String = "CREATE TABLE t2stable(traditional INTEGER NOT NULL PRIMARY KEY, simplified TEXT NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                guard let url = Bundle.module.url(forResource: "t2s", withExtension: "txt") else { return }
                guard let content = try? String(contentsOf: url) else { return }
                let sourceLines: [String] = content.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let entries = sourceLines.compactMap { sourceLine -> String? in
                        let parts = sourceLine.split(separator: "\t")
                        guard parts.count == 2 else { return nil }
                        let traditionalCode = parts[0]
                        let simplified = parts[1]
                        return "(\(traditionalCode), '\(simplified)')"
                }
                let values: String = entries.joined(separator: ", ")
                let insert: String = "INSERT INTO t2stable (traditional, simplified) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
        private static func createComposeTable() {
                let createTable: String = "CREATE TABLE composetable(word TEXT NOT NULL, romanization TEXT NOT NULL, ping INTEGER NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                guard let url = Bundle.module.url(forResource: "compose", withExtension: "txt") else { return }
                guard let content = try? String(contentsOf: url) else { return }
                let sourceLines: [String] = content.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let entries = sourceLines.compactMap { sourceLine -> String? in
                        let parts = sourceLine.split(separator: "\t")
                        guard parts.count == 3 else { return nil }
                        let word = parts[0]
                        let romanization = parts[1]
                        let ping = parts[2]
                        return "('\(word)', '\(romanization)', \(ping))"
                }
                let values: String = entries.joined(separator: ", ")
                let insert: String = "INSERT INTO composetable (word, romanization, ping) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
        private static func createPinyinTable() {
                let createTable: String = "CREATE TABLE pinyintable(word TEXT NOT NULL, pinyin TEXT NOT NULL, shortcut INTEGER NOT NULL, ping INTEGER NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                guard let url = Bundle.module.url(forResource: "pinyin", withExtension: "txt") else { return }
                guard let content = try? String(contentsOf: url) else { return }
                let sourceLines: [String] = content.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                func insert(values: String) {
                        let insert: String = "INSERT INTO pinyintable (word, pinyin, shortcut, ping) VALUES \(values);"
                        var insertStatement: OpaquePointer? = nil
                        defer { sqlite3_finalize(insertStatement) }
                        guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                        guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
                }
                let range: Range<Int> = 0..<2000
                let distance: Int = sourceLines.count / 2000
                for number in range {
                        let bound: Int = number == 1999 ? sourceLines.count : ((number + 1) * distance)
                        let part = sourceLines[(number * distance)..<bound]
                        let entries = part.compactMap { line -> String? in
                                let parts = line.split(separator: "\t")
                                guard parts.count == 4 else { return nil }
                                let word = parts[0]
                                let pinyin = parts[1]
                                let shortcut = parts[2]
                                let ping = parts[3]
                                return "('\(word)', '\(pinyin)', \(shortcut), \(ping))"
                        }
                        let values: String = entries.joined(separator: ", ")
                        insert(values: values)
                }
        }
        private static func createCangjieTable() {
                let createTable: String = "CREATE TABLE cangjietable(word TEXT NOT NULL, cangjie TEXT NOT NULL, complex INTEGER NOT NULL, code INTEGER NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                let sourceLines: [String] = Cangjie.generate()
                let entries = sourceLines.compactMap { sourceLine -> String? in
                        let parts = sourceLine.split(separator: "\t")
                        guard parts.count == 4 else { return nil }
                        let word = parts[0]
                        let cangjie = parts[1]
                        let complex = parts[2]
                        let code = parts[3]
                        return "('\(word)', '\(cangjie)', \(complex), \(code))"
                }
                let values: String = entries.joined(separator: ", ")
                let insert: String = "INSERT INTO cangjietable (word, cangjie, complex, code) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
        private static func createStrokeTable() {
                let createTable: String = "CREATE TABLE stroketable(word TEXT NOT NULL, stroke TEXT NOT NULL, complex INTEGER NOT NULL, code INTEGER NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                let sourceLines: [String] = Stroke.generate()
                let entries = sourceLines.compactMap { sourceLine -> String? in
                        let parts = sourceLine.split(separator: "\t")
                        guard parts.count == 4 else { return nil }
                        let word = parts[0]
                        let stroke = parts[1]
                        let complex = parts[2]
                        let code = parts[3]
                        return "('\(word)', '\(stroke)', \(complex), \(code))"
                }
                let values: String = entries.joined(separator: ", ")
                let insert: String = "INSERT INTO stroketable (word, stroke, complex, code) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
        private static func createSymbolTable() {
                let createTable: String = "CREATE TABLE symboltable(category INTEGER NOT NULL, codepoint TEXT NOT NULL, cantonese TEXT NOT NULL, romanization TEXT NOT NULL, shortcut INTEGER NOT NULL, ping INTEGER NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                guard let url = Bundle.module.url(forResource: "symbol", withExtension: "txt") else { return }
                guard let content = try? String(contentsOf: url) else { return }
                let sourceLines: [String] = content.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let entries = sourceLines.compactMap { sourceLine -> String? in
                        let parts = sourceLine.split(separator: "\t")
                        guard parts.count == 6 else { return nil }
                        let category = parts[0]
                        let codepoint = parts[1]
                        let cantonese = parts[2]
                        let romanization = parts[3]
                        let shortcut = parts[4]
                        let ping = parts[5]
                        return "(\(category), '\(codepoint)', '\(cantonese)', '\(romanization)', \(shortcut), \(ping))"
                }
                let values: String = entries.joined(separator: ", ")
                let insert: String = "INSERT INTO symboltable (category, codepoint, cantonese, romanization, shortcut, ping) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
        private static func createTextMarkTable() {
                let createTable: String = "CREATE TABLE marktable(code INTEGER NOT NULL PRIMARY KEY, mark TEXT NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                let sourceLines: [String] = TextMarkLexicon.convert()
                let entries = sourceLines.compactMap { line -> String? in
                        let parts = line.split(separator: "\t")
                        guard parts.count == 2 else { return nil }
                        let code = parts[0]
                        let text = parts[1]
                        return "(\(code), '\(text)')"
                }
                let values: String = entries.joined(separator: ", ")
                let insert: String = "INSERT INTO marktable (code, mark) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
}
