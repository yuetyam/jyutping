import SwiftUI

struct KeyExpansionPath: Shape {

        /// Key location, left half (leading) or right half (trailing).
        let keyLocale: HorizontalEdge

        /// Count of the extras blocks
        let expansions: Int

        func path(in rect: CGRect) -> Path {
                let origin: CGPoint = CGPoint(x: rect.midX, y: rect.maxY)
                switch keyLocale {
                case .leading:
                        return Path.keyRightExpansionPath(origin: origin, previewCornerRadius: 10, keyWidth: rect.size.width, keyHeight: rect.size.height, keyCornerRadius: 5, expansions: expansions)
                case .trailing:
                        return Path.keyLeftExpansionPath(origin: origin, previewCornerRadius: 10, keyWidth: rect.size.width, keyHeight: rect.size.height, keyCornerRadius: 5, expansions: expansions)
                }
        }
}

extension HorizontalEdge {
        var isLeading: Bool {
                return self == .leading
        }
        var isTrailing: Bool {
                return self == .trailing
        }
}
