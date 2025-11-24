import Foundation
import SQLite3
import CommonExtensions

private extension DataMaster {

        // CREATE TABLE chohok_table(code INTEGER NOT NULL, word TEXT NOT NULL, romanization TEXT NOT NULL, initial TEXT NOT NULL, final TEXT NOT NULL, tone TEXT NOT NULL, faancit TEXT NOT NULL);
        static func matchChoHokYuetYamCitYiu(for character: Character) -> [ChoHokYuetYamCitYiu] {
                var entries: [ChoHokYuetYamCitYiu] = []
                guard let code: UInt32 = character.unicodeScalars.first?.value else { return entries }
                let query: String = "SELECT * FROM chohok_table WHERE code = \(code);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK else { return entries }
                while sqlite3_step(statement) == SQLITE_ROW {
                        // let code: Int = Int(sqlite3_column_int64(queryStatement, 0))
                        let word: String = String(cString: sqlite3_column_text(statement, 1))
                        let romanization: String = String(cString: sqlite3_column_text(statement, 2))
                        let initial: String = String(cString: sqlite3_column_text(statement, 3))
                        let final: String = String(cString: sqlite3_column_text(statement, 4))
                        let tone: String = String(cString: sqlite3_column_text(statement, 5))
                        let faancit: String = String(cString: sqlite3_column_text(statement, 6))
                        let homophones: [String] = fetchHomophones(for: romanization).filter({ $0 != word })
                        let instance: ChoHokYuetYamCitYiu = ChoHokYuetYamCitYiu(word: word, romanization: romanization, initial: initial, final: final, tone: tone, faancit: faancit, homophones: homophones)
                        entries.append(instance)
                }
                return entries
        }

        /// Fetch homophone characters
        /// - Parameter romanization: Jyutping romanization syllable
        /// - Returns: Homophone characters
        static func fetchHomophones(for romanization: String) -> [String] {
                var homophones: [String] = []
                let query = "SELECT word FROM chohok_table WHERE romanization = '\(romanization)' LIMIT 11;"
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

public struct ChoHokYuetYamCitYiu: Hashable {

        fileprivate init(word: String, romanization: String, initial: String, final: String, tone: String, faancit: String, homophones: [String]) {
                let convertedInitial: String = initial == "X" ? "" : initial
                let convertedFinal: String = final == "X" ? "" : final
                let pronunciation: String = convertedInitial + convertedFinal
                let faancitText: String = faancit + "切"
                self.word = word
                self.pronunciation = pronunciation
                self.tone = tone
                self.faancit = faancitText
                self.romanization = romanization
                self.homophones = homophones
        }

        public let word: String
        public let pronunciation: String
        public let tone: String
        public let faancit: String
        public let romanization: String
        public let homophones: [String]

        public static func ==(lhs: ChoHokYuetYamCitYiu, rhs: ChoHokYuetYamCitYiu) -> Bool {
                return lhs.word == rhs.word && lhs.romanization == rhs.romanization
        }
        public func hash(into hasher: inout Hasher) {
                hasher.combine(word)
                hasher.combine(romanization)
        }

        public static func match<T: StringProtocol>(text: T) -> [ChoHokYuetYamCitYiu] {
                guard let character = text.first else { return [] }
                let matched = DataMaster.matchChoHokYuetYamCitYiu(for: character).distinct()
                guard matched.isEmpty else { return matched }
                let traditionalCharacter: Character = text.convertedS2T().first ?? character
                return DataMaster.matchChoHokYuetYamCitYiu(for: traditionalCharacter).distinct()
        }
}
