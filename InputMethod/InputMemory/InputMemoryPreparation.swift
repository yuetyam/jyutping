import Foundation
import SQLite3

/// The lock protects readiness and connection ownership; only the shared preparation task
/// uses the connection until ready. Subsequent callers use SQLite's FULLMUTEX connection.
final class InputMemoryPreparation: @unchecked Sendable {

        let databaseURL: URL
        private let defaults: UserDefaults
        private let lock = NSLock()
        private var database: MemorySQLite?
        private var preparation: Task<Void, Error>?
        private var ready: Bool = false

        init(databaseURL: URL, defaults: UserDefaults = .standard) {
                self.databaseURL = databaseURL
                self.defaults = defaults
        }

        var connection: OpaquePointer? {
                lock.withLock { ready ? database?.connection : nil }
        }

        var isReady: Bool {
                lock.withLock { ready }
        }

        func prepareForTyping() {
                lock.lock()
                guard !ready && preparation == nil else {
                        lock.unlock()
                        return
                }
                guard savedInputMemoryMigration == Self.definedMigrationValue else {
                        lock.unlock()
                        _ = prepare()
                        return
                }
                do {
                        let database = try openDatabase()
                        try MemorySQLite.check(sqlite3_busy_timeout(database.connection, 100))
                        self.database = database
                        ready = true
                } catch {
                        database = nil
                }
                lock.unlock()
        }

        func prepare() -> Task<Void, Error> {
                lock.withLock {
                        if ready { return Task { () throws -> Void in } }
                        if let preparation { return preparation }
                        let task = Task.detached(priority: .high) { [self] in
                                do {
                                        let database = try prepareDatabase()
                                        lock.withLock {
                                                self.database = database
                                                ready = true
                                        }
                                } catch {
                                        lock.withLock {
                                                database = nil
                                                preparation = nil
                                        }
                                        throw error
                                }
                        }
                        preparation = task
                        return task
                }
        }

        func waitUntilReady() async throws {
                // Cancellation of an export must not cancel shared migration needed by typing.
                try await prepare().value
                try Task.checkCancellation()
        }

        private func prepareDatabase() throws -> MemorySQLite {
                let db = try openDatabase()
                try migrateDatabase(db)
                // Backup steps briefly hold a read lock in DELETE journal mode. Give learning
                // writes a short bounded wait instead of immediately dropping them as busy.
                try MemorySQLite.check(sqlite3_busy_timeout(db.connection, 100))
                return db
        }

        private func openDatabase() throws -> MemorySQLite {
                let db = try MemorySQLite(url: databaseURL, flags: SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX)
                try MemorySQLite.check(sqlite3_busy_timeout(db.connection, 1000))
                try db.execute("CREATE TABLE IF NOT EXISTS memory2608 (id INTEGER PRIMARY KEY AUTOINCREMENT, word TEXT NOT NULL, romanization TEXT NOT NULL, frequency INTEGER NOT NULL, latest INTEGER NOT NULL, char_count INTEGER NOT NULL, letter_count INTEGER NOT NULL, complexity INTEGER NOT NULL, anchors INTEGER NOT NULL, spell INTEGER NOT NULL, UNIQUE (word, romanization));")
                for command in Self.indexCommands { try db.execute(command) }
                return db
        }

        private static let definedMigrationValue: Int = 2608
        private static let kMigrationKey: String = "Migration2608"
        private var savedInputMemoryMigration: Int {
                defaults.integer(forKey: Self.kMigrationKey)
        }

