import Foundation

extension String {

        static let empty: String = ""
        static let space: String = " "

        /// A subsequence that only contains tones (1-6)
        var tones: String {
                return self.filter(\.isTone)
        }

        /// Remove all tones (1-6)
        /// - Returns: A subsequence that leaves off tones.
        func removedTones() -> String {
                return self.filter({ !$0.isTone })
        }

        /// Remove all spaces
        /// - Returns: A subsequence that leaves off spaces.
        func removedSpaces() -> String {
                return self.replacingOccurrences(of: " ", with: "")
        }

        /// Remove all spaces and tones
        /// - Returns: A subsequence that leaves off spaces and tones.
        func removedSpacesTones() -> String {
                return self.filter({ !$0.isSpaceOrTone })
        }

        /// Remove all separators
        /// - Returns: A subsequence that leaves off separators
        func removedSeparators() -> String {
                return self.replacingOccurrences(of: "'", with: "")
        }

        /// Remove all separators and tones
        /// - Returns: A subsequence that leaves off separators and tones
        func removedSeparatorsTones() -> String {
                return self.filter({ !$0.isSeparatorOrTone })
        }

        /// Remove all spaces, tones and separators
        /// - Returns: A subsequence that leaves off spaces, tones and separators
        func removedSpacesTonesSeparators() -> String {
                return self.filter({ !$0.isSpaceOrToneOrSeparator })
        }

        /// Contains separator
        var hasSeparators: Bool {
                return self.contains("'")
        }

        /// Contains tone number (1-6)
        var hasTones: Bool {
                return self.first(where: { $0.isTone }) != nil
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

        /// Format text with separators and tones
        /// - Returns: Formatted text
        public func formattedForMark() -> String {
                let blocks = self.map { character -> String in
                        return character.isSeparatorOrTone ? "\(character) " : String(character)
                }
                return blocks.joined().trimmingCharacters(in: .whitespaces)
        }
}

extension Array where Element == String {

        /// All characters count
        var summedLength: Int {
                return self.map(\.count).reduce(0, +)
        }
}

extension String {
        /// Occurrence count of substring in this String
        /// - Parameter substring: Substring
        /// - Returns: Number of occurrences
        func occurrenceCount(substring: String) -> Int {
                // return self.matches(of: Regex{substring}).count
                guard let regex = try? NSRegularExpression(pattern: substring) else { return 0 }
                return regex.numberOfMatches(in: self, range: NSRange(self.startIndex..., in: self))
        }
}
