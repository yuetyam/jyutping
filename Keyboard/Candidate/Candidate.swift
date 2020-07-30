struct Candidate: Hashable, CustomStringConvertible {
        
        let text: String
        let footnote: String
        let input: String?
        
        var count: Int {
                return text.count
        }
        
        var description: String {
                return text
        }
        
        init(text: String, footnote: String = "", input: String? = nil) {
                self.text = text
                self.footnote = footnote
                self.input = input
        }
        
        // Equatable
        static func == (lhs: Candidate, rhs: Candidate) -> Bool {
                return lhs.text == rhs.text
        }
        
        // Hashable
        func hash(into hasher: inout Hasher) {
                hasher.combine(text)
        }
}
