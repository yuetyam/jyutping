import Foundation
import SQLite3
import Testing
@testable import SQLiteWrapper

@Suite("SQLiteDatabase")
struct SQLiteDatabaseTests {

        private func temporaryDirectory() throws -> URL {
                let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: false)
                return url
        }

        private func sampleDatabase() throws -> SQLiteDatabase {
                let db = try SQLiteDatabase.inMemory()
                try db.execute("CREATE TABLE sample (id INTEGER PRIMARY KEY, word TEXT, frequency INTEGER, score REAL, payload BLOB);")
                return db
        }

        @Test func openFailureReportsResultCode() throws {
                let directory = try temporaryDirectory()
                defer { try? FileManager.default.removeItem(at: directory) }
                let missing = directory.appendingPathComponent("missing/database.sqlite3")
                #expect(throws: SQLiteError.sqlite(SQLITE_CANTOPEN)) { try SQLiteDatabase(url: missing) }
                #expect(throws: SQLiteError.sqlite(SQLITE_CANTOPEN)) { try SQLiteDatabase(url: directory.appendingPathComponent("absent.sqlite3"), flags: [.readOnly]) }
        }

        @Test func openFlagsMatchSQLite() {
                #expect(SQLiteDatabase.OpenFlags.readOnly.rawValue == SQLITE_OPEN_READONLY)
                #expect(SQLiteDatabase.OpenFlags.readWrite.rawValue == SQLITE_OPEN_READWRITE)
                #expect(SQLiteDatabase.OpenFlags.create.rawValue == SQLITE_OPEN_CREATE)
                #expect(SQLiteDatabase.OpenFlags.uri.rawValue == SQLITE_OPEN_URI)
                #expect(SQLiteDatabase.OpenFlags.memory.rawValue == SQLITE_OPEN_MEMORY)
                #expect(SQLiteDatabase.OpenFlags.noMutex.rawValue == SQLITE_OPEN_NOMUTEX)
                #expect(SQLiteDatabase.OpenFlags.fullMutex.rawValue == SQLITE_OPEN_FULLMUTEX)
                #expect(SQLiteDatabase.OpenFlags.noFollow.rawValue == SQLITE_OPEN_NOFOLLOW)
        }

        @Test func fileDatabaseRoundTripAndReadOnly() throws {
                let directory = try temporaryDirectory()
                defer { try? FileManager.default.removeItem(at: directory) }
                let url = directory.appendingPathComponent("database.sqlite3")
                let writer = try SQLiteDatabase(url: url)
                try writer.execute(["CREATE TABLE t (value INTEGER);", "INSERT INTO t VALUES (7);"])
                try writer.close()
                try writer.close()
                let reader = try SQLiteDatabase(url: url, flags: [.readOnly, .fullMutex])
                #expect(try reader.integer("SELECT value FROM t;") == 7)
                #expect(throws: SQLiteError.sqlite(SQLITE_READONLY)) { try reader.execute("INSERT INTO t VALUES (8);") }
        }

        @Test func closeFailsWhileStatementIsAlive() throws {
                let db = try SQLiteDatabase.inMemory()
                let statement = try db.prepare("SELECT 1;")
                #expect(throws: SQLiteError.sqlite(SQLITE_BUSY)) { try db.close() }
                _ = statement
        }

        @Test func checkComparesExpectedResult() throws {
                try SQLiteDatabase.check(SQLITE_OK)
                try SQLiteDatabase.check(SQLITE_DONE, expected: SQLITE_DONE)
                #expect(throws: SQLiteError.sqlite(SQLITE_ROW)) { try SQLiteDatabase.check(SQLITE_ROW, expected: SQLITE_DONE) }
        }

        @Test func prepareAndExecuteFailures() throws {
                let db = try SQLiteDatabase.inMemory()
                #expect(throws: SQLiteError.sqlite(SQLITE_ERROR)) { try db.prepare("SELECT * FROM missing;") }
                #expect(throws: SQLiteError.sqlite(SQLITE_ERROR)) { try db.execute("NOT SQL;") }
                #expect(throws: SQLiteError.sqlite(SQLITE_ERROR)) { try db.execute(["CREATE TABLE t (v);", "NOT SQL;", "CREATE TABLE u (v);"]) }
                #expect(try db.tableExists("t"))
                #expect(try !db.tableExists("u"))
        }

        @Test func runQueryAndFirst() throws {
                let db = try sampleDatabase()
                try db.run("INSERT INTO sample (word, frequency) VALUES (?, ?);", "粵", 3)
                #expect(db.lastInsertRowID == 1)
                try db.run("INSERT INTO sample (word, frequency) VALUES (?, ?);", "拼", Int64(2))
                try db.run("INSERT INTO sample (word, frequency) VALUES (?, ?);", nil, 1)
                try db.run("UPDATE sample SET score = ?;", 0.5)
                #expect(db.changes == 3)
                let words = try db.query("SELECT word FROM sample WHERE frequency >= ? ORDER BY frequency DESC;", 1, transform: { $0.text(at: 0) })
                #expect(words == ["粵", "拼"])
                let first = try db.first("SELECT word, frequency FROM sample ORDER BY frequency;", transform: { ($0.text(at: 0), $0.int(at: 1)) })
                #expect(first?.0 == nil)
                #expect(first?.1 == 1)
                #expect(try db.first("SELECT word FROM sample WHERE frequency > 100;", transform: { $0.text(at: 0) }) == nil)
                #expect(throws: SQLiteError.sqlite(SQLITE_ROW)) { try db.run("SELECT * FROM sample;") }
                #expect(throws: SQLiteError.sqlite(SQLITE_RANGE)) { try db.run("SELECT ?;", 1, 2) }
        }

        @Test func scalarsRequireExactlyOneTypedRow() throws {
                let db = try sampleDatabase()
                #expect(try db.integer("SELECT ? + 1;", 41) == 42)
                #expect(try db.string("SELECT ?;", "話") == "話")
                #expect(throws: SQLiteError.invalidFormat) { try db.integer("SELECT id FROM sample;") }
                #expect(throws: SQLiteError.invalidFormat) { try db.integer("SELECT 1 UNION ALL SELECT 2;") }
                #expect(throws: SQLiteError.invalidFormat) { try db.integer("SELECT '1';") }
                #expect(throws: SQLiteError.invalidFormat) { try db.string("SELECT 1;") }
        }

        @Test func connectionState() throws {
                let db = try SQLiteDatabase.inMemory()
                #expect(db.isAutocommit)
                try db.setBusyTimeout(milliseconds: 100)
                try db.setBusyTimeout(milliseconds: 0)
                #expect(try db.userVersion() == 0)
                try db.setUserVersion(3)
                #expect(try db.userVersion() == 3)
                #expect(try db.isIntegrityOK())
                #expect(throws: SQLiteError.sqlite(SQLITE_ERROR)) { try db.execute("SELECT * FROM missing;") }
                #expect(db.errorCode == SQLITE_ERROR)
                #expect(try !db.tableExists("sqlite_master"))
        }

        @Test func transactionCommitsAndRollsBack() throws {
                let db = try sampleDatabase()
                let count = try db.transaction(.immediate) { () throws -> Int64 in
                        #expect(!db.isAutocommit)
                        try db.run("INSERT INTO sample (word) VALUES (?);", "一")
                        return try db.integer("SELECT COUNT(*) FROM sample;")
                }
                #expect(count == 1)
                #expect(db.isAutocommit)
                #expect(throws: SQLiteError.invalidFormat) {
                        try db.transaction(.exclusive) {
                                try db.run("INSERT INTO sample (word) VALUES (?);", "二")
                                throw SQLiteError.invalidFormat
                        }
                }
                #expect(db.isAutocommit)
                try db.transaction { try db.run("INSERT INTO sample (word) VALUES (?);", "三") }
                #expect(try db.query("SELECT word FROM sample ORDER BY id;", transform: { $0.text(at: 0) }) == ["一", "三"])
                try db.execute("BEGIN;")
                #expect(throws: SQLiteError.sqlite(SQLITE_ERROR)) { try db.transaction { } }
                // A failed BEGIN leaves the outer transaction untouched.
                #expect(!db.isAutocommit)
                try db.execute("ROLLBACK;")
        }

        @Test func backupCopiesDatabase() throws {
                let source = try SQLiteDatabase.inMemory()
                try source.execute("CREATE TABLE t (v); WITH RECURSIVE r(n) AS (VALUES(1) UNION ALL SELECT n+1 FROM r WHERE n<2000) INSERT INTO t SELECT randomblob(100) FROM r;")
                let whole = try SQLiteDatabase.inMemory()
                try source.backup(to: whole)
                #expect(try whole.integer("SELECT COUNT(*) FROM t;") == 2000)
                let stepped = try SQLiteDatabase.inMemory()
                try source.backup(to: stepped, pagesPerStep: 8, timeout: .seconds(10), retryInterval: .zero)
                #expect(try stepped.integer("SELECT COUNT(*) FROM t;") == 2000)
                #expect(throws: SQLiteError.sqlite(SQLITE_ERROR)) { try source.backup(to: source) }
        }

        @Test func backupTimesOutOnLockedSource() throws {
                let directory = try temporaryDirectory()
                defer { try? FileManager.default.removeItem(at: directory) }
                let url = directory.appendingPathComponent("database.sqlite3")
                let locker = try SQLiteDatabase(url: url)
                try locker.execute("CREATE TABLE t (v); BEGIN EXCLUSIVE; INSERT INTO t VALUES (1);")
                let source = try SQLiteDatabase(url: url, flags: [.readOnly])
                let destination = try SQLiteDatabase.inMemory()
                #expect(throws: SQLiteError.timedOut) { try source.backup(to: destination, pagesPerStep: 1, timeout: .milliseconds(50)) }
                try locker.execute("ROLLBACK;")
                try source.backup(to: destination)
                #expect(try destination.tableExists("t"))
        }

        @Test func backupIsCancellable() async throws {
                let task = Task.detached {
                        withUnsafeCurrentTask { $0?.cancel() }
                        let source = try SQLiteDatabase.inMemory()
                        try source.backup(to: try SQLiteDatabase.inMemory())
                }
                await #expect(throws: CancellationError.self) { try await task.value }
        }
}

