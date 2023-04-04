public struct PinyinSegmentor {

        public static func segment(text: String) -> [[String]] {
                switch text.count {
                case 0:
                        return []
                case 1:
                        switch text {
                        case "a", "o", "e":
                                return [[text]]
                        default:
                                return []
                        }
                default:
                        return split(text)
                }
        }

        private static func split(_ text: String) -> [[String]] {
                let leadingTokens: [String] = splitLeading(text)
                guard !(leadingTokens.isEmpty) else { return [] }
                let textCount = text.count
                var segmentation: [[String]] = leadingTokens.map({ [$0] })
                var previousSegmentation = segmentation
                var shouldContinue: Bool = true
                while shouldContinue {
                        for scheme in segmentation {
                                let schemeLength = scheme.reduce(0, { $0 + $1.count })
                                guard schemeLength < textCount else { continue }
                                let tailText = String(text.dropFirst(schemeLength))
                                let tailTokens = splitLeading(tailText)
                                guard !(tailTokens.isEmpty) else { continue }
                                let newSegmentation: [[String]] = tailTokens.map({ scheme + [$0] })
                                segmentation = (segmentation + newSegmentation).uniqued()
                        }
                        if segmentation.subelementCount != previousSegmentation.subelementCount {
                                previousSegmentation = segmentation
                        } else {
                                shouldContinue = false
                        }
                }
                let sequences: [[String]] = segmentation.uniqued().sorted(by: {
                        let lhsLength: Int = $0.summedLength
                        let rhsLength: Int = $1.summedLength
                        if lhsLength == rhsLength {
                                return $0.count < $1.count
                        } else {
                                return lhsLength > rhsLength
                        }
                })
                return sequences
        }

        private static func splitLeading(_ text: String) -> [String] {
                let maxLength: Int = min(text.count, 6)
                guard maxLength > 0 else { return [] }
                let tokens = (1...maxLength).map({ number -> String? in
                        let token = String(text.prefix(number))
                        return syllables.contains(token) ? token : nil
                })
                return tokens.compactMap({ $0 })
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
