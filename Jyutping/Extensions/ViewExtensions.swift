import SwiftUI

extension View {
        /// Apply 0.85 opacity
        func shallow() -> some View {
                return opacity(0.85)
        }

        /// Apply 0.66 opacity
        func airy() -> some View {
                return opacity(0.66)
        }
}

#if os(macOS)

extension View {

        /// Apply rounded rectangle background with content padding
        func block() -> some View {
                return padding(8).background(Color.textBackgroundColor.opacity(0.5), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        }

        /// Apply rounded rectangle background
        func stack(cornerRadius: CGFloat = 10) -> some View {
                return background(Color.textBackgroundColor.opacity(0.5), in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        }
}

#else

extension View {

        /// Apply rounded rectangle background
        func stack(colorScheme: ColorScheme, cornerRadius: CGFloat = 10) -> some View {
                return background(Color.textBackgroundColor(colorScheme: colorScheme), in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        }
}

#endif