@Suite("SQLiteStatement")
struct SQLiteStatementTests {

        @Test func bindAndReadEveryType() throws {
                let db = try SQLiteDatabase.inMemory()
                let statement = try db.prepare("SELECT ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?;")
                #expect(statement.parameterCount == 12)
                let text = "廣東話𠵱\u{0000}家"
                try statement.bind(Int64.max, at: 1)
                try statement.bind(Int(-3), at: 2)
                try statement.bind(1.25, at: 3)
                try statement.bind(text, at: 4)
                try statement.bind("", at: 5)
                try statement.bind(Data([0, 1, 2]), at: 6)
                try statement.bind(Data(), at: 7)
                try statement.bindNull(at: 8)
                try statement.bind(Int32(-7) as (any SQLiteBindable)?, at: 9)
                try statement.bind(UInt32.max as (any SQLiteBindable)?, at: 10)
                try statement.bind(true as (any SQLiteBindable)?, at: 11)
                try statement.bind(nil as (any SQLiteBindable)?, at: 12)
                #expect(try statement.step())
                #expect(statement.columnCount == 12)
                #expect(statement.columnType(at: 0) == .integer)
                #expect(statement.columnType(at: 2) == .float)
                #expect(statement.columnType(at: 3) == .text)
                #expect(statement.columnType(at: 5) == .blob)
                #expect(statement.columnType(at: 7) == .null)
                #expect(statement.int64(at: 0) == Int64.max)
                #expect(try statement.requireInt64(at: 0) == Int64.max)
                #expect(statement.int(at: 1) == -3)
                #expect(statement.double(at: 2) == 1.25)
                #expect(statement.text(at: 3) == text)
                #expect(try statement.requireText(at: 3) == text)
                #expect(statement.text(at: 4) == "")
                #expect(statement.isNull(at: 4) == false)
                #expect(statement.data(at: 5) == Data([0, 1, 2]))
                #expect(statement.data(at: 6) == Data())
                #expect(statement.isNull(at: 6) == false)
                #expect(statement.text(at: 7) == nil)
                #expect(statement.data(at: 7) == nil)
                #expect(statement.isNull(at: 7))
                #expect(statement.int64(at: 8) == -7)
                #expect(statement.int64(at: 9) == Int64(UInt32.max))
                #expect(statement.int64(at: 10) == 1)
                #expect(statement.isNull(at: 11))
                #expect(throws: SQLiteError.invalidFormat) { try statement.requireInt64(at: 2) }
                #expect(throws: SQLiteError.invalidFormat) { try statement.requireText(at: 0) }
                #expect(throws: SQLiteError.invalidFormat) { try statement.requireText(at: 7) }
                #expect(try !statement.step())
        }

