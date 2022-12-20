struct Syllable: Hashable {
        let initial: String?
        let final: String
        let tone: Int
}

/// Romanization Syllable Sequence
public typealias SyllableScheme = [String]

/// Schemes, aka. Romanization Syllable Sequences
public typealias Segmentation = [SyllableScheme]

/// Romanization Segmentor
public struct Segmentor {

        static func canSplit(_ text: String) -> Bool {
                return true
        }

        private static let syllables: Set<String> = []

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
}

