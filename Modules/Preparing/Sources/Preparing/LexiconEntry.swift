/// Lexicon Object
struct LexiconEntry: Hashable {

        /// Chinese text
        let word: String

        /// Jyutping, Pinyin, ...
        let romanization: String

        /// CharCode of initials
        let anchors: Int

        /// Letter-only romanization hash code
        let spell: Int

        /// NineKeyCharCode of initials
        let nineKeyAnchors: Int

        /// Letter-only romanization NineKeyCharCode
        let nineKeyCode: Int

        /// Create a lexicon entry
        /// - Parameters:
        ///   - word: Chinese text
        ///   - romanization: Jyutping, Pinyin, ...
        ///   - anchors: CharCode of initials
        ///   - ping: Letter-only romanization hash code
        ///   - nineKeyAnchors: NineKeyCharCode of initials
        ///   - nineKeyCode: Letter-only romanization NineKeyCharCode
        init(word: String, romanization: String, anchors: Int, spell: Int32, nineKeyAnchors: Int, nineKeyCode: Int) {
                self.word = word
                self.romanization = romanization
                self.anchors = anchors
                self.spell = Int(spell)
                self.nineKeyAnchors = nineKeyAnchors
                self.nineKeyCode = nineKeyCode
        }

        // Equatable
        static func ==(lhs: LexiconEntry, rhs: LexiconEntry) -> Bool {
                return lhs.word == rhs.word && lhs.romanization == rhs.romanization
        }

        // Hashable
        func hash(into hasher: inout Hasher) {
                hasher.combine(word)
                hasher.combine(romanization)
        }
}
