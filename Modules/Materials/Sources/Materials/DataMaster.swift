import Foundation
import SQLite3

public struct DataMaster {

        private(set) static var database: OpaquePointer? = nil
        private(set) static var isDatabaseReady: Bool = false

        public static func prepare(appVersion: String) {
                guard !isDatabaseReady else { return }
                guard !verifiedCachedDatabase(appVersion: appVersion) else {
                        isDatabaseReady = true
                        return
                }
                sqlite3_close_v2(database)
                guard sqlite3_open_v2(":memory:", &database, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, nil) == SQLITE_OK else { return }
                createJyutpingTable()
                createYingWaaTable()
                createChoHokTable()
                createFanWanTable()
                createGwongWanTable()
                createMetaTable(appVersion: appVersion)
                isDatabaseReady = true
                createIndies()
                backupInMemoryDatabaseToCaches()
        }
        private static func verifiedCachedDatabase(appVersion: String) -> Bool {
                guard let cacheUrl = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else { return false }
                let url = cacheUrl.appendingPathComponent("appdb.sqlite3", isDirectory: false)
                let path = url.path
                guard FileManager.default.fileExists(atPath: path) else { return false }
                guard sqlite3_open_v2(path, &database, SQLITE_OPEN_READONLY, nil) == SQLITE_OK else { return false }
                let query: String = "SELECT valuetext FROM metatable WHERE keynumber = 1;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK else { return false }
                guard sqlite3_step(statement) == SQLITE_ROW else { return false }
                let savedAppVersion: String = String(cString: sqlite3_column_text(statement, 0))
                return appVersion == savedAppVersion
        }
        private static func backupInMemoryDatabaseToCaches() {
                guard let cacheUrl = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else { return }
                let url = cacheUrl.appendingPathComponent("appdb.sqlite3", isDirectory: false)
                let path = url.path
                if FileManager.default.fileExists(atPath: path) {
                        try? FileManager.default.removeItem(at: url)
                }
                var destination: OpaquePointer? = nil
                guard sqlite3_open_v2(path, &destination, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, nil) == SQLITE_OK else { return }
                let backup = sqlite3_backup_init(destination, "main", database, "main")
                sqlite3_backup_step(backup, -1)
                sqlite3_backup_finish(backup)
                sqlite3_close_v2(destination)
        }
}

private extension DataMaster {
        static func createMetaTable(appVersion: String) {
                let createTable: String = "CREATE TABLE metatable(keynumber INTEGER NOT NULL PRIMARY KEY, valuetext TEXT NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                let values: String = "(1, '\(appVersion)')"
                let insert: String = "INSERT INTO metatable (keynumber, valuetext) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { sqlite3_finalize(insertStatement); return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { sqlite3_finalize(insertStatement); return }
                sqlite3_finalize(insertStatement)
        }
        static func createJyutpingTable() {
                let createTable: String = "CREATE TABLE jyutpingtable(word TEXT NOT NULL, romanization TEXT NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                guard let url = Bundle.module.url(forResource: "jyutping", withExtension: "txt") else { return }
                guard let content = try? String(contentsOf: url) else { return }
                let sourceLines: [String] = content.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let entries = sourceLines.map { sourceLine -> String? in
                        let parts = sourceLine.split(separator: "\t")
                        guard parts.count == 2 else { return nil }
                        let word = parts[0]
                        let romanization = parts[1]
                        return "('\(word)', '\(romanization)')"
                }
                let values: String = entries.compactMap({ $0 }).joined(separator: ", ")
                let insert: String = "INSERT INTO jyutpingtable (word, romanization) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { sqlite3_finalize(insertStatement); return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { sqlite3_finalize(insertStatement); return }
                sqlite3_finalize(insertStatement)
        }
        static func createIndies() {
                do {
                        let command: String = "CREATE INDEX jyutpingwordindex ON jyutpingtable(word);"
                        var statement: OpaquePointer? = nil
                        guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { sqlite3_finalize(statement); return }
                        guard sqlite3_step(statement) == SQLITE_DONE else { sqlite3_finalize(statement); return }
                        sqlite3_finalize(statement)
                }
                do {
                        let command: String = "CREATE INDEX yingwaacodeindex ON yingwaatable(code);"
                        var statement: OpaquePointer? = nil
                        guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { sqlite3_finalize(statement); return }
                        guard sqlite3_step(statement) == SQLITE_DONE else { sqlite3_finalize(statement); return }
                        sqlite3_finalize(statement)
                }
                do {
                        let command: String = "CREATE INDEX chohokcodeindex ON chohoktable(code);"
                        var statement: OpaquePointer? = nil
                        guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { sqlite3_finalize(statement); return }
                        guard sqlite3_step(statement) == SQLITE_DONE else { sqlite3_finalize(statement); return }
                        sqlite3_finalize(statement)
                }
                do {
                        let command: String = "CREATE INDEX fanwancodeindex ON fanwantable(code);"
                        var statement: OpaquePointer? = nil
                        guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { sqlite3_finalize(statement); return }
                        guard sqlite3_step(statement) == SQLITE_DONE else { sqlite3_finalize(statement); return }
                        sqlite3_finalize(statement)
                }
                do {
                        let command: String = "CREATE INDEX gwongwancodeindex ON gwongwantable(code);"
                        var statement: OpaquePointer? = nil
                        guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { sqlite3_finalize(statement); return }
                        guard sqlite3_step(statement) == SQLITE_DONE else { sqlite3_finalize(statement); return }
                        sqlite3_finalize(statement)
                }
        }
}

