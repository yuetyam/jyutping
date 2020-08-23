struct Candidate: Hashable {
        
        let text: String
        let footnote: String
        let input: String
        
        var count: Int {
                return text.count
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
}
