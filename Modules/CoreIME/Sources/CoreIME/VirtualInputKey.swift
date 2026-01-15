public struct VirtualInputKey: Hashable, Identifiable, Comparable, Sendable {

        /// Key text
        public let text: String

        /// Unique identifier code
        public let code: Int

        /// Virtual KeyCode from Mac OS X Carbon HIToolbox/Events.h
        public let keyCode: UInt16

        /// Identifiable. Same value as the `code`
        public let id: Int

        private init(text: String, code: Int, keyCode: UInt16) {
                self.text = text
                self.code = code
                self.keyCode = keyCode
                self.id = code
        }

        // Equatable
        public static func ==(lhs: VirtualInputKey, rhs: VirtualInputKey) -> Bool {
                return lhs.code == rhs.code
        }

        // Hashable
        public func hash(into hasher: inout Hasher) {
                hasher.combine(code)
        }

        // Comparable
        public static func < (lhs: VirtualInputKey, rhs: VirtualInputKey) -> Bool {
                return lhs.code < rhs.code
        }

        public static let number0 = VirtualInputKey(text: "0", code: 10, keyCode: 0x1D)
        public static let number1 = VirtualInputKey(text: "1", code: 11, keyCode: 0x12)
        public static let number2 = VirtualInputKey(text: "2", code: 12, keyCode: 0x13)
        public static let number3 = VirtualInputKey(text: "3", code: 13, keyCode: 0x14)
        public static let number4 = VirtualInputKey(text: "4", code: 14, keyCode: 0x15)
        public static let number5 = VirtualInputKey(text: "5", code: 15, keyCode: 0x17)
        public static let number6 = VirtualInputKey(text: "6", code: 16, keyCode: 0x16)
        public static let number7 = VirtualInputKey(text: "7", code: 17, keyCode: 0x1A)
        public static let number8 = VirtualInputKey(text: "8", code: 18, keyCode: 0x1C)
        public static let number9 = VirtualInputKey(text: "9", code: 19, keyCode: 0x19)

        public static let letterA = VirtualInputKey(text: "a", code: 20, keyCode: 0x00)
        public static let letterB = VirtualInputKey(text: "b", code: 21, keyCode: 0x0B)
        public static let letterC = VirtualInputKey(text: "c", code: 22, keyCode: 0x08)
        public static let letterD = VirtualInputKey(text: "d", code: 23, keyCode: 0x02)
        public static let letterE = VirtualInputKey(text: "e", code: 24, keyCode: 0x0E)
        public static let letterF = VirtualInputKey(text: "f", code: 25, keyCode: 0x03)
        public static let letterG = VirtualInputKey(text: "g", code: 26, keyCode: 0x05)
        public static let letterH = VirtualInputKey(text: "h", code: 27, keyCode: 0x04)
        public static let letterI = VirtualInputKey(text: "i", code: 28, keyCode: 0x22)
        public static let letterJ = VirtualInputKey(text: "j", code: 29, keyCode: 0x26)
        public static let letterK = VirtualInputKey(text: "k", code: 30, keyCode: 0x28)
        public static let letterL = VirtualInputKey(text: "l", code: 31, keyCode: 0x25)
        public static let letterM = VirtualInputKey(text: "m", code: 32, keyCode: 0x2E)
        public static let letterN = VirtualInputKey(text: "n", code: 33, keyCode: 0x2D)
        public static let letterO = VirtualInputKey(text: "o", code: 34, keyCode: 0x1F)
        public static let letterP = VirtualInputKey(text: "p", code: 35, keyCode: 0x23)
        public static let letterQ = VirtualInputKey(text: "q", code: 36, keyCode: 0x0C)
        public static let letterR = VirtualInputKey(text: "r", code: 37, keyCode: 0x0F)
        public static let letterS = VirtualInputKey(text: "s", code: 38, keyCode: 0x01)
        public static let letterT = VirtualInputKey(text: "t", code: 39, keyCode: 0x11)
        public static let letterU = VirtualInputKey(text: "u", code: 40, keyCode: 0x20)
        public static let letterV = VirtualInputKey(text: "v", code: 41, keyCode: 0x09)
        public static let letterW = VirtualInputKey(text: "w", code: 42, keyCode: 0x0D)
        public static let letterX = VirtualInputKey(text: "x", code: 43, keyCode: 0x07)
        public static let letterY = VirtualInputKey(text: "y", code: 44, keyCode: 0x10)
        public static let letterZ = VirtualInputKey(text: "z", code: 45, keyCode: 0x06)

        /// Separator; Delimiter; Quote
        public static let apostrophe = VirtualInputKey(text: "\u{27}", code: 47, keyCode: 0x27)

        /// Grave accent; Backtick; Backquote
        public static let grave = VirtualInputKey(text: "\u{60}", code: 48, keyCode: 0x32)
}

