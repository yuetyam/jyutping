import CommonExtensions

/// CommentForm
public enum RomanizationForm: Int, Sendable {

        /// Regular
        case full = 1

        /// Tone-free
        case toneless = 2

        /// Empty
        case nothing = 3
}

/// Display Candidate
public struct Candidate: Hashable, Sendable {

        /// Cantonese word, emoji, symbol, or plain text.
        public let text: String

        /// Romanization (Jyutping) or annotation.
        public let comment: String?

        /// Extra annotation, mainly for macOS `composed` candidates.
        public let secondaryComment: String?

        /// Internal candidate lexicon.
        public let lexicon: Lexicon

        public init(text: String, lexicon: Lexicon, commentForm: RomanizationForm = .full, charset: CharacterStandard = .preset) {
                self.text = text
                self.lexicon = lexicon
                switch lexicon.type {
                case .cantonese:
                        self.comment = switch commentForm {
                        case .full: lexicon.romanization
                        case .toneless: lexicon.romanization.filter(\.isCantoneseToneDigit.negative)
                        case .nothing: nil
                        }
                        self.secondaryComment = nil
                case .text:
                        self.comment = nil
                        self.secondaryComment = nil
                case .emoji, .symbol:
                        #if os(iOS)
                        self.comment = nil
                        #else
                        if let cantonese = lexicon.attached, cantonese.isNotEmpty {
                                self.comment = String.openingParenthesis + Converter.convert(cantonese, to: charset) + String.closingParenthesis
                        } else {
                                self.comment = nil
                        }
                        #endif
                        self.secondaryComment = nil
                case .composed:
                        if let cantonese = lexicon.attached, cantonese.isNotEmpty {
                                self.comment = Converter.convert(cantonese, to: charset)
                        } else {
                                self.comment = nil
                        }
                        let codePoint = lexicon.romanization
                        self.secondaryComment = codePoint.isEmpty ? nil : codePoint
                }
        }

        // Equatable
        public static func == (lhs: Candidate, rhs: Candidate) -> Bool {
                #if os(iOS)
                return lhs.text == rhs.text && lhs.comment == rhs.comment
                #else
                if lhs.lexicon.isEmojiOrSymbol && rhs.lexicon.isEmojiOrSymbol {
                        return lhs.text == rhs.text
                } else {
                        return lhs.text == rhs.text && lhs.comment == rhs.comment
                }
                #endif
        }

        // Hashable
        public func hash(into hasher: inout Hasher) {
                #if os(iOS)
                hasher.combine(text)
                hasher.combine(comment)
                #else
                if lexicon.isEmojiOrSymbol {
                        hasher.combine(text)
                } else {
                        hasher.combine(text)
                        hasher.combine(comment)
                }
                #endif
        }

        public var isCantonese: Bool { lexicon.isCantonese }
        public var isNotCantonese: Bool { lexicon.isNotCantonese }
}
