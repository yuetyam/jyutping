struct Candidate: Hashable {

        /// Candidate word.
        ///
        /// Cloud be traditional or simplified characters, depends on `logogram` settings.
        let text: String

        /// Jyutping
        let footnote: String

        /// User input
        let input: String

        /// Lexicon Entry Cantonese word.
        ///
        /// Always be traditional characters. User invisible.
        let lexiconText: String

        /// Row number in database
        let ranking: Int

        /// Candidate
        /// - Parameters:
        ///   - text: Candidate word.
        ///   - footnote: Word's Jyutping.
        ///   - input: User input for this Candidate.
        ///   - lexiconText: Lexicon Entry Cantonese word. User invisible.
        ///   - ranking: Row number in database.
        init(text: String, footnote: String, input: String, lexiconText: String, ranking: Int = 0) {
                self.text = text
                self.footnote = footnote
                self.input = input
                self.lexiconText = lexiconText
                self.ranking = ranking
        }

        // Equatable
        static func == (lhs: Candidate, rhs: Candidate) -> Bool {
                return lhs.text == rhs.text &&
                        lhs.footnote.filter({!$0.isNumber}) == rhs.footnote.filter({!$0.isNumber})
        }

        // Hashable
        func hash(into hasher: inout Hasher) {
                hasher.combine(text)
                hasher.combine(footnote.filter({!$0.isNumber}))
        }

        static func + (lhs: Candidate, rhs: Candidate) -> Candidate {
                let newText: String = lhs.text + rhs.text
                let newFootnote: String = lhs.footnote + " " + rhs.footnote
                let newInput: String = lhs.input + rhs.input
                let newLexiconText: String = lhs.lexiconText + rhs.lexiconText

                let newCandidate: Candidate = Candidate(text: newText,
                                                        footnote: newFootnote,
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
                let footnote: String = map({ $0.footnote }).joined(separator: " ")
                let input: String = map({ $0.input }).joined()
                let lexiconText: String = map({ $0.lexiconText }).joined()
                let candidate: Candidate = Candidate(text: text, footnote: footnote, input: input, lexiconText: lexiconText)
                return candidate
        }
}
