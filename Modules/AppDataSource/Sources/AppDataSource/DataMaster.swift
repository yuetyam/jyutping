import Foundation
import SQLite3

struct DataMaster {
        nonisolated(unsafe) static let database: OpaquePointer? = {
                guard let path: String = Bundle.module.path(forResource: "appdb", ofType: "sqlite3") else { return nil }
                var db: OpaquePointer?
                guard sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil) == SQLITE_OK else { return nil }
                return db
        }()

        /// SQLITE_TRANSIENT replacement
        static let transientDestructorType = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
}
