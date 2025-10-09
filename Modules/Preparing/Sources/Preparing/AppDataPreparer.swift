import Foundation
import SQLite3

struct AppDataPreparer {

        nonisolated(unsafe) fileprivate static let database: OpaquePointer? = {
                var db: OpaquePointer? = nil
                guard sqlite3_open_v2(":memory:", &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX, nil) == SQLITE_OK else { return nil }
                return db
        }()

        static func prepare() async {
                await withTaskGroup(of: Void.self) { group in
                        group.addTask { await createJyutpingTable() }
                        group.addTask { await createCollocationTable() }
                        group.addTask { await createDictionaryTable() }
                        group.addTask { await createYingWaaTable() }
                        group.addTask { await createChoHokTable() }
                        group.addTask { await createFanWanTable() }
                        group.addTask { await createGwongWanTable() }
                        group.addTask { await createDefinitionTable() }
                        await group.waitForAll()
                }
                createIndies()
                backupInMemoryDatabase()
                sqlite3_close_v2(database)
        }

        private static func backupInMemoryDatabase() {
                let path: String = "../AppDataSource/Sources/AppDataSource/Resources/appdb.sqlite3"
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
}

private extension AppDataPreparer {
        static func createJyutpingTable() async {
                let createTable: String = "CREATE TABLE jyutpingtable(word TEXT NOT NULL, romanization TEXT NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                guard let url = Bundle.module.url(forResource: "jyutping", withExtension: "txt") else { return }
                guard let content = try? String(contentsOf: url, encoding: .utf8) else { return }
                let sourceLines: [String] = content.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let entries = sourceLines.compactMap { sourceLine -> String? in
                        let parts = sourceLine.split(separator: "\t")
                        guard parts.count == 2 else { return nil }
                        let word = parts[0]
                        let romanization = parts[1]
                        return "('\(word)', '\(romanization)')"
                }
                let values: String = entries.joined(separator: ", ")
                let insert: String = "INSERT INTO jyutpingtable (word, romanization) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
        static func createIndies() {
                let commands: [String] = [
                        "CREATE INDEX jyutpingwordindex ON jyutpingtable(word);",
                        "CREATE INDEX jyutpingromanizationindex ON jyutpingtable(romanization);",

                        "CREATE INDEX collocationwordindex ON collocationtable(word);",
                        "CREATE INDEX collocationromanizationindex ON collocationtable(romanization);",

                        "CREATE INDEX dictionarywordindex ON dictionarytable(word);",
                        "CREATE INDEX dictionaryromanizationindex ON dictionarytable(romanization);",

                        "CREATE INDEX yingwaacodeindex ON yingwaatable(code);",
                        "CREATE INDEX yingwaaromanizationindex ON yingwaatable(romanization);",

                        "CREATE INDEX chohokcodeindex ON chohoktable(code);",
                        "CREATE INDEX chohokromanizationindex ON chohoktable(romanization);",

                        "CREATE INDEX fanwancodeindex ON fanwantable(code);",
                        "CREATE INDEX fanwanromanizationindex ON fanwantable(romanization);",

                        "CREATE INDEX gwongwancodeindex ON gwongwantable(code);",
                ]
                for command in commands {
                        var statement: OpaquePointer? = nil
                        defer { sqlite3_finalize(statement) }
                        guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                        guard sqlite3_step(statement) == SQLITE_DONE else { return }
                }
        }
}
private extension AppDataPreparer {
        static func createCollocationTable() async {
                let createTable: String = "CREATE TABLE collocationtable(word TEXT NOT NULL, romanization TEXT NOT NULL, collocation TEXT NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                guard let url = Bundle.module.url(forResource: "collocation", withExtension: "txt") else { return }
                guard let content = try? String(contentsOf: url, encoding: .utf8) else { return }
                let sourceLines: [String] = content.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let entries = sourceLines.compactMap { sourceLine -> String? in
                        let parts = sourceLine.split(separator: "\t")
                        guard parts.count == 3 else { return nil }
                        let word = parts[0]
                        let romanization = parts[1]
                        let collocation = parts[2]
                        return "('\(word)', '\(romanization)', '\(collocation)')"
                }
                let values: String = entries.joined(separator: ", ")
                let insert: String = "INSERT INTO collocationtable (word, romanization, collocation) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
}
private extension AppDataPreparer {
        static func createDictionaryTable() async {
                let createTable: String = "CREATE TABLE dictionarytable(word TEXT NOT NULL, romanization TEXT NOT NULL, description TEXT NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                guard let url = Bundle.module.url(forResource: "wordshk", withExtension: "txt") else { return }
                guard let content = try? String(contentsOf: url, encoding: .utf8) else { return }
                let sourceLines: [String] = content.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                func insert(values: String) {
                        let insert: String = "INSERT INTO dictionarytable (word, romanization, description) VALUES \(values);"
                        var insertStatement: OpaquePointer? = nil
                        defer { sqlite3_finalize(insertStatement) }
                        guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                        guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
                }
                let range: Range<Int> = 0..<2000
                let distance: Int = sourceLines.count / 2000
                for number in range {
                        let bound: Int = (number == 1999) ? sourceLines.count : ((number + 1) * distance)
                        let part = sourceLines[(number * distance)..<bound]
                        let entries = part.compactMap { sourceLine -> String? in
                                let parts = sourceLine.split(separator: "\t")
                                guard parts.count == 3 else { return nil }
                                let word = parts[0]
                                let romanization = parts[1]
                                let description = parts[2]
                                return "('\(word)', '\(romanization)', '\(description)')"
                        }
                        let values: String = entries.joined(separator: ", ")
                        insert(values: values)
                }
        }
}
private extension AppDataPreparer {
        static func createYingWaaTable() async {
                let createTable: String = "CREATE TABLE yingwaatable(code INTEGER NOT NULL, word TEXT NOT NULL, romanization TEXT NOT NULL, pronunciation TEXT NOT NULL, pronunciationmark TEXT NOT NULL, interpretation TEXT NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { return }
                guard let url = Bundle.module.url(forResource: "yingwaa", withExtension: "txt") else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                guard let content = try? String(contentsOf: url, encoding: .utf8) else { return }
                let sourceLines: [String] = content.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let entries = sourceLines.compactMap { sourceLine -> String? in
                        let parts = sourceLine.split(separator: "\t")
                        guard parts.count == 6 else { return nil }
                        let code = parts[0]
                        let word = parts[1]
                        let romanization = parts[2]
                        let pronunciation = parts[3]
                        let pronunciationmark = parts[4]
                        let interpretation = parts[5]
                        return "(\(code), '\(word)', '\(romanization)', '\(pronunciation)', '\(pronunciationmark)', '\(interpretation)')"
                }
                let values: String = entries.joined(separator: ", ")
                let insert: String = "INSERT INTO yingwaatable (code, word, romanization, pronunciation, pronunciationmark, interpretation) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
        static func createChoHokTable() async {
                let createTable: String = "CREATE TABLE chohoktable(code INTEGER NOT NULL, word TEXT NOT NULL, romanization TEXT NOT NULL, initial TEXT NOT NULL, final TEXT NOT NULL, tone TEXT NOT NULL, faancit TEXT NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                guard let url = Bundle.module.url(forResource: "chohok", withExtension: "txt") else { return }
                guard let content = try? String(contentsOf: url, encoding: .utf8) else { return }
                let sourceLines: [String] = content.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let entries = sourceLines.compactMap { sourceLine -> String? in
                        let parts = sourceLine.split(separator: "\t")
                        guard parts.count == 7 else { return nil }
                        let code = parts[0]
                        let word = parts[1]
                        let romanization = parts[2]
                        let initial = parts[3]
                        let final = parts[4]
                        let tone = parts[5]
                        let faancit = parts[6]
                        return "(\(code), '\(word)', '\(romanization)', '\(initial)', '\(final)', '\(tone)', '\(faancit)')"
                }
                let values: String = entries.joined(separator: ", ")
                let insert: String = "INSERT INTO chohoktable (code, word, romanization, initial, final, tone, faancit) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
        static func createFanWanTable() async {
                let createTable: String = "CREATE TABLE fanwantable(code INTEGER NOT NULL, word TEXT NOT NULL, romanization TEXT NOT NULL, initial TEXT NOT NULL, final TEXT NOT NULL, yamyeung TEXT NOT NULL, tone TEXT NOT NULL, rhyme TEXT NOT NULL, interpretation TEXT NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                guard let url = Bundle.module.url(forResource: "fanwan", withExtension: "txt") else { return }
                guard let content = try? String(contentsOf: url, encoding: .utf8) else { return }
                let sourceLines: [String] = content.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let entries = sourceLines.compactMap { sourceLine -> String? in
                        let parts = sourceLine.split(separator: "\t")
                        guard parts.count == 9 else { return nil }
                        let code = parts[0]
                        let word = parts[1]
                        let romanization = parts[2]
                        let initial = parts[3]
                        let final = parts[4]
                        let yamyeung = parts[5]
                        let tone = parts[6]
                        let rhyme = parts[7]
                        let interpretation = parts[8]
                        return "(\(code), '\(word)', '\(romanization)', '\(initial)', '\(final)', '\(yamyeung)', '\(tone)', '\(rhyme)', '\(interpretation)')"
                }
                let values: String = entries.joined(separator: ", ")
                let insert: String = "INSERT INTO fanwantable (code, word, romanization, initial, final, yamyeung, tone, rhyme, interpretation) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
        static func createGwongWanTable() async {
                let createTable: String = "CREATE TABLE gwongwantable(code INTEGER NOT NULL, word TEXT NOT NULL, rhyme TEXT NOT NULL, subrhyme TEXT NOT NULL, subrhymeserial INTEGER NOT NULL, subrhymenumber INTEGER NOT NULL, upper TEXT NOT NULL, lower TEXT NOT NULL, initial TEXT NOT NULL, rounding TEXT NOT NULL, division TEXT NOT NULL, rhymeclass TEXT NOT NULL, repeating TEXT NOT NULL, tone TEXT NOT NULL, interpretation TEXT NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                guard let url = Bundle.module.url(forResource: "gwongwan", withExtension: "txt") else { return }
                guard let content = try? String(contentsOf: url, encoding: .utf8) else { return }
                let sourceLines: [String] = content.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let entries = sourceLines.compactMap { sourceLine -> String? in
                        let parts = sourceLine.split(separator: ",")
                        guard parts.count == 15 else { return nil }
                        let code = parts[0]
                        let word = parts[1]
                        let rhyme = parts[2]
                        let subrhyme = parts[3]
                        let subrhymeserial = parts[4]
                        let subrhymenumber = parts[5]
                        let upper = parts[6]
                        let lower = parts[7]
                        let initial = parts[8]
                        let rounding = parts[9]
                        let division = parts[10]
                        let rhymeclass = parts[11]
                        let repeating = parts[12]
                        let tone = parts[13]
                        let interpretation = parts[14]
                        return "(\(code), '\(word)', '\(rhyme)', '\(subrhyme)', \(subrhymeserial), \(subrhymenumber), '\(upper)', '\(lower)', '\(initial)', '\(rounding)', '\(division)', '\(rhymeclass)', '\(repeating)', '\(tone)', '\(interpretation)')"
                }
                let values: String = entries.joined(separator: ", ")
                let insert: String = "INSERT INTO gwongwantable (code, word, rhyme, subrhyme, subrhymeserial, subrhymenumber, upper, lower, initial, rounding, division, rhymeclass, repeating, tone, interpretation) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
        private static func createDefinitionTable() async {
                let createTable: String = "CREATE TABLE definitiontable(code INTEGER NOT NULL PRIMARY KEY, definition TEXT NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                let tuples = UnihanDefinition.generate()
                let entries = tuples.map { tuple -> String in
                        let code = tuple.0
                        let definition = tuple.1
                        return "(\(code), '\(definition)')"
                }
                let values: String = entries.joined(separator: ", ")
                let insert: String = "INSERT INTO definitiontable (code, definition) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }
}
