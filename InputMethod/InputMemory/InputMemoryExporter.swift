import Foundation
import SQLite3
import Darwin

enum InputMemoryExporter {

        private static let schema = "CREATE TABLE input_memory (word TEXT NOT NULL, romanization TEXT NOT NULL, frequency INTEGER NOT NULL, latest INTEGER NOT NULL, UNIQUE (word, romanization));"

        private static let indexCommands: [String] = [
                "CREATE INDEX ix_input_memory_frequency ON input_memory (frequency);",
                "CREATE INDEX ix_input_memory_latest ON input_memory (latest);",
        ]

        /// The output must be a new private file. All connections close before this returns.
        static func export(source: URL, output: URL, timeout: Duration = .seconds(10)) throws -> Int64 {
                try Task.checkCancellation()
                guard !FileManager.default.fileExists(atPath: output.path) else { throw CocoaError(.fileWriteFileExists) }
                try protectSource(source: source, destination: output)
                let workspace = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
                try FileManager.default.createDirectory(at: workspace, withIntermediateDirectories: false)
                defer { try? FileManager.default.removeItem(at: workspace) }
                do {
                        let snapshot = workspace.appendingPathComponent("snapshot.sqlite3")
                        try capture(source: source, snapshot: snapshot, timeout: timeout)
                        let count = try write(snapshot: snapshot, output: output)
                        try validate(output: output, expectedCount: count)
                        return count
                } catch {
                        for suffix in ["", "-journal", "-wal", "-shm"] {
                                try? FileManager.default.removeItem(atPath: output.path + suffix)
                        }
                        throw error
                }
        }

        private static func capture(source: URL, snapshot: URL, timeout: Duration) throws {
                let sourceDB = try MemorySQLite(url: source, flags: SQLITE_OPEN_READONLY | SQLITE_OPEN_FULLMUTEX)
                let snapshotDB = try MemorySQLite(url: snapshot, flags: SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX)
                guard let backup = sqlite3_backup_init(snapshotDB.connection, "main", sourceDB.connection, "main") else { throw MemorySQLiteError.sqlite(sqlite3_errcode(snapshotDB.connection)) }
                var finished = false
                defer { if !finished { sqlite3_backup_finish(backup) } }
                let deadline = ContinuousClock.now.advanced(by: timeout)
                while true {
                        try Task.checkCancellation()
                        guard ContinuousClock.now < deadline else { throw MemorySQLiteError.timedOut }
                        let result = sqlite3_backup_step(backup, 128)
                        if result == SQLITE_DONE { break }
                        guard result == SQLITE_OK || result == SQLITE_BUSY || result == SQLITE_LOCKED else { throw MemorySQLiteError.sqlite(result) }
                        // Yield this worker between bounded batches and busy retries.
                        Thread.sleep(forTimeInterval: 0.01)
                }
                finished = true
                try MemorySQLite.check(sqlite3_backup_finish(backup))
                // A WAL source can copy its journal-mode header into the snapshot.
                // Normalize it while writable before reopening it read-only without sidecars.
                try snapshotDB.execute("PRAGMA journal_mode = DELETE;")
                try snapshotDB.close()
                try sourceDB.close()
        }

        private static func write(snapshot: URL, output: URL) throws -> Int64 {
                let sourceDB = try MemorySQLite(url: snapshot, flags: SQLITE_OPEN_READONLY | SQLITE_OPEN_FULLMUTEX)
                let outputDB = try MemorySQLite(url: output, flags: SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX)
                try outputDB.execute("PRAGMA journal_mode = DELETE;")
                try outputDB.execute("BEGIN;")
                let count: Int64
                do {
                        try outputDB.execute(schema)
                        try outputDB.execute("PRAGMA user_version = 1;")
                        count = try copyRows(source: sourceDB, output: outputDB)
                        guard count == (try sourceDB.integer("SELECT COUNT(*) FROM memory2608;")) else { throw MemorySQLiteError.invalidFormat }
                        for command in indexCommands {
                                try Task.checkCancellation()
                                try outputDB.execute(command)
                        }
                        try Task.checkCancellation()
                        try outputDB.execute("COMMIT;")
                } catch {
                        try? outputDB.execute("ROLLBACK;")
                        throw error
                }
                try outputDB.close()
                try sourceDB.close()
                return count
        }

