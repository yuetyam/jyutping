import SwiftUI

extension View {

        /// Apply rounded rectangle background with content padding
        func block() -> some View {
                return padding(8).background(Color.textBackgroundColor.opacity(0.5), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        }

        /// Apply rounded rectangle background
        func stack(cornerRadius: CGFloat = 10) -> some View {
                return background(Color.textBackgroundColor.opacity(0.5), in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        }

        // https://www.avanderlee.com/swiftui/disable-animations-transactions
        func disableAnimation() -> some View {
                return self.transaction { transaction in
                        transaction.animation = nil
                }
        }

        func conditionalAnimation(_ shouldAnimate: Bool) -> some View {
                return self.transaction { transaction in
                        if !shouldAnimate {
                                transaction.animation = nil
                        }
                }
        }

        /// Apply 0.75 opacity
        func shallow() -> some View {
                return opacity(0.75)
        }
}

extension Color {
        static let textBackgroundColor: Color = Color(nsColor: NSColor.textBackgroundColor)
}
