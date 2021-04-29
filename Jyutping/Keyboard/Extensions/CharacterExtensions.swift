extension Character {

        /// A Boolean value indicating whether this character represents a tone number (1-6).
        var isTone: Bool {
                var tones: Set<Character> = ["1", "2", "3", "4", "5", "6"]
                return !(tones.insert(self).inserted)
        }

        /// A Boolean value indicating whether this character represents a space or a tone number.
        var isSpaceOrTone: Bool {
                var charSet: Set<Character> = [" ", "1", "2", "3", "4", "5", "6"]
                return !(charSet.insert(self).inserted)
        }
}
