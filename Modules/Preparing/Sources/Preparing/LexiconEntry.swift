/// Lexicon Object
struct LexiconEntry: Hashable {

        /// Chinese text
        let word: String

        /// Jyutping, Pinyin, ...
        let romanization: String

        /// CharCode of initials
        let anchors: Int

        /// Letter-only romanization hash code
        let ping: Int

        /// TenKeyCharCode of initials
        let tenKeyAnchors: Int

        /// Letter-only romanization TenKeyCharCode
        let tenKeyCode: Int
        
        /// Create a lexicon entry
        /// - Parameters:
        ///   - word: Chinese text
        ///   - romanization: Jyutping, Pinyin, ...
        ///   - anchors: CharCode of initials
        ///   - ping: Letter-only romanization hash code
        ///   - tenKeyAnchors: TenKeyCharCode of initials
        ///   - tenKeyCode: Letter-only romanization TenKeyCharCode
        init(word: String, romanization: String, anchors: Int, ping: Int32, tenKeyAnchors: Int, tenKeyCode: Int) {
                self.word = word
                self.romanization = romanization
                self.anchors = anchors
                self.ping = Int(ping)
                self.tenKeyAnchors = tenKeyAnchors
                self.tenKeyCode = tenKeyCode
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
