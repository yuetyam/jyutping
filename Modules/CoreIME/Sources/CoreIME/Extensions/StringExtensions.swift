import Foundation
import CommonExtensions

extension String {

        /// A subsequence that only contains tones (1-6)
        var tones: String {
                return self.filter(\.isCantoneseToneDigit)
        }

        /// Remove all tones (1-6)
        /// - Returns: A subsequence that leaves off tones.
        func removedTones() -> String {
                return self.filter(\.isCantoneseToneDigit.negative)
        }

        /// Remove all spaces
        /// - Returns: A subsequence that leaves off spaces.
        func removedSpaces() -> String {
                return self.filter(\.isSpace.negative)
        }

        /// Remove all spaces and tones
        /// - Returns: A subsequence that leaves off spaces and tones.
        func removedSpacesTones() -> String {
                return self.filter({ $0.isSpace.negative && $0.isCantoneseToneDigit.negative })
        }
}

extension StringProtocol {

        /// Convert v/x/q to the tone digits
        /// - Returns: Converted text with digital tones
        public func toneConverted() -> String {
                return replacingOccurrences(of: "vv", with: "4")
                        .replacingOccurrences(of: "xx", with: "5")
                        .replacingOccurrences(of: "qq", with: "6")
                        .replacingOccurrences(of: "v", with: "1")
                        .replacingOccurrences(of: "x", with: "2")
                        .replacingOccurrences(of: "q", with: "3")
        }

        /// Inserts a space after any non-letter character
        /// - Returns: Formatted text for mark
        public func markFormatted() -> String {
                var result: String = String.empty
                result.reserveCapacity(count * 2)
                for character in self {
                        result.append(character)
                        if character.isBasicLatinLetter.negative {
                                result.append(Character.space)
                        }
                }
                return result
        }
}
