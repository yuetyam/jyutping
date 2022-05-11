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


enum CandidateType {
        case cantonese
        case trademark
}


extension Candidate {

        static let trademarks: [String: String] = {


let trademarksText: String = """
iOS
iPadOS
macOS
watchOS
tvOS
iPhone
iPhone X
iPhone XS
iPhone XS Max
iPhone XR
iPhone SE
iPad
iPad mini
iPad Air
iPad Pro
iPod
iMac
iMac Pro
MacBook
MacBook Air
MacBook Pro
Mac Pro
Mac mini
HomePod
AirPods
AirTag
iCloud
FaceTime
iMessage
GitHub
PayPal
WhatsApp
YouTube
"""


                let values: [String] = trademarksText.components(separatedBy: .newlines)
                let keys: [String] = values.map({ $0.replacingOccurrences(of: String.space, with: String.empty).lowercased() })
                let combined = zip(keys, values)
                let dict: [String: String] = Dictionary(uniqueKeysWithValues: combined)
                return dict
        }()
}
