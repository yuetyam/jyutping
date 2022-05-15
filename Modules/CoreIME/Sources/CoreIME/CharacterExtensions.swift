extension Character {

        private static let tones: Set<Character> = ["1", "2", "3", "4", "5", "6"]
        private static let spaceTones: Set<Character> = [" ", "1", "2", "3", "4", "5", "6"]

        /// A Boolean value indicating whether this character represents a tone number (1-6).
        var isTone: Bool {
                return Character.tones.contains(self)
        }

        /// A Boolean value indicating whether this character represents a space or a tone number.
        var isSpaceOrTone: Bool {
                return Character.spaceTones.contains(self)
        }

        /// A Boolean value indicating whether this character represents a separator ( ' ).
        var isSeparator: Bool {
                return self == "'"
        }
}
