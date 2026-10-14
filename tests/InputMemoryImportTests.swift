import Foundation
import SQLite3
import Testing
import SQLiteWrapper
@testable import InputMemoryExportSupport

struct InputMemoryImportTests {

        private func temporaryDirectory() throws -> URL {
                let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: false)
                return url
        }

        private final class Settings {
                let domain = "InputMemoryImportTests.\(UUID().uuidString)"
                let defaults: UserDefaults

                init() {
                        defaults = UserDefaults(suiteName: domain)!
                        defaults.set(2608, forKey: "Migration2608")
                }

                deinit {
                        defaults.removePersistentDomain(forName: domain)
                }
        }

        /// A prepared live store and its preferences, kept alive together.
        private func prepareStore(at url: URL) async throws -> (InputMemoryPreparation, Settings) {
                let settings = Settings()
                let store = InputMemoryPreparation(databaseURL: url, defaults: settings.defaults)
                try await store.waitUntilReady()
                return (store, settings)
        }

        private func insert(_ db: SQLiteDatabase, _ entry: MemoryLexicon) throws {
                try db.run("INSERT INTO memory2608 (word, romanization, frequency, latest, char_count, letter_count, complexity, anchors, spell) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);", entry.word, entry.romanization, entry.frequency, entry.latest, entry.charCount, entry.letterCount, entry.complexity, entry.anchors, entry.spell)
        }

        private func rows(_ url: URL) throws -> [String: [Int64]] {
                let db = try SQLiteDatabase(url: url, flags: [.readOnly])
                let items = try db.query("SELECT word, romanization, frequency, latest, char_count, letter_count, complexity, anchors, spell FROM memory2608;", transform: { row -> (String, [Int64]) in
                        (try row.requireText(at: 0) + "|" + row.requireText(at: 1), (2...8).map({ row.int64(at: Int32($0)) }))
                })
                return Dictionary(uniqueKeysWithValues: items)
        }

        @Test func exportedMemoryRoundTripsWithDerivedFields() async throws {
                let directory = try temporaryDirectory()
                defer { try? FileManager.default.removeItem(at: directory) }
                let source = directory.appendingPathComponent("source.sqlite3")
                let target = directory.appendingPathComponent("target.sqlite3")
                let exported = directory.appendingPathComponent("export.sqlite3")
                let (sourceStore, sourceSettings) = try await prepareStore(at: source)
                defer { _ = (sourceStore, sourceSettings) }
                let sourceDB = try SQLiteDatabase(url: source)
                try insert(sourceDB, MemoryLexicon(word: "廣東話𠵱\u{0000}家", romanization: "gwong2 dung1 waa2  ji1 gaa1", frequency: 5000000000, latest: 1791923456789))
                try insert(sourceDB, MemoryLexicon(word: "粵拼", romanization: "jyut6 ping3", frequency: 3, latest: 1700000000000))
                try sourceDB.close()
                #expect(try InputMemoryExporter.export(source: source, output: exported) == 2)
                let (targetStore, targetSettings) = try await prepareStore(at: target)
                defer { _ = (targetStore, targetSettings) }
                #expect(try InputMemoryImporter.importEntries(from: exported, into: target) == 2)
                #expect(try rows(target) == rows(source))
                // Importing the same file again is idempotent.
                #expect(try InputMemoryImporter.importEntries(from: exported, into: target) == 2)
                #expect(try rows(target) == rows(source))
                for suffix in ["-wal", "-shm", "-journal"] {
                        #expect(!FileManager.default.fileExists(atPath: exported.path + suffix))
                }
        }

        @Test func mergeKeepsLargerFrequencyAndLaterTimestamp() async throws {
                let directory = try temporaryDirectory()
                defer { try? FileManager.default.removeItem(at: directory) }
                let target = directory.appendingPathComponent("target.sqlite3")
                let file = directory.appendingPathComponent("import.sqlite3")
                let (store, settings) = try await prepareStore(at: target)
                defer { _ = (store, settings) }
                let targetDB = try SQLiteDatabase(url: target)
                try insert(targetDB, MemoryLexicon(word: "你好", romanization: "nei5 hou2", frequency: 10, latest: 100))
                try insert(targetDB, MemoryLexicon(word: "早晨", romanization: "zou2 san4", frequency: 2, latest: 900))
                try insert(targetDB, MemoryLexicon(word: "唔該", romanization: "m4 goi1", frequency: 7, latest: 50))
                try targetDB.close()
                let db = try SQLiteDatabase(url: file)
                try db.execute("CREATE TABLE input_memory (word TEXT NOT NULL, romanization TEXT NOT NULL, frequency INTEGER NOT NULL, latest INTEGER NOT NULL, UNIQUE (word, romanization)); PRAGMA user_version = 1;")
                try db.run("INSERT INTO input_memory VALUES (?, ?, ?, ?);", "你好", "nei5 hou2", Int64(4), Int64(500))
                try db.run("INSERT INTO input_memory VALUES (?, ?, ?, ?);", "早晨", "zou2 san4", Int64(8), Int64(300))
                try db.run("INSERT INTO input_memory VALUES (?, ?, ?, ?);", "多謝", "do1 ze6", Int64(1), Int64(700))
                try db.close()
                #expect(try InputMemoryImporter.importEntries(from: file, into: target) == 3)
                let merged = try rows(target)
                #expect(merged["你好|nei5 hou2"]?.prefix(2) == [10, 500])
                #expect(merged["早晨|zou2 san4"]?.prefix(2) == [8, 900])
                #expect(merged["唔該|m4 goi1"]?.prefix(2) == [7, 50])
                let added = MemoryLexicon(word: "多謝", romanization: "do1 ze6", frequency: 1, latest: 700)
                #expect(merged["多謝|do1 ze6"] == [1, 700, Int64(added.charCount), Int64(added.letterCount), Int64(added.complexity), Int64(added.anchors), Int64(added.spell)])
        }

        @Test func invalidRowsAreSkipped() async throws {
                let directory = try temporaryDirectory()
                defer { try? FileManager.default.removeItem(at: directory) }
                let target = directory.appendingPathComponent("target.sqlite3")
                let file = directory.appendingPathComponent("import.sqlite3")
                let (store, settings) = try await prepareStore(at: target)
                defer { _ = (store, settings) }
                let db = try SQLiteDatabase(url: file)
                // Additional columns and missing constraints are tolerated by version-1 readers.
                try db.execute("CREATE TABLE input_memory (word, romanization, frequency, latest, extra); PRAGMA user_version = 1;")
                let rows: [[(any SQLiteBindable)?]] = [
                        ["好", "hou2", Int64(1), Int64(1), nil],
                        ["", "hou2", Int64(1), Int64(1), nil],
                        ["好", "", Int64(1), Int64(1), nil],
                        ["好", "Hou2", Int64(1), Int64(1), nil],
                        ["好", "hou7", Int64(1), Int64(1), nil],
                        ["好", "hou2", Int64(0), Int64(1), nil],
                        ["好", "hou2", Int64(1), Int64(0), nil],
                        ["好", "hou2", "1", Int64(1), nil],
                        [nil, "hou2", Int64(1), Int64(1), nil],
                        ["好", "hou2", 1.5, Int64(1), nil],
                ]
                do {
                        let insert = try db.prepare("INSERT INTO input_memory VALUES (?, ?, ?, ?, ?);")
                        for row in rows { try insert.reset().bind(row).run() }
                }
                try db.close()
                #expect(try InputMemoryImporter.importEntries(from: file, into: target) == 1)
                #expect(try SQLiteDatabase(url: target, flags: [.readOnly]).integer("SELECT COUNT(*) FROM memory2608;") == 1)
        }

        @Test(arguments: ["missing", "text", "version", "table", "columns"]) func unsupportedFilesChangeNothing(kind: String) async throws {
                let directory = try temporaryDirectory()
                defer { try? FileManager.default.removeItem(at: directory) }
                let target = directory.appendingPathComponent("target.sqlite3")
                let file = directory.appendingPathComponent("import.sqlite3")
                let (store, settings) = try await prepareStore(at: target)
                defer { _ = (store, settings) }
                let targetDB = try SQLiteDatabase(url: target)
                try insert(targetDB, MemoryLexicon(word: "你好", romanization: "nei5 hou2", frequency: 10, latest: 100))
                try targetDB.close()
                switch kind {
                case "missing":
                        break
                case "text":
                        try Data("not a database".utf8).write(to: file)
                default:
                        let db = try SQLiteDatabase(url: file)
                        switch kind {
                        case "version":
                                try db.execute("CREATE TABLE input_memory (word TEXT, romanization TEXT, frequency INTEGER, latest INTEGER); PRAGMA user_version = 2;")
                        case "table":
                                try db.execute("CREATE TABLE memory2608 (word TEXT, romanization TEXT, frequency INTEGER, latest INTEGER); PRAGMA user_version = 1;")
                        default:
                                try db.execute("CREATE TABLE input_memory (word TEXT, romanization TEXT, frequency INTEGER); PRAGMA user_version = 1;")
                        }
                        try db.close()
                }
                #expect(throws: InputMemoryImportError.unsupportedFormat) { try InputMemoryImporter.importEntries(from: file, into: target) }
                #expect(try rows(target).keys.sorted() == ["你好|nei5 hou2"])
        }

        @Test func missingStoreIsNotCreated() throws {
                let directory = try temporaryDirectory()
                defer { try? FileManager.default.removeItem(at: directory) }
                let target = directory.appendingPathComponent("target.sqlite3")
                let file = directory.appendingPathComponent("import.sqlite3")
                let db = try SQLiteDatabase(url: file)
                try db.execute("CREATE TABLE input_memory (word TEXT, romanization TEXT, frequency INTEGER, latest INTEGER); PRAGMA user_version = 1;")
                try db.close()
                #expect(throws: (any Error).self) { try InputMemoryImporter.importEntries(from: file, into: target) }
                #expect(!FileManager.default.fileExists(atPath: target.path))
        }

        @Test func failedMergeRollsBackAllEntries() async throws {
                let directory = try temporaryDirectory()
                defer { try? FileManager.default.removeItem(at: directory) }
                let target = directory.appendingPathComponent("target.sqlite3")
                let file = directory.appendingPathComponent("import.sqlite3")
                let (store, settings) = try await prepareStore(at: target)
                defer { _ = (store, settings) }
                let targetDB = try SQLiteDatabase(url: target)
                try targetDB.execute("CREATE TRIGGER reject AFTER INSERT ON memory2608 WHEN NEW.word = '壞' BEGIN SELECT RAISE(ABORT, 'rejected'); END;")
                try targetDB.close()
                let db = try SQLiteDatabase(url: file)
                try db.execute("CREATE TABLE input_memory (word TEXT, romanization TEXT, frequency INTEGER, latest INTEGER); PRAGMA user_version = 1;")
                try db.run("INSERT INTO input_memory VALUES (?, ?, ?, ?);", "好", "hou2", Int64(1), Int64(1))
                try db.run("INSERT INTO input_memory VALUES (?, ?, ?, ?);", "壞", "waai6", Int64(1), Int64(1))
                try db.close()
                #expect(throws: SQLiteError.self) { try InputMemoryImporter.importEntries(from: file, into: target) }
                #expect(try rows(target).isEmpty)
        }

        @Test func lockedStoreFailsWithoutChanges() async throws {
                let directory = try temporaryDirectory()
                defer { try? FileManager.default.removeItem(at: directory) }
                let target = directory.appendingPathComponent("target.sqlite3")
                let file = directory.appendingPathComponent("import.sqlite3")
                let (store, settings) = try await prepareStore(at: target)
                defer { _ = (store, settings) }
                let db = try SQLiteDatabase(url: file)
                try db.execute("CREATE TABLE input_memory (word TEXT, romanization TEXT, frequency INTEGER, latest INTEGER); PRAGMA user_version = 1;")
                try db.run("INSERT INTO input_memory VALUES (?, ?, ?, ?);", "好", "hou2", Int64(1), Int64(1))
                try db.close()
                let blocker = try SQLiteDatabase(url: target)
                try blocker.execute("BEGIN EXCLUSIVE;")
                #expect(throws: SQLiteError.sqlite(SQLITE_BUSY)) { try InputMemoryImporter.importEntries(from: file, into: target) }
                try blocker.execute("ROLLBACK;")
                #expect(try rows(target).isEmpty)
        }

        @Test func cancellationRollsBack() async throws {
                let directory = try temporaryDirectory()
                defer { try? FileManager.default.removeItem(at: directory) }
                let target = directory.appendingPathComponent("target.sqlite3")
                let file = directory.appendingPathComponent("import.sqlite3")
                let (store, settings) = try await prepareStore(at: target)
                defer { _ = (store, settings) }
                let db = try SQLiteDatabase(url: file)
                try db.execute("CREATE TABLE input_memory (word TEXT, romanization TEXT, frequency INTEGER, latest INTEGER); PRAGMA user_version = 1;")
                try db.run("INSERT INTO input_memory VALUES (?, ?, ?, ?);", "好", "hou2", Int64(1), Int64(1))
                try db.close()
                let task = Task.detached {
                        withUnsafeCurrentTask { $0?.cancel() }
                        return try InputMemoryImporter.importEntries(from: file, into: target)
                }
                await #expect(throws: CancellationError.self) { try await task.value }
                #expect(try rows(target).isEmpty)
        }
}
