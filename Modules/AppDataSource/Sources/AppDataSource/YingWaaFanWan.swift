import Foundation
import SQLite3
import CommonExtensions

public struct YingWaaFanWan: Hashable {

        public let word: String
        public let romanization: String
        public let pronunciation: String
        public let pronunciationMark: String?
        public let interpretation: String?
        public let homophones: [String]

        fileprivate init(word: String, romanization: String, pronunciation: String, pronunciationMark: String, interpretation: String, homophones: [String]) {
                self.word = word
                self.romanization = romanization
                self.pronunciation = pronunciation
                self.pronunciationMark = YingWaaFanWan.handlePronunciationMark(of: pronunciationMark)
                self.interpretation = (interpretation == "X") ? nil : interpretation
                self.homophones = homophones
        }

        public static func ==(lhs: YingWaaFanWan, rhs: YingWaaFanWan) -> Bool {
                return lhs.word == rhs.word && lhs.romanization == rhs.romanization
        }
        public func hash(into hasher: inout Hasher) {
                hasher.combine(word)
                hasher.combine(romanization)
        }

        public static func match<T: StringProtocol>(text: T) -> [YingWaaFanWan] {
                guard let character = text.first else { return [] }
                let fetched = fetch(for: character)
                guard fetched.isEmpty else { return fetched }
                let traditionalCharacter: Character = text.convertedS2T().first ?? character
                return fetch(for: traditionalCharacter)
        }
        private static func fetch(for character: Character) -> [YingWaaFanWan] {
                let items: [YingWaaFanWan] = DataMaster.matchYingWaaFanWan(for: character)
                guard items.isNotEmpty else { return items }
                let romanizations = items.map(\.romanization).distinct()
                let hasDuplicates: Bool = romanizations.count != items.count
                guard hasDuplicates else { return items }
                let entries = romanizations.compactMap { syllable -> YingWaaFanWan? in
                        let filtered = items.filter({ $0.romanization == syllable })
                        switch filtered.count {
                        case 0:
                                return nil
                        case 1:
                                return filtered.first!
                        default:
                                let example = filtered.first!
                                let pronunciationMark: String = filtered.compactMap(\.pronunciationMark).distinct().joined(separator: ", ")
                                let interpretation: String = filtered.compactMap(\.interpretation).distinct().joined(separator: " ")
                                return YingWaaFanWan(word: example.word, romanization: syllable, pronunciation: example.pronunciation, pronunciationMark: pronunciationMark, interpretation: interpretation, homophones: example.homophones)
                        }
                }
                return entries
        }
}

private extension DataMaster {

        // CREATE TABLE yingwaatable(code INTEGER NOT NULL, word TEXT NOT NULL, romanization TEXT NOT NULL, pronunciation TEXT NOT NULL, pronunciationmark TEXT NOT NULL, interpretation TEXT NOT NULL);
        static func matchYingWaaFanWan(for character: Character) -> [YingWaaFanWan] {
                var entries: [YingWaaFanWan] = []
                guard let code: UInt32 = character.unicodeScalars.first?.value else { return entries }
                let query: String = "SELECT * FROM yingwaatable WHERE code = \(code);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK else { return entries }
                while sqlite3_step(statement) == SQLITE_ROW {
                        // let code: Int = Int(sqlite3_column_int64(queryStatement, 0))
                        let word: String = String(cString: sqlite3_column_text(statement, 1))
                        let romanization: String = String(cString: sqlite3_column_text(statement, 2))
                        let pronunciation: String = String(cString: sqlite3_column_text(statement, 3))
                        let pronunciationMark: String = String(cString: sqlite3_column_text(statement, 4))
                        let interpretation: String = String(cString: sqlite3_column_text(statement, 5))
                        let homophones: [String] = fetchHomophones(for: romanization).filter({ $0 != word })
                        let instance: YingWaaFanWan = YingWaaFanWan(word: word, romanization: romanization, pronunciation: pronunciation, pronunciationMark: pronunciationMark, interpretation: interpretation, homophones: homophones)
                        entries.append(instance)
                }
                return entries
        }

        /// Fetch homophone characters
        /// - Parameter romanization: Jyutping romanization syllable
        /// - Returns: Homophone characters
        static func fetchHomophones(for romanization: String) -> [String] {
                var homophones: [String] = []
                let query = "SELECT word FROM yingwaatable WHERE romanization = '\(romanization)' LIMIT 11;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK else { return homophones }
                while sqlite3_step(statement) == SQLITE_ROW {
                        let homophone: String = String(cString: sqlite3_column_text(statement, 0))
                        homophones.append(homophone)
                }
                return homophones
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
