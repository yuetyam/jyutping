import Foundation
import CommonExtensions

extension String {

        var pingCode: Int {
                return filter(\.isLowercaseBasicLatinLetter).hash
        }

        var shortcutCode: Int {
                let anchors = split(separator: Character.space).compactMap(\.first)
                return String(anchors).hash
        }

        /// A subsequence that only contains tones (1-6)
        var tones: String {
                return filter(\.isCantoneseToneDigit)
        }

        /// Remove all tones (1-6)
        /// - Returns: A subsequence that leaves off the tones.
        func removedTones() -> String {
                return filter(\.isCantoneseToneDigit.negative)
        }

        /// Check if the first character is letter
        var isLetters: Bool {
                return self.first?.isBasicLatinLetter ?? false
        }
}