extension VirtualInputKey {

        /// Digits [0-9]
        public var isNumber: Bool {
                return Self.digitSet.contains(self)
        }

        /// Cantonese tone digits [1-6]
        public var isToneNumber: Bool {
                return Self.toneSet.contains(self)
        }

        /// Letters [a-z]
        public var isLetter: Bool {
                return Self.alphabetSet.contains(self)
        }

        /// Letters [a-z] excluded tone letters [vxq]
        public var isSyllableLetter: Bool {
                return isLetter && !(isToneLetter)
        }

        /// v, x, q
        public var isToneLetter: Bool {
                switch self {
                case .letterV, .letterX, .letterQ: true
                default: false
                }
        }

        /// v, x, q, [1-6]
        public var isToneInputKey: Bool {
                return isToneLetter || isToneNumber
        }

        /// r, v, x, q
        public var isReverseLookupTrigger: Bool {
                switch self {
                case .letterR, .letterV, .letterX, .letterQ: true
                default: false
                }
        }

        /// Separator; Delimiter; Quote
        public var isApostrophe: Bool {
                return self == Self.apostrophe
        }

        /// Grave accent; Backtick; Backquote
        public var isGrave: Bool {
                return self == Self.grave
        }

        /// Integer number of the number key
        public var digit: Int? {
                guard isNumber else { return nil }
                return self.code - 10
        }
}

extension VirtualInputKey {
        public static func isMatchedNumber(keyCode: UInt16) -> Bool {
                return digitSet.contains(where: { $0.keyCode == keyCode })
        }
        public static func isMatchedLetter(keyCode: UInt16) -> Bool {
                return alphabetSet.contains(where: { $0.keyCode == keyCode })
        }
        public static func matchInputKey(for keyCode: UInt16) -> VirtualInputKey? {
                switch keyCode {
                case VirtualInputKey.apostrophe.keyCode:
                        return .apostrophe
                case VirtualInputKey.grave.keyCode:
                        return .grave
                default:
                        return alphabetSet.first(where: { $0.keyCode == keyCode }) ?? digitSet.first(where: { $0.keyCode == keyCode })
                }
        }
        public static func matchInputKey(for code: Int) -> VirtualInputKey? {
                return alphabetSet.first(where: { $0.code == code }) ?? digitSet.first(where: { $0.code == code })
        }
        public static func matchInputKey(for character: Character) -> VirtualInputKey? {
                guard let code = character.virtualKeyInputCode else { return nil }
                return alphabetSet.first(where: { $0.code == code }) ?? digitSet.first(where: { $0.code == code })
        }

        public static let GWInputKeys: [VirtualInputKey] = [letterG, letterW]
        public static let KWInputKeys: [VirtualInputKey] = [letterK, letterW]
}

extension RandomAccessCollection where Element == VirtualInputKey {
        /// radix100Combined
        var combinedCode: Int {
                guard count < 10 else { return 0 }
                return reduce(0, { $0 * 100 + $1.code })
        }
        var anchorsCode: Int {
                return map({ $0 == VirtualInputKey.letterY ? VirtualInputKey.letterJ : $0 }).combinedCode
        }
}

extension Int {
        var matchedInputKeys: [VirtualInputKey] {
                var number = self
                var codes: [Int] = []
                while number > 0 {
                        codes.append(number % 100)
                        number /= 100
                }
                return codes.reversed().compactMap(VirtualInputKey.matchInputKey(for:))
        }
}

extension VirtualInputKey {

        /// Digit numbers [0-9]
        public static let digitSet: Set<VirtualInputKey> = [
                number0,
                number1,
                number2,
                number3,
                number4,
                number5,
                number6,
                number7,
                number8,
                number9
        ]

        /// Cantonese tone digits [1-6]
        public static let toneSet: Set<VirtualInputKey> = [
                number1,
                number2,
                number3,
                number4,
                number5,
                number6
        ]

        /// Letters [a-z]
        public static let alphabetSet: Set<VirtualInputKey> = [
                letterA,
                letterB,
                letterC,
                letterD,
                letterE,
                letterF,
                letterG,
                letterH,
                letterI,
                letterJ,
                letterK,
                letterL,
                letterM,
                letterN,
                letterO,
                letterP,
                letterQ,
                letterR,
                letterS,
                letterT,
                letterU,
                letterV,
                letterW,
                letterX,
                letterY,
                letterZ
        ]
}
