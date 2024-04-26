/// Jyutping romanization syllable to IPA
struct Syllable2IPA {

        static func IPAText(_ syllable: String) -> String {
                lazy var fallback: String = "[ ? ]"
                let isBadFormat: Bool = syllable.isEmpty || (syllable == "?") || (syllable == "X") || syllable.contains(" ")
                guard !isBadFormat else { return fallback }
                guard let phone: String = IPAPhone(syllable) else { return fallback }
                guard let tone: String = IPATone(syllable) else { return fallback }
                return "[ " + phone + " " + tone + " ]"
        }
        static func ipa(of syllable: String) -> String {
                lazy var fallback: String = ""
                let isBadFormat: Bool = syllable.isEmpty || (syllable == "?") || (syllable == "X") || syllable.contains(" ")
                guard !isBadFormat else { return fallback }
                guard let phone: String = IPAPhone(syllable) else { return fallback }
                guard let tone: String = IPATone(syllable) else { return fallback }
                return phone + tone
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
                        return "˨˩"
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
                let phone = syllable.dropLast()
                guard !phone.isEmpty else { return nil }
                switch phone {
                case "m":
                        return "m̩"
                case "ng":
                        return "ŋ̩"
                case let text where text.hasPrefix("ng") || text.hasPrefix("gw") || text.hasPrefix("kw"):
                        let initialText = phone.dropLast(phone.count - 2)
                        let initial: String = String(initialText)
                        guard let IPAInitial: String = dualInitialsMap[initial] else { return nil }
                        let final: String = String(text.dropFirst(2))
                        guard let IPAFinal: String = FinalMap[final] else { return nil }
                        return IPAInitial + IPAFinal
                default:
                        let initial = phone.first!
                        if let IPAInitial: String = InitialMap[initial] {
                                let final: String = String(phone.dropFirst())
                                guard let IPAFinal: String = FinalMap[final] else { return nil }
                                return IPAInitial + IPAFinal
                        } else {
                                let final: String = String(phone)
                                return FinalMap[final]
                        }
                }
        }

        private static let dualInitialsMap: [String: String] = [
                "ng": "ŋ",
                "gw": "kʷ",
                "kw": "kʷʰ"
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
                // "ng": "ŋ",
                "h": "h",
                // "gw": "kʷ",
                // "kw": "kʷʰ",
                "w": "w",
                "z": "t͡s",
                "c": "t͡sʰ",
                "s": "s",
                "j": "j"
        ]
        private static let FinalMap: [String: String] = [
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
                "on": "ɔːn",
                "ong": "ɔːŋ",
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
                "yut": "yːt̚"
        ]
}
