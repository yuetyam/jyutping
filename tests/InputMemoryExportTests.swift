import Foundation
import SQLite3
import Testing
import SQLiteWrapper
@testable import InputMemoryExportSupport

struct InputMemoryExportTests {

        private func temporaryDirectory() throws -> URL {
                let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: false)
                return url
        }

        private final class Settings {
                let domain = "InputMemoryExportTests.\(UUID().uuidString)"
                let defaults: UserDefaults

                init() {
                        defaults = UserDefaults(suiteName: domain)!
                }

                deinit {
                        defaults.removePersistentDomain(forName: domain)
                }
        }

        private func open(_ url: URL) throws -> SQLiteDatabase {
                try SQLiteDatabase(url: url, flags: [.readWrite, .create, .fullMutex])
        }

        private func seed(_ db: SQLiteDatabase, table: String = "memory2608", word: String = "廣東話𠵱\u{0000}家", romanization: String = "gwong2 dung1 waa2  ji1 gaa1", frequency: Int64 = 5000000000, latest: Int64 = 1791923456789) throws {
                try db.run("INSERT INTO \(table) (word, romanization, frequency, latest) VALUES (?, ?, ?, ?);", word, romanization, frequency, latest)
        }

        @Test func exactPortableSnapshotAndReplacement() throws {
                let directory = try temporaryDirectory()
                defer { try? FileManager.default.removeItem(at: directory) }
                let source = directory.appendingPathComponent("memory.sqlite3")
                let output = directory.appendingPathComponent("export.sqlite3")
                let destination = directory.appendingPathComponent("saved.sqlite3")
                let db = try open(source)
                try db.execute("PRAGMA journal_mode = WAL; CREATE TABLE memory2608 (word TEXT, romanization TEXT, frequency INTEGER, latest INTEGER, private_field TEXT);")
                try seed(db)
                let count = try InputMemoryExporter.export(source: source, output: output)
                #expect(count == 1)
                try Data("previous export".utf8).write(to: destination)
                try InputMemoryExporter.publish(output: output, destination: destination, source: source)
                try InputMemoryExporter.validate(output: destination, expectedCount: 1)
                let exported = try SQLiteDatabase(url: destination, flags: [.readOnly])
                let query = try exported.prepare("SELECT word, romanization, frequency, latest FROM input_memory;")
                #expect(try query.step())
                #expect(try query.requireText(at: 0) == "廣東話𠵱\u{0000}家")
                #expect(try query.requireText(at: 1) == "gwong2 dung1 waa2  ji1 gaa1")
                #expect(try query.requireInt64(at: 2) == 5000000000)
                #expect(try query.requireInt64(at: 3) == 1791923456789)
                #expect(try exported.integer("SELECT COUNT(*) FROM pragma_table_info('input_memory');") == 4)
                #expect(try exported.integer("SELECT COUNT(*) FROM sqlite_master WHERE type = 'table';") == 1)
                let writableExport = try SQLiteDatabase(url: output, flags: [.readWrite])
                do {
                        try writableExport.execute("INSERT INTO input_memory SELECT * FROM input_memory;")
                        Issue.record("Duplicate word/romanization was accepted")
                } catch SQLiteError.sqlite(let code) {
                        #expect(code == SQLITE_CONSTRAINT)
                }
                for suffix in ["-wal", "-shm", "-journal"] {
                        #expect(!FileManager.default.fileExists(atPath: destination.path + suffix))
                }
        }

        @Test func emptyAndMissingStoresAreDifferent() async throws {
                let directory = try temporaryDirectory()
                defer { try? FileManager.default.removeItem(at: directory) }
                let source = directory.appendingPathComponent("memory.sqlite3")
                let output = directory.appendingPathComponent("export.sqlite3")
                #expect(throws: (any Error).self) { try InputMemoryExporter.export(source: source, output: output) }
                #expect(!FileManager.default.fileExists(atPath: source.path))
                let settings = Settings()
                defer { _ = settings }
                let store = InputMemoryPreparation(databaseURL: source, defaults: settings.defaults)
                async let first: Void = store.waitUntilReady()
                async let second: Void = store.waitUntilReady()
                _ = try await (first, second)
                #expect(store.isReady)
                #expect(try InputMemoryExporter.export(source: source, output: output) == 0)
                try InputMemoryExporter.validate(output: output, expectedCount: 0)
        }

        @Test func alreadyMigratedStoreIsReadyWhenTypingPreparationReturns() throws {
                let directory = try temporaryDirectory()
                defer { try? FileManager.default.removeItem(at: directory) }
                let source = directory.appendingPathComponent("memory.sqlite3")
                let settings = Settings()
                defer { _ = settings }
                settings.defaults.set(2608, forKey: "Migration2608")
                let store = InputMemoryPreparation(databaseURL: source, defaults: settings.defaults)
                store.prepareForTyping()
                #expect(store.isReady)
                #expect(store.database != nil)
                let db = try SQLiteDatabase(url: source, flags: [.readOnly])
                #expect(try db.tableExists("memory2608"))
        }

        @Test(arguments: [false, true]) func legacySelectionAndCeiling(previousMigration: Bool) async throws {
                let directory = try temporaryDirectory()
                defer { try? FileManager.default.removeItem(at: directory) }
                let source = directory.appendingPathComponent("memory.sqlite3")
                let fixture = Settings()
                defer { _ = fixture }
                let settings = fixture.defaults
                if previousMigration { settings.set(2026, forKey: "InputMemoryMigration2026") }
                let db = try open(source)
                for table in ["memory", "core_memory"] {
                        try db.execute("CREATE TABLE \(table) (word TEXT, romanization TEXT, frequency INTEGER, latest INTEGER);")
                        for frequency in [1, 20, 21, 100000, 100001] {
                                try seed(db, table: table, word: "\(table)-\(frequency)", romanization: "waa2", frequency: Int64(frequency))
                        }
                }
                let obsolete = directory.appendingPathComponent("userlexicon.sqlite3")
                try Data().write(to: obsolete)
                let store = InputMemoryPreparation(databaseURL: source, defaults: settings)
                try await store.waitUntilReady()
                #expect(settings.integer(forKey: "Migration2608") == 2608)
                #expect(settings.object(forKey: "InputMemoryMigration2026") == nil)
                #expect(!FileManager.default.fileExists(atPath: obsolete.path))
                #expect(try db.integer("SELECT COUNT(*) FROM memory2608;") == 4)
                let selected = previousMigration ? "core_memory" : "memory"
                #expect(try db.integer("SELECT COUNT(*) FROM memory2608 WHERE word LIKE '\(selected)-%';") == 4)
                #expect(try db.integer("SELECT latest FROM memory2608 WHERE frequency = 1;") == 1791923456789)
                #expect(try db.integer("SELECT char_count FROM memory2608 WHERE frequency = 1;") == Int64("\(selected)-1".count))
        }

        @Test func migrationFailureDoesNotAdvanceCheckpointAndCanRetry() async throws {
                let directory = try temporaryDirectory()
                defer { try? FileManager.default.removeItem(at: directory) }
                let source = directory.appendingPathComponent("memory.sqlite3")
                let fixture = Settings()
                defer { _ = fixture }
                let settings = fixture.defaults
                settings.set(2, forKey: "Migration2608")
                settings.set(2026, forKey: "InputMemoryMigration2026")
                let db = try open(source)
                try db.execute("CREATE TABLE core_memory (word TEXT, romanization TEXT, frequency INTEGER, latest INTEGER);")
                try seed(db, table: "core_memory", word: "話", romanization: "waa2", frequency: 2)
                try seed(db, table: "core_memory", word: "話", romanization: "waa2", frequency: 1)
                let store = InputMemoryPreparation(databaseURL: source, defaults: settings)
                // Create the current schema, then force a write failure in the migration band.
                try db.execute("CREATE TABLE memory2608 (id INTEGER PRIMARY KEY AUTOINCREMENT, word TEXT NOT NULL, romanization TEXT NOT NULL, frequency INTEGER NOT NULL, latest INTEGER NOT NULL, char_count INTEGER NOT NULL, letter_count INTEGER NOT NULL, complexity INTEGER NOT NULL, anchors INTEGER NOT NULL, spell INTEGER NOT NULL, UNIQUE (word, romanization));")
                try db.execute("CREATE TRIGGER reject_migration BEFORE INSERT ON memory2608 BEGIN SELECT RAISE(ABORT, 'test failure'); END;")
                await #expect(throws: (any Error).self) { try await store.waitUntilReady() }
                #expect(!store.isReady)
                #expect(store.database == nil)
                #expect(settings.integer(forKey: "Migration2608") == 2)
                #expect(settings.integer(forKey: "InputMemoryMigration2026") == 2026)
                #expect(try db.integer("SELECT COUNT(*) FROM memory2608;") == 0)
                try db.execute("DROP TRIGGER reject_migration;")
                try await store.waitUntilReady()
                #expect(store.isReady)
                #expect(try db.integer("SELECT frequency FROM memory2608;") == 2)
        }

        @Test func initializationFailureCanRetry() async throws {
                let directory = try temporaryDirectory()
                defer { try? FileManager.default.removeItem(at: directory) }
                let parent = directory.appendingPathComponent("missing", isDirectory: true)
                let settings = Settings()
                defer { _ = settings }
                let store = InputMemoryPreparation(databaseURL: parent.appendingPathComponent("memory.sqlite3"), defaults: settings.defaults)
                await #expect(throws: (any Error).self) { try await store.waitUntilReady() }
                #expect(!store.isReady)
                try FileManager.default.createDirectory(at: parent, withIntermediateDirectories: false)
                try await store.waitUntilReady()
                #expect(store.isReady)
        }

        @Test func lockedSourceTimesOutWithoutOutput() throws {
                let directory = try temporaryDirectory()
                defer { try? FileManager.default.removeItem(at: directory) }
                let source = directory.appendingPathComponent("memory.sqlite3")
                let output = directory.appendingPathComponent("export.sqlite3")
                let db = try open(source)
                try db.execute("CREATE TABLE memory2608 (word TEXT, romanization TEXT, frequency INTEGER, latest INTEGER); BEGIN EXCLUSIVE;")
                defer { try? db.execute("ROLLBACK;") }
                let start = ContinuousClock.now
                #expect(throws: SQLiteError.timedOut) { try InputMemoryExporter.export(source: source, output: output, timeout: .milliseconds(100)) }
                #expect(start.duration(to: .now) < .seconds(2))
                #expect(!FileManager.default.fileExists(atPath: output.path))
        }

        @Test func destinationAliasesAndFailuresPreserveFiles() throws {
                let directory = try temporaryDirectory()
                defer { try? FileManager.default.removeItem(at: directory) }
                let source = directory.appendingPathComponent("memory.sqlite3")
                let hardLink = directory.appendingPathComponent("hard-link.sqlite3")
                let symlink = directory.appendingPathComponent("symbolic-link.sqlite3")
                let destination = directory.appendingPathComponent("saved.sqlite3")
                try Data("live memory".utf8).write(to: source)
                try FileManager.default.linkItem(at: source, to: hardLink)
                try FileManager.default.createSymbolicLink(at: symlink, withDestinationURL: source)
                for protected in [source, hardLink, symlink, URL(fileURLWithPath: source.path + "-wal"), URL(fileURLWithPath: source.path + "-shm"), URL(fileURLWithPath: source.path + "-journal")] {
                        #expect(throws: (any Error).self) { try InputMemoryExporter.protectSource(source: source, destination: protected) }
                }
                let existing = Data("previous export".utf8)
                try existing.write(to: destination)
                #expect(throws: (any Error).self) { try InputMemoryExporter.publish(output: directory.appendingPathComponent("missing.sqlite3"), destination: destination, source: source) }
                #expect(try Data(contentsOf: destination) == existing)
                #expect(try Data(contentsOf: source) == Data("live memory".utf8))
        }

        @Test func cancellationAndValidationFailureDoNotPublish() async throws {
                let directory = try temporaryDirectory()
                defer { try? FileManager.default.removeItem(at: directory) }
                let source = directory.appendingPathComponent("memory.sqlite3")
                let output = directory.appendingPathComponent("export.sqlite3")
                let db = try open(source)
                try db.execute("CREATE TABLE memory2608 (word TEXT, romanization TEXT, frequency INTEGER, latest INTEGER);")
                let task = Task.detached {
                        withUnsafeCurrentTask { $0?.cancel() }
                        return try InputMemoryExporter.export(source: source, output: output)
                }
                await #expect(throws: CancellationError.self) { _ = try await task.value }
                #expect(!FileManager.default.fileExists(atPath: output.path))
                _ = try InputMemoryExporter.export(source: source, output: output)
                let exported = try open(output)
                try exported.execute("PRAGMA user_version = 2;")
                #expect(throws: (any Error).self) { try InputMemoryExporter.validate(output: output, expectedCount: 0) }
        }

        @Test func snapshotDuringConcurrentCommittedWrites() async throws {
                let directory = try temporaryDirectory()
                defer { try? FileManager.default.removeItem(at: directory) }
                let source = directory.appendingPathComponent("memory.sqlite3")
                let output = directory.appendingPathComponent("export.sqlite3")
                let db = try open(source)
                try db.execute("PRAGMA journal_mode = WAL; CREATE TABLE memory2608 (word TEXT, romanization TEXT, frequency INTEGER, latest INTEGER);")
                try db.execute("WITH RECURSIVE rows(n) AS (VALUES(1) UNION ALL SELECT n+1 FROM rows WHERE n<5000) INSERT INTO memory2608 SELECT printf('%d', n), 'waa2', 1, 1 FROM rows;")
                let writer = Task.detached {
                        let connection = try SQLiteDatabase(url: source, flags: [.readWrite, .fullMutex])
                        for value in 2...20 {
                                try connection.execute("UPDATE memory2608 SET frequency = \(value), latest = \(value);")
                                try await Task.sleep(for: .milliseconds(2))
                        }
                }
                let exporter = Task.detached { try InputMemoryExporter.export(source: source, output: output) }
                #expect(try await exporter.value == 5000)
                try await writer.value
                let exported = try SQLiteDatabase(url: output, flags: [.readOnly])
                #expect(try exported.integer("SELECT COUNT(DISTINCT frequency) FROM input_memory;") == 1)
                #expect(try exported.integer("SELECT COUNT(*) FROM input_memory WHERE frequency != latest;") == 0)
        }

        @Test func cancelledReadinessCallerDoesNotCancelSharedPreparation() async throws {
                let directory = try temporaryDirectory()
                defer { try? FileManager.default.removeItem(at: directory) }
                let settings = Settings()
                defer { _ = settings }
                let source = directory.appendingPathComponent("memory.sqlite3")
                let db = try open(source)
                try db.execute("BEGIN EXCLUSIVE;")
                let store = InputMemoryPreparation(databaseURL: source, defaults: settings.defaults)
                let cancelled = Task { try await store.waitUntilReady() }
                let remaining = Task { try await store.waitUntilReady() }
                try await Task.sleep(for: .milliseconds(50))
                #expect(!store.isReady)
                cancelled.cancel()
                try db.execute("ROLLBACK;")
                await #expect(throws: CancellationError.self) { try await cancelled.value }
                try await remaining.value
                #expect(store.isReady)
                #expect(settings.defaults.integer(forKey: "Migration2608") == 2608)
        }

        @Test func failedMigrationBandRollsBackAllEntries() async throws {
                let directory = try temporaryDirectory()
                defer { try? FileManager.default.removeItem(at: directory) }
                let fixture = Settings()
                defer { _ = fixture }
                let source = directory.appendingPathComponent("memory.sqlite3")
                let db = try open(source)
                try db.execute("CREATE TABLE memory (word TEXT, romanization TEXT, frequency INTEGER, latest INTEGER);")
                try seed(db, table: "memory", word: "先", romanization: "sin1", frequency: 100)
                try seed(db, table: "memory", word: "後", romanization: "hau6", frequency: 50)
                try db.execute("CREATE TABLE memory2608 (id INTEGER PRIMARY KEY AUTOINCREMENT, word TEXT NOT NULL, romanization TEXT NOT NULL, frequency INTEGER NOT NULL, latest INTEGER NOT NULL, char_count INTEGER NOT NULL, letter_count INTEGER NOT NULL, complexity INTEGER NOT NULL, anchors INTEGER NOT NULL, spell INTEGER NOT NULL, UNIQUE (word, romanization));")
                try db.execute("CREATE TRIGGER reject_second BEFORE INSERT ON memory2608 WHEN NEW.frequency = 50 BEGIN SELECT RAISE(ABORT, 'test failure'); END;")
                let store = InputMemoryPreparation(databaseURL: source, defaults: fixture.defaults)
                await #expect(throws: (any Error).self) { try await store.waitUntilReady() }
                #expect(try db.integer("SELECT COUNT(*) FROM memory2608;") == 0)
                #expect(fixture.defaults.integer(forKey: "Migration2608") == 0)
                try db.execute("DROP TRIGGER reject_second;")
                try await store.waitUntilReady()
                #expect(try db.integer("SELECT COUNT(*) FROM memory2608;") == 2)
        }

        @Test func malformedSourceAndDestinationFailureCleanUp() throws {
                let directory = try temporaryDirectory()
                defer { try? FileManager.default.removeItem(at: directory) }
                let source = directory.appendingPathComponent("memory.sqlite3")
                let output = directory.appendingPathComponent("export.sqlite3")
                let db = try open(source)
                try db.execute("CREATE TABLE memory2608 (word TEXT, romanization TEXT, frequency INTEGER, latest INTEGER);")
                try db.execute("INSERT INTO memory2608 VALUES ('話', 'waa2', 'invalid integer', 1);")
                #expect(throws: SQLiteError.invalidFormat) { try InputMemoryExporter.export(source: source, output: output) }
                for suffix in ["", "-journal", "-wal", "-shm"] {
                        #expect(!FileManager.default.fileExists(atPath: output.path + suffix))
                }
                try db.execute("DELETE FROM memory2608;")
                _ = try InputMemoryExporter.export(source: source, output: output)
                let missingParent = directory.appendingPathComponent("missing/saved.sqlite3")
                #expect(throws: (any Error).self) { try InputMemoryExporter.publish(output: output, destination: missingParent, source: source) }
                #expect(!FileManager.default.fileExists(atPath: missingParent.path))
                let existingDirectory = directory.appendingPathComponent("existing", isDirectory: true)
                try FileManager.default.createDirectory(at: existingDirectory, withIntermediateDirectories: false)
                let existingFile = existingDirectory.appendingPathComponent("preserved.txt")
                try Data("preserve".utf8).write(to: existingFile)
                #expect(throws: (any Error).self) { try InputMemoryExporter.publish(output: output, destination: existingDirectory, source: source) }
                #expect(try Data(contentsOf: existingFile) == Data("preserve".utf8))
        }

        @Test func liveLearningWaitsForBriefSnapshotReadLock() async throws {
                let directory = try temporaryDirectory()
                defer { try? FileManager.default.removeItem(at: directory) }
                let fixture = Settings()
                defer { _ = fixture }
                let source = directory.appendingPathComponent("memory.sqlite3")
                let store = InputMemoryPreparation(databaseURL: source, defaults: fixture.defaults)
                try await store.waitUntilReady()
                let reader = try open(source)
                try reader.execute("INSERT INTO memory2608 (word, romanization, frequency, latest, char_count, letter_count, complexity, anchors, spell) VALUES ('話', 'waa2', 1, 1, 1, 3, 3, 1, 2);")
                try reader.execute("BEGIN; SELECT COUNT(*) FROM memory2608;")
                let writer = Task.detached {
                        try #require(store.database).execute("UPDATE memory2608 SET frequency = 2;")
                }
                try await Task.sleep(for: .milliseconds(30))
                try reader.execute("ROLLBACK;")
                try await writer.value
                #expect(try reader.integer("SELECT frequency FROM memory2608;") == 2)
        }

        @Test(arguments: [false, true]) func exportedIndexesSupportOrderedQueries(empty: Bool) throws {
                let directory = try temporaryDirectory()
                defer { try? FileManager.default.removeItem(at: directory) }
                let source = directory.appendingPathComponent("memory.sqlite3")
                let output = directory.appendingPathComponent("export.sqlite3")
                let db = try open(source)
                try db.execute("CREATE TABLE memory2608 (word TEXT, romanization TEXT, frequency INTEGER, latest INTEGER);")
                if !empty {
                        try seed(db, word: "常用", romanization: "soeng4 jung6", frequency: 100, latest: 1)
                        try seed(db, word: "最近", romanization: "zeoi3 gan6", frequency: 1, latest: 100)
                }
                let count: Int64 = empty ? 0 : 2
                #expect(try InputMemoryExporter.export(source: source, output: output) == count)
                let exported = try SQLiteDatabase(url: output, flags: [.readOnly])
                for column in ["frequency", "latest"] {
                        let details = try exported.query("EXPLAIN QUERY PLAN SELECT word, romanization FROM input_memory ORDER BY \(column) DESC LIMIT 1;", transform: { try $0.requireText(at: 3) })
                        #expect(details.contains { $0.contains("USING INDEX ix_input_memory_\(column)") })
                        #expect(!details.contains { $0.contains("TEMP B-TREE") })
                }
                if !empty {
                        #expect(try exported.string("SELECT word FROM input_memory ORDER BY frequency DESC LIMIT 1;") == "常用")
                        #expect(try exported.string("SELECT word FROM input_memory ORDER BY latest DESC LIMIT 1;") == "最近")
                }
                try exported.close()
                // The optional indexes do not change the version-1 data contract.
                let writable = try open(output)
                try writable.execute("DROP INDEX ix_input_memory_frequency; DROP INDEX ix_input_memory_latest;")
                try writable.close()
                try InputMemoryExporter.validate(output: output, expectedCount: count)
        }
}
