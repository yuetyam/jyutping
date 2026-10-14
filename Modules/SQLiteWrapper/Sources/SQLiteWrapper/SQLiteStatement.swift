import Foundation
import SQLite3

/// A compiled SQL statement. The statement finalizes when the instance is deallocated.
///
/// Parameter indexes start at 1 and column indexes start at 0, as in the SQLite C API.
public final class SQLiteStatement {

        /// The underlying `sqlite3_stmt` handle, for APIs this wrapper does not cover.
        public let handle: OpaquePointer

        init(handle: OpaquePointer) {
                self.handle = handle
        }

        deinit {
                sqlite3_finalize(handle)
        }

        /// Rewind the statement so it can be stepped again. Bindings are kept.
        ///
        /// The result of `sqlite3_reset` repeats the failure of the previous step, which `step()` already reported.
        @discardableResult
        public func reset() -> SQLiteStatement {
                sqlite3_reset(handle)
                return self
        }

        /// Set all parameters to NULL.
        @discardableResult
        public func clearBindings() -> SQLiteStatement {
                sqlite3_clear_bindings(handle)
                return self
        }

        /// Evaluate the next step.
        /// - Returns: true if a row is available, false if the statement has finished.
        public func step() throws -> Bool {
                let result = sqlite3_step(handle)
                switch result {
                case SQLITE_ROW: return true
                case SQLITE_DONE: return false
                default: throw SQLiteError.sqlite(result)
                }
        }

        /// Step a statement that must finish without returning rows.
        public func run() throws {
                try SQLiteDatabase.check(sqlite3_step(handle), expected: SQLITE_DONE)
        }

        /// Reset, bind parameters from index 1, then run.
        public func run(_ bindings: (any SQLiteBindable)?...) throws {
                try reset().bind(bindings).run()
        }
}

// MARK: - Bindings

extension SQLiteStatement {

        public func bind(_ value: Int64, at index: Int32) throws {
                try SQLiteDatabase.check(sqlite3_bind_int64(handle, index, value))
        }

        public func bind(_ value: Int, at index: Int32) throws {
                try SQLiteDatabase.check(sqlite3_bind_int64(handle, index, Int64(value)))
        }

        public func bind(_ value: Double, at index: Int32) throws {
                try SQLiteDatabase.check(sqlite3_bind_double(handle, index, value))
        }

        /// Bind the complete UTF-8 bytes, including embedded NUL characters.
        public func bind(_ value: String, at index: Int32) throws {
                var value = value
                try value.withUTF8 { bytes in
                        guard bytes.count <= Int(Int32.max) else { throw SQLiteError.sqlite(SQLITE_TOOBIG) }
                        // A NULL pointer would bind NULL, so an empty string needs a valid pointer.
                        guard let pointer = bytes.baseAddress else {
                                try SQLiteDatabase.check(sqlite3_bind_text(handle, index, "", 0, SQLiteDatabase.transient))
                                return
                        }
                        try pointer.withMemoryRebound(to: CChar.self, capacity: bytes.count) { text in
                                try SQLiteDatabase.check(sqlite3_bind_text(handle, index, text, Int32(bytes.count), SQLiteDatabase.transient))
                        }
                }
        }

        public func bind(_ value: Data, at index: Int32) throws {
                guard value.count <= Int(Int32.max) else { throw SQLiteError.sqlite(SQLITE_TOOBIG) }
                guard !value.isEmpty else {
                        try SQLiteDatabase.check(sqlite3_bind_zeroblob(handle, index, 0))
                        return
                }
                try value.withUnsafeBytes { bytes in
                        try SQLiteDatabase.check(sqlite3_bind_blob(handle, index, bytes.baseAddress, Int32(bytes.count), SQLiteDatabase.transient))
                }
        }

        public func bindNull(at index: Int32) throws {
                try SQLiteDatabase.check(sqlite3_bind_null(handle, index))
        }

        /// Bind a value, or NULL if the value is nil.
        public func bind(_ value: (any SQLiteBindable)?, at index: Int32) throws {
                if let value {
                        try value.bind(to: self, at: index)
                } else {
                        try bindNull(at: index)
                }
        }

        /// Bind values to consecutive parameters from index 1.
        @discardableResult
        public func bind(_ values: [(any SQLiteBindable)?]) throws -> SQLiteStatement {
                for (offset, value) in values.enumerated() {
                        try bind(value, at: Int32(offset + 1))
                }
                return self
        }

        /// Bind values to consecutive parameters from index 1.
        @discardableResult
        public func bind(_ values: (any SQLiteBindable)?...) throws -> SQLiteStatement {
                try bind(values)
        }

        /// The number of SQL parameters.
        public var parameterCount: Int32 {
                sqlite3_bind_parameter_count(handle)
        }
}

// MARK: - Rows

extension SQLiteStatement {

