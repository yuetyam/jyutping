enum CandidateType {
        case cantonese
        case specialMark
        case emoji
}


struct Candidate: Hashable {

        /// Displaying Candidate text
        let text: String

        /// Jyutping
        let romanization: String

        /// User input
        let input: String

        /// Candidate text for UserLexicon Entry.
        ///
        /// Always be traditional characters. User invisible.
        let lexiconText: String

        /// Candidate Type
        let type: CandidateType

        /// Primary initializer of Candidate
        /// - Parameters:
        ///   - text: Candidate word.
        ///   - romanization: Jyutping.
        ///   - input: User input for this Candidate.
        ///   - lexiconText: Lexicon Entry Cantonese word. User invisible.
        init(text: String, romanization: String, input: String, lexiconText: String) {
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

        var isCantonese: Bool {
                return self.type == .cantonese
        }

        /// Romanization without tones
        private var syllables: String {
                return romanization.removedTones()
        }

        // Equatable
        static func ==(lhs: Candidate, rhs: Candidate) -> Bool {
                return lhs.text == rhs.text && lhs.syllables == rhs.syllables
        }

        // Hashable
        func hash(into hasher: inout Hasher) {
                hasher.combine(text)
                hasher.combine(syllables)
        }

        static func +(lhs: Candidate, rhs: Candidate) -> Candidate {
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
        func joined() -> Candidate {
                let text: String = map({ $0.text }).joined()
                let romanization: String = map({ $0.romanization }).joined(separator: String.space)
                let input: String = map({ $0.input }).joined()
                let lexiconText: String = map({ $0.lexiconText }).joined()
                let candidate: Candidate = Candidate(text: text, romanization: romanization, input: input, lexiconText: lexiconText)
                return candidate
        }
}

