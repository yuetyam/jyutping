import SwiftUI
import CommonExtensions

extension View {

        /// Apply rounded rectangle background with content padding
        func block() -> some View {
                padding(8).background(Color.textBackgroundColor.opacity(0.5), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        }

        /// Apply rounded rectangle background
        func stack(cornerRadius: CGFloat = 10) -> some View {
                background(Color.textBackgroundColor.opacity(0.5), in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        }

        /// Disable animations when condition is true
        func disableAnimations(when condition: Bool = true) -> some View {
                transaction { transaction in
                        if condition {
                                transaction.animation = nil
                        }
                }
        }

        /// Apply animations only when condition is true
        func applyAnimations(onlyIf condition: Bool) -> some View {
                transaction { transaction in
                        if condition.negative {
                                transaction.animation = nil
                        }
                }
        }

        /// Apply 0.75 opacity
        func shallow() -> some View {
                opacity(0.75)
        }
}

extension Color {
        static let textBackgroundColor: Color = Color(nsColor: NSColor.textBackgroundColor)
}
