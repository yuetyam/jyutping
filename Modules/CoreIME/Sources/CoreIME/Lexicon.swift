import CommonExtensions

public enum LexiconType: Int, Sendable {

        case cantonese

        /// Plain text. Examples: Face ID, SwiftUI, Café
        case text

        /// Note that `Lexicon.text.count == 1` not always true for this type.
        case emoji

        /// Note that `Lexicon.text.count == 1` not always true for this type.
        case symbol

        /// Mac keyboard composed text. Mainly for PunctuationKey.
        case composed
}

public struct Lexicon: Hashable, Comparable, Sendable {

        /// Lexicon type
        public let type: LexiconType

        /// Lexicon text
        public let text: String

        /// Jyutping
        public let romanization: String

        /// User input
        public let input: String

        /// Character count of the `input`
        public let inputCount: Int

        /// Formatted user input for pre-edit display
        public let mark: String

        /// Rank, order. (Smaller is preferred)
        public let number: Int

        /// Extra text to attach to this lexicon
        public let attached: String?

        /// Primary Initializer
        /// - Parameters:
        ///   - type: Lexicon type
        ///   - text: Lexicon text
        ///   - romanization: Jyutping
        ///   - input: User input
        ///   - mark: Formatted user input for pre-edit display
        ///   - number: Rank, order. (Smaller is preferred)
        ///   - attached: Extra text to attach to this lexicon
        public init(type: LexiconType = .cantonese, text: String, romanization: String, input: String, mark: String? = nil, number: Int = 0, attached: String? = nil) {
                self.type = type
                self.text = text
                self.romanization = romanization
                self.input = input
                self.inputCount = input.count
                self.mark = mark ?? input
                self.number = number
                self.attached = attached
        }

        /// `type == .cantonese`
        public var isCantonese: Bool { type == .cantonese }

        /// `type != .cantonese`
        public var isNotCantonese: Bool { type != .cantonese }

        // Equatable
        public static func == (lhs: Lexicon, rhs: Lexicon) -> Bool {
                guard lhs.type == rhs.type else { return false }
                if lhs.isCantonese && rhs.isCantonese {
                        return lhs.text == rhs.text && lhs.romanization == rhs.romanization
                } else {
                        return lhs.text == rhs.text
                }
        }

        // Hashable
        public func hash(into hasher: inout Hasher) {
                switch type {
                case .cantonese:
                        hasher.combine(text)
                        hasher.combine(romanization)
                default:
                        hasher.combine(text)
                }
        }

        // Comparable
        public static func < (lhs: Lexicon, rhs: Lexicon) -> Bool {
                guard lhs.inputCount == rhs.inputCount else { return lhs.inputCount > rhs.inputCount }
                return lhs.number < rhs.number
        }

        // Concatenation
        public static func + (lhs: Lexicon, rhs: Lexicon) -> Lexicon? {
                guard lhs.isCantonese && rhs.isCantonese else { return nil }
                let newText = lhs.text + rhs.text
                let newRomanization = lhs.romanization + String.space + rhs.romanization
                let newInput = lhs.input + rhs.input
                let newMark = lhs.mark + String.space + rhs.mark
                let step: Int = 1_000_000
                let newNumber: Int = (lhs.number + step) + (rhs.number + step)
                return Lexicon(text: newText, romanization: newRomanization, input: newInput, mark: newMark, number: newNumber)
        }
}

extension Lexicon {
        public var isEmojiOrSymbol: Bool {
                switch type {
                case .emoji, .symbol: true
                default: false
                }
        }
        public var isComposed: Bool { type == .composed }

        /// isConcatenated
        public var isCompound: Bool { number > 1_000_000 }

        public var isInputMemory: Bool { number < 0 }
        public var isIdealInputMemory: Bool { number == -1 }
        public var isNotIdealInputMemory: Bool { number == -2 }
}

extension Lexicon {
        public func replacedInput(with newInput: String) -> Lexicon {
                return Lexicon(type: type, text: text, romanization: romanization, input: newInput, mark: mark, number: number, attached: attached)
        }
}

extension RandomAccessCollection where Element == Lexicon {

        /// Concatenate the Lexicon sequence.
        /// - Returns: Compound Lexicon.
        public func joined() -> Lexicon? {
                let isAllCantonese: Bool = contains(where: \.isNotCantonese).negative
                guard isAllCantonese else { return nil }
                let text = map(\.text).joined()
                let romanization = map(\.romanization).joined(separator: String.space)
                let input = map(\.input).joined()
                let mark = map(\.mark).joined(separator: String.space)
                let step: Int = 1_000_000
                let number: Int = map(\.number).reduce(0, { $0 + $1 + step })
                return Lexicon(text: text, romanization: romanization, input: input, mark: mark, number: number)
        }
}

extension Lexicon {

        /// Create a Lexicon which `LexiconType` is `LexiconType.text`
        /// - Parameters:
        ///   - input: User input
        ///   - text: Lexicon text
        init(input: String, text: String) {
                self.type = .text
                self.text = text
                self.romanization = input
                self.input = input
                self.inputCount = input.count
                self.mark = input
                self.number = 0
                self.attached = nil
        }

        /// Create a Lexicon which type is emoji or symbol
        /// - Parameters:
        ///   - symbol: Emoji / symbol text
        ///   - cantonese: Cantonese word for this emoji / symbol. Will be this Lexicon's `attached` text.
        ///   - romanization: Romanization (Jyutping) of Cantonese word
        ///   - input: User input
        ///   - isEmoji: Emoji or symbol
        init(symbol: String, cantonese: String, romanization: String, input: String, isEmoji: Bool) {
                self.type = isEmoji ? .emoji : .symbol
                self.text = symbol
                self.romanization = romanization
                self.input = input
                self.inputCount = input.count
                self.mark = input
                self.number = 0
                self.attached = cantonese
        }

        /// Create a Lexicon for macOS keyboard composed text
        /// - Parameters:
        ///   - text: Lexicon text
        ///   - comment: Comment, annotation
        ///   - secondaryComment: Unicode code point
        ///   - input: User input
        public init(text: String, comment: String?, secondaryComment: String?, input: String) {
                self.type = .composed
                self.text = text
                self.romanization = secondaryComment ?? String.empty
                self.input = input
                self.inputCount = input.count
                self.mark = input
                self.number = 0
                self.attached = comment
        }
}
