struct Candidate: Hashable {

        /// Candidate word.
        ///
        /// Cloud be traditional or simplified characters, depends on `logogram` settings.
        let text: String

        /// Word's Jyutping
        let jyutping: String

        /// User input
        let input: String

        /// Lexicon Entry Cantonese word.
        ///
        /// Always be traditional characters. User invisible.
        let lexiconText: String

        /// Candidate
        /// - Parameters:
        ///   - text: Candidate word.
        ///   - jyutping: Word's Jyutping.
        ///   - input: User input for this Candidate.
        ///   - lexiconText: Lexicon Entry Cantonese word. User invisible.
        init(text: String, jyutping: String, input: String, lexiconText: String) {
                self.text = text
                self.jyutping = jyutping
                self.input = input
                self.lexiconText = lexiconText
        }

        // Equatable
        static func == (lhs: Candidate, rhs: Candidate) -> Bool {
                return lhs.text == rhs.text &&
                        lhs.jyutping.removedTones() == rhs.jyutping.removedTones()
        }

        // Hashable
        func hash(into hasher: inout Hasher) {
                hasher.combine(text)
                hasher.combine(jyutping.removedTones())
        }

        static func + (lhs: Candidate, rhs: Candidate) -> Candidate {
                let newText: String = lhs.text + rhs.text
                let newJyutping: String = lhs.jyutping + .space + rhs.jyutping
                let newInput: String = lhs.input + rhs.input
                let newLexiconText: String = lhs.lexiconText + rhs.lexiconText

                let newCandidate: Candidate = Candidate(text: newText,
                                                        jyutping: newJyutping,
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
        /// - Returns: A single, concatenated Candidate.
        func joined() -> Candidate {
                let text: String = map({ $0.text }).joined()
                let jyutping: String = map({ $0.jyutping }).joined(separator: .space)
                let input: String = map({ $0.input }).joined()
                let lexiconText: String = map({ $0.lexiconText }).joined()
                let candidate: Candidate = Candidate(text: text, jyutping: jyutping, input: input, lexiconText: lexiconText)
                return candidate
        }
}
