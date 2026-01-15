import CommonExtensions

/// 筆畫輸入
public enum StrokeVirtualKey: Int, Sendable {

        /// 橫 w
        case horizontal   = 1

        /// 豎 s
        case vertical     = 2

        /// 撇 a
        case leftFalling  = 3

        /// 點 d
        case rightFalling = 4

        /// 折 z
        case turning      = 5

        /// 通配 x
        case wildcard     = 6

        public var isWildcard: Bool { self == .wildcard }

        /// Same value as the `self.rawValue`
        public var code: Int { rawValue }
}

extension RandomAccessCollection where Element == StrokeVirtualKey {
        var sequenceText: String {
                return compactMap(\.codeText).joined()
        }
}
private extension StrokeVirtualKey {
        var codeText: String? {
                return Self.codeTextMap[self]
        }
        private static let codeTextMap: [StrokeVirtualKey : String] = [
                .horizontal   : "1",
                .vertical     : "2",
                .leftFalling  : "3",
                .rightFalling : "4",
                .turning      : "5",
                .wildcard     : "6"
        ]
}

extension StrokeVirtualKey {

        public static func displayText<T: RandomAccessCollection<VirtualInputKey>>(from keys: T) -> String {
                return keys.compactMap(\.strokeKey?.strokeText).joined()
        }
        public var strokeText: String? {
                return Self.displayMap[self]
        }
        private static let displayMap: [StrokeVirtualKey : String] = [
                .horizontal   : "⼀",
                .vertical     : "⼁",
                .leftFalling  : "⼃",
                .rightFalling : "⼂",
                .turning      : "乛",
                .wildcard     : "＊"
        ]

        public var virtualInputKey: VirtualInputKey {
                switch self {
                case .horizontal  : .number1
                case .vertical    : .number2
                case .leftFalling : .number3
                case .rightFalling: .number4
                case .turning     : .number5
                case .wildcard    : .number6
                }
        }

        public static func isValidStrokes<T: RandomAccessCollection<VirtualInputKey>>(_ keys: T) -> Bool {
                return keys.contains(where: { $0.strokeKey == nil }).negative
        }
}

extension VirtualInputKey {
        var strokeKey: StrokeVirtualKey? {
                return Self.keyMap[self]
        }
        private static let keyMap: [VirtualInputKey : StrokeVirtualKey] = [
                .letterW : .horizontal,
                .letterH : .horizontal,
                .letterT : .horizontal,
                .letterS : .vertical,
                .letterA : .leftFalling,
                .letterP : .leftFalling,
                .letterD : .rightFalling,
                .letterN : .rightFalling,
                .letterZ : .turning,
                .letterX : .wildcard,

                .letterJ : .horizontal,
                .letterK : .vertical,
                .letterL : .leftFalling,
                .letterU : .rightFalling,
                .letterI : .turning,
                .letterO : .wildcard,

                .number1 : .horizontal,
                .number2 : .vertical,
                .number3 : .leftFalling,
                .number4 : .rightFalling,
                .number5 : .turning,
                .number6 : .wildcard,
        ]
}

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
