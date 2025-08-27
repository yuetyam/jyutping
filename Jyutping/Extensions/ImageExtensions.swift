import SwiftUI

extension Image {

        static let settings: Image = Image(systemName: "gear")
        static let speaker: Image = Image(systemName: "speaker.wave.2")
        static let speaking: Image = Image(systemName: "speaker.wave.3.fill")
        static let safari: Image = Image(systemName: "safari")
        static let arrowUpForward: Image = Image(systemName: "arrow.up.forward")

        // ExpressionsView
        static let info: Image = Image(systemName: "info.circle")
        static let checkmark: Image = Image(systemName: "checkmark.circle")
        static let warning: Image = Image(systemName: "exclamationmark.circle")
        static let xmark: Image = Image(systemName: "xmark.circle")


        // MARK: - Chevrons

        /// Chevron Image
        /// - Parameter direction: Chevron direction
        /// - Returns: A Chevron Image
        static func chevron(_ direction: Direction) -> Image {
                let imageName: String = {
                        switch direction {
                        case .up:
                                return "chevron.up"
                        case .down:
                                return "chevron.down"
                        case .forward:
                                return "chevron.forward"
                        case .backward:
                                return "chevron.backward"
                        }
                }()
                return Image(systemName: imageName)
        }

        static let downChevron: Image = Image.chevron(.down)
        static let backwardChevron: Image = Image.chevron(.backward)
}


enum Direction {
        case up
        case down
        case forward
        case backward
}

