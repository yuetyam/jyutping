/// Input key; Input method processing event
public struct InputEvent: Hashable, Identifiable, Comparable, Sendable {

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
        public static func ==(lhs: InputEvent, rhs: InputEvent) -> Bool {
                return lhs.code == rhs.code
        }

        // Hashable
        public func hash(into hasher: inout Hasher) {
                hasher.combine(code)
        }

        // Comparable
        public static func < (lhs: InputEvent, rhs: InputEvent) -> Bool {
                return lhs.code < rhs.code
        }

        public static let number0 = InputEvent(text: "0", code: 10, keyCode: 0x1D)
        public static let number1 = InputEvent(text: "1", code: 11, keyCode: 0x12)
        public static let number2 = InputEvent(text: "2", code: 12, keyCode: 0x13)
        public static let number3 = InputEvent(text: "3", code: 13, keyCode: 0x14)
        public static let number4 = InputEvent(text: "4", code: 14, keyCode: 0x15)
        public static let number5 = InputEvent(text: "5", code: 15, keyCode: 0x17)
        public static let number6 = InputEvent(text: "6", code: 16, keyCode: 0x16)
        public static let number7 = InputEvent(text: "7", code: 17, keyCode: 0x1A)
        public static let number8 = InputEvent(text: "8", code: 18, keyCode: 0x1C)
        public static let number9 = InputEvent(text: "9", code: 19, keyCode: 0x19)

        public static let letterA = InputEvent(text: "a", code: 20, keyCode: 0x00)
        public static let letterB = InputEvent(text: "b", code: 21, keyCode: 0x0B)
        public static let letterC = InputEvent(text: "c", code: 22, keyCode: 0x08)
        public static let letterD = InputEvent(text: "d", code: 23, keyCode: 0x02)
        public static let letterE = InputEvent(text: "e", code: 24, keyCode: 0x0E)
        public static let letterF = InputEvent(text: "f", code: 25, keyCode: 0x03)
        public static let letterG = InputEvent(text: "g", code: 26, keyCode: 0x05)
        public static let letterH = InputEvent(text: "h", code: 27, keyCode: 0x04)
        public static let letterI = InputEvent(text: "i", code: 28, keyCode: 0x22)
        public static let letterJ = InputEvent(text: "j", code: 29, keyCode: 0x26)
        public static let letterK = InputEvent(text: "k", code: 30, keyCode: 0x28)
        public static let letterL = InputEvent(text: "l", code: 31, keyCode: 0x25)
        public static let letterM = InputEvent(text: "m", code: 32, keyCode: 0x2E)
        public static let letterN = InputEvent(text: "n", code: 33, keyCode: 0x2D)
        public static let letterO = InputEvent(text: "o", code: 34, keyCode: 0x1F)
        public static let letterP = InputEvent(text: "p", code: 35, keyCode: 0x23)
        public static let letterQ = InputEvent(text: "q", code: 36, keyCode: 0x0C)
        public static let letterR = InputEvent(text: "r", code: 37, keyCode: 0x0F)
        public static let letterS = InputEvent(text: "s", code: 38, keyCode: 0x01)
        public static let letterT = InputEvent(text: "t", code: 39, keyCode: 0x11)
        public static let letterU = InputEvent(text: "u", code: 40, keyCode: 0x20)
        public static let letterV = InputEvent(text: "v", code: 41, keyCode: 0x09)
        public static let letterW = InputEvent(text: "w", code: 42, keyCode: 0x0D)
        public static let letterX = InputEvent(text: "x", code: 43, keyCode: 0x07)
        public static let letterY = InputEvent(text: "y", code: 44, keyCode: 0x10)
        public static let letterZ = InputEvent(text: "z", code: 45, keyCode: 0x06)

        /// Separator; Delimiter; Apostrophe
        public static let quote = InputEvent(text: "\u{27}", code: 47, keyCode: 0x27)

        /// Grave accent; Backtick; Backquote
        public static let grave = InputEvent(text: "\u{60}", code: 48, keyCode: 0x32)
}

extension InputEvent {

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

        /// r, v, x, q
        public var isReverseLookupTrigger: Bool {
                switch self {
                case .letterR, .letterV, .letterX, .letterQ: true
                default: false
                }
        }

        /// Separator; Delimiter; Apostrophe
        public var isQuote: Bool {
                return self == Self.quote
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

extension InputEvent {
        public static func isMatchedNumber(keyCode: UInt16) -> Bool {
                return digitSet.contains(where: { $0.keyCode == keyCode })
        }
        public static func isMatchedLetter(keyCode: UInt16) -> Bool {
                return alphabetSet.contains(where: { $0.keyCode == keyCode })
        }
        public static func matchEvent(for keyCode: UInt16) -> InputEvent? {
                switch keyCode {
                case InputEvent.quote.keyCode:
                        return .quote
                case InputEvent.grave.keyCode:
                        return .grave
                default:
                        return alphabetSet.first(where: { $0.keyCode == keyCode }) ?? digitSet.first(where: { $0.keyCode == keyCode })
                }
        }
        public static func matchInputEvent(for code: Int) -> InputEvent? {
                return alphabetSet.first(where: { $0.code == code }) ?? digitSet.first(where: { $0.code == code })
        }
        public static func matchInputEvent(for character: Character) -> InputEvent? {
                guard let code = character.inputEventCode else { return nil }
                return alphabetSet.first(where: { $0.code == code }) ?? digitSet.first(where: { $0.code == code })
        }

        public static let GWEvents: [InputEvent] = [letterG, letterW]
        public static let KWEvents: [InputEvent] = [letterK, letterW]
}

extension RandomAccessCollection where Element == InputEvent {
        var combinedCode: Int {
                guard self.count < 10 else { return 0 }
                return reduce(0, { $0 * 100 + $1.code })
        }
        var anchorsCode: Int {
                return map({ $0 == InputEvent.letterY ? InputEvent.letterJ : $0 }).combinedCode
        }
}

extension Int {
        var matchedInputEvents: [InputEvent] {
                var number = self
                var codes: [Int] = []
                while number > 0 {
                        codes.append(number % 100)
                        number /= 100
                }
                return codes.reversed().compactMap(InputEvent.matchInputEvent(for:))
        }
}

extension InputEvent {

        /// Digit numbers [0-9]
        public static let digitSet: Set<InputEvent> = [
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
        public static let toneSet: Set<InputEvent> = [
                number1,
                number2,
                number3,
                number4,
                number5,
                number6
        ]

        /// Letters [a-z]
        public static let alphabetSet: Set<InputEvent> = [
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
