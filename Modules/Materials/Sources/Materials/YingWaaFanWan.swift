import Foundation
import SQLite3

public struct YingWaaFanWan: Hashable {

        public let word: String
        public let jyutping: String
        public let romanization: String
        public let romanizationMark: String
        public let romanizationType: String?
        public let romanizationNote: String?
        public let interpretation: String?
        public let note: String?

        fileprivate init(word: String, jyutping: String, romanizationMark: String, romanizationType: String, romanizationNote: String, interpretation: String, note: String) {
                self.word = word
                self.jyutping = jyutping
                // TODO: romanization from romanizationMark
                self.romanization = romanizationMark
                self.romanizationMark = romanizationMark
                self.romanizationType = YingWaaFanWan.handleRomanizationType(of: romanizationType)
                self.romanizationNote = romanizationNote.isNone ? nil : romanizationNote
                self.interpretation = interpretation.isNone ? nil : interpretation
                self.note = note.isNone ? nil : note
        }

        public static func match(for character: Character) -> [YingWaaFanWan] {
                return DataMaster.matchYingWaaFanWan(for: character)
        }
}

private extension DataMaster {

        // CREATE TABLE yingwaatable(code INTEGER NOT NULL, word TEXT NOT NULL, jyutping TEXT NOT NULL, romanizationmark TEXT NOT NULL, romanizationtype TEXT NOT NULL, romanizationnote TEXT NOT NULL, interpretation TEXT NOT NULL, note TEXT NOT NULL);
        static func matchYingWaaFanWan(for character: Character) -> [YingWaaFanWan] {
                var entries: [YingWaaFanWan] = []
                let code: UInt32 = character.unicodeScalars.first?.value ?? 0xFFFFFF
                let queryString = "SELECT * FROM yingwaatable WHERE code = \(code);"
                var queryStatement: OpaquePointer? = nil
                defer {
                        sqlite3_finalize(queryStatement)
                }
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                // let code: Int = Int(sqlite3_column_int64(queryStatement, 0))
                                let word: String = String(cString: sqlite3_column_text(queryStatement, 1))
                                let jyutping: String = String(cString: sqlite3_column_text(queryStatement, 2))
                                let romanizationMark: String = String(cString: sqlite3_column_text(queryStatement, 3))
                                let romanizationType: String = String(cString: sqlite3_column_text(queryStatement, 4))
                                let romanizationNote: String = String(cString: sqlite3_column_text(queryStatement, 5))
                                let interpretation: String = String(cString: sqlite3_column_text(queryStatement, 6))
                                let note: String = String(cString: sqlite3_column_text(queryStatement, 7))
                                let instance: YingWaaFanWan = YingWaaFanWan(word: word, jyutping: jyutping, romanizationMark: romanizationMark, romanizationType: romanizationType, romanizationNote: romanizationNote, interpretation: interpretation, note: note)
                                entries.append(instance)
                        }
                }
                return entries
        }
}

private extension YingWaaFanWan {
        static func handleRomanizationType(of type: String) -> String? {
                switch type {
                case "X":
                        return nil
                case "ALMOST_ALWAYS_PRO":
                        return "Almost Always Pronounced"
                case "ALSO_PRO":
                        return "Also Pronounced"
                case "CORRECTLY_READ":
                        return "Correctly Pronounced"
                case "FAN_WAN_PRO":
                        return "Read in Fan Wan"
                case "FAN_WAN_ERRONEOUSLY_READ":
                        return "Erroneously read in Fan Wan"
                case "FREQ_PRO":
                        return "Frequently Pronounced"
                case "MORE_FREQ_HEARD":
                        return "More frequency heard than original"
                case "OFTEN_PRO":
                        return "Often Pronounced"
                case "OFTEN_READ_CANTON":
                        return "Often read in Canton"
                case "PROPER_SOUND":
                        return "Proper Sound"
                case "SELDOM_HEARD":
                        return "Seldom Heard"
                case "SOMETIMES_READ":
                        return "Sometimes Read"
                case "USUALLY_PRO":
                        return "Usually Pronounced"
                case "VULGAR":
                        return "Vulgar"
                default:
                        return type
                }
        }
}
