import Foundation
import CommonExtensions

extension String {

        var ping: Int64 {
                return Int64(self.removedSpacesTones().hash)
        }

        var shortcut: Int64 {
                let syllables = self.split(separator: Character.space)
                let anchors = syllables.map(\.first).compactMap({ $0 })
                let text = String(anchors)
                return Int64(text.hash)
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
                return self.filter({ $0.isSpaceOrSeparatorOrTone })
        }

        /// check if the first character is letter
        var isLetters: Bool {
                return self.first?.isBasicLatinLetter ?? false
        }
}


extension String {

        /// Transform to Full Width characters
        /// - Returns: Full Width characters
        func fullWidth() -> String {
                let transformed: String? = self.applyingTransform(.fullwidthToHalfwidth, reverse: true)
                return transformed ?? self
        }
}

