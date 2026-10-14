import Foundation
import SQLite3

/// A database connection. The connection closes when the instance is deallocated, unless `close()` already closed it.
public final class SQLiteDatabase {

        /// Flags for opening a database connection.
        public struct OpenFlags: OptionSet, Sendable {
                public let rawValue: Int32
                public init(rawValue: Int32) {
                        self.rawValue = rawValue
                }
                public static let readOnly = OpenFlags(rawValue: SQLITE_OPEN_READONLY)
                public static let readWrite = OpenFlags(rawValue: SQLITE_OPEN_READWRITE)
                public static let create = OpenFlags(rawValue: SQLITE_OPEN_CREATE)
                public static let uri = OpenFlags(rawValue: SQLITE_OPEN_URI)
                public static let memory = OpenFlags(rawValue: SQLITE_OPEN_MEMORY)
                public static let noMutex = OpenFlags(rawValue: SQLITE_OPEN_NOMUTEX)
                public static let fullMutex = OpenFlags(rawValue: SQLITE_OPEN_FULLMUTEX)
                public static let noFollow = OpenFlags(rawValue: SQLITE_OPEN_NOFOLLOW)
        }

        /// The underlying `sqlite3` connection handle, for APIs this wrapper does not cover.
        public let connection: OpaquePointer
        private var isClosed: Bool = false

        public init(path: String, flags: OpenFlags = [.readWrite, .create, .fullMutex]) throws {
                var pointer: OpaquePointer?
                let result = sqlite3_open_v2(path, &pointer, flags.rawValue, nil)
                guard result == SQLITE_OK, let pointer else {
                        sqlite3_close_v2(pointer)
                        throw SQLiteError.sqlite(result)
                }
                connection = pointer
        }

        public convenience init(url: URL, flags: OpenFlags = [.readWrite, .create, .fullMutex]) throws {
                try self.init(path: url.path, flags: flags)
        }

        /// Open a private, temporary in-memory database.
        public static func inMemory() throws -> SQLiteDatabase {
                try SQLiteDatabase(path: ":memory:", flags: [.readWrite, .create, .fullMutex])
        }

        deinit {
                if !isClosed { sqlite3_close_v2(connection) }
        }

        /// Close the connection now. Fails with `SQLITE_BUSY` if any statement of this connection has not been finalized.
        public func close() throws {
                guard !isClosed else { return }
                try Self.check(sqlite3_close(connection))
                isClosed = true
        }

        /// The missing `SQLITE_TRANSIENT`: SQLite makes its own copy of bound text or blob bytes.
        public static var transient: sqlite3_destructor_type {
                unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        }

        /// Throw `SQLiteError.sqlite(result)` unless `result` is the expected code.
        public static func check(_ result: Int32, expected: Int32 = SQLITE_OK) throws {
                guard result == expected else { throw SQLiteError.sqlite(result) }
        }
}

// MARK: - Statements

extension SQLiteDatabase {

        /// Compile a single SQL statement.
        public func prepare(_ sql: String) throws -> SQLiteStatement {
                var statement: OpaquePointer?
                let result = sqlite3_prepare_v2(connection, sql, -1, &statement, nil)
                guard result == SQLITE_OK, let statement else {
                        sqlite3_finalize(statement)
                        throw SQLiteError.sqlite(result)
                }
                return SQLiteStatement(handle: statement)
        }

        /// Run SQL text that may contain multiple statements, without bindings or results.
        public func execute(_ sql: String) throws {
                try Self.check(sqlite3_exec(connection, sql, nil, nil, nil))
        }

        /// Run each SQL text in order, stopping at the first failure.
        public func execute<S: Sequence<String>>(_ commands: S) throws {
                for command in commands { try execute(command) }
        }

        /// Run a single statement with bindings that must not return rows.
        public func run(_ sql: String, _ bindings: (any SQLiteBindable)?...) throws {
                try prepare(sql).bind(bindings).run()
        }

        /// Collect the non-nil transformed rows of a single statement.
        public func query<T>(_ sql: String, _ bindings: (any SQLiteBindable)?..., transform: (SQLiteStatement) throws -> T?) throws -> [T] {
                try prepare(sql).bind(bindings).rows(transform)
        }

        /// Transform the first row of a single statement, or return nil if there is no row.
        public func first<T>(_ sql: String, _ bindings: (any SQLiteBindable)?..., transform: (SQLiteStatement) throws -> T?) throws -> T? {
                try prepare(sql).bind(bindings).first(transform)
        }

