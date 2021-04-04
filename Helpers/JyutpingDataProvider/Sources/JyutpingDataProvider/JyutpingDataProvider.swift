import Foundation
import SQLite3

/// Provide Jyutping Data
public struct JyutpingDataProvider {

        /// SQLite3 database
        public let database: OpaquePointer?

        /// Database initializer
        public init() {
                database = {
                        guard let path: String = Bundle.module.path(forResource: "keyboard", ofType: "sqlite3") else { return nil }
                        var db: OpaquePointer?
                        if sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil) == SQLITE_OK {
                                return db
                        } else {
                                return nil
                        }
                }()
        }

        /// Close database
        public func close() {
                sqlite3_close_v2(database)
        }
}
