import Foundation

/// A value that can be bound to an SQL parameter.
public protocol SQLiteBindable {
        func bind(to statement: SQLiteStatement, at index: Int32) throws
}

extension Int64: SQLiteBindable {
        public func bind(to statement: SQLiteStatement, at index: Int32) throws {
                try statement.bind(self, at: index)
        }
}

extension Int: SQLiteBindable {
        public func bind(to statement: SQLiteStatement, at index: Int32) throws {
                try statement.bind(self, at: index)
        }
}

extension Int32: SQLiteBindable {
        public func bind(to statement: SQLiteStatement, at index: Int32) throws {
                try statement.bind(Int64(self), at: index)
        }
}

extension UInt32: SQLiteBindable {
        public func bind(to statement: SQLiteStatement, at index: Int32) throws {
                try statement.bind(Int64(self), at: index)
        }
}

/// Bound as INTEGER 1 or 0.
extension Bool: SQLiteBindable {
        public func bind(to statement: SQLiteStatement, at index: Int32) throws {
                try statement.bind(Int64(self ? 1 : 0), at: index)
        }
}

extension Double: SQLiteBindable {
        public func bind(to statement: SQLiteStatement, at index: Int32) throws {
                try statement.bind(self, at: index)
        }
}

extension String: SQLiteBindable {
        public func bind(to statement: SQLiteStatement, at index: Int32) throws {
                try statement.bind(self, at: index)
        }
}

extension Substring: SQLiteBindable {
        public func bind(to statement: SQLiteStatement, at index: Int32) throws {
                try statement.bind(String(self), at: index)
        }
}

extension Data: SQLiteBindable {
        public func bind(to statement: SQLiteStatement, at index: Int32) throws {
                try statement.bind(self, at: index)
        }
}
