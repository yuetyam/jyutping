import Foundation
import SQLite3
import CommonExtensions

public struct YingWaaUnit: Hashable, Identifiable {
        public let word: String
        public let romanization: String
        public let pronunciation: String
        public let pronunciationMark: String?
        public let interpretation: String?
        public let homophones: [String]
        public static func ==(lhs: YingWaaUnit, rhs: YingWaaUnit) -> Bool {
                return (lhs.word == rhs.word) && (lhs.romanization == rhs.romanization)
        }
        public func hash(into hasher: inout Hasher) {
                hasher.combine(word)
                hasher.combine(romanization)
        }
        public var id: String {
                return word + romanization
        }
}
public struct YingWaaLexicon: Hashable, Identifiable {
        public let word: String
        public let units: [YingWaaUnit]
        public static func ==(lhs: YingWaaLexicon, rhs: YingWaaLexicon) -> Bool {
                return lhs.word == rhs.word
        }
        public func hash(into hasher: inout Hasher) {
                hasher.combine(word)
        }
        public let id: UUID = UUID()
}

// yingwaa_table(code INTEGER NOT NULL, word TEXT NOT NULL, romanization TEXT NOT NULL, pronunciation TEXT NOT NULL, pronunciationmark TEXT NOT NULL, interpretation TEXT NOT NULL);

private extension DataMaster {
        static func matchYingWaa(for character: Character) -> YingWaaLexicon? {
                guard let code: UInt32 = character.unicodeScalars.first?.value else { return nil }
                let command: String = "SELECT * FROM yingwaa_table WHERE code = \(code);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return nil }
                var entries: [YingWaaUnit] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        // let code: Int = Int(sqlite3_column_int64(queryStatement, 0))
                        let word: String = String(cString: sqlite3_column_text(statement, 1))
                        let romanization: String = String(cString: sqlite3_column_text(statement, 2))
                        let pronunciation: String = String(cString: sqlite3_column_text(statement, 3))
                        let pronunciationMark: String = String(cString: sqlite3_column_text(statement, 4))
                        let interpretation: String = String(cString: sqlite3_column_text(statement, 5))
                        let mark: String? = (pronunciationMark == "X") ? nil : pronunciationMark
                        let explanation: String? = (interpretation == "X") ? nil : interpretation
                        let instance = YingWaaUnit(word: word, romanization: romanization, pronunciation: pronunciation, pronunciationMark: mark, interpretation: explanation, homophones: [])
                        entries.append(instance)
                }
                guard let word = entries.first?.word else { return nil }
                return YingWaaLexicon(word: word, units: entries)
        }
        static func fetchYingWaaHomophones(for romanization: String) -> [String] {
                var homophones: [String] = []
                let command: String = "SELECT word FROM yingwaa_table WHERE romanization = '\(romanization)' LIMIT 11;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return homophones }
                while sqlite3_step(statement) == SQLITE_ROW {
                        let homophone: String = String(cString: sqlite3_column_text(statement, 0))
                        homophones.append(homophone)
                }
                return homophones
        }
}

public struct YingWaa {
        public static func search(_ character: Character) -> YingWaaLexicon? {
                if let fetched = fetch(for: character) {
                        return fetched
                } else {
                        guard let traditional = String(character).convertedS2T().first else { return nil }
                        guard traditional != character else { return nil }
                        return fetch(for: traditional)
                }
        }
        private static func fetch(for character: Character) -> YingWaaLexicon? {
                guard let matched = DataMaster.matchYingWaa(for: character) else { return nil }
                let romanizations = matched.units.map(\.romanization).distinct()
                let entries = romanizations.compactMap { romanization -> YingWaaUnit? in
                        let filtered = matched.units.filter({ $0.romanization == romanization })
                        guard let firstUnit = filtered.first else { return nil }
                        guard filtered.count > 1 else {
                                let mark = YingWaa.processPronunciationMark(firstUnit.pronunciationMark)
                                let homophones = DataMaster.fetchYingWaaHomophones(for: romanization).filter({ $0 != matched.word })
                                return YingWaaUnit(word: firstUnit.word, romanization: romanization, pronunciation: firstUnit.pronunciation, pronunciationMark: mark, interpretation: firstUnit.interpretation, homophones: homophones)
                        }
                        let mark: String = filtered.compactMap(\.pronunciationMark).distinct().compactMap(YingWaa.processPronunciationMark(_:)).joined(separator: ", ")
                        let interpretation: String = filtered.compactMap(\.interpretation).distinct().joined(separator: String.space)
                        let homophones = DataMaster.fetchYingWaaHomophones(for: romanization).filter({ $0 != matched.word })
                        return YingWaaUnit(word: firstUnit.word, romanization: romanization, pronunciation: firstUnit.pronunciation, pronunciationMark: mark, interpretation: interpretation, homophones: homophones)
                }
                return YingWaaLexicon(word: matched.word, units: entries)
        }

        private static func processPronunciationMark(_ mark: String?) -> String? {
                guard let mark else { return nil }
                return markMap[mark] ?? mark
        }
        private static let markMap: [String : String] = [
                "ALMOST_ALWAYS_PRO" : "Almost Always Pronounced",
                "ALSO_PRO" : "Also Pronounced",
                "CORRECTLY_READ" : "Correctly Pronounced",
                "FAN_WAN_PRO" : "Read in Fan Wan",
                "FAN_WAN_ERRONEOUSLY_READ" : "Erroneously Read in Fan Wan",
                "FREQ_PRO" : "Frequently Pronounced",
                "MORE_FREQ_HEARD" : "More Frequency Heard Than Original",
                "OFTEN_PRO" : "Often Pronounced",
                "OFTEN_READ_CANTON" : "Often Read in Canton",
                "PROPER_SOUND" : "Proper Sound",
                "SELDOM_HEARD" : "Seldom Heard",
                "SOMETIMES_READ" : "Sometimes Read",
                "USUALLY_PRO" : "Usually Pronounced",
                "VULGAR" : "Vulgar",
        ]
}
