struct CoreLexicon: Hashable {

        /// Input text for the lexicon
        let input: String

        /// Lexicon text for the input
        let text: String
}


public enum CandidateType {
        case cantonese
        case specialMark
        case emoji
        case symbol
}


public struct Candidate: Hashable {

        /// Displaying Candidate text
        public let text: String

        /// Jyutping
        public let romanization: String

        /// User input
        public let input: String

        /// Candidate text for UserLexicon Entry.
        ///
        /// Always be traditional characters. User invisible.
        public let lexiconText: String

        /// Candidate Type
        public let type: CandidateType

        /// Primary initializer of Candidate
        /// - Parameters:
        ///   - text: Candidate word.
        ///   - romanization: Jyutping.
        ///   - input: User input for this Candidate.
        ///   - lexiconText: Lexicon Entry Cantonese word. User invisible.
        public init(text: String, romanization: String, input: String, lexiconText: String) {
                self.text = text
                self.romanization = romanization
                self.input = input
                self.lexiconText = lexiconText
                self.type = .cantonese
        }

        /// Create a Candidate with special mark text
        /// - Parameter mark: Special mark. Examples: iPhone, GitHub
        init(mark: String) {
                self.text = mark
                self.romanization = mark
                self.input = mark
                self.lexiconText = mark
                self.type = .specialMark
        }

        /// Create a Candidate with Emoji
        /// - Parameters:
        ///   - emoji: Emoji
        ///   - cantonese: Cantonese word for this Emoji
        ///   - romanization: Romanization (Jyutping) of Cantonese word
        ///   - input: User input
        init(emoji: String, cantonese: String, romanization: String, input: String) {
                self.text = emoji
                self.romanization = romanization
                self.input = input
                self.lexiconText = cantonese
                self.type = .emoji
        }

        /// Create a Candidate with symbol
        public init(symbol: String, comment: String?, secondaryComment: String?) {
                let commentText: String = comment ?? ""
                let secondaryCommentText: String = secondaryComment ?? ""
                self.text = symbol
                self.romanization = secondaryCommentText
                self.input = commentText
                self.lexiconText = commentText
                self.type = .symbol
        }

        /// type == .cantonese
        public var isCantonese: Bool {
                return self.type == .cantonese
        }

        /// Romanization without tones
        private var syllables: String {
                return romanization.removedTones()
        }

        // Equatable
        public static func ==(lhs: Candidate, rhs: Candidate) -> Bool {
                return lhs.text == rhs.text && lhs.syllables == rhs.syllables
        }

        // Hashable
        public func hash(into hasher: inout Hasher) {
                hasher.combine(text)
                hasher.combine(syllables)
        }

        public static func +(lhs: Candidate, rhs: Candidate) -> Candidate {
                let newText: String = lhs.text + rhs.text
                let newRomanization: String = lhs.romanization + String.space + rhs.romanization
                let newInput: String = lhs.input + rhs.input
                let newLexiconText: String = lhs.lexiconText + rhs.lexiconText
                let newCandidate: Candidate = Candidate(text: newText, romanization: newRomanization, input: newInput, lexiconText: newLexiconText)
                return newCandidate
        }
}


extension Array where Element == Candidate {

        /// Returns a new Candidate by concatenating the candidates of the sequence.
        /// - Returns: Single, concatenated Candidate.
        public func joined() -> Candidate {
                let text: String = map({ $0.text }).joined()
                let romanization: String = map({ $0.romanization }).joined(separator: String.space)
                let input: String = map({ $0.input }).joined()
                let lexiconText: String = map({ $0.lexiconText }).joined()
                let candidate: Candidate = Candidate(text: text, romanization: romanization, input: input, lexiconText: lexiconText)
                return candidate
        }
}


typealias CoreCandidate = Candidate

extension CoreCandidate {

        /// Create a CoreCandidate
        /// - Parameters:
        ///   - text: Candidate word
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

