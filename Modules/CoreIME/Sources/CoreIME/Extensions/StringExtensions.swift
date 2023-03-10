import Foundation

extension String {

        static let empty: String = ""
        static let space: String = " "

        /// A subsequence that only contains tones (1-6)
        var tones: String {
                return self.filter(\.isTone)
        }

        /// Remove all tones (1-6)
        /// - Returns: A subsequence that leaves off the tones.
        func removedTones() -> String {
                return self.filter({ !$0.isTone })
        }

        /// Remove all spaces and tones
        /// - Returns: A subsequence that leaves off the spaces and tones.
        func removedSpacesTones() -> String {
                return self.filter({ !$0.isSpaceOrTone })
        }
}
