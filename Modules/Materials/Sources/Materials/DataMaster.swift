import Foundation
import SQLite3

public struct DataMaster {
        private(set) static var database: OpaquePointer? = nil
        private(set) static var isDatabaseReady: Bool = false
        public static func prepare() {
                guard !isDatabaseReady else { return }
                var db: OpaquePointer?
                guard sqlite3_open_v2(":memory:", &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, nil) == SQLITE_OK else { return }
                database = db
                createJyutpingTable()
                createYingWaaTable()
                createChoHokTable()
                createFanWanTable()
                createGwongWanTable()
                isDatabaseReady = true
        }
}

private extension DataMaster {
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
                let createIndex: String = "CREATE INDEX jyutpingwordindex ON jyutpingtable(word);"
                var createIndexStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(createIndexStatement) }
                guard sqlite3_prepare_v2(database, createIndex, -1, &createIndexStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(createIndexStatement) == SQLITE_DONE else { return }
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
}

private extension DataMaster {
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
}

private extension DataMaster {
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
}

private extension DataMaster {
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
