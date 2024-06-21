public struct OldCantonese {
        public static func IPAText(of syllable: String) -> String {
                lazy var fallback: String = "[ ? ]"
                let isBadFormat: Bool = syllable.isEmpty || (syllable == "?") || (syllable == "X") || syllable.contains(" ")
                guard !isBadFormat else { return fallback }
                guard let phone = IPAPhone(syllable) else { return fallback }
                guard let tone = IPATone(syllable) else { return fallback }
                return "[ \(phone) \(tone) ]"
        }
        public static func ipa(of syllable: String) -> String {
                lazy var fallback: String = "?"
                let isBadFormat: Bool = syllable.isEmpty || (syllable == "?") || (syllable == "X") || syllable.contains(" ")
                guard !isBadFormat else { return fallback }
                guard let phone = IPAPhone(syllable) else { return fallback }
                guard let tone = IPATone(syllable) else { return fallback }
                return phone + tone
        }

        private static func IPAPhone(_ syllable: String) -> String? {
                let phone = syllable.dropLast()
                guard phone.isNotEmpty else { return nil }
                switch phone {
                case "m":
                        return "\u{6D}\u{329}" // { m̩ }
                case "ng":
                        return "\u{14B}\u{329}" // { ŋ̩ }
                case let text where dualInitialsMap[text.prefix(2)] != nil:
                        guard let initial = dualInitialsMap[text.prefix(2)] else { return nil }
                        guard let final = FinalMap[text.dropFirst(2)] else { return nil }
                        return initial + final
                default:
                        if let initial = InitialMap[phone.first!] {
                                guard let final = FinalMap[phone.dropFirst()] else { return nil }
                                return initial + final
                        } else {
                                return FinalMap[phone]
                        }
                }
        }
        private static func IPATone(_ syllable: String) -> String? {
                guard let tone = syllable.last else { return nil }
                return ToneMap[tone]
        }

        private static let dualInitialsMap: [String.SubSequence: String] = [
                "ng": "ŋ",
                "gw": "kʷ",
                "kw": "kʷʰ",
                "nj": "ȵ",
                "zh": "t͡ʃ",
                "ch": "t͡ʃʰ",
                "sh": "ʃ"
        ]
        private static let InitialMap: [Character: String] = [
                "b": "p",
                "p": "pʰ",
                "m": "m",
                "f": "f",
                "d": "t",
                "t": "tʰ",
                "n": "n",
                "l": "l",
                "g": "k",
                "k": "kʰ",
                "h": "h",
                "w": "w",
                "z": "t͡s",
                "c": "t͡sʰ",
                "s": "s",
                "j": "j"
        ]
        private static let FinalMap: [String.SubSequence: String] = [
                "aa": "aː",
                "aai": "aːi",
                "aau": "aːu",
                "aam": "aːm",
                "aan": "aːn",
                "aang": "aːŋ",
                "aap": "aːp̚",
                "aat": "aːt̚",
                "aak": "aːk̚",
                "a": "ɐ",
                "ai": "ɐi",
                "au": "ɐu",
                "am": "ɐm",
                "an": "ɐn",
                "ang": "ɐŋ",
                "ap": "ɐp̚",
                "at": "ɐt̚",
                "ak": "ɐk̚",
                "e": "ɛː",
                "ei": "ei",
                "eu": "ɛːu",
                "em": "ɛːm",
                "en": "en",
                "eng": "ɛːŋ",
                "ep": "ɛːp̚",
                "et": "ɛːt̚",
                "ek": "ɛːk̚",
                "i": "iː",
                "iu": "iːu",
                "im": "iːm",
                "in": "iːn",
                "ing": "eŋ",
                "ip": "iːp̚",
                "it": "iːt̚",
                "ik": "ek̚",
                "o": "ɔː",
                "oi": "ɔːi",
                "ou": "ou",
                "om": "ɔːm",
                "on": "ɔːn",
                "ong": "ɔːŋ",
                "op": "ɔːp̚",
                "ot": "ɔːt̚",
                "ok": "ɔːk̚",
                "u": "uː",
                "ui": "uːi",
                "um": "om",
                "un": "uːn",
                "ung": "oŋ",
                "up": "op̚",
                "ut": "uːt̚",
                "uk": "ok̚",
                "oe": "œː",
                "oeng": "œːŋ",
                "oet": "œːt̚",
                "oek": "œːk̚",
                "eoi": "ɵy",
                "eon": "ɵn",
                "eot": "ɵt̚",
                "yu": "yː",
                "yun": "yːn",
                "yut": "yːt̚",
                "ii": "ɿ"
        ]
        private static let ToneMap: [Character: String] = [
                "1": "˥",
                "2": "˧˥",
                "3":  "˧",
                "4": "˨˩",
                "5": "˩˧",
                "6": "˨",
                "7": "˥",
                "8": "˧",
                "9": "˨"
        ]
}
