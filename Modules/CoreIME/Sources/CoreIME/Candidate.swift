public enum CandidateType: Int {

        case cantonese

        /// Examples: iPad, macOS
        case specialMark

        case emoji

        /// Note that `text.count == 1` not always true
        case symbol

        /// macOS Keyboard composed text
        case compose
}

public struct Candidate: Hashable {

        /// Displaying Candidate text
        public let text: String

        /// Jyutping
        public let romanization: String

        /// User input
        public let input: String

        /// Candidate text for UserLexicon.
        ///
        /// Always traditional characters. User invisible.
        public let lexiconText: String

        /// Candidate Type
        public let type: CandidateType

        /// Create a Cantonese Candidate
        /// - Parameters:
        ///   - text: Displaying Candidate text.
        ///   - romanization: Jyutping.
        ///   - input: User input for this Candidate.
        ///   - lexiconText: Lexicon Candidate text. User invisible.
        public init(text: String, romanization: String, input: String, lexiconText: String) {
                self.text = text
                self.romanization = romanization
                self.input = input
                self.lexiconText = lexiconText
                self.type = .cantonese
        }

        /// Create a Candidate with special mark text
        /// - Parameters:
        ///   - mark: Special mark text. Examples: iPhone, GitHub
        ///   - input: User input for this Candidate
        init(mark: String, input: String) {
                self.text = mark
                self.romanization = input
                self.input = input
                self.lexiconText = mark
                self.type = .specialMark
        }

        /// Create a Candidate with a emoji or a symbol
        /// - Parameters:
        ///   - symbol: Emoji/Symbol text
        ///   - cantonese: Cantonese word for this Emoji/Symbol
        ///   - romanization: Romanization (Jyutping) of Cantonese word
        ///   - input: User input for this Candidate
        ///   - isEmoji: Emoji or symbol
        init(symbol: String, cantonese: String, romanization: String, input: String, isEmoji: Bool) {
                self.text = symbol
                self.romanization = romanization
                self.input = input
                self.lexiconText = cantonese
                self.type = isEmoji ? .emoji : .symbol
        }

        /// Create a Candidate for keyboard compose
        /// - Parameters:
        ///   - text: Symbol text for this key compose
        ///   - comment: Name comment of this key symbol
        ///   - secondaryComment: Unicode code point
        ///   - input: User input for this Candidate
        public init(text: String, comment: String?, secondaryComment: String?, input: String) {
                let commentText: String = comment ?? ""
                let secondaryCommentText: String = secondaryComment ?? ""
                self.text = text
                self.romanization = secondaryCommentText
                self.input = input
                self.lexiconText = commentText
                self.type = .compose
        }

        /// type == .cantonese
        public var isCantonese: Bool {
                return self.type == .cantonese
        }

        // Equatable
        public static func ==(lhs: Candidate, rhs: Candidate) -> Bool {
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
                case .specialMark:
                        hasher.combine(text)
                case .emoji:
                        hasher.combine(text)
                case .symbol:
                        hasher.combine(text)
                case .compose:
                        hasher.combine(text)
                }
        }

        public static func +(lhs: Candidate, rhs: Candidate) -> Candidate {
                let newText: String = lhs.text + rhs.text
                let newRomanization: String = lhs.romanization + " " + rhs.romanization
                let newInput: String = lhs.input + rhs.input
                let newLexiconText: String = lhs.lexiconText + rhs.lexiconText
                return Candidate(text: newText, romanization: newRomanization, input: newInput, lexiconText: newLexiconText)
        }
}

extension Array where Element == Candidate {

        /// Returns a new Candidate by concatenating this Candidate sequence.
        /// - Returns: Single, concatenated Candidate.
        public func joined() -> Candidate {
                let text: String = map(\.text).joined()
                let romanization: String = map(\.romanization).joined(separator: " ")
                let input: String = map(\.input).joined()
                let lexiconText: String = map(\.lexiconText).joined()
                return Candidate(text: text, romanization: romanization, input: input, lexiconText: lexiconText)
        }
}

typealias CoreCandidate = Candidate

extension CoreCandidate {

        /// Create a Cantonese Candidate
        /// - Parameters:
        ///   - text: Candidate word, also as lexiconText
        ///   - romanization: Jyutping
        ///   - input: Input text for this Candidate
        init(text: String, romanization: String, input: String) {
                self.text = text
                self.romanization = romanization
                self.input = input
                self.lexiconText = text
                self.type = .cantonese
        }
}
