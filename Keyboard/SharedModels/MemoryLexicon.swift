import Foundation
import CommonExtensions

/// InputMemory Lexicon Entry
struct MemoryLexicon: Hashable {

        /// (Candidate.lexiconText + period + Candidate.romanization).hash
        let identifier: Int

        /// Cantonese candidate lexicon text
        let word: String

        /// Jyutping
        let romanization: String

        /// Count of input selection
        let frequency: Int

        /// Most recently updated timestamp, in milliseconds
        let latest: Int

        /// romanization.anchorText.CharCode
        let anchors: Int

        /// romanization.anchorText.hash
        let shortcut: Int

        /// romanization.removedTonesAndSpaces.hash
        let ping: Int

        /// romanization.anchorText.NineKeyCharCode
        let nineKeyAnchors: Int

        /// romanization.removedTonesAndSpaces.NineKeyCharCode
        let nineKeyCode: Int

        init(word: String, romanization: String, frequency: Int) {
                let anchorText: String = String(romanization.split(separator: Character.space).compactMap(\.first))
                let letterText: String = romanization.filter(\.isLowercaseBasicLatinLetter)
                self.identifier = (word + String.period + romanization).hash
                self.word = word
                self.romanization = romanization
                self.frequency = frequency
                self.latest = Int(Date.now.timeIntervalSince1970 * 1000)
                self.anchors = anchorText.charCode ?? 0
                self.shortcut = anchorText.hash
                self.ping = letterText.hash
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
