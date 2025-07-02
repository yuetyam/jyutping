import SwiftUI

extension Color {

        #if os(iOS)
        static func textBackgroundColor(colorScheme: ColorScheme) -> Color {
                return Color(uiColor: colorScheme.isDark ? UIColor.secondarySystemBackground : UIColor.systemBackground)
        }
        static let separator: Color = Color(uiColor: UIColor.separator)
        #endif

        #if os(macOS)
        static let textBackgroundColor: Color = Color(nsColor: NSColor.textBackgroundColor).opacity(0.66)
        static let separator: Color = Color(nsColor: NSColor.separatorColor)
        #endif
}

extension ColorScheme {
        var isDark: Bool {
                return self == .dark
        }
}
