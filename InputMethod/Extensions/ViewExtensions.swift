import SwiftUI

extension View {

        func block() -> some View {
                return self.padding(12).background(Color.textBackgroundColor, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
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
}

private extension Color {
        static let textBackgroundColor: Color = Color(nsColor: NSColor.textBackgroundColor).opacity(0.8)
}
