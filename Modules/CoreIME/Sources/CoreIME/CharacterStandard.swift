import CommonExtensions

/// 字符集標準
///
/// 1: 傳統漢字
///
/// 2: 傳統漢字・香港
///
/// 3: 傳統漢字・臺灣
///
/// 4: 簡化字
public enum CharacterStandard: Int, CaseIterable, Sendable {

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

        public static func cangjie(of letter: Character) -> Character? {
                return cangjieMap[letter]
        }

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
