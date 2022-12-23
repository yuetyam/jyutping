/// Romanization Syllable Sequence
public typealias SyllableScheme = [String]

/// Schemes, aka. Romanization Syllable Sequences, alias to `[[String]]`
public typealias Segmentation = [SyllableScheme]

private extension SyllableScheme {
        var length: Int {
                return reduce(0, { $0 + $1.count })
        }
}
private extension Segmentation {
        var length: Int {
                return reduce(0, { $0 + $1.length })
        }
}

/// Romanization Segmentor
public struct Segmentor {

        /// Split text to sequence blocks by tones
        private static func composition(of text: String) -> (hasTones: Bool, components: [String]) {
                var hasTones: Bool = false
                var components: [String] = []
                var block: String = ""
                for character in text {
                        block.append(character)
                        if character.isTone {
                                hasTones = true
                                components.append(block)
                                block = ""
                        }
                }
                if !block.isEmpty {
                        components.append(block)
                }
                return (hasTones: hasTones, components: components)
        }
        private static func separate(text: String) -> Segmentation {
                let scheme: SyllableScheme = text.components(separatedBy: "'")
                return regular(scheme: scheme)
        }
        private static func regular(scheme blocks: SyllableScheme) -> Segmentation {
                switch blocks.count {
                case 0:
                        return []
                case 1:
                        return [blocks]
                default:
                        var schemes: [SyllableScheme] = [blocks]
                        for number in 1..<blocks.count {
                                schemes.append(blocks.dropLast(number))
                        }
                        return schemes
                }
        }

        public static func scheme(of text: String) -> SyllableScheme {
                switch text.count {
                case 0:
                        return []
                case 1:
                        return canSplit(text) ? [text] : []
                default:
                        guard let sequence: [String] = segment(text).first, !sequence.isEmpty else { return [] }
                        return transform(sequence)
                }
        }
        static func engineSegment(_ text: String) -> Segmentation {
                switch text.count {
                case 0:
                        return []
                case 1:
                        return canSplit(text) ? [[text]] : []
                default:
                        return segment(text).map(transform(_:))
                }
        }
        private static func transform(_ scheme: SyllableScheme) -> SyllableScheme {
                let convertedScheme: [String] = scheme.map { syllable -> String in
                        let shouldConvert: Bool = syllable.count > 2 || syllable.hasPrefix("y")
                        guard shouldConvert else { return syllable }
                        let converted: String = syllable.replacingOccurrences(of: "eo(ng|k)$", with: "oe$1", options: .regularExpression)
                                .replacingOccurrences(of: "oe(i|n|t)$", with: "eo$1", options: .regularExpression)
                                .replacingOccurrences(of: "eung$", with: "oeng", options: .regularExpression)
                                .replacingOccurrences(of: "(u|o)m$", with: "am", options: .regularExpression)
                                .replacingOccurrences(of: "^y(u|un|ut)$", with: "jy$1", options: .regularExpression)
                                .replacingOccurrences(of: "y", with: "j", options: .anchored)
                        return converted
                }
                return convertedScheme
        }

        public static func segment(_ text: String) -> Segmentation {
                switch text.count {
                case 0:
                        return []
                case 1:
                        return canSplit(text) ? [[text]] : []
                default:
                        break
                }
                guard !text.contains("'") else { return separate(text: text) }
                let composition = composition(of: text)
                guard composition.hasTones else { return split(text: text) }
                let segmentation: Segmentation = split(text: text.removedTones())
                let blocks: [String] = composition.components
                guard !segmentation.isEmpty else { return regular(scheme: blocks) }
                var scheme: [String] = []
                for block in blocks {
                        let hasTone: Bool = block.last!.isTone
                        let raw: String = hasTone ? String(block.dropLast()) : block
                        let shouldSplit: Bool = !(isValidSyllable(raw))
                        guard shouldSplit else {
                                scheme.append(block)
                                continue
                        }
                        let sequence: SyllableScheme = split(text: raw).first ?? []
                        switch sequence.length {
                        case 0:
                                scheme.append(block)
                        case raw.count:
                                if hasTone {
                                        let last: String = sequence.last! + String(block.last!)
                                        scheme.append(contentsOf: sequence.dropLast())
                                        scheme.append(last)
                                } else {
                                        scheme.append(contentsOf: sequence)
                                }
                        default:
                                let tail: String = String(block.dropFirst(sequence.length))
                                scheme.append(contentsOf: sequence)
                                scheme.append(tail)
                        }
                }
                return regular(scheme: scheme)
        }

