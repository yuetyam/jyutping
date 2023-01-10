import Foundation
import SQLite3

extension DataMaster {

        // CREATE TABLE fanwantable(code INTEGER NOT NULL, word TEXT NOT NULL, romanization TEXT NOT NULL, initial TEXT NOT NULL, final TEXT NOT NULL, yamyeung TEXT NOT NULL, tone TEXT NOT NULL, rhyme TEXT NOT NULL, interpretation TEXT NOT NULL);
        static func matchFanWanCuetYiu(for character: Character) -> [FanWanCuetYiu] {
                let code: UInt32 = character.unicodeScalars.first?.value ?? 0xFFFFFF
                var entries: [FanWanCuetYiu] = []
                let queryString = "SELECT * FROM fanwantable WHERE code = \(code);"
                var queryStatement: OpaquePointer? = nil
                defer {
                        sqlite3_finalize(queryStatement)
                }
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                // // let code: Int = Int(sqlite3_column_int64(queryStatement, 0))
                                let word: String = String(cString: sqlite3_column_text(queryStatement, 1))
                                let romanization: String = String(cString: sqlite3_column_text(queryStatement, 2))
                                let initial: String = String(cString: sqlite3_column_text(queryStatement, 3))
                                let final: String = String(cString: sqlite3_column_text(queryStatement, 4))
                                let yamyeung: String = String(cString: sqlite3_column_text(queryStatement, 5))
                                let tone: String = String(cString: sqlite3_column_text(queryStatement, 6))
                                let rhyme: String = String(cString: sqlite3_column_text(queryStatement, 7))
                                let interpretation: String = String(cString: sqlite3_column_text(queryStatement, 8))
                                let instance: FanWanCuetYiu = FanWanCuetYiu(word: word, romanization: romanization, initial: initial, final: final, yamyeung: yamyeung, tone: tone, rhyme: rhyme, interpretation: interpretation)
                                entries.append(instance)
                        }
                }
                return entries
        }
}
public struct FanWanCuetYiu: Hashable {

        public let word: String

        /// Jyutping
        public let romanization: String

        public let initial: String
        public let final: String
        public let yamyeung: String
        public let tone: String
        public let rhyme: String
        public let interpretation: String

        public static func match(for character: Character) -> [FanWanCuetYiu] {
                return DataMaster.matchFanWanCuetYiu(for: character)
        }
}
