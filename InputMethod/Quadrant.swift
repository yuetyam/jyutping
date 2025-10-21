import SwiftUI

/// Candidate window pattern
enum Quadrant: Int, Sendable {

        /// Quadrant I. Positive horizontal and positive vertical. Left to right, bottom to top.
        case upperRight

        /// Quadrant II. Negative horizontal and positive vertical. Right to left, bottom to top.
        case upperLeft

        /// Quadrant III. Negative horizontal and negative vertical. Right to left, top to bottom.
        case bottomLeft

        /// Quadrant IV. Positive horizontal and negative vertical. Left to right, top to bottom.
        case bottomRight

        /// From right to left
        var isNegativeHorizontal: Bool {
                switch self {
                case .upperRight:
                        return false
                case .upperLeft:
                        return true
                case .bottomLeft:
                        return true
                case .bottomRight:
                        return false
                }
        }

        /// From top to bottom
        var isNegativeVertical: Bool {
                switch self {
                case .upperRight:
                        return false
                case .upperLeft:
                        return false
                case .bottomLeft:
                        return true
                case .bottomRight:
                        return true
                }
        }

        /// Candidate window MotherBoard alignment
        var alignment: Alignment {
                switch self {
                case .upperRight : .bottomLeading
                case .upperLeft  : .bottomTrailing
                case .bottomLeft : .topTrailing
                case .bottomRight: .topLeading
                }
        }
}
