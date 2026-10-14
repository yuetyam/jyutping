import Foundation
import SQLite3

/// Errors deliberately omit SQLite messages, which can contain learned words.
enum MemorySQLiteError: Error, Equatable {
        case sqlite(Int32)
        case invalidFormat
        case timedOut
        case protectedDestination
}

/// A connection owned by one operation, or by the prepared memory store.
final class MemorySQLite {

        let connection: OpaquePointer
        private var isClosed: Bool = false

        init(url: URL, flags: Int32) throws {
                var pointer: OpaquePointer?
                let result = sqlite3_open_v2(url.path, &pointer, flags, nil)
                guard result == SQLITE_OK, let pointer else {
                        sqlite3_close_v2(pointer)
                        throw MemorySQLiteError.sqlite(result)
                }
                connection = pointer
        }

        deinit {
                if !isClosed { sqlite3_close_v2(connection) }
        }

        func close() throws {
                try Self.check(sqlite3_close(connection))
                isClosed = true
        }

        static var transient: sqlite3_destructor_type {
                unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        }

        static func check(_ result: Int32, expected: Int32 = SQLITE_OK) throws {
                guard result == expected else { throw MemorySQLiteError.sqlite(result) }
        }

        func execute(_ sql: String) throws {
                try Self.check(sqlite3_exec(connection, sql, nil, nil, nil))
        }

        func prepare(_ sql: String) throws -> OpaquePointer {
                var statement: OpaquePointer?
                let result = sqlite3_prepare_v2(connection, sql, -1, &statement, nil)
                guard result == SQLITE_OK, let statement else {
                        sqlite3_finalize(statement)
                        throw MemorySQLiteError.sqlite(result)
                }
                return statement
        }

        static func text(_ statement: OpaquePointer, column: Int32) throws -> String {
                guard sqlite3_column_type(statement, column) == SQLITE_TEXT, let pointer = sqlite3_column_text(statement, column) else { throw MemorySQLiteError.invalidFormat }
                let bytes = UnsafeBufferPointer(start: pointer, count: Int(sqlite3_column_bytes(statement, column)))
                guard let value = String(bytes: bytes, encoding: .utf8) else { throw MemorySQLiteError.invalidFormat }
                return value
        }

        static func bind(_ value: String, to statement: OpaquePointer, at index: Int32) throws {
                try value.utf8CString.withUnsafeBufferPointer { bytes in
                        guard bytes.count - 1 <= Int(Int32.max) else { throw MemorySQLiteError.invalidFormat }
                        try check(sqlite3_bind_text(statement, index, bytes.baseAddress, Int32(bytes.count - 1), transient))
                }
        }

        func integer(_ sql: String) throws -> Int64 {
                let statement = try prepare(sql)
                defer { sqlite3_finalize(statement) }
                try Self.check(sqlite3_step(statement), expected: SQLITE_ROW)
                guard sqlite3_column_type(statement, 0) == SQLITE_INTEGER else { throw MemorySQLiteError.invalidFormat }
                let value = sqlite3_column_int64(statement, 0)
                try Self.check(sqlite3_step(statement), expected: SQLITE_DONE)
                return value
        }

        func string(_ sql: String) throws -> String {
                let statement = try prepare(sql)
                defer { sqlite3_finalize(statement) }
                try Self.check(sqlite3_step(statement), expected: SQLITE_ROW)
                let value = try Self.text(statement, column: 0)
                try Self.check(sqlite3_step(statement), expected: SQLITE_DONE)
                return value
        }
}
