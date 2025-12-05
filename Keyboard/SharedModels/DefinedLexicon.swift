import Foundation
import CommonExtensions
import CoreIME

/// System Text Replacements
struct DefinedLexicon: Hashable {
        let input: String
        let text: String
        let events: [InputEvent]
        let charCode: Int
        let nineKeyCharCode: Int
        init(input: String, text: String, events: [InputEvent]) {
                self.input = input
                self.text = text
                self.events = events
                self.charCode = events.map(\.code).radix100Combined()
                self.nineKeyCharCode = input.nineKeyCharCode ?? 0
        }
        static func ==(lhs: DefinedLexicon, rhs: DefinedLexicon) -> Bool {
                return lhs.input == rhs.input && lhs.text == rhs.text
        }
        func hash(into hasher: inout Hasher) {
                hasher.combine(input)
                hasher.combine(text)
        }
        var candidate: Candidate {
                return Candidate(type: .text, text: text, romanization: input, input: input)
        }
}
