struct Candidate: Hashable {

        /// Candidate word.
        ///
        /// Cloud be traditional or simplified characters, depends on `logogram` settings.
        let text: String

        /// Jyutping
        let romanization: String

        /// User input
        let input: String

        /// Lexicon Entry Cantonese word.
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
        init(text: String, romanization: String, input: String, lexiconText: String, type: CandidateType = .cantonese) {
                self.text = text
                self.romanization = romanization
                self.input = input
                self.lexiconText = lexiconText
                self.type = type
        }

        /// Create a Candidate with trademark text
        /// - Parameters:
        ///   - trademark: Trademark text. Examples: iPhone, GitHub
        init(trademark: String) {
                self.init(text: trademark, romanization: String.empty, input: String.empty, lexiconText: String.empty, type: .trademark)
        }

        // Equatable
        static func ==(lhs: Candidate, rhs: Candidate) -> Bool {
                return lhs.text == rhs.text && lhs.romanization.removedTones() == rhs.romanization.removedTones()
        }

        // Hashable
        func hash(into hasher: inout Hasher) {
                hasher.combine(text)
                hasher.combine(romanization.removedTones())
        }

        static func +(lhs: Candidate, rhs: Candidate) -> Candidate {
                let newText: String = lhs.text + rhs.text
                let newRomanization: String = lhs.romanization + String.space + rhs.romanization
                let newInput: String = lhs.input + rhs.input
                let newLexiconText: String = lhs.lexiconText + rhs.lexiconText

                let newCandidate: Candidate = Candidate(text: newText,
                                                        romanization: newRomanization,
                                                        input: newInput,
                                                        lexiconText: newLexiconText)
                return newCandidate
        }

        static func += (lhs: inout Candidate, rhs: Candidate) {
                return lhs = lhs + rhs
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

