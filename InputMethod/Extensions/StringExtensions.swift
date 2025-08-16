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

        /// Remove tones (1-6)
        /// - Returns: A subsequence that leaves off tones.
        func removedTones() -> String {
                return filter(\.isCantoneseToneDigit.negative)
        }

        /// Remove spaces and tones (1-6)
        /// - Returns: A subsequence that leaves off spaces and tones.
        func removedSpacesTones() -> String {
                return filter(\.isLowercaseBasicLatinLetter)
        }
}

extension StringProtocol {

        /// Transform to full-width characters
        /// - Returns: A new String with full-width characters
        func fullWidth() -> String {
                return self.applyingTransform(.fullwidthToHalfwidth, reverse: true) ?? (self as? String) ?? String(self)
        }
}
