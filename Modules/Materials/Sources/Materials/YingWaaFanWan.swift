import Foundation
import SQLite3

public struct YingWaaFanWan: Hashable {

        public let word: String
        public let romanization: String
        public let pronunciation: String
        public let pronunciationMark: String?
        public let interpretation: String?
        public let ipa: String
        public let jyutping: String

        fileprivate init(word: String, romanization: String, pronunciation: String, pronunciationMark: String, interpretation: String) {
                self.word = word
                self.romanization = romanization
                self.pronunciation = pronunciation
                self.pronunciationMark = YingWaaFanWan.handlePronunciationMark(of: pronunciationMark)
                self.interpretation = (interpretation == "X") ? nil : interpretation
                self.ipa = OldCantonese.IPA(for: romanization)
                self.jyutping = OldCantonese.jyutping(for: romanization)
        }

        public static func match(for character: Character) -> [YingWaaFanWan] {
                let originalMatch = fetch(for: character)
                guard originalMatch.isEmpty else { return originalMatch }
                let traditionalText: String = String(character).convertedS2T()
                let traditionalCharacter: Character = traditionalText.first ?? character
                return fetch(for: traditionalCharacter)
        }
        private static func fetch(for character: Character) -> [YingWaaFanWan] {
                let items: [YingWaaFanWan] = DataMaster.matchYingWaaFanWan(for: character)
                guard items.count > 1 else { return items }
                let romanizations = items.map({ $0.romanization }).uniqued()
                let hasDuplicates: Bool = romanizations.count != items.count
                guard hasDuplicates else { return items }
                let entries: [YingWaaFanWan?] = romanizations.map { syllable -> YingWaaFanWan? in
                        let filtered = items.filter({ $0.romanization == syllable })
                        switch filtered.count {
                        case 0:
                                return nil
                        case 1:
                                return filtered.first!
                        default:
                                let example = filtered.first!
                                let pronunciationMark: String = filtered.map({ $0.pronunciationMark }).compactMap({ $0 }).uniqued().joined(separator: ", ")
                                let interpretation: String = filtered.map({ $0.interpretation }).compactMap({ $0 }).uniqued().joined(separator: " ")
                                return YingWaaFanWan(word: example.word, romanization: syllable, pronunciation: example.pronunciation, pronunciationMark: pronunciationMark, interpretation: interpretation)
                        }
                }
                return entries.compactMap({ $0 })
        }
}

private extension DataMaster {

        // CREATE TABLE yingwaatable(code INTEGER NOT NULL, word TEXT NOT NULL, romanization TEXT NOT NULL, pronunciation TEXT NOT NULL, pronunciationmark TEXT NOT NULL, interpretation TEXT NOT NULL);
        static func matchYingWaaFanWan(for character: Character) -> [YingWaaFanWan] {
                var entries: [YingWaaFanWan] = []
                guard let code: UInt32 = character.unicodeScalars.first?.value else { return entries }
                let queryString = "SELECT * FROM yingwaatable WHERE code = \(code);"
                var queryStatement: OpaquePointer? = nil
                defer {
                        sqlite3_finalize(queryStatement)
                }
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                // let code: Int = Int(sqlite3_column_int64(queryStatement, 0))
                                let word: String = String(cString: sqlite3_column_text(queryStatement, 1))
                                let romanization: String = String(cString: sqlite3_column_text(queryStatement, 2))
                                let pronunciation: String = String(cString: sqlite3_column_text(queryStatement, 3))
                                let pronunciationMark: String = String(cString: sqlite3_column_text(queryStatement, 4))
                                let interpretation: String = String(cString: sqlite3_column_text(queryStatement, 5))
                                let instance: YingWaaFanWan = YingWaaFanWan(word: word, romanization: romanization, pronunciation: pronunciation, pronunciationMark: pronunciationMark, interpretation: interpretation)
                                entries.append(instance)
                        }
                }
                return entries
        }
}

private extension YingWaaFanWan {
        static func handlePronunciationMark(of mark: String) -> String? {
                switch mark {
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
                        return mark
                }
        }
}
