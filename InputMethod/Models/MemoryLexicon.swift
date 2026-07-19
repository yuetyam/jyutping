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

        /// Element/character count of the `word`
        let charCount: Int

        /// Complexity. Letter count (length) of the letter-only romanization (no tones & no spaces)
        let complex: Int

        /// Conjoined code of initials/anchors
        let anchors: Int

        /// Conjoined code of the letter-only romanization (no tones & no spaces)
        let spell: Int

        init(word: String, romanization: String, frequency: Int64 = 1, latest: Int64? = nil) {
                let anchorText = romanization.split(separator: Character.space).compactMap(\.first)
                let letterText = romanization.filter(\.isLowercaseBasicLatinLetter)
                self.word = word
                self.romanization = romanization
                self.frequency = frequency
                self.latest = latest ?? Int64(Date.now.timeIntervalSince1970 * 1000)
                self.charCount = word.count
                self.complex = letterText.count
                self.anchors = anchorText.serialCode
                self.spell = letterText.serialCode
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
