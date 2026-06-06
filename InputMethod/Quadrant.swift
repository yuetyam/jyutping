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
                case .upperRight : false
                case .upperLeft  : true
                case .bottomLeft : true
                case .bottomRight: false
                }
        }

        /// From top to bottom
        var isNegativeVertical: Bool {
                switch self {
                case .upperRight : false
                case .upperLeft  : false
                case .bottomLeft : true
                case .bottomRight: true
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
