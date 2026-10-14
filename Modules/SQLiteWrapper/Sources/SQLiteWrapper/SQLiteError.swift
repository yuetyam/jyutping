/// Errors deliberately omit SQLite messages, which can contain user data such as learned words.
public enum SQLiteError: Error, Equatable, Sendable {

        /// An unexpected SQLite result code.
        case sqlite(Int32)

        /// A value has an unexpected storage type, an unexpected row count, or invalid UTF-8 text.
        case invalidFormat

        /// A bounded operation did not finish before its deadline.
        case timedOut
}
