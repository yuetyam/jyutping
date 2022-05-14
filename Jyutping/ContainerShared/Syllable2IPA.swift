import CommonExtensions

/// Romanization syllable to IPA
struct Syllable2IPA {

        static func IPAText(_ syllable: String) -> String {
                lazy var fallback: String = "[ ? ]"
                guard syllable != "?" else { return fallback }
                guard !syllable.contains(" ") else { return fallback }
                guard let withoutTone: String = IPASyllable(syllable) else { return fallback }
                guard let tone: String = IPATone(syllable) else { return fallback }
                return "[ " + withoutTone + " " + tone + " ]"
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
                default:
                        return nil
                }
        }

        private static func IPASyllable(_ syllable: String) -> String? {
                let withoutTone = syllable.dropLast()
                guard !withoutTone.isEmpty else { return nil }
                guard !withoutTone.contains(" ") else { return nil }

                switch withoutTone {
                case "m":
                        return "m̩"
                case "ng":
                        return "ŋ̩"
                case let text where text.hasPrefix("ng") || text.hasPrefix("gw") || text.hasPrefix("kw"):
                        let initialText = withoutTone.dropLast(withoutTone.count - 2)
                        let initial: String = String(initialText)
                        guard let IPAInitial: String = InitialsMap[initial] else { return nil }
                        let final: String = String(text.dropFirst(2))
                        guard let IPAFinal: String = FinalsMap[final] else { return nil }
                        return IPAInitial + IPAFinal
                default:
                        let initial: String = String(withoutTone.first!)
                        if let IPAInitial: String = InitialsMap[initial] {
                                let final: String = String(withoutTone.dropFirst())
                                guard let IPAFinal: String = FinalsMap[final] else { return nil }
                                return IPAInitial + IPAFinal
                        } else {
                                let final: String = String(withoutTone)
                                return FinalsMap[final]
                        }
                }
        }

        private static let InitialsMap: [String: String] = [
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
                "ng": "ŋ",
                "h": "h",
                "gw": "kʷ",
                "kw": "kʷʰ",
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