        @Test func bindableConformances() throws {
                let db = try SQLiteDatabase.inMemory()
                let statement = try db.prepare("SELECT ?, ?, ?, ?, ?, ?;")
                try statement.bind("話"[...], false, Int64(1), 2, 3.5, Data([9]))
                #expect(try statement.step())
                #expect(statement.text(at: 0) == "話")
                #expect(statement.int64(at: 1) == 0)
                #expect(statement.int64(at: 2) == 1)
                #expect(statement.int(at: 3) == 2)
                #expect(statement.double(at: 4) == 3.5)
                #expect(statement.data(at: 5) == Data([9]))
                #expect(throws: SQLiteError.sqlite(SQLITE_MISUSE)) { try statement.bind(1, at: 1) }
                statement.reset()
                #expect(throws: SQLiteError.sqlite(SQLITE_RANGE)) { try statement.bind(1, at: 7) }
                #expect(throws: SQLiteError.sqlite(SQLITE_RANGE)) { try statement.bind(Int64(1), at: 0) }
                #expect(throws: SQLiteError.sqlite(SQLITE_RANGE)) { try statement.bind(1.0, at: 0) }
                #expect(throws: SQLiteError.sqlite(SQLITE_RANGE)) { try statement.bind("", at: 0) }
                #expect(throws: SQLiteError.sqlite(SQLITE_RANGE)) { try statement.bind("a", at: 0) }
                #expect(throws: SQLiteError.sqlite(SQLITE_RANGE)) { try statement.bind(Data(), at: 0) }
                #expect(throws: SQLiteError.sqlite(SQLITE_RANGE)) { try statement.bind(Data([1]), at: 0) }
                #expect(throws: SQLiteError.sqlite(SQLITE_RANGE)) { try statement.bindNull(at: 0) }
        }

