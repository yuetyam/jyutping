import CommonExtensions

extension String {

        var ping: Int {
                return self.removedSpacesTones().hash
        }

        var shortcut: Int {
                let anchors = self.split(separator: Character.space).compactMap(\.first)
                return String(anchors).hash
        }

        /// A subsequence that only contains tones (1-6)
        var tones: String {
                return self.filter(\.isCantoneseToneDigit)
        }

        /// Remove all tones (1-6)
        /// - Returns: A subsequence that leaves off the tones.
        func removedTones() -> String {
                return self.filter({ !$0.isCantoneseToneDigit })
        }

        /// Remove all spaces and tones
        /// - Returns: A subsequence that leaves off the spaces and tones.
        func removedSpacesTones() -> String {
                return self.filter({ !$0.isSpaceOrTone })
        }

        /// Remove all spaces, separators and tones
        /// - Returns: A subsequence that leaves off the spaces, separators and tones.
        func removedSpacesSeparatorsTones() -> String {
                return self.filter({ !$0.isSpaceOrSeparatorOrTone })
        }

        /// Check if the first character is letter
        var isLetters: Bool {
                return self.first?.isBasicLatinLetter ?? false
        }
}
