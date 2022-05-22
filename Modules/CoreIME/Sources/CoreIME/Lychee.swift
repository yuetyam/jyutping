import Foundation
import SQLite3

/// Core IME Engine
public struct Lychee {

        /// SQLite3 database
        private(set) static var database: OpaquePointer? = {
                guard let path: String = Bundle.module.path(forResource: "lexicon", ofType: "sqlite3") else { return nil }
                var db: OpaquePointer?
                if sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil) == SQLITE_OK {
                        return db
                } else {
                        return nil
                }
        }()

        /// Connect SQLite3 database
        public static func connect() {
                guard let path: String = Bundle.module.path(forResource: "lexicon", ofType: "sqlite3") else { return }
                var db: OpaquePointer?
                if sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil) == SQLITE_OK {
                        database = db
                }
        }

        /// Close SQLite3 database
        public static func close() {
                sqlite3_close_v2(database)
        }
}
