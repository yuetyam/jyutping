struct Splitter {
        private static func prepare(text: String) -> (text: String, raw: String, tones: String, blocks: [String]) {
                let tones: String = text.filter({ $0.isNumber })
                guard !tones.isEmpty else { return (text, text, tones, []) }
                var unit: String = ""
                var blocks: [String] = []
                for character in text {
                        unit.append(character)
                        if character.isNumber {
                                blocks.append(unit)
                                unit = ""
                        }
                }
                if !unit.isEmpty {
                        blocks.append(unit)
                }
                let raw: String = text.filter({ !$0.isNumber })
                return (text, raw, tones, blocks)
        }
        static func engineSplit(_ text: String) -> [String] {
                guard let sequence: [String] = split(text).first, !sequence.isEmpty else { return [] }
                let scheme = sequence.map({ syllable -> String in
                        let converted: String = syllable.replacingOccurrences(of: "eo(ng|k)$", with: "oe$1", options: .regularExpression)
                                .replacingOccurrences(of: "oe(i|n|t)$", with: "eo$1", options: .regularExpression)
                        return converted
                })
                return scheme
        }
        static func split(_ text: String) -> [[String]] {
                guard !text.isEmpty else { return [] }
                guard !text.contains("'") else {
                        return separate(text: text)
                }
                let prepared = prepare(text: text)
                let schemes: [[String]] = performSplit(text: prepared.raw)
                guard !prepared.tones.isEmpty else { return schemes }

                let blocks: [String] = prepared.blocks
                guard !schemes.isEmpty else { return sequences(for: blocks) }

                var checked: [String] = []
                for block in blocks {
                        let hasTone: Bool = block.last!.isNumber
                        let raw: String = hasTone ? String(block.dropLast()) : block
                        guard !syllables.contains(raw) else {
                                checked.append(block)
                                continue
                        }
                        let scheme: [String] = performSplit(text: raw).first ?? []
                        guard !scheme.isEmpty else {
                                checked.append(block)
                                continue
                        }
                        let splittable: String = scheme.joined()
                        if splittable == raw {
                                if hasTone {
                                        let last: String = scheme.last! + String(block.last!)
                                        checked.append(contentsOf: scheme.dropLast())
                                        checked.append(last)
                                } else {
                                        checked.append(contentsOf: scheme)
                                }
                        } else {
                                let tail: String = String(block.dropFirst(splittable.count))
                                checked.append(contentsOf: scheme)
                                checked.append(tail)
                        }
                }
                return sequences(for: checked)
        }
        private static func separate(text: String) -> [[String]] {
                let parts: [String] = text.split(separator: "'").map({ String($0) })
                let schemes: [[String]] = Splitter.sequences(for: parts)
                return schemes
        }
        private static func sequences(for blocks: [String]) -> [[String]] {
                guard blocks.count > 1 else {
                        return [blocks]
                }
                var schemes: [[String]] = []
                for number in 0..<blocks.count {
                        schemes.append(blocks.dropLast(number))
                }
                return schemes
        }

        private static func performSplit(text: String) -> [[String]] {
                let leadingJyutpings: [String] = splitLeading(text)
                guard !leadingJyutpings.isEmpty else { return [] }

                var sequences: [[String]] = leadingJyutpings.map { [$0] }
                var leadingLength: Int = 0
                var shouldContinue: Bool = true
                var latestGeneration: [[String]] = sequences
                while shouldContinue {
                        var cache: [[String]] = []
                        for sequence in latestGeneration {
                                leadingLength = max(leadingLength, sequence.reduce(0, { $0 + $1.count }))
                                let lastPart: String = String(text.dropFirst(leadingLength))
                                let nextTokens: [String] = splitLeading(lastPart)
                                let newGenSequences: [[String]] = nextTokens.map { sequence + [$0] }
                                cache += newGenSequences
                        }
                        if let _ = cache.first?.first {
                                sequences += cache
                                latestGeneration = cache
                        } else {
                                shouldContinue = false
                                break
                        }
                        
                        if leadingLength == text.count {
                                shouldContinue = false
                                break
                        }
                        if !canSplit(String(text.dropFirst(leadingLength))) {
                                shouldContinue = false
                                break
                        }
                }
                sequences.sort {
                        let lhsCount: Int = $0.joined().count
                        let rhsCount: Int = $1.joined().count
                        if lhsCount == rhsCount {
                                return $0.count < $1.count
                        } else {
                                return lhsCount > rhsCount
                        }
                }
                return sequences
        }

        private static func splitLeading(_ text: String) -> [String] {
                guard !text.isEmpty else { return [] }
                var tokens: [String] = []
                let maxLength: Int = min(text.count, 6)
                for number in 0..<maxLength {
                        let dropCount: Int = (text.count - 1) - number
                        let part: String = String(text.dropLast(dropCount))
                        if syllables.contains(part) {
                                tokens.append(part)
                        }
                }
                return tokens
        }

        private static func canSplit(_ text: String) -> Bool {
                guard !text.isEmpty else { return false }
                for jyutping in syllables {
                        if text.hasPrefix(jyutping) {
                                return true
                        }
                }
                return false
        }

private static let syllables: Set<String> = [
"ngo", "hai", "nei", "keoi", "m", "ge", "aa", "hou", "dou", "ne",
"ni", "zau", "go", "heoi", "jau", "la", "laa", "gam", "di", "dit",
"tung", "ga", "gaa", "gei", "gong", "zo", "me", "jiu", "mou", "waa",
"tai", "dak", "dei", "je", "wui", "jat", "zyu", "soeng", "wo", "dik",
"jan", "zou", "sin", "mat", "sik", "gwo", "laak", "zek", "zi", "daan",
"bei", "faan", "wan", "mai", "lo", "haa", "do", "zik", "giu", "gin",
"zoi", "ting", "teng", "si", "dim", "zung", "deoi", "ji", "o", "bong",
"liu", "wai", "nam", "jap", "daa", "maai", "jyun", "mei", "daai", "zoeng",
"ceot", "tiu", "jung", "faai", "saai", "co", "lok", "man", "sau", "gan",
"sei", "zing", "hoeng", "hoi", "hang", "hong", "gaan", "loeng", "mong", "saam",
"ling", "jam", "joeng", "no", "kwan", "fan", "jik", "bin", "dang", "siu",
"gaau", "baai", "cin", "ce", "zai", "ging", "zeoi", "ze", "zaa", "hei",
"cung", "ci", "ceoi", "sing", "syut", "tin", "neoi", "bat", "naa", "dong",
"tau", "taa", "cing", "lin", "taai", "hau", "leng", "nan", "baa", "soi",
"seoi", "baan", "zan", "fong", "can", "paa", "min", "gok", "ng", "jyut",
"se", "san", "loi", "sang", "saang", "laan", "ngaam", "oi", "maat", "mut",
"haam", "daap", "lou", "ming", "joek", "seon", "nin", "goek", "ding", "dai",
"noi", "zuk", "gou", "king", "zong", "kau", "sung", "sam", "lung", "haak",
"gwai", "hok", "ngaan", "syun", "cai", "ho", "paak", "gaai", "syu", "jaa",
"gung", "tim", "coeng", "waak", "geoi", "so", "gau", "pun", "gang", "gaang",
"zyun", "paau", "jyu", "aai", "ngaai", "pui", "bun", "gu", "lik", "maa",
"kei", "aak", "ngaak", "ngak", "naan", "uk", "sai", "suk", "maan", "mit",
"lek", "sap", "cyun", "mun", "pou", "ngaau", "bou", "wong", "maau", "duk",
"saat", "mo", "lei", "on", "naam", "dau", "naau", "to", "caap", "lau",
"gwaai", "haai", "fei", "fai", "mui", "nau", "zin", "laai", "laam", "gai",
"nap", "zoek", "bo", "luk", "baat", "sek", "ngoi", "bui", "doi", "dung",
"tou", "cat", "hung", "daam", "caat", "jin", "han", "kan", "taan", "hak",
"zang", "gui", "juk", "ning", "saan", "fu", "caa", "caai", "zap", "kaau",
"hng", "ma", "miu", "faat", "wun", "jit", "sat", "le", "kap", "lyun",
"diu", "fo", "lim", "tek", "caan", "cau", "dam", "zeon", "faa", "sou",
"zip", "leoi", "hon", "ngok", "koek", "bing", "beng", "caau", "zaam",
"ngaa", "waai", "teoi", "baau", "hyut", "jai", "tong", "gwaa", "lat",
"cou", "haau", "waan", "cyu", "ping", "hap", "naai", "ciu", "cong", "kam",
"nang", "jip", "caam", "baak", "mau", "gap", "dyun", "mung", "cit", "toi",
"paai", "caang", "pin", "ziu", "zok", "gaap", "pik", "git", "gwong", "jing",
"din", "jo", "jeng", "gon", "gim", "tip", "aap", "goi", "saa", "gaam",
"taam", "dok", "gwaan", "ngaang", "zaat", "niu", "caak", "bik", "nyun",
"biu", "long", "fung", "taap", "nou", "fun", "geng", "kin", "am", "gik",
"pok", "puk", "zaan", "pei", "wing", "cang", "koeng", "kat", "coi", "kyun",
"lam", "dip", "kit", "kung", "hing", "sak", "ok", "ceon", "gwok", "kaa",
"kaat", "gyun", "hyun", "gaak", "tyun", "sit", "ham", "ngan", "koi", "ak",
"noeng", "paang", "jim", "leon", "wu", "waat", "maak", "po", "zaau",
"kwong", "zyut", "tam", "zaak", "him", "tan", "ai", "pek", "hek", "piu",
"gip", "ngau", "fuk", "hot", "zam", "bai", "au", "fui", "gwan", "sim",
"muk", "cim", "laang", "deng", "song", "aat", "aau", "pung", "mok", "pai",
"be", "fat", "bok", "guk", "aan", "taat", "ung", "zim", "zit", "laau",
"dyut", "tit", "lap", "laap", "pang", "zeot", "cek", "nai", "daat", "bit",
"nim", "huk", "ngong", "haan", "ngap", "de", "lem", "pong", "wut", "nung",
"kai", "zak", "sok", "gwat", "kiu", "zaai", "lak", "tok", "gat", "doe",
"lai", "wat", "gun", "zaap", "zat", "got", "wok", "hiu", "jeon", "ei",
"fut", "nik", "kek", "lit", "ban", "pan", "bung", "hip", "laat", "sip",
"cam", "leot", "seot", "kwaang", "mang", "kuk", "cik", "haang", "mak",
"ang", "zeng", "loek", "gwaat", "maang", "hat", "bak", "waang", "pit",
"hm", "but", "hin", "ngai", "jaak", "goeng", "dan", "gwang", "ngon",
"ke", "lip", "dat", "fang", "fing", "we", "coek", "lyut", "fau", "deon",
"tyut", "kong", "put", "soek", "cuk", "kwaa", "kwai", "goe", "dek", "pat",
"bang", "kut", "ou", "kaai", "hoe", "seng", "buk", "gwaak", "hit", "saau",
"loe", "haap", "gaat", "cok", "saap", "jeoi", "ku", "kok", "doek", "fok",
"tang", "kang", "cap", "fe", "ngat", "nong", "bam", "cyut", "gwaang", "cip",
"naap", "kwok", "nok", "kyut", "ap", "koe", "ngou", "zaang", "aang", "dap",
"nip", "gep", "bek", "paan", "baang", "cak", "wik", "gwing", "teon", "kim",
"tik", "lu", "mik", "kwik", "naat", "soe", "wang", "nat", "neot", "fik",
"kui", "aam", "an", "at", "bau", "bi", "bon", "ceng", "coet", "daak", "deot",
"deu", "doeng", "eot", "faak", "fit", "fiu", "gak", "gi", "gut", "gwak",
"gwe", "gwei", "gwi", "gwik", "gwit", "gyut", "he", "heng", "hi", "hik",
"jaai", "jaang", "jaap", "jaau", "jou", "kaak", "kaam", "kak", "kep",
"keu", "kik", "kip", "ko", "kwaai", "kwaak", "kwang", "lan", "lang",
"leu", "li", "mam", "meng", "mi", "nak", "neng", "ngaap", "ngaat",
"ngam", "ngang", "nge", "ngit", "ngot", "nit", "noek", "nuk", "ong",
"paat", "pau", "pe", "peng", "pet", "poi", "saak", "tap", "teot", "ti",
"toe", "tuk", "wak", "wet", "wi", "zem", "zep", "zoe", "zoet",
"koei",
"hoei",
"doei",
"coet",
"zoei",
"coei",
"noei",
"soei",
"soen",
"goei",
"zoen",
"loei",
"toei",
"coen",
"loen",
"zoet",
"joen",
"loet",
"soet",
"doen",
"joei",
"toen",
"noet",
"doet",
"toet",
"seong",
"zeong",
"heong",
"leong",
"jeong",
"jeok",
"geok",
"ceong",
"zeok",
"keok",
"keong",
"neong",
"leok",
"geong",
"ceok",
"seok",
"deok",
"deong",
"neok"]
}