        private static func split(text: String) -> Segmentation {
                let leadingSyllables: [String] = splitLeading(text)
                guard !leadingSyllables.isEmpty else { return [] }

                var segmentation: Segmentation = leadingSyllables.map { [$0] }
                let textCount: Int = text.count
                var leadingLength: Int = 0
                var shouldContinue: Bool = true
                var latestGeneration: [[String]] = segmentation
                while shouldContinue {
                        var cache: [[String]] = []
                        for sequence in latestGeneration {
                                leadingLength = max(leadingLength, sequence.length)
                                let tailText: String = String(text.dropFirst(leadingLength))
                                let nextTokens: [String] = splitLeading(tailText)
                                let newGenerationSequences: [[String]] = nextTokens.map { sequence + [$0] }
                                cache += newGenerationSequences
                        }
                        if let _ = cache.first?.first {
                                segmentation += cache
                                latestGeneration = cache
                        } else {
                                shouldContinue = false
                                break
                        }
                        if leadingLength == textCount {
                                shouldContinue = false
                                break
                        }
                        let latestTailText: String = String(text.dropFirst(leadingLength))
                        if !canSplit(latestTailText) {
                                shouldContinue = false
                                break
                        }
                }
                let sortedSegmentation: Segmentation = segmentation.uniqued().sorted(by: {
                        let lhsLength: Int = $0.length
                        let rhsLength: Int = $1.length
                        if lhsLength == rhsLength {
                                return $0.count < $1.count
                        } else {
                                return lhsLength > rhsLength
                        }
                })
                return sortedSegmentation
        }
        private static func splitLeading(_ text: String) -> [String] {
                let textCount: Int = text.count
                switch textCount {
                case 0:
                        return []
                case 1:
                        let isSingular: Bool = singular.contains(text.first!)
                        return isSingular ? [text] : []
                case 2:
                        let firstCharacter = text.first!
                        let canBeSingular: Bool = singular.contains(firstCharacter)
                        let canBeDual: Bool = dual.contains(text)
                        switch (canBeSingular, canBeDual) {
                        case (true, true):
                                return [String(firstCharacter), text]
                        case (true, false):
                                return [String(firstCharacter)]
                        case (false, true):
                                return [text]
                        case (false, false):
                                return []
                        }
                default:
                        var tokens: [String] = []
                        let maxLength: Int = min(textCount, 6)
                        for number in 0..<maxLength {
                                let leadingCount: Int = number + 1
                                let tailCount: Int = textCount - leadingCount
                                let leadingSlice: String = String(text.dropLast(tailCount))
                                switch leadingCount {
                                case 1:
                                        if singular.contains(text.first!) {
                                                tokens.append(leadingSlice)
                                        }
                                case 2:
                                        if dual.contains(leadingSlice) {
                                                tokens.append(leadingSlice)
                                        }
                                case 3:
                                        if triple.contains(leadingSlice) {
                                                tokens.append(leadingSlice)
                                        }
                                case 4:
                                        if quad.contains(leadingSlice) {
                                                tokens.append(leadingSlice)
                                        }
                                case 5:
                                        if five.contains(leadingSlice) {
                                                tokens.append(leadingSlice)
                                        }
                                default:
                                        if six.contains(leadingSlice) {
                                                tokens.append(leadingSlice)
                                        }
                                }
                        }
                        return tokens
                }
        }
        private static func canSplit(_ text: String) -> Bool {
                switch text.count {
                case 0:
                        return false
                case 1:
                        return singular.contains(text.first!)
                case 2:
                        return dual.contains(text) || singular.contains(text.first!)
                case 3:
                        guard !(triple.contains(text)) else { return true }
                        let leading: String = String(text.dropLast())
                        return canSplit(leading)
                case 4:
                        guard !(quad.contains(text)) else { return true }
                        let leading: String = String(text.dropLast())
                        return canSplit(leading)
                case 5:
                        guard !(five.contains(text)) else { return true }
                        let leading: String = String(text.dropLast())
                        return canSplit(leading)
                case 6:
                        guard !(six.contains(text)) else { return true }
                        let leading: String = String(text.dropLast())
                        return canSplit(leading)
                default:
                        let leadingSix: String = String(text.dropLast(text.count - 6))
                        return canSplit(leadingSix)
                }
        }
        private static func isValidSyllable(_ text: String) -> Bool {
                switch text.count {
                case 0:
                        return false
                case 1:
                        return singular.contains(text.first!)
                case 2:
                        return dual.contains(text)
                case 3:
                        return triple.contains(text)
                case 4:
                        return dual.contains(text)
                case 5:
                        return five.contains(text)
                case 6:
                        return six.contains(text)
                default:
                        return false
                }
        }

