import Foundation
import SQLiteWrapper

/// The lock protects readiness and connection ownership; only the shared preparation task
/// uses the connection until ready. Subsequent callers use SQLite's FULLMUTEX connection.
final class InputMemoryPreparation: @unchecked Sendable {

        let databaseURL: URL
        private let defaults: UserDefaults
        private let lock = NSLock()
        private var connection: SQLiteDatabase?
        private var preparation: Task<Void, Error>?
        private var ready: Bool = false

        init(databaseURL: URL, defaults: UserDefaults = .standard) {
                self.databaseURL = databaseURL
                self.defaults = defaults
        }

        var database: SQLiteDatabase? {
                lock.withLock { ready ? connection : nil }
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
                        try database.setBusyTimeout(milliseconds: 100)
                        connection = database
                        ready = true
                } catch {
                        connection = nil
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
                                                connection = database
                                                ready = true
                                        }
                                } catch {
                                        lock.withLock {
                                                connection = nil
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

        private func prepareDatabase() throws -> SQLiteDatabase {
                let db = try openDatabase()
                try migrateDatabase(db)
                // Backup steps briefly hold a read lock in DELETE journal mode. Give learning
                // writes a short bounded wait instead of immediately dropping them as busy.
                try db.setBusyTimeout(milliseconds: 100)
                return db
        }

        private func openDatabase() throws -> SQLiteDatabase {
                let db = try SQLiteDatabase(url: databaseURL, flags: [.readWrite, .create, .fullMutex])
                try db.setBusyTimeout(milliseconds: 1000)
                try db.execute("CREATE TABLE IF NOT EXISTS memory2608 (id INTEGER PRIMARY KEY AUTOINCREMENT, word TEXT NOT NULL, romanization TEXT NOT NULL, frequency INTEGER NOT NULL, latest INTEGER NOT NULL, char_count INTEGER NOT NULL, letter_count INTEGER NOT NULL, complexity INTEGER NOT NULL, anchors INTEGER NOT NULL, spell INTEGER NOT NULL, UNIQUE (word, romanization));")
                try db.execute(Self.indexCommands)
                return db
        }

        private static let definedMigrationValue: Int = 2608
        private static let kMigrationKey: String = "Migration2608"
        private var savedInputMemoryMigration: Int {
                defaults.integer(forKey: Self.kMigrationKey)
        }

        private func migrateDatabase(_ db: SQLiteDatabase) throws {
                guard savedInputMemoryMigration != Self.definedMigrationValue else { return }
                let table = defaults.integer(forKey: "InputMemoryMigration2026") == 2026 ? "core_memory" : "memory"
                if try db.tableExists(table) {
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

        private func migrate(_ db: SQLiteDatabase, table: String, lower: Int, upper: Int) throws {
                // Checkpoints advance only after the entire frequency band commits.
                try db.transaction(.immediate) {
                        try copyLegacyEntries(db, table: table, lower: lower, upper: upper)
                }
        }

        private func copyLegacyEntries(_ db: SQLiteDatabase, table: String, lower: Int, upper: Int) throws {
                let query = try db.prepare("SELECT word, romanization, frequency, latest FROM \(table) WHERE frequency > ? AND frequency <= ? ORDER BY frequency DESC;").bind(lower, upper)
                let insert = try db.prepare("INSERT OR IGNORE INTO memory2608 (word, romanization, frequency, latest, char_count, letter_count, complexity, anchors, spell) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);")
                while try query.step() {
                        let entry = MemoryLexicon(word: try query.requireText(at: 0), romanization: try query.requireText(at: 1), frequency: try query.requireInt64(at: 2), latest: try query.requireInt64(at: 3))
                        try insert.run(entry.word, entry.romanization, entry.frequency, entry.latest, entry.charCount, entry.letterCount, entry.complexity, entry.anchors, entry.spell)
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