        private func migrateDatabase(_ db: MemorySQLite) throws {
                guard savedInputMemoryMigration != Self.definedMigrationValue else { return }
                let table = defaults.integer(forKey: "InputMemoryMigration2026") == 2026 ? "core_memory" : "memory"
                let exists = try db.integer("SELECT COUNT(*) FROM sqlite_master WHERE type = 'table' AND name = '\(table)';") != 0
                if exists {
                        let saved = savedInputMemoryMigration
                        if saved == 0 {
                                try migrate(db, table: table, lower: 20, upper: 100000)
                                defaults.set(20, forKey: Self.kMigrationKey)
                        }
                        var upper = saved == 0 ? 20 : saved
                        while upper > 1 {
                                try migrate(db, table: table, lower: upper - 1, upper: upper)
                                upper -= 1
                                defaults.set(upper, forKey: Self.kMigrationKey)
                        }
                        try migrate(db, table: table, lower: 0, upper: 1)
                }
                defaults.set(Self.definedMigrationValue, forKey: Self.kMigrationKey)
                cleanupObsoleteObjects()
        }
        private func cleanupObsoleteObjects() {
                let previousMigrationKeys: [String] = ["InputMemoryMigration2026", "InputMemoryVersion"]
                previousMigrationKeys.forEach(defaults.removeObject(forKey:))
                let previousDatabase = URL.libraryDirectory.appending(path: "userlexicon.sqlite3", directoryHint: .notDirectory)
                try? FileManager.default.removeItem(at: previousDatabase)
        }

        private func migrate(_ db: MemorySQLite, table: String, lower: Int, upper: Int) throws {
                // Checkpoints advance only after the entire frequency band commits.
                try db.execute("BEGIN IMMEDIATE;")
                do {
                        try copyLegacyEntries(db, table: table, lower: lower, upper: upper)
                        try db.execute("COMMIT;")
                } catch {
                        try? db.execute("ROLLBACK;")
                        throw error
                }
        }

        private func copyLegacyEntries(_ db: MemorySQLite, table: String, lower: Int, upper: Int) throws {
                let query = try db.prepare("SELECT word, romanization, frequency, latest FROM \(table) WHERE frequency > \(lower) AND frequency <= \(upper) ORDER BY frequency DESC;")
                defer { sqlite3_finalize(query) }
                let insert = try db.prepare("INSERT OR IGNORE INTO memory2608 (word, romanization, frequency, latest, char_count, letter_count, complexity, anchors, spell) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);")
                defer { sqlite3_finalize(insert) }
                while true {
                        let result = sqlite3_step(query)
                        if result == SQLITE_DONE { break }
                        try MemorySQLite.check(result, expected: SQLITE_ROW)
                        guard sqlite3_column_type(query, 2) == SQLITE_INTEGER, sqlite3_column_type(query, 3) == SQLITE_INTEGER else { throw MemorySQLiteError.invalidFormat }
                        let entry = MemoryLexicon(word: try MemorySQLite.text(query, column: 0), romanization: try MemorySQLite.text(query, column: 1), frequency: sqlite3_column_int64(query, 2), latest: sqlite3_column_int64(query, 3))
                        try MemorySQLite.check(sqlite3_reset(insert))
                        try MemorySQLite.bind(entry.word, to: insert, at: 1)
                        try MemorySQLite.bind(entry.romanization, to: insert, at: 2)
                        let values: [Int64] = [entry.frequency, entry.latest, Int64(entry.charCount), Int64(entry.letterCount), Int64(entry.complexity), Int64(entry.anchors), Int64(entry.spell)]
                        for (index, value) in values.enumerated() {
                                try MemorySQLite.check(sqlite3_bind_int64(insert, Int32(index + 3), value))
                        }
                        try MemorySQLite.check(sqlite3_step(insert), expected: SQLITE_DONE)
                }
        }

        private static let indexCommands: [String] = [
                "CREATE INDEX IF NOT EXISTS ix2608_frequency ON memory2608 (frequency);",
                "CREATE INDEX IF NOT EXISTS ix2608_anchors ON memory2608 (anchors, char_count, frequency DESC);",
                "CREATE INDEX IF NOT EXISTS ix2608_spell ON memory2608 (spell, letter_count, complexity, frequency DESC);",
                "CREATE INDEX IF NOT EXISTS ix2608_word ON memory2608 (word, frequency DESC);",
                "CREATE INDEX IF NOT EXISTS ix2608_lexicon ON memory2608 (word, romanization);",
        ]
}
