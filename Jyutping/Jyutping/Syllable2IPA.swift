/// Jyutping syllable to IPA
struct Syllable2IPA {

        static func ipa(_ syllable: String) -> String {
                guard syllable != "?" else { return String() }
                return ipaWoTone(syllable) + ipaTone(syllable)
        }

        static func ipaText(_ syllable: String) -> String {
                guard syllable != "?" else { return String() }
                return "[ " + ipaWoTone(syllable) + " " + ipaTone(syllable) + " ]"
        }

        static func ipaTone(_ syllable: String) -> String {
                guard let tone = syllable.last else { return String() }
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
                default:
                        return String()
                }
        }

        static func ipaWoTone(_ syllable: String) -> String {
                let withoutTone = syllable.dropLast()
                guard !withoutTone.isEmpty else { return String() }

                switch withoutTone {
                case "m":
                        return "m̩"
                case "ng":
                        return "ŋ̩"
                case let text where text.hasPrefix("ng"):
                        let ipaInitial: String = "ŋ"
                        let final: String = String(text.dropFirst(2))
                        let ipaFinal: String = FinalsMap[final] ?? "?"
                        return ipaInitial + ipaFinal
                case let text where text.hasPrefix("gw"):
                        let ipaInitial: String = "kʷ"
                        let final: String = String(text.dropFirst(2))
                        let ipaFinal: String = FinalsMap[final] ?? "?"
                        return ipaInitial + ipaFinal
                case let text where text.hasPrefix("kw"):
                        let ipaInitial: String = "kʷʰ"
                        let final: String = String(text.dropFirst(2))
                        let ipaFinal: String = FinalsMap[final] ?? "?"
                        return ipaInitial + ipaFinal
                default:
                        if let ipaInitial: String = InitialsMap[withoutTone.first!] {
                                let final: String = String(withoutTone.dropFirst())
                                let ipaFinal: String = FinalsMap[final] ?? "?"
                                return ipaInitial + ipaFinal
                        } else {
                                let ipaText: String = FinalsMap[String(withoutTone)] ?? "?"
                                return ipaText
                        }
                }
        }

        private static let InitialsMap: [Character: String] = [
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
                "z": "t͡ʃ",
                "c": "t͡ʃʰ",
                "s": "ʃ",
                "j": "j"
        ]

        private static let FinalsMap: [String: String] = [
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
                "un": "uːn",
                "ung": "oŋ",
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