        /// Step until the statement finishes, collecting the non-nil transformed rows.
        public func rows<T>(_ transform: (SQLiteStatement) throws -> T?) throws -> [T] {
                var items: [T] = []
                while try step() {
                        if let item = try transform(self) { items.append(item) }
                }
                return items
        }

        /// Visit each remaining row until the statement finishes.
        public func forEachRow(_ body: (SQLiteStatement) throws -> Void) throws {
                while try step() { try body(self) }
        }

        /// Transform the next row, or return nil if the statement has finished.
        public func first<T>(_ transform: (SQLiteStatement) throws -> T?) throws -> T? {
                guard try step() else { return nil }
                return try transform(self)
        }

        /// Transform the only row. Throws `SQLiteError.invalidFormat` unless there is exactly one row.
        public func single<T>(_ transform: (SQLiteStatement) throws -> T) throws -> T {
                guard try step() else { throw SQLiteError.invalidFormat }
                let value = try transform(self)
                guard try !step() else { throw SQLiteError.invalidFormat }
                return value
        }

        /// Reset, bind parameters from index 1, then collect the non-nil transformed rows.
        public func query<T>(_ bindings: (any SQLiteBindable)?..., transform: (SQLiteStatement) throws -> T?) throws -> [T] {
                try reset().bind(bindings).rows(transform)
        }

        /// Reset, bind parameters from index 1, then transform the first row, if any.
        public func queryFirst<T>(_ bindings: (any SQLiteBindable)?..., transform: (SQLiteStatement) throws -> T?) throws -> T? {
                try reset().bind(bindings).first(transform)
        }
}

// MARK: - Columns

extension SQLiteStatement {

        public enum ColumnType: Sendable {
                case integer
                case float
                case text
                case blob
                case null
        }

        /// The number of columns in a result row.
        public var columnCount: Int32 {
                sqlite3_column_count(handle)
        }

        /// The name of a result column.
        public func columnName(at index: Int32) -> String? {
                sqlite3_column_name(handle, index).map({ String(cString: $0) })
        }

        /// The storage type of a column value in the current row, before any conversion.
        public func columnType(at index: Int32) -> ColumnType {
                switch sqlite3_column_type(handle, index) {
                case SQLITE_INTEGER: .integer
                case SQLITE_FLOAT: .float
                case SQLITE_TEXT: .text
                case SQLITE_BLOB: .blob
                default: .null
                }
        }

        public func isNull(at index: Int32) -> Bool {
                sqlite3_column_type(handle, index) == SQLITE_NULL
        }

        /// The column value converted to INTEGER by SQLite. NULL becomes 0.
        public func int64(at index: Int32) -> Int64 {
                sqlite3_column_int64(handle, index)
        }

        /// The column value converted to INTEGER by SQLite. NULL becomes 0.
        public func int(at index: Int32) -> Int {
                Int(truncatingIfNeeded: sqlite3_column_int64(handle, index))
        }

        /// The column value converted to REAL by SQLite. NULL becomes 0.
        public func double(at index: Int32) -> Double {
                sqlite3_column_double(handle, index)
        }

        /// The column value converted to TEXT by SQLite, or nil for NULL. Invalid UTF-8 is repaired.
        public func text(at index: Int32) -> String? {
                guard let pointer = sqlite3_column_text(handle, index) else { return nil }
                // sqlite3_column_bytes must follow sqlite3_column_text to measure the converted text.
                let bytes = UnsafeBufferPointer(start: pointer, count: Int(sqlite3_column_bytes(handle, index)))
                return String(decoding: bytes, as: UTF8.self)
        }

        /// The column value as BLOB bytes, or nil for NULL.
        public func data(at index: Int32) -> Data? {
                guard sqlite3_column_type(handle, index) != SQLITE_NULL else { return nil }
                guard let pointer = sqlite3_column_blob(handle, index) else { return Data() }
                return Data(bytes: pointer, count: Int(sqlite3_column_bytes(handle, index)))
        }

        /// The INTEGER value of a column. Throws `SQLiteError.invalidFormat` for any other storage type.
        public func requireInt64(at index: Int32) throws -> Int64 {
                guard sqlite3_column_type(handle, index) == SQLITE_INTEGER else { throw SQLiteError.invalidFormat }
                return sqlite3_column_int64(handle, index)
        }

        /// The TEXT value of a column, including embedded NUL characters.
        /// Throws `SQLiteError.invalidFormat` for any other storage type or invalid UTF-8.
        public func requireText(at index: Int32) throws -> String {
                guard sqlite3_column_type(handle, index) == SQLITE_TEXT, let pointer = sqlite3_column_text(handle, index) else { throw SQLiteError.invalidFormat }
                let bytes = UnsafeBufferPointer(start: pointer, count: Int(sqlite3_column_bytes(handle, index)))
                guard let value = String(bytes: bytes, encoding: .utf8) else { throw SQLiteError.invalidFormat }
                return value
        }
}
