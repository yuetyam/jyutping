import Foundation
import SQLite3
import CommonExtensions

private extension DataMaster {

        // CREATE TABLE fanwan_table(code INTEGER NOT NULL, word TEXT NOT NULL, romanization TEXT NOT NULL, initial TEXT NOT NULL, final TEXT NOT NULL, yamyeung TEXT NOT NULL, tone TEXT NOT NULL, rhyme TEXT NOT NULL, interpretation TEXT NOT NULL);
        static func matchFanWanCuetYiu(for character: Character) -> [FanWanCuetYiu] {
                var entries: [FanWanCuetYiu] = []
                guard let code: UInt32 = character.unicodeScalars.first?.value else { return entries }
                let query: String = "SELECT * FROM fanwan_table WHERE code = \(code);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK else { return entries }
                while sqlite3_step(statement) == SQLITE_ROW {
                        // let code: Int = Int(sqlite3_column_int64(queryStatement, 0))
                        let word: String = String(cString: sqlite3_column_text(statement, 1))
                        let romanization: String = String(cString: sqlite3_column_text(statement, 2))
                        let initial: String = String(cString: sqlite3_column_text(statement, 3))
                        let final: String = String(cString: sqlite3_column_text(statement, 4))
                        let yamyeung: String = String(cString: sqlite3_column_text(statement, 5))
                        let tone: String = String(cString: sqlite3_column_text(statement, 6))
                        let rhyme: String = String(cString: sqlite3_column_text(statement, 7))
                        let interpretation: String = String(cString: sqlite3_column_text(statement, 8))
                        let instance: FanWanCuetYiu = FanWanCuetYiu(word: word, romanization: romanization, initial: initial, final: final, yamyeung: yamyeung, tone: tone, rhyme: rhyme, interpretation: interpretation)
                        entries.append(instance)
                }
                return entries
        }

        /// Fetch homophone characters
        /// - Parameter romanization: Jyutping romanization syllable
        /// - Returns: Homophone characters
        static func fetchHomophones(for romanization: String) -> [String] {
                var homophones: [String] = []
                let query = "SELECT word FROM fanwan_table WHERE romanization = '\(romanization)' LIMIT 11;"
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

public struct FanWanCuetYiu: Hashable {

        fileprivate init(word: String, romanization: String, initial: String, final: String, yamyeung: String, tone: String, rhyme: String, interpretation: String) {
                let convertedRomanization: String = romanization
                        .replacingOccurrences(of: "7", with: "1", options: [.anchored, .backwards])
                        .replacingOccurrences(of: "8", with: "3", options: [.anchored, .backwards])
                        .replacingOccurrences(of: "9", with: "6", options: [.anchored, .backwards])
                let processedInterpretation: String = interpretation == "X" ? "(None)" : interpretation
                let abstract: String = "\(initial)母　\(final)韻　\(yamyeung)\(tone)　\(rhyme)小韻"
                self.word = word
                self.romanization = convertedRomanization
                self.initial = initial
                self.final = final
                self.yamyeung = yamyeung
                self.tone = tone
                self.rhyme = rhyme
                self.interpretation = processedInterpretation
                self.abstract = abstract
                self.homophones = DataMaster.fetchHomophones(for: romanization).filter({ $0 != word })
        }

        public let word: String
        public let romanization: String
        public let initial: String
        public let final: String
        public let yamyeung: String
        public let tone: String
        public let rhyme: String
        public let interpretation: String

        public let abstract: String
        public let homophones: [String]

        public static func ==(lhs: FanWanCuetYiu, rhs: FanWanCuetYiu) -> Bool {
                return lhs.word == rhs.word && lhs.romanization == rhs.romanization
        }
        public func hash(into hasher: inout Hasher) {
                hasher.combine(word)
                hasher.combine(romanization)
        }

        public static func match<T: StringProtocol>(text: T) -> [FanWanCuetYiu] {
                guard let character = text.first else { return [] }
                let match = DataMaster.matchFanWanCuetYiu(for: character).distinct()
                guard match.isEmpty else { return match }
                let traditionalCharacter: Character = text.convertedS2T().first ?? character
                return DataMaster.matchFanWanCuetYiu(for: traditionalCharacter).distinct()
        }
}
