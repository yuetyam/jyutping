extension String {
        public var isValidJyutpingSyllable: Bool {
                return JyutpingSyllableChecker.isValidJyutpingSyllable(text: self)
        }
}

public struct JyutpingSyllableChecker {
        public static func isValidJyutpingSyllable(text: String) -> Bool {
                guard let tone = text.last else { return false }
                guard tones.contains(tone) else { return false }
                let syllable = text.dropLast()
                guard syllable.isNotEmpty else { return false }
                let isNasal: Bool = (syllable == "m") || (syllable == "ng")
                guard !isNasal else { return true }
                let isPluralInitial: Bool = pluralInitials.contains(syllable.prefix(2))
                guard !isPluralInitial else { return finals.contains(syllable.dropFirst(2)) }
                let isFinalOnly: Bool = finals.contains(syllable)
                guard !isFinalOnly else { return true }
                guard initials.contains(syllable.first!) else { return false }
                return finals.contains(syllable.dropFirst())
        }

        private static let pluralInitials: Set<String.SubSequence> = [
                "ng",
                "gw",
                "kw"
        ]
        private static let initials: Set<Character> = [
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
        private static let finals: Set<String.SubSequence> = [
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
