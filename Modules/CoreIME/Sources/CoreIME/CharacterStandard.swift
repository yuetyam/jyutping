/// 字符集標準
///
/// 1: 傳統漢字
///
/// 2: 傳統漢字・香港
///
/// 3: 傳統漢字・臺灣
///
/// 4: 簡化字
public enum CharacterStandard: Int, CaseIterable {

        /// Traditional. 傳統漢字
        case traditional = 1

        /// Traditional, Hong Kong. 傳統漢字・香港
        case hongkong = 2

        /// Traditional, Taiwan. 傳統漢字・臺灣
        case taiwan = 3

        /// Simplified. 簡化字
        case simplified = 4
}

extension CharacterStandard {

        /// self == .simplified
        public var isSimplified: Bool {
                return self == .simplified
        }

        /// self != .simplified
        public var isTraditional: Bool {
                return self != .simplified
        }

        /// Match the CharacterStandard for the given RawValue
        /// - Parameter value: RawValue
        /// - Returns: CharacterStandard
        public static func standard(of value: Int) -> CharacterStandard {
                return Self.allCases.first(where: { $0.rawValue == value }) ?? Self.traditional
        }
}

extension CharacterStandard {

        public static func strokeTransform(_ text: String) -> String {
                return String(text.compactMap({ mapStrokeKey[$0] }))
        }

        public static func stroke(of letter: Character) -> Character? {
                return strokeMap[letter]
        }

        public static func cangjie(of letter: Character) -> Character? {
                return cangjieMap[letter]
        }

        private static let strokeMap: [Character: Character] = ["w": "⼀", "s": "⼁", "a": "⼃", "d": "⼂", "z": "乛", "x": "＊"]

        // 橫: w, h, t: w = Waang, h = Héng, t = 提 = Tai = Tí
        // 豎: s      : s = Syu = Shù
        // 撇: a, p   : p = Pit = Piě
        // 點: d, n   : d = Dim = Diǎn, n = 捺 = Naat = Nà
        // 折: z      : z = Zit = Zhé
        // 通: x, *   : x = wildcard match
        //
        // macOS built-in Stroke: https://support.apple.com/zh-hk/guide/chinese-input-method/cim4f6882a80/mac
        // 橫: j, KP_1
        // 豎: k, KP_2
        // 撇: l, KP_3
        // 點: u, KP_4
        // 折: i, KP_5
        // 通: o, KP_6
        private static let mapStrokeKey: [Character : Character] = [
                "w" : "w",
                "h" : "w",
                "t" : "w",
                "s" : "s",
                "a" : "a",
                "p" : "a",
                "d" : "d",
                "n" : "d",
                "z" : "z",
                "x" : "x",
                "*" : "x",

                "j" : "w",
                "k" : "s",
                "l" : "a",
                "u" : "d",
                "i" : "z",
                "o" : "x",

                "1" : "w",
                "2" : "s",
                "3" : "a",
                "4" : "d",
                "5" : "z",
                "6" : "x"
        ]

        private static let cangjieMap: [Character: Character] = [
                "a": "日",
                "b": "月",
                "c": "金",
                "d": "木",
                "e": "水",
                "f": "火",
                "g": "土",
                "h": "竹",
                "i": "戈",
                "j": "十",
                "k": "大",
                "l": "中",
                "m": "一",
                "n": "弓",
                "o": "人",
                "p": "心",
                "q": "手",
                "r": "口",
                "s": "尸",
                "t": "廿",
                "u": "山",
                "v": "女",
                "w": "田",
                "x": "難",
                "y": "卜",
                "z": "重"
        ]
}
