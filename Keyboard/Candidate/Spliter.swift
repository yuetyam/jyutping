struct Spliter {
        
        static func split(_ text: String) -> [String] {
                var input: String = text
                var token: String = ""
                var matches: [String] = []
                
                while input.count > 1 {
                        let maxLength: Int = input.count < 6 ? input.count : 6
                        let startIndex: String.Index = input.startIndex
                        
                        for index in 0..<maxLength {
                                let end: String.Index = input.index(startIndex, offsetBy: index)
                                let part: String = String(input[startIndex...end])
                                if jyutpings.contains(part) {
                                        token = part
                                }
                        }
                        if !token.isEmpty {
                                matches.append(token)
                                input = String(input.dropFirst(token.count))
                                token = ""
                        } else {
                                break
                        }
                }
                return matches
        }
        
        static func canSplit(_ text: String) -> Bool {
                if invalidFirstCharacter.contains(text.first!) {
                        return false
                }
                
                for jyutping in jyutpings {
                        if text.hasPrefix(jyutping) {
                                return true
                        }
                }
                
                return false
        }
        
        private static let invalidFirstCharacter: String = "qryixv"
        
        private static let jyutpings: Set<String> = ["ngo", "nei", "keoi", "ge", "aa", "gam", "dou", "zau", "hai", "hou",
        "heoi", "ng", "go", "jau", "tung", "laa", "gong", "zo", "jiu",
        "di", "gei", "waa", "wui", "me", "soeng", "gaa", "mou", "jat", "zou",
        "dak", "je", "sin", "gwo", "laak", "jan", "faan", "wan", "haa", "wo",
        "zik", "giu", "zyu", "zoi", "tai", "lo", "bei", "si", "dim", "zung",
        "bong", "maai", "ji", "deoi", "nam", "mai", "daai", "zoeng", "tiu", "ceot",
        "man", "jung", "gan", "zing", "sik", "hang", "hong", "zi", "gaan", "daa",
        "ting", "zek", "maa", "joeng", "mei", "no", "gin", "loeng", "mat", "cin",
        "bin", "zai", "jyun", "ze", "ling", "do", "dang", "co", "zeoi",
        "hoeng", "saam", "tin", "jap", "naa", "cing", "gaau", "lin", "taai", "waan",
        "wun", "sing", "sit", "lok", "dong", "baan", "faai", "fan", "zan", "paa",
        "hei", "sei", "saang", "sang", "hoi", "sau", "mong", "ming", "seon", "ging",
        "bo", "san", "king", "wai", "cung", "zong", "fong", "kau", "sung",
        "lung", "sam", "dei", "min", "sai", "jam", "ding", "gung", "tim", "zoek",
        "ce", "geoi", "pun", "siu", "daap", "gau", "leng", "jik", "hau", "bun",
        "neoi", "aak", "ngaak", "ngak", "naan", "uk", "can", "suk", "maan", "daan",
        "pui", "gu", "cyun", "bou", "gou", "dik", "wong", "se", "noi", "nin",
        "seoi", "on", "paak", "joek", "naau", "haak", "lau", "liu", "tau", "syu",
        "kei", "fai", "hok", "lei", "sap", "ngaam", "laai", "gai", "so", "nau",
        "ceoi", "luk", "baat", "baa", "dai", "bui", "jyut", "oi", "zyun", "tou",
        "cat", "hung", "duk", "bat", "haam", "goek", "lou", "zang", "gaai", "ngaan",
        "syun", "lik", "coeng", "loi", "caa", "caai", "zap", "kaau", "hng", "faat",
        "sat", "lit", "lim", "caan", "gwai", "lyun", "faa", "sou", "zip", "jaa",
        "ngok", "mun", "bing", "caau", "ci", "dyun", "fo", "fei", "aai", "to",
        "doi", "mui", "cou", "haau", "ping", "jing", "taa", "ciu", "baau", "cong",
        "fuk", "jip", "baai", "caam", "mau", "laan", "kan", "gap", "zuk", "ngaai",
        "jin", "gwaai", "jyu", "waak", "pin", "ziu", "zok", "ho", "paai", "git",
        "nan", "zaa", "jeng", "gon", "jit", "goi", "hak", "gaam", "taam", "gwaan",
        "tek", "baak", "nap", "zeon", "gok", "gwaa", "bik", "saat", "dit", "fung",
        "naam", "nou", "fun", "gaang", "gang", "gik", "pou", "zaan", "pei", "wing",
        "paau", "tong", "cyu", "goeng", "koeng", "fu", "coi", "teoi", "dung", "kyun",
        "gwong", "hap", "lam", "ngaang", "saan", "kung", "lak", "lek", "ngoi", "miu",
        "din", "gwok", "kaa", "kaat", "toi", "juk", "maat", "mut", "cau", "gui",
        "ngan", "zaam", "hyut", "gaak", "haai", "dip", "gaap", "cai", "am", "jim",
        "hyun", "kwan", "leoi", "ok", "wu", "caap", "ham", "kam", "ngaau", "caak",
        "biu", "kap", "him", "dau", "piu", "daam", "mung", "ngau", "waai", "tyun",
        "zam", "au", "hon", "sek", "zaau", "hek", "han", "taan", "ceon", "teng",
        "hing", "cim", "deng", "maau", "diu", "tip", "mo", "nang", "ma", "sak",
        "pai", "guk", "muk", "syut", "saai", "bok", "aan", "cit", "taat", "gim",
        "lat", "zit", "bai", "laau", "beng", "leon", "laap", "lap", "hot", "pang",
        "long", "cek", "daat", "bit", "caang", "haan", "hat", "kai", "kit", "soi",
        "zak", "niu", "zin", "kin", "sok", "fat", "gwat", "cang", "zyut", "lai",
        "zaak", "mok", "kiu", "zaai", "gwan", "tit", "zaat", "gyun", "koek", "dam",
        "zim", "tok", "geng", "gat", "doe", "ning", "nim", "le", "wat", "naai",
        "dok", "kat", "gun", "zaap", "wut", "ngaa", "pok", "puk", "cam", "laam",
        "zat", "pong", "got", "wok", "po", "hiu", "nyun", "jeon", "ngap", "mak",
        "song", "ei", "caat", "aau", "fut", "nik", "kek", "nai", "ban", "saa",
        "pan", "bung", "hip", "laat", "kong", "kwong", "sip", "leot", "seot", "kwaang",
        "ai", "mang", "kuk", "pek", "noeng", "tam", "cik", "nung", "jai", "haang",
        "waat", "aat", "laang", "ang", "zeng", "sim", "loek", "gwaat", "koi", "maang",
        "bak", "waang", "aap", "pit", "pung", "de", "tan", "mit", "hm", "but",
        "hin", "ngai", "jaak", "dan", "gwang", "gip", "fui", "ung", "paang", "ngon",
        "zeot", "ke", "be", "fau", "lip", "dat", "fing", "we", "coek", "huk",
        "lyut", "ngong", "deon", "tyut", "pik", "put", "soek", "cuk", "kwaa", "dyut",
        "kwai", "goe", "dek", "pat", "bang", "kut", "ou", "kaai", "hoe", "taap",
        "seng", "buk", "gwaak", "hit", "saau", "loe", "haap", "ga", "gaat", "cok",
        "saap", "jeoi", "ku", "kok", "doek", "fok", "tang", "kang", "cap", "fe",
        "ngat", "nong", "bam", "cyut", "gwaang", "cip", "maak", "naap", "kwok", "nok",
        "kyut", "ap", "koe", "ngou", "zaang", "aang", "dap", "nip", "tik", "kwik",
        "teon", "cak", "ak", "naat", "wik", "bek", "kui", "wang", "pau", "paan",
        "kim", "jo", "fik", "mik", "nat", "neot", "tuk", "toe", "gwing", "ngaat",
        "baang", "saak", "lu", "ong", "deot", "gwik", "kaak", "aam", "an", "at",
        "bau", "bon", "ceng", "coet", "cun", "daak", "deu", "doeng", "eot",
        "faak", "fang", "fit", "fiu", "gak", "gep", "gi", "gut", "gwak", "gwe",
        "gwei", "gwi", "gwit", "gyut", "he", "heng", "hi", "hik", "jaai", "jaang",
        "jaap", "jaau", "jou", "kaam", "kak", "keu", "kik", "kip", "ko", "kwaai",
        "kwaak", "kwang", "la", "lan", "lang", "lem", "leu", "meng", "mi",
        "nak", "ne", "neng", "ngaap", "ngam", "ngang", "nge", "ngit", "ngot", "ni",
        "nit", "noek", "nuk", "paat", "pe", "peng", "pet", "poi", "soe", "tap",
        "teot", "wak", "wet", "zem", "zep", "zoe", "zoet", "m"]
}
