import Foundation
import CommonExtensions
import CoreIME

/// System Text Replacements
struct DefinedLexicon: Hashable {
        let input: String
        let text: String
        let complex: Int
        let spell: Int
        let nineKeyCode: Int
        init(input: String, text: String) {
                self.input = input
                self.text = text
                self.complex = input.count
                self.spell = input.serialCode
                self.nineKeyCode = input.keypadCode
        }
        static func ==(lhs: DefinedLexicon, rhs: DefinedLexicon) -> Bool {
                return lhs.input == rhs.input && lhs.text == rhs.text
        }
        func hash(into hasher: inout Hasher) {
                hasher.combine(input)
                hasher.combine(text)
        }
        var mappedLexicon: Lexicon {
                return Lexicon(type: .text, text: text, romanization: input, input: input)
        }
}
