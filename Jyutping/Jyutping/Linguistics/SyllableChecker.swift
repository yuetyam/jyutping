import Foundation

extension String {
        var isValidJyutping: Bool {
                return SyllableChecker.isValidJyutping(text: self)
        }
}

struct SyllableChecker {

        static func isValidJyutping(text: String) -> Bool {
                let syllable: String = text.filter({ !(tones.contains($0)) })
                let isNasal: Bool = (syllable == "m") || (syllable == "ng")
                guard !isNasal else { return true }
                let isPluralInitial: Bool = syllable.hasPrefix("ng") || syllable.hasPrefix("gw") || syllable.hasPrefix("kw")
                if isPluralInitial {
                        let final = syllable.dropFirst(2)
                        return finals.contains(String(final))
                } else {
                        let isZeroConsonant: Bool = finals.contains(syllable)
                        guard !isZeroConsonant else { return true }
                        guard let initial = syllable.first else { return false }
                        guard singularInitials.contains(initial) else { return false }
                        let final = syllable.dropFirst()
                        return finals.contains(String(final))
                }
        }

        private static let initials: Set<String> = [
                "b",
                "p",
                "m",
                "f",
                "d",
                "t",
                "n",
                "l",
                "g",
                "k",
                "ng",
                "h",
                "gw",
                "kw",
                "w",
                "z",
                "c",
                "s",
                "j",
        ]
        private static let singularInitials: Set<Character> = [
                "b",
                "p",
                "m",
                "f",
                "d",
                "t",
                "n",
                "l",
                "g",
                "k",
                "h",
                "w",
                "z",
                "c",
                "s",
                "j",
        ]
        private static let finals: Set<String> = [
                "aa",
                "aai",
                "aau",
                "aam",
                "aan",
                "aang",
                "aap",
                "aat",
                "aak",

                "a",
                "ai",
                "au",
                "am",
                "an",
                "ang",
                "ap",
                "at",
                "ak",

                "e",
                "ei",
                "eu",
                "em",
                "en",
                "eng",
                "ep",
                "et",
                "ek",

                "i",
                "iu",
                "im",
                "in",
                "ing",
                "ip",
                "it",
                "ik",

                "o",
                "oi",
                "ou",
                "on",
                "ong",
                "ot",
                "ok",

                "u",
                "ui",
                "um",
                "un",
                "ung",
                "up",
                "ut",
                "uk",

                "oe",
                "oeng",
                "oet",
                "oek",

                "eoi",
                "eon",
                "eot",

                "yu",
                "yun",
                "yut",
        ]

        private static let tones: Set<Character> = ["1", "2", "3", "4", "5", "6"]
}
