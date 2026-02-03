import Foundation
import CommonExtensions
import CoreIME

/// System Text Replacements
struct DefinedLexicon: Hashable {
        let input: String
        let text: String
        let keys: [VirtualInputKey]
        let charCode: Int
        init(input: String, text: String, keys: [VirtualInputKey]) {
                self.input = input
                self.text = text
                self.keys = keys
                self.charCode = keys.map(\.code).radix100Combined()
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
