import SwiftUI

extension View {

        /// Apply rounded rectangle background color
        func block() -> some View {
                return self.padding(8).background(Color.textBackgroundColor, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
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
        static let textBackgroundColor: Color = Color(nsColor: NSColor.textBackgroundColor).opacity(0.66)
}
