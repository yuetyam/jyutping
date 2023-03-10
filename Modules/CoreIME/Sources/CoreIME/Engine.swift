import Foundation
import SQLite3

public struct Engine {

        private static var storageDatabase: OpaquePointer? = nil
        private(set) static var database: OpaquePointer? = nil

        public static func prepare() {
                guard !isWorking else { return }
                sqlite3_close_v2(storageDatabase)
                sqlite3_close_v2(database)
                guard let path: String = Bundle.module.path(forResource: "imedb", ofType: "sqlite3") else { return }
                #if os(iOS)
                guard sqlite3_open_v2(path, &database, SQLITE_OPEN_READONLY, nil) == SQLITE_OK else { return }
                #else
                guard sqlite3_open_v2(path, &storageDatabase, SQLITE_OPEN_READONLY, nil) == SQLITE_OK else { return }
                guard sqlite3_open_v2(":memory:", &database, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, nil) == SQLITE_OK else { return }
                let backup = sqlite3_backup_init(database, "main", storageDatabase, "main")
                guard sqlite3_backup_step(backup, -1) == SQLITE_DONE else { return }
                guard sqlite3_backup_finish(backup) == SQLITE_OK else { return }
                sqlite3_close_v2(storageDatabase)
                #endif
        }

        private static var isWorking: Bool {
                guard database != nil else { return false }
                let text: String = "ngo"
                let code = text.hash
                let queryString = "SELECT word FROM lexicontable WHERE ping = \(code) LIMIT 1;"
                var queryStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(queryStatement) }
                guard sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK else { return false }
                return sqlite3_step(queryStatement) == SQLITE_ROW
        }
}
