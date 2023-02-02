import SwiftUI

extension View {

        /// Material background in rounded rectangle
        /// - Returns: some View
        func block() -> some View {
                return self.padding().background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
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
