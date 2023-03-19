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
                return !(self.filter(\.isTone).isEmpty)
        }
}
