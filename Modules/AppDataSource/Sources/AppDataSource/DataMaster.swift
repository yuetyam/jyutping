import Foundation
import SQLite3

struct DataMaster {
        nonisolated(unsafe) static let database: OpaquePointer? = {
                guard let path: String = Bundle.module.path(forResource: "appdb", ofType: "sqlite3") else { return nil }
                var db: OpaquePointer?
                if sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil) == SQLITE_OK {
                        return db
                } else {
                        sqlite3_close_v2(db)
                        return nil
                }
        }()

        /// The missing SQLITE_TRANSIENT
        static let DEFINED_SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
}