        /// The INTEGER value of a statement that returns exactly one row.
        public func integer(_ sql: String, _ bindings: (any SQLiteBindable)?...) throws -> Int64 {
                try prepare(sql).bind(bindings).single({ try $0.requireInt64(at: 0) })
        }

        /// The TEXT value of a statement that returns exactly one row.
        public func string(_ sql: String, _ bindings: (any SQLiteBindable)?...) throws -> String {
                try prepare(sql).bind(bindings).single({ try $0.requireText(at: 0) })
        }
}

// MARK: - Connection State

extension SQLiteDatabase {

        /// The rowid of the most recent successful INSERT on this connection.
        public var lastInsertRowID: Int64 {
                sqlite3_last_insert_rowid(connection)
        }

        /// The number of rows modified by the most recent INSERT, UPDATE, or DELETE on this connection.
        public var changes: Int64 {
                Int64(sqlite3_changes(connection))
        }

        /// Whether the connection is outside an explicit transaction.
        public var isAutocommit: Bool {
                sqlite3_get_autocommit(connection) != 0
        }

        /// The most recent result code of this connection.
        public var errorCode: Int32 {
                sqlite3_errcode(connection)
        }

        /// Wait up to the given duration for locks held by other connections. Zero or less turns the busy handler off.
        public func setBusyTimeout(milliseconds: Int32) throws {
                try Self.check(sqlite3_busy_timeout(connection, milliseconds))
        }

        /// `PRAGMA user_version`
        public func userVersion() throws -> Int64 {
                try integer("PRAGMA user_version;")
        }

        /// `PRAGMA user_version`
        public func setUserVersion(_ version: Int32) throws {
                try execute("PRAGMA user_version = \(version);")
        }

        /// Whether the main schema contains a table with the given name.
        public func tableExists(_ name: String) throws -> Bool {
                try integer("SELECT COUNT(*) FROM sqlite_master WHERE type = 'table' AND name = ?;", name) != 0
        }

        /// `PRAGMA integrity_check` reports exactly `ok`.
        public func isIntegrityOK() throws -> Bool {
                try query("PRAGMA integrity_check;", transform: { $0.text(at: 0) }) == ["ok"]
        }
}

// MARK: - Transactions

extension SQLiteDatabase {

        public enum TransactionKind: String, Sendable {
                case deferred = "DEFERRED"
                case immediate = "IMMEDIATE"
                case exclusive = "EXCLUSIVE"
        }

        /// Commit if the body returns, or roll back and rethrow if it throws.
        public func transaction<T>(_ kind: TransactionKind = .deferred, _ body: () throws -> T) throws -> T {
                try execute("BEGIN \(kind.rawValue);")
                do {
                        let value = try body()
                        try execute("COMMIT;")
                        return value
                } catch {
                        try? execute("ROLLBACK;")
                        throw error
                }
        }
}

// MARK: - Backup

extension SQLiteDatabase {

        /// Copy the `main` database of this connection into the `main` database of `destination`.
        /// - Parameters:
        ///   - destination: The connection to overwrite.
        ///   - pagesPerStep: Pages copied per step. A negative value copies everything in one step.
        ///   - timeout: Give up with `SQLiteError.timedOut` after this duration. Nil means no deadline.
        ///   - retryInterval: Pause between steps, which also lets busy or locked sources retry.
        /// - Throws: `CancellationError` when the current task is cancelled between steps.
        public func backup(to destination: SQLiteDatabase, pagesPerStep: Int32 = -1, timeout: Duration? = nil, retryInterval: Duration = .milliseconds(10)) throws {
                guard let backup = sqlite3_backup_init(destination.connection, "main", connection, "main") else { throw SQLiteError.sqlite(destination.errorCode) }
                var finished = false
                defer { if !finished { sqlite3_backup_finish(backup) } }
                let deadline = timeout.map({ ContinuousClock.now.advanced(by: $0) })
                let interval = TimeInterval(retryInterval.components.seconds) + TimeInterval(retryInterval.components.attoseconds) / 1e18
                while true {
                        try Task.checkCancellation()
                        if let deadline, ContinuousClock.now >= deadline { throw SQLiteError.timedOut }
                        let result = sqlite3_backup_step(backup, pagesPerStep)
                        if result == SQLITE_DONE { break }
                        guard result == SQLITE_OK || result == SQLITE_BUSY || result == SQLITE_LOCKED else { throw SQLiteError.sqlite(result) }
                        // Yield this worker between bounded batches and busy retries.
                        Thread.sleep(forTimeInterval: interval)
                }
                finished = true
                try Self.check(sqlite3_backup_finish(backup))
        }
}