        private static let singular: Set<Character> = ["m", "a", "o"]
        private static let dual: Set<String> = [
                "aa", "ai", "au", "am", "an", "ap", "at", "ak", "ei", "oi", "ou", "on", "ok", "uk", "yu",
                "bo", "po", "mo", "fo", "do", "to", "no", "lo", "go", "ko", "ho", "wo", "zo", "co", "so",
                "me", "de", "ne", "le", "ge", "ke", "ze", "ce", "se", "je",
                "di", "ni", "zi", "ci", "si", "ji",
                "fu", "gu", "ku", "wu",
                "ng",
        ]
        private static let triple: Set<String> = [
                "ang", "ong", "ung",
                "ngo", "gwo",

                "baa", "paa", "maa", "faa", "daa", "taa", "naa", "laa", "gaa", "kaa", "haa", "waa", "zaa", "caa", "saa", "jaa",
                "bai", "pai", "mai", "fai", "dai", "tai", "nai", "lai", "gai", "kai", "hai", "wai", "zai", "cai", "sai", "jai",
                "bau", "pau", "mau", "fau", "dau", "tau", "nau", "lau", "gau", "kau", "hau", "zau", "cau", "sau", "jau",
                "dam", "tam", "nam", "lam", "gam", "kam", "ham", "zam", "cam", "sam", "jam",
                "ban", "pan", "man", "fan", "dan", "tan", "nan", "lan", "gan", "kan", "han", "wan", "zan", "can", "san", "jan",
                "dap", "nap", "lap", "gap", "kap", "hap", "zap", "cap", "sap", "jap",
                "bat", "pat", "mat", "fat", "dat", "nat", "lat", "gat", "kat", "hat", "wat", "zat", "cat", "sat", "jat",
                "bak", "mak", "dak", "lak", "hak", "zak", "cak", "sak",

                "bei", "pei", "mei", "fei", "dei", "nei", "lei", "gei", "kei", "hei", "sei",
                "pek", "lek", "kek", "hek", "zek", "cek", "sek",

                "biu", "piu", "miu", "diu", "tiu", "niu", "liu", "giu", "kiu", "hiu", "ziu", "ciu", "siu", "jiu",
                "dim", "tim", "nim", "lim", "gim", "kim", "him", "zim", "cim", "sim", "jim",
                "bin", "pin", "min", "din", "tin", "nin", "lin", "gin", "kin", "hin", "zin", "cin", "sin", "jin",
                "dip", "tip", "nip", "lip", "gip", "hip", "zip", "cip", "sip", "jip",
                "bit", "pit", "mit", "dit", "tit", "nit", "lit", "git", "kit", "hit", "zit", "cit", "sit", "jit",
                "bik", "pik", "mik", "dik", "tik", "nik", "lik", "gik", "kik", "hik", "wik", "zik", "cik", "sik", "jik",

                "doe", "toe", "loe", "goe", "koe", "hoe", "soe",

                "doi", "toi", "noi", "loi", "goi", "koi", "hoi", "zoi", "coi", "soi",
                "bou", "pou", "mou", "dou", "tou", "nou", "lou", "gou", "hou", "zou", "cou", "sou",
                "gon", "hon",
                "got", "hot",
                "bok", "pok", "mok", "fok", "dok", "tok", "nok", "lok", "gok", "kok", "hok", "wok", "zok", "cok", "sok",

                "bui", "pui", "mui", "fui", "gui", "kui", "wui",
                "bun", "pun", "mun", "fun", "gun", "wun",
                "but", "put", "mut", "fut", "kut", "wut",
                "buk", "puk", "muk", "fuk", "duk", "tuk", "nuk", "luk", "guk", "kuk", "huk", "zuk", "cuk", "suk", "juk",

                "zyu", "cyu", "syu", "jyu",
        ]
        private static let quad: Set<String> = [
                "ngaa", "gwaa", "kwaa",

                "ngai", "ngau", "ngam", "ngan", "ngap", "ngat", "ngak", "ngoi", "ngou", "ngon", "ngok",
                "gwai", "gwan", "gwat", "gwik", "gwok",
                "kwai", "kwan", "kwik", "kwok",

                "bang", "pang", "mang", "dang", "tang", "nang", "gang", "kang", "hang", "zang", "cang", "sang",

                "baai", "paai", "maai", "faai", "daai", "taai", "naai", "laai", "gaai", "kaai", "haai", "zaai", "caai", "saai",
                "baau", "paau", "maau", "naau", "laau", "gaau", "kaau", "haau", "zaau", "caau", "saau",
                "laam", "gaam", "haam", "zaam", "caam", "saam",
                "baan", "paan", "maan", "faan", "daan", "taan", "naan", "laan", "gaan", "haan", "zaan", "caan", "saan",
                "daap", "taap", "naap", "laap", "gaap", "haap", "zaap", "caap", "saap",
                "baat", "maat", "faat", "daat", "taat", "naat", "laat", "gaat", "zaat", "caat", "saat",
                "baak", "paak", "maak", "laak", "gaak", "haak", "zaak", "caak", "saak", "jaak",

                "bing", "ping", "ming", "ding", "ting", "ning", "ling", "ging", "king", "hing", "zing", "cing", "sing", "jing",

                "deoi", "teoi", "neoi", "leoi", "geoi", "keoi", "heoi", "zeoi", "ceoi", "seoi", "jeoi",
                "deon", "teon", "leon", "zeon", "ceon", "seon", "jeon",
                "deot", "teot", "neot", "leot", "zeot", "ceot", "seot",
                "doek", "loek", "goek", "koek", "zoek", "coek", "soek", "joek",
                "bong", "pong", "mong", "fong", "dong", "tong", "nong", "long", "gong", "kong", "hong", "zong", "cong", "song",
                "bung", "pung", "mung", "fung", "dung", "tung", "nung", "lung", "gung", "kung", "hung", "zung", "cung", "sung", "jung",
                "dyun", "tyun", "nyun", "lyun", "gyun", "kyun", "hyun", "zyun", "cyun", "syun", "jyun",
                "dyut", "tyut", "lyut", "gyut", "kyut", "hyut", "zyut", "cyut", "syut", "jyut",

                "beng", "peng", "meng", "deng", "teng", "leng", "geng", "zeng", "ceng", "seng",

        ]
        private static let five: Set<String> = [
                "ngaai", "ngaau", "ngaam", "ngaan",
                "gwang", "gwaan", "gwaat", "gwaak", "gwong", "gwing",
                "baang", "paang", "maang", "laang", "gaang", "haang", "zaang", "caang", "saang",
                "doeng", "loeng", "goeng", "koeng", "hoeng", "zoeng", "coeng", "soeng", "joeng", "yoeng",
        ]
        private static let six: Set<String> = ["ngaang", "gwaang", "kwaang"]
}

