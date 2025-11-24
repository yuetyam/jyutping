import SwiftUI

extension View {
        /// Apply half opacity
        func shallow() -> some View {
                return opacity(0.5)
        }

        /// Set transaction.animation to nil
        func disableAnimations() -> some View {
                transaction { $0.animation = nil }
        }
}
