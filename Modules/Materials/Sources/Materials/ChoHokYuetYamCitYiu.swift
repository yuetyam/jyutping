import Foundation
import SQLite3

extension DataMaster {

        // CREATE TABLE chohoktable(code INTEGER NOT NULL, word TEXT NOT NULL, upper TEXT NOT NULL, lower TEXT NOT NULL, initial TEXT NOT NULL, final TEXT NOT NULL, yamyeung TEXT NOT NULL, tone TEXT NOT NULL);
        static func matchChoHokYuetYamCitYiu(for character: Character) -> [ChoHokYuetYamCitYiu] {
                let code: UInt32 = character.unicodeScalars.first?.value ?? 0xFFFFFF
                var entries: [ChoHokYuetYamCitYiu] = []
                let queryString = "SELECT * FROM chohoktable WHERE code = \(code);"
                var queryStatement: OpaquePointer? = nil
                defer {
                        sqlite3_finalize(queryStatement)
                }
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                // // let code: Int = Int(sqlite3_column_int64(queryStatement, 0))
                                let word: String = String(cString: sqlite3_column_text(queryStatement, 1))
                                let upper: String = String(cString: sqlite3_column_text(queryStatement, 2))
                                let lower: String = String(cString: sqlite3_column_text(queryStatement, 3))
                                let initial: String = String(cString: sqlite3_column_text(queryStatement, 4))
                                let final: String = String(cString: sqlite3_column_text(queryStatement, 5))
                                let yamyeung: String = String(cString: sqlite3_column_text(queryStatement, 6))
                                let tone: String = String(cString: sqlite3_column_text(queryStatement, 7))
                                let instance: ChoHokYuetYamCitYiu = ChoHokYuetYamCitYiu(word: word, upper: upper, lower: lower, initial: initial, final: final, yamyeung: yamyeung, tone: tone)
                                entries.append(instance)
                        }
                }
                return entries
        }
}

public struct ChoHokYuetYamCitYiu: Hashable {

        fileprivate init(word: String, upper: String, lower: String, initial: String, final: String, yamyeung: String, tone: String) {
                let convertedInitial: String = initial.replacingOccurrences(of: "X", with: "")
                let syllable: String = {
                        let processedInitial: String = Self.initialMap[convertedInitial] ?? convertedInitial
                        let processedFinal: String = Self.finalMap[final] ?? final
                        let fullTone: String = yamyeung + tone
                        let processedTone: String = Self.toneMap[fullTone] ?? "0"
                        let syllable: String = processedInitial + processedFinal + processedTone
                        return syllable
                }()
                self.word = word
                self.upper = upper
                self.lower = lower
                self.initial = convertedInitial
                self.final = final
                self.yamyeung = yamyeung
                self.tone = tone
                self.abstract = "\(convertedInitial)\(final)　\(yamyeung)\(tone)　\(upper)\(lower)切"
                self.romanization = syllable
                self.ipa = OldCantonese.IPA(for: syllable)
                self.jyutping = OldCantonese.jyutping(for: syllable)
        }

        public let word: String
        public let upper: String
        public let lower: String
        public let initial: String
        public let final: String
        public let yamyeung: String
        public let tone: String

        public let abstract: String
        public let romanization: String
        public let ipa: String
        public let jyutping: String

        public static func match(for character: Character) -> [ChoHokYuetYamCitYiu] {
                return DataMaster.matchChoHokYuetYamCitYiu(for: character)
        }

        private static let initialMap: [String: String] = [
                "p'": "p",
                "p": "b",
                "ts'": "c",
                "ts": "z",
                "s'": "sh",
                "t'": "t",
                "t": "d",
                "ch'": "ch",
                "ch": "zh",
                "j": "nj",
                "k'": "k",
                "k": "g",
                "y": "j"
        ]
        private static let finalMap: [String: String] = [
                "een": "in",
                "eet": "it",
                "an": "aan",
                "at": "aat",
                "wan": "waan",
                "wat": "waat",
                "a'n": "an",
                "a't": "at",
                "wa'n": "wan",
                "wa't": "wat",
                "un": "eon",
                "ut": "eot",
                "oon": "un",
                "oot": "ut",
                "ün": "yun",
                "üt": "yut",
                "on": "on",
                "ot": "ot",
                "eem": "im",
                "eep": "ip",
                "am": "aam",
                "ap": "aap",
                "um": "am",
                "up": "ap",
                "om": "om",
                "op": "op",
                "a'ng": "ang",
                "a'k": "ak",
                "ang": "aang",
                "ak": "aak",
                "wang": "waang",
                "wak": "waak",
                "ing": "ing",
                "ik": "ik",
                "ëing": "eng",
                "ëik": "ek",
                "wing": "wing",
                "wik": "wik",
                "ung": "ung",
                "uk": "uk",
                "ong": "ong",
                "ok": "ok",
                "wong": "wong",
                "wok": "wok",
                "eong": "oeng",
                "eok": "oek",
                "ng": "ng",
                "a[r]": "aa",
                "wa": "waa",
                "ea": "aai",
                "wae": "waai",
                "y": "ai",
                "wy": "wai",
                "ěa": "e",
                "ěy": "ei",
                "e": "i",
                "ze": "z",
                "ü": "yu",
                "üy": "yu",
                "oey": "eoi",
                "oy": "oi",
                "ooey": "ui",
                "oo": "u",
                "ou": "ou",
                "o[r]": "o",
                "wo": "wo",
                "aou": "aau",
                "ow": "au",
                "ew": "iu"
        ]
        private static let toneMap: [String: String] = [
                "陰平": "1",
                "陰上": "2",
                "陰去": "3",
                "陽平": "4",
                "陽上": "5",
                "陽去": "6",
                "陰入": "1",
                "陽入": "6"
        ]
}