        private static func copyRows(source: MemorySQLite, output: MemorySQLite) throws -> Int64 {
                let query = try source.prepare("SELECT word, romanization, frequency, latest FROM memory2608;")
                defer { sqlite3_finalize(query) }
                let insert = try output.prepare("INSERT INTO input_memory (word, romanization, frequency, latest) VALUES (?, ?, ?, ?);")
                defer { sqlite3_finalize(insert) }
                var count: Int64 = 0
                while true {
                        try Task.checkCancellation()
                        let result = sqlite3_step(query)
                        if result == SQLITE_DONE { return count }
                        try MemorySQLite.check(result, expected: SQLITE_ROW)
                        try MemorySQLite.check(sqlite3_reset(insert))
                        for column: Int32 in 0...1 {
                                // Validate UTF-8 but bind the original byte length, including embedded NULs.
                                _ = try MemorySQLite.text(query, column: column)
                                try MemorySQLite.check(sqlite3_bind_text(insert, column + 1, sqlite3_column_text(query, column), sqlite3_column_bytes(query, column), MemorySQLite.transient))
                        }
                        for column: Int32 in 2...3 {
                                guard sqlite3_column_type(query, column) == SQLITE_INTEGER else { throw MemorySQLiteError.invalidFormat }
                                try MemorySQLite.check(sqlite3_bind_int64(insert, column + 1, sqlite3_column_int64(query, column)))
                        }
                        try MemorySQLite.check(sqlite3_step(insert), expected: SQLITE_DONE)
                        count += 1
                }
        }

        static func validate(output: URL, expectedCount: Int64) throws {
                try Task.checkCancellation()
                let db = try MemorySQLite(url: output, flags: SQLITE_OPEN_READONLY | SQLITE_OPEN_FULLMUTEX)
                guard try db.integer("PRAGMA user_version;") == 1, try db.integer("SELECT COUNT(*) FROM input_memory;") == expectedCount else { throw MemorySQLiteError.invalidFormat }
                guard try db.string("SELECT sql FROM sqlite_master WHERE type = 'table' AND name = 'input_memory';") == String(schema.dropLast()), try db.string("PRAGMA integrity_check;") == "ok" else { throw MemorySQLiteError.invalidFormat }
                try db.close()
        }

        /// Protect the database and its sidecars by canonical path and POSIX file identity.
        static func protectSource(source: URL, destination: URL) throws {
                guard destination.isFileURL else { throw MemorySQLiteError.protectedDestination }
                let resolvedDestination = destination.standardizedFileURL.resolvingSymlinksInPath()
                for suffix in ["", "-wal", "-shm", "-journal"] {
                        let protectedURL = URL(fileURLWithPath: source.path + suffix).standardizedFileURL.resolvingSymlinksInPath()
                        if resolvedDestination == protectedURL { throw MemorySQLiteError.protectedDestination }
                        var sourceInfo = stat()
                        var destinationInfo = stat()
                        if stat(protectedURL.path, &sourceInfo) == 0, stat(resolvedDestination.path, &destinationInfo) == 0, sourceInfo.st_dev == destinationInfo.st_dev, sourceInfo.st_ino == destinationInfo.st_ino {
                                throw MemorySQLiteError.protectedDestination
                        }
                }
        }

        /// Foundation owns atomic staging under the coordinated save-panel authorization.
        /// No caller-created sibling files or persistent security-scoped bookmarks are needed.
        static func publish(output: URL, destination: URL, source: URL) throws {
                try Task.checkCancellation()
                try protectSource(source: source, destination: destination)
                var coordinationError: NSError?
                var publicationError: Error?
                let coordinator = NSFileCoordinator()
                coordinator.coordinate(writingItemAt: destination, options: .forReplacing, error: &coordinationError) { coordinatedURL in
                        do {
                                try Task.checkCancellation()
                                try protectSource(source: source, destination: coordinatedURL)
                                let data = try Data(contentsOf: output, options: .mappedIfSafe)
                                try data.write(to: coordinatedURL, options: .atomic)
                        } catch {
                                publicationError = error
                        }
                }
                if let coordinationError { throw coordinationError }
                if let publicationError { throw publicationError }
        }
}
