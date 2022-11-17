import SwiftUI

extension View {

        /// Set Material background in rounded rectangle for view
        /// - Returns: some View
        func block() -> some View {
                return self.padding().background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
}