        @Test func textReadersHandleInvalidUTF8AndConversion() throws {
                let db = try SQLiteDatabase.inMemory()
                let statement = try db.prepare("SELECT CAST(x'ff' AS TEXT), 12, x'e8a9b1';")
                #expect(try statement.step())
                #expect(statement.text(at: 0) == "\u{FFFD}")
                #expect(throws: SQLiteError.invalidFormat) { try statement.requireText(at: 0) }
                #expect(statement.text(at: 1) == "12")
                #expect(statement.text(at: 2) == "話")
                #expect(statement.columnName(at: 1) == "12")
                #expect(statement.columnName(at: 9) == nil)
        }

        @Test func reusableStatementQueries() throws {
                let db = try SQLiteDatabase.inMemory()
                try db.execute("CREATE TABLE t (word TEXT, code INTEGER); INSERT INTO t VALUES ('一', 1), ('二', 2), ('三', 2), (NULL, 2);")
                let statement = try db.prepare("SELECT word FROM t WHERE code = ? ORDER BY rowid;")
                #expect(try statement.query(2, transform: { $0.text(at: 0) }) == ["二", "三"])
                #expect(try statement.query(1, transform: { $0.text(at: 0) }) == ["一"])
                #expect(try statement.queryFirst(2, transform: { $0.text(at: 0) }) == "二")
                #expect(try statement.queryFirst(9, transform: { $0.text(at: 0) }) == nil)
                var visited: [String?] = []
                try statement.reset().clearBindings().forEachRow({ visited.append($0.text(at: 0)) })
                #expect(visited.isEmpty)
                try statement.reset().bind(2).forEachRow({ visited.append($0.text(at: 0)) })
                #expect(visited == ["二", "三", nil])
                #expect(throws: SQLiteError.invalidFormat) { try statement.reset().single({ $0.text(at: 0) }) }
        }

        @Test func singleRequiresExactlyOneRow() throws {
                let db = try SQLiteDatabase.inMemory()
                #expect(try db.prepare("SELECT 1;").single({ $0.int(at: 0) }) == 1)
                #expect(throws: SQLiteError.invalidFormat) { try db.prepare("SELECT 1 WHERE 0;").single({ $0.int(at: 0) }) }
                #expect(throws: SQLiteError.invalidFormat) { try db.prepare("SELECT 1 UNION ALL SELECT 2;").single({ $0.int(at: 0) }) }
        }

        @Test func runReusesInsertStatement() throws {
                let db = try SQLiteDatabase.inMemory()
                try db.execute("CREATE TABLE t (word TEXT NOT NULL UNIQUE, code INTEGER);")
                let insert = try db.prepare("INSERT INTO t (word, code) VALUES (?, ?);")
                try insert.run("一", 1)
                try insert.run("二", nil)
                #expect(throws: SQLiteError.sqlite(SQLITE_CONSTRAINT)) { try insert.run("一", 3) }
                #expect(throws: SQLiteError.sqlite(SQLITE_CONSTRAINT)) { try insert.run(nil, 4) }
                try insert.run("三", 3)
                #expect(try db.integer("SELECT COUNT(*) FROM t;") == 3)
                #expect(try db.integer("SELECT COUNT(*) FROM t WHERE code IS NULL;") == 1)
        }

        @Test func stepErrorsAreThrown() throws {
                let db = try SQLiteDatabase.inMemory()
                let statement = try db.prepare("SELECT abs(-9223372036854775807 - 1);")
                #expect(throws: SQLiteError.sqlite(SQLITE_ERROR)) { try statement.step() }
                #expect(throws: SQLiteError.sqlite(SQLITE_ERROR)) { try statement.reset().rows({ $0.int(at: 0) }) }
        }

        @Test func transientDestructorCopiesBoundText() throws {
                let db = try SQLiteDatabase.inMemory()
                let statement = try db.prepare("SELECT ?;")
                var value = "temporary"
                try statement.bind(value, at: 1)
                value = "changed"
                #expect(try statement.single({ $0.text(at: 0) }) == "temporary")
                #expect(value == "changed")
                #expect(unsafeBitCast(SQLiteDatabase.transient, to: Int.self) == -1)
        }
}
