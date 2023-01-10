import Foundation
import SQLite3

struct DataMaster {
        static let database: OpaquePointer? = {
                guard let path: String = Bundle.module.path(forResource: "materials", ofType: "sqlite3") else { return nil }
                var db: OpaquePointer?
                if sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil) == SQLITE_OK {
                        return db
                } else {
                        return nil
                }
        }()
}
