extension OldCantonese {
        static func jyutping(for syllable: String) -> String {
                return syllable.replacingOccurrences(of: "^(z|c|s)h", with: "$1", options: .regularExpression)
                        .replacingOccurrences(of: "^nj", with: "j", options: .regularExpression)
                        .replacingOccurrences(of: "o(m|p)$", with: "a$1", options: .regularExpression)
        }
}

struct OldCantonese {

        static func IPA(for syllable: String) -> String {
                lazy var fallback: String = "[ ? ]"
                let isFineSyllable: Bool = syllable != "X" || syllable != "?"
                guard isFineSyllable else { return fallback }
                guard let phone: String = IPAPhone(syllable) else { return fallback }
                guard let tone: String = IPATone(syllable) else { return fallback }
                return "[ \(phone) \(tone) ]"
        }

        private static func IPATone(_ syllable: String) -> String? {
                guard let tone = syllable.last else { return nil }
                switch tone {
                case "1":
                        return "˥"
                case "2":
                        return "˧˥"
                case "3":
                        return "˧"
                case "4":
                        return "˩"
                case "5":
                        return "˩˧"
                case "6":
                        return "˨"
                case "7":
                        return "˥"
                case "8":
                        return "˧"
                case "9":
                        return "˨"
                default:
                        return nil
                }
        }

        private static func IPAPhone(_ syllable: String) -> String? {
                let withoutTone = syllable.filter({ !$0.isNumber })
                guard !withoutTone.isEmpty else { return nil }
                switch withoutTone {
                case "m":
                        return "m̩"
                case "ng":
                        return "ŋ̩"
                case let text where foundDual(text):
                        let initial = String(text.dropLast(text.count - 2))
                        guard let IPAInitial = dualInitialsMap[initial] else { return nil }
                        let final: String = String(text.dropFirst(2))
                        guard let IPAFinal: String = finalMap[final] else { return nil }
                        return IPAInitial + IPAFinal
                default:
                        if let IPAInitial: String = initialMap[withoutTone.first!] {
                                let final: String = String(withoutTone.dropFirst())
                                guard let IPAFinal: String = finalMap[final] else { return nil }
                                return IPAInitial + IPAFinal
                        } else {
                                guard let IPAFinal: String = finalMap[String(withoutTone)] else { return nil }
                                return IPAFinal
                        }
                }
        }

        private static func foundDual(_ text: String) -> Bool {
                guard text.count > 1 else { return false }
                let firstTwo = String(text.dropLast(text.count - 2))
                let found = dualInitialsMap.keys.contains(firstTwo)
                return found
        }
        private static let dualInitialsMap: [String: String] = [
                "ng": "ŋ",
                "gw": "kʷ",
                "kw": "kʷʰ",
                "nj": "ȵ",
                "zh": "t͡ʃ",
                "ch": "t͡ʃʰ",
                "sh": "ʃ"
        ]

        private static let initialMap: [Character: String] = [
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
        private static let finalMap: [String: String] = [
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
                "z": "ɿ"
        ]
}
