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

        // TODO: Improve this code
        /// Format text with separators and tones
        /// - Returns: Formatted text
        public func formattedForMark() -> String {
                let blocks = self.map { character -> String in
                        return character.isBasicLatinLetter ? String(character) : "\(character) "
                }
                return blocks.joined().trimmingCharacters(in: .whitespaces)
        }
}

extension Sequence where Element == Character {

        /// Returns a new string by concatenating the elements of the sequence, adding a space between each element.
        func spaceSeparated() -> String {
                return self.reduce(into: String.empty) { partialResult, character in
                        if partialResult.isNotEmpty {
                                partialResult.append(String.space)
                        }
                        partialResult.append(character)
                }
        }
}

extension String {
        /// Occurrence count of pattern in this String
        /// - Parameter pattern: Regular expression pattern
        /// - Returns: Number of occurrences
        func occurrenceCount(pattern: String) -> Int {
                // TODO: Improve this code
                // return self.matches(of: Regex{substring}).count
                guard let regex = try? NSRegularExpression(pattern: pattern) else { return 0 }
                return regex.numberOfMatches(in: self, range: NSRange(self.startIndex..., in: self))
        }
}
