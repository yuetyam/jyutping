struct CoreLexicon: Hashable {

        /// Input text for the lexicon
        let input: String

        /// Lexicon text for the input
        let text: String
}


/// CoreIME Engine Candidate
public struct CoreCandidate: Hashable {

        /// Candidate word
        public let text: String

        /// Jyutping
        public let romanization: String

        /// Input text for this Candidate
        public let input: String

        /// Create a CoreCandidate
        /// - Parameters:
        ///   - text: Candidate word
        ///   - romanization: Jyutping
        ///   - input: Input text for this Candidate
        init(text: String, romanization: String, input: String) {
                self.text = text
                self.romanization = romanization
                self.input = input
        }

        /// Romanization without tones
        private var syllables: String {
                return romanization.removedTones()
        }

        // Equatable
        public static func ==(lhs: CoreCandidate, rhs: CoreCandidate) -> Bool {
                return lhs.text == rhs.text && lhs.syllables == rhs.syllables
        }

        // Hashable
        public func hash(into hasher: inout Hasher) {
                hasher.combine(text)
                hasher.combine(syllables)
        }

        static func +(lhs: CoreCandidate, rhs: CoreCandidate) -> CoreCandidate {
                let newText: String = lhs.text + rhs.text
                let newRomanization: String = lhs.romanization + String.space + rhs.romanization
                let newInput: String = lhs.input + rhs.input
                let newCandidate: CoreCandidate = CoreCandidate(text: newText, romanization: newRomanization, input: newInput)
                return newCandidate
        }
}