private extension DataMaster {
        static func createYingWaaTable() {
                let createTable: String = "CREATE TABLE yingwaatable(code INTEGER NOT NULL, word TEXT NOT NULL, romanization TEXT NOT NULL, pronunciation TEXT NOT NULL, pronunciationmark TEXT NOT NULL, interpretation TEXT NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { return }
                guard let url = Bundle.module.url(forResource: "yingwaa", withExtension: "txt") else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                guard let content = try? String(contentsOf: url) else { return }
                let sourceLines: [String] = content.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let entries = sourceLines.map { sourceLine -> String? in
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
                let values: String = entries.compactMap({ $0 }).joined(separator: ", ")
                let insert: String = "INSERT INTO yingwaatable (code, word, romanization, pronunciation, pronunciationmark, interpretation) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { sqlite3_finalize(insertStatement); return }
        }
        static func createChoHokTable() {
                let createTable: String = "CREATE TABLE chohoktable(code INTEGER NOT NULL, word TEXT NOT NULL, romanization TEXT NOT NULL, initial TEXT NOT NULL, final TEXT NOT NULL, tone TEXT NOT NULL, faancit TEXT NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                guard let url = Bundle.module.url(forResource: "chohok", withExtension: "txt") else { return }
                guard let content = try? String(contentsOf: url) else { return }
                let sourceLines: [String] = content.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let entries = sourceLines.map { sourceLine -> String? in
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
                let values: String = entries.compactMap({ $0 }).joined(separator: ", ")
                let insert: String = "INSERT INTO chohoktable (code, word, romanization, initial, final, tone, faancit) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { sqlite3_finalize(insertStatement); return }
        }
        static func createFanWanTable() {
                let createTable: String = "CREATE TABLE fanwantable(code INTEGER NOT NULL, word TEXT NOT NULL, romanization TEXT NOT NULL, initial TEXT NOT NULL, final TEXT NOT NULL, yamyeung TEXT NOT NULL, tone TEXT NOT NULL, rhyme TEXT NOT NULL, interpretation TEXT NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                guard let url = Bundle.module.url(forResource: "fanwan", withExtension: "txt") else { return }
                guard let content = try? String(contentsOf: url) else { return }
                let sourceLines: [String] = content.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let entries = sourceLines.map { sourceLine -> String? in
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
                let values: String = entries.compactMap({ $0 }).joined(separator: ", ")
                let insert: String = "INSERT INTO fanwantable (code, word, romanization, initial, final, yamyeung, tone, rhyme, interpretation) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { sqlite3_finalize(insertStatement); return }
        }
        static func createGwongWanTable() {
                let createTable: String = "CREATE TABLE gwongwantable(code INTEGER NOT NULL, word TEXT NOT NULL, rhyme TEXT NOT NULL, subrhyme TEXT NOT NULL, subrhymeserial INTEGER NOT NULL, subrhymenumber INTEGER NOT NULL, upper TEXT NOT NULL, lower TEXT NOT NULL, initial TEXT NOT NULL, rounding TEXT NOT NULL, division TEXT NOT NULL, rhymeclass TEXT NOT NULL, repeating TEXT NOT NULL, tone TEXT NOT NULL, interpretation TEXT NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                guard let url = Bundle.module.url(forResource: "gwongwan", withExtension: "txt") else { return }
                guard let content = try? String(contentsOf: url) else { return }
                let sourceLines: [String] = content.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let entries = sourceLines.map { sourceLine -> String? in
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
                let values: String = entries.compactMap({ $0 }).joined(separator: ", ")
                let insert: String = "INSERT INTO gwongwantable (code, word, rhyme, subrhyme, subrhymeserial, subrhymenumber, upper, lower, initial, rounding, division, rhymeclass, repeating, tone, interpretation) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insert, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { sqlite3_finalize(insertStatement); return }
        }
}
