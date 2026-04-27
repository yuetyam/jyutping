import Foundation
import CommonExtensions

/// InputMemory Lexicon Entry
struct MemoryLexicon: Hashable {

        /// Cantonese candidate lexicon text
        let word: String

        /// Jyutping
        let romanization: String

        /// Count of input selection
        let frequency: Int64

        /// Most recently updated timestamp, in milliseconds
        let latest: Int64

        /// romanization.anchorText.hashCode()
        let shortcut: Int32

        /// romanization.removedTonesAndSpaces.hashCode()
        let spell: Int32

        /// romanization.anchorText.NineKeyCharCode
        let nineKeyAnchors: Int

        /// romanization.removedTonesAndSpaces.NineKeyCharCode
        let nineKeyCode: Int

        init(word: String, romanization: String, frequency: Int64 = 1, latest: Int64? = nil) {
                let anchorText: String = String(romanization.split(separator: Character.space).compactMap(\.first))
                let letterText: String = romanization.filter(\.isLowercaseBasicLatinLetter)
                self.word = word
                self.romanization = romanization
                self.frequency = frequency
                self.latest = latest ?? Int64(Date.now.timeIntervalSince1970 * 1000)
                self.shortcut = anchorText.hashCode()
                self.spell = letterText.hashCode()
                self.nineKeyAnchors = anchorText.nineKeyCharCode ?? 0
                self.nineKeyCode = letterText.nineKeyCharCode ?? 0
        }

        // Equatable
        static func ==(lhs: MemoryLexicon, rhs: MemoryLexicon) -> Bool {
                return lhs.word == rhs.word && lhs.romanization == rhs.romanization
        }

        // Hashable
        func hash(into hasher: inout Hasher) {
                hasher.combine(word)
                hasher.combine(romanization)
        }
}
