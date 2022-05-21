struct PinyinSplitter {

        static func split(_ text: String) -> [[String]] {
                let leadings: [String] = splitLeading(text)
                guard !leadings.isEmpty else { return [] }

                var sequences: [[String]] = leadings.map { [$0] }
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
                        if cache.first?.first != nil {
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
                return sequences.uniqued()
        }

        private static func splitLeading(_ text: String) -> [String] {
                guard !text.isEmpty else { return [] }
                var tokens: [String] = []
                let maxLength: Int = min(text.count, 6)
                for number in 0..<maxLength {
                        let tailCount: Int = (text.count - 1) - number
                        let leading: String = String(text.dropLast(tailCount))
                        if syllables.contains(leading) {
                                tokens.append(leading)
                        }
                }
                return tokens
        }

        private static func canSplit(_ text: String) -> Bool {
                guard !text.isEmpty else { return false }
                for pinyin in syllables {
                        if text.hasPrefix(pinyin) {
                                return true
                        }
                }
                return false
        }


private static let syllables: Set<String> = [
"a", "ai", "an", "ang", "ao",
"ba", "bai", "ban", "bang", "bao", "bei", "ben", "beng", "bi", "bian", "biang", "biao", "bie", "bin", "bing", "bo", "bu",
"ca", "cai", "can", "cang", "cao", "ce", "cei", "cen", "ceng", "ci", "cong", "cou", "cu", "cuan", "cui", "cun", "cuo",
"cha", "chai", "chan", "chang", "chao", "che", "chen", "cheng", "chi", "chong", "chou", "chu", "chua", "chuai", "chuan", "chuang", "chui", "chun", "chuo",
"da", "dai", "dan", "dang", "dao", "de", "dei", "den", "deng", "di", "dia", "dian", "diao", "die", "din", "ding", "diu", "dong", "dou", "du", "duan", "dui", "dun", "duo",
"e", "eh", "ei", "en", "eng", "er",
"fa", "fan", "fang", "fei", "fen", "feng", "fiao", "fo", "fong", "fou", "fu",
"ga", "gai", "gan", "gang", "gao", "ge", "gei", "gen", "geng", "gong", "gou", "gu", "gua", "guai", "guan", "guang", "gui", "gun", "guo",
"ha", "hai", "han", "hang", "hao", "he", "hei", "hen", "heng", "hong", "hou", "hu", "hua", "huai", "huan", "huang", "hui", "hun", "huo",
"ji", "jia", "jian", "jiang", "jiao", "jie", "jin", "jing", "jiong", "jiu", "ju", "juan", "jue", "jun",
"ka", "kai", "kan", "kang", "kao", "ke", "kei", "ken", "keng", "kong", "kou", "ku", "kua", "kuai", "kuan", "kuang", "kui", "kun", "kuo",
"la", "lai", "lan", "lang", "lao", "le", "lei", "leng", "li", "lia", "lian", "liang", "liao", "lie", "lin", "ling", "liu", "lo", "long", "lou", "lu", "luan", "lun", "luo", "lv", "lvan", "lve",
"ma", "mai", "man", "mang", "mao", "me", "mei", "men", "meng", "mi", "mian", "miao", "mie", "min", "ming", "miu", "mo", "mou", "mu",
"na", "nai", "nan", "nang", "nao", "ne", "nei", "nen", "neng", "ni", "nia", "nian", "niang", "niao", "nie", "nin", "ning", "niu", "nong", "nou", "nu", "nuan", "nun", "nuo", "nv", "nve",
"o", "ou",
"pa", "pai", "pan", "pang", "pao", "pei", "pen", "peng", "pi", "pia", "pian", "piao", "pie", "pin", "ping", "po", "pou", "pu",
"qi", "qia", "qian", "qiang", "qiao", "qie", "qin", "qing", "qiong", "qiu", "qu", "quan", "que", "qun",
"ran", "rang", "rao", "re", "ren", "reng", "ri", "rong", "rou", "ru", "ruan", "rui", "run", "ruo",
"sa", "sai", "san", "sang", "sao", "se", "sei", "sen", "seng", "si", "song", "sou", "su", "suan", "sui", "sun", "suo",
"sha", "shai", "shan", "shang", "shao", "she", "shei", "shen", "sheng", "shi", "shou", "shu", "shua", "shuai", "shuan", "shuang", "shui", "shun", "shuo",
"ta", "tai", "tan", "tang", "tao", "te", "tei", "teng", "ti", "tian", "tiao", "tie", "ting", "tong", "tou", "tu", "tuan", "tui", "tun", "tuo",
"wa", "wai", "wan", "wang", "wei", "wen", "weng", "wo", "wong", "wu",
"xi", "xia", "xian", "xiang", "xiao", "xie", "xin", "xing", "xiong", "xiu", "xu", "xuan", "xue", "xun",
"ya", "yai", "yan", "yang", "yao", "ye", "yi", "yin", "ying", "yo", "yong", "you", "yu", "yuan", "yue", "yun",
"za", "zai", "zan", "zang", "zao", "ze", "zei", "zen", "zeng", "zi", "zong", "zou", "zu", "zuan", "zui", "zun", "zuo",
"zha", "zhai", "zhan", "zhang", "zhao", "zhe", "zhei", "zhen", "zheng", "zhi", "zhong", "zhou", "zhu", "zhua", "zhuai", "zhuan", "zhuang", "zhui", "zhun", "zhuo"
]


}

