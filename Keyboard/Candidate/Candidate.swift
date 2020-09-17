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
        
        init(text: String, footnote: String, input: String, lexiconText: String = "") {
                self.text = text
                self.footnote = footnote
                self.input = input
                self.lexiconText = lexiconText.isEmpty ? text : lexiconText
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
                let newCandidate: Candidate = Candidate(text: newText, footnote: newFootnote, input: newInput)
                return newCandidate
        }
        
        static func += (lhs: inout Candidate, rhs: Candidate) {
                return lhs = lhs + rhs
        }
}
