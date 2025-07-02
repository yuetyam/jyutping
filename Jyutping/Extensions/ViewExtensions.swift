#if os(macOS)

import SwiftUI

extension View {
        /// Apply rounded rectangle background color
        func block() -> some View {
                return self.padding(8).background(Color.textBackgroundColor, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
}

#endif
