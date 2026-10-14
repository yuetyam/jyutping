import Foundation
import SQLiteWrapper

/// Writes the portable version-1 input memory file, the same format as the macOS InputMethod export.
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
                let sourceDB = try SQLiteDatabase(url: source, flags: [.readOnly, .fullMutex])
                let snapshotDB = try SQLiteDatabase(url: snapshot, flags: [.readWrite, .create, .fullMutex])
                try sourceDB.backup(to: snapshotDB, pagesPerStep: 128, timeout: timeout)
                // A WAL source can copy its journal-mode header into the snapshot.
                // Normalize it while writable before reopening it read-only without sidecars.
                try snapshotDB.execute("PRAGMA journal_mode = DELETE;")
                try snapshotDB.close()
                try sourceDB.close()
        }

        private static func write(snapshot: URL, output: URL) throws -> Int64 {
                let sourceDB = try SQLiteDatabase(url: snapshot, flags: [.readOnly, .fullMutex])
                let outputDB = try SQLiteDatabase(url: output, flags: [.readWrite, .create, .fullMutex])
                try outputDB.execute("PRAGMA journal_mode = DELETE;")
                let count: Int64 = try outputDB.transaction {
                        try outputDB.execute(schema)
                        try outputDB.setUserVersion(1)
                        let count = try copyRows(source: sourceDB, output: outputDB)
                        guard count == (try sourceDB.integer("SELECT COUNT(*) FROM memory2608;")) else { throw SQLiteError.invalidFormat }
                        for command in indexCommands {
                                try Task.checkCancellation()
                                try outputDB.execute(command)
                        }
                        try Task.checkCancellation()
                        return count
                }
                try outputDB.close()
                try sourceDB.close()
                return count
        }

        private static func copyRows(source: SQLiteDatabase, output: SQLiteDatabase) throws -> Int64 {
                let query = try source.prepare("SELECT word, romanization, frequency, latest FROM memory2608;")
                let insert = try output.prepare("INSERT INTO input_memory (word, romanization, frequency, latest) VALUES (?, ?, ?, ?);")
                var count: Int64 = 0
                while try query.step() {
                        try Task.checkCancellation()
                        // Validated UTF-8 text keeps its full byte length, including embedded NULs.
                        try insert.run(try query.requireText(at: 0), try query.requireText(at: 1), try query.requireInt64(at: 2), try query.requireInt64(at: 3))
                        count += 1
                }
                return count
        }

        private static func validate(output: URL, expectedCount: Int64) throws {
                try Task.checkCancellation()
                let db = try SQLiteDatabase(url: output, flags: [.readOnly, .fullMutex])
                guard try db.userVersion() == 1, try db.integer("SELECT COUNT(*) FROM input_memory;") == expectedCount else { throw SQLiteError.invalidFormat }
                guard try db.string("SELECT sql FROM sqlite_master WHERE type = 'table' AND name = 'input_memory';") == String(schema.dropLast()), try db.isIntegrityOK() else { throw SQLiteError.invalidFormat }
                try db.close()
        }
}
