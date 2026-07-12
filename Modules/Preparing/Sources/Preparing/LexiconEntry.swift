import CommonExtensions

struct LexiconEntry: Hashable {

        /// Chinese text
        let word: String

        /// Jyutping, Pinyin, etc.
        let romanization: String

        /// Element/character count of the `word`
        let charCount: Int

        /// Complexity. Letter count (length) of the letter-only romanization (no tones & no spaces)
        let complex: Int

        /// Conjoined code of initials/anchors
        let anchors: Int

        /// Conjoined code of the letter-only romanization (no tones & no spaces)
        let spell: Int

        /// Conjoined keypad code of initials/anchors
        let nineKeyAnchors: Int

        /// Conjoined keypad code of the letter-only romanization (no tones & no spaces)
        let nineKeyCode: Int

        /// Create a lexicon entry
        /// - Parameters:
        ///   - word: Chinese text
        ///   - romanization: Jyutping, Pinyin, etc.
        ///   - complex: Complexity. Letter count (length) of the letter-only romanization (no tones & no spaces)
        ///   - anchors: Conjoined code of initials/anchors
        ///   - spell: Conjoined code of the letter-only romanization (no tones & no spaces)
        ///   - nineKeyAnchors: Conjoined keypad code of initials/anchors
        ///   - nineKeyCode: Conjoined keypad code of the letter-only romanization (no tones & no spaces)
        init(word: String, romanization: String, complex: Int? = nil, anchors: Int, spell: Int, nineKeyAnchors: Int, nineKeyCode: Int) {
                self.word = word
                self.romanization = romanization
                self.charCount = word.count
                self.complex = complex ?? romanization.count(where: \.isLowercaseBasicLatinLetter)
                self.anchors = anchors
                self.spell = spell
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
