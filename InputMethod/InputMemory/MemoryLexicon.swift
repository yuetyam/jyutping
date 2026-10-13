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

        /// Length of the letter-only romanization (no tones & no spaces)
        let letterCount: Int

        /// Conjoined digit of letter-only-syllable (phone) lengths.
        ///
        /// For example: phone lengths of romanization “gwong2 dung1 dou6” are `[5, 4, 3]`, which makes the `complexity` become `543`
        let complexity: Int

        /// Conjoined code of initials/anchors
        let anchors: Int

        /// Conjoined code of the letter-only romanization (no tones & no spaces)
        let spell: Int

        init(word: String, romanization: String, frequency: Int64 = 1, latest: Int64? = nil) {
                let phones = romanization.filter(\.isBasicDigit.negative).split(separator: Character.space)
                let complexity = phones.map(\.count).decimalOverflowed()
                let anchorText = phones.compactMap(\.first)
                let letters = romanization.filter(\.isLowercaseBasicLatinLetter)
                self.word = word
                self.romanization = romanization
                self.frequency = frequency
                self.latest = latest ?? Int64(Date.now.timeIntervalSince1970 * 1000)
                self.charCount = word.count
                self.letterCount = letters.count
                self.complexity = complexity
                self.anchors = anchorText.serialCode
                self.spell = letters.serialCode
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
