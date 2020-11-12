struct Candidate: Hashable {
        
        /// Displaying Cantonese word.
        ///
        /// Cloud be traditional or simplified characters, depends on `logogram` setting.
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
        ///   - text: Displaying Cantonese word.
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
                return lhs.text == rhs.text
        }
        
        // Hashable
        func hash(into hasher: inout Hasher) {
                hasher.combine(text)
        }
        
        static func + (lhs: Candidate, rhs: Candidate) -> Candidate {
                let newText: String = lhs.text + rhs.text
                let newFootnote: String = lhs.footnote + " " + rhs.footnote
                let newInput: String = lhs.input + rhs.input
                let newLexiconText: String = lhs.lexiconText + rhs.lexiconText
                // let newRanking: Int = min(lhs.ranking, rhs.ranking)
                
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
