import Foundation
import SQLite3

private extension DataMaster {

        // CREATE TABLE fanwantable(code INTEGER NOT NULL, word TEXT NOT NULL, romanization TEXT NOT NULL, initial TEXT NOT NULL, final TEXT NOT NULL, yamyeung TEXT NOT NULL, tone TEXT NOT NULL, rhyme TEXT NOT NULL, interpretation TEXT NOT NULL);
        static func matchFanWanCuetYiu(for character: Character) -> [FanWanCuetYiu] {
                var entries: [FanWanCuetYiu] = []
                guard let code: UInt32 = character.unicodeScalars.first?.value else { return entries }
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

        fileprivate init(word: String, romanization: String, initial: String, final: String, yamyeung: String, tone: String, rhyme: String, interpretation: String) {
                let romanization: String = romanization
                        .replacingOccurrences(of: "7", with: "1", options: [.anchored, .backwards])
                        .replacingOccurrences(of: "aa(p|t|k)8$", with: "aa$13", options: .regularExpression)
                        .replacingOccurrences(of: "8", with: "1", options: [.anchored, .backwards])
                        .replacingOccurrences(of: "9", with: "6", options: [.anchored, .backwards])
                let interpretation: String = interpretation
                        .replacingOccurrences(of: "[同上](", with: "", options: .anchored)
                        .replacingOccurrences(of: ")", with: "", options: [.anchored, .backwards])
                self.word = word
                self.romanization = romanization
                self.initial = initial
                self.final = final
                self.yamyeung = yamyeung
                self.tone = tone
                self.rhyme = rhyme
                self.interpretation = interpretation
                self.abstract = "\(initial)母　\(final)韻　\(yamyeung)\(tone)　\(rhyme)小韻"
                self.ipa = OldCantonese.IPA(for: romanization)
                self.jyutping = OldCantonese.jyutping(for: romanization)
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
        public let ipa: String
        public let jyutping: String

        public static func match(for character: Character) -> [FanWanCuetYiu] {
                let originalMatch = fetch(for: character)
                guard originalMatch.isEmpty else { return originalMatch }
                let traditionalText: String = String(character).convertedS2T()
                let traditionalCharacter: Character = traditionalText.first ?? character
                return fetch(for: traditionalCharacter)
        }
        private static func fetch(for character: Character) -> [FanWanCuetYiu] {
                return DataMaster.matchFanWanCuetYiu(for: character).uniqued()
        }
}
