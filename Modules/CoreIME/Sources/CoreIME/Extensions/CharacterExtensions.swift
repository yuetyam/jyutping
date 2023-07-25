extension Character {

        /// U+0020
        static let space: Character = "\u{20}"

        /// U+0020.
        var isSpace: Bool {
                return self == Self.space
        }

        /// U+0027 ( ' ) apostrophe
        static let separator: Character = "\u{27}"

        /// U+0027 ( ' ) apostrophe
        var isSeparator: Bool {
                return self == Self.separator
        }

        /// A Boolean value indicating whether this character represents a tone number (1-6).
        var isTone: Bool {
                return ("1"..."6") ~= self
        }

        /// A Boolean value indicating whether this character represents a space or a tone number.
        var isSpaceOrTone: Bool {
                return self.isSpace || self.isTone
        }

        /// A Boolean value indicating whether this character represents a separator or a tone number.
        var isSeparatorOrTone: Bool {
                return self.isSeparator || self.isTone
        }

        /// A Boolean value indicating whether this character represents a space / a tone number / a separator.
        var isSpaceOrToneOrSeparator: Bool {
                return self.isSpace || self.isTone || self.isSeparator
        }
}
