extension Character {

        private static let tones: Set<Character> = ["1", "2", "3", "4", "5", "6"]

        /// A Boolean value indicating whether this character represents a tone number (1-6).
        var isTone: Bool {
                return Character.tones.contains(self)
        }

        /// A Boolean value indicating whether this character represents a space.
        var isSpace: Bool {
                return self == " "
        }

        /// A Boolean value indicating whether this character represents a separator ( ' ).
        var isSeparator: Bool {
                return self == "'"
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
