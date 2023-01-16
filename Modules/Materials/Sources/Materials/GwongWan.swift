import Foundation
import SQLite3

private extension DataMaster {
        static func matchGwongWan(for character: Character) -> [GwongWan] {
                var entries: [GwongWan] = []
                guard let code: UInt32 = character.unicodeScalars.first?.value else { return entries }
                let queryString = "SELECT * FROM gwongwantable WHERE code = \(code);"
                var queryStatement: OpaquePointer? = nil
                defer {
                        sqlite3_finalize(queryStatement)
                }
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                // // let code: Int = Int(sqlite3_column_int64(queryStatement, 0))
                                let word: String = String(cString: sqlite3_column_text(queryStatement, 1))
                                let faancit: String = String(cString: sqlite3_column_text(queryStatement, 2))
                                let hierarchy: String = String(cString: sqlite3_column_text(queryStatement, 3))
                                let interpretation: String = String(cString: sqlite3_column_text(queryStatement, 4))
                                let instance: GwongWan = GwongWan(word: word, faancit: faancit, hierarchy: hierarchy, interpretation: interpretation)
                                entries.append(instance)
                        }
                }
                return entries
        }
}

public struct GwongWan: Hashable {

        /// 字頭
        public let word: String

        /// 反切. 毋包含「切」字. 例: 德紅
        public let faancit: String

        /// 音韻位屬. 例: 端母　東韻　平聲　一等
        public let hierarchy: String

        /// 釋義. Definition. Description. Meaning.
        public let interpretation: String

        public static func match(for character: Character) -> [GwongWan] {
                return DataMaster.matchGwongWan(for: character).uniqued()
        }
}
