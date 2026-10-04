import SwiftUI

extension Color {

        #if canImport(UIKit)
        static let separator: Color = Color(uiColor: UIColor.separator)
        #elseif canImport(AppKit)
        static let separator: Color = Color(nsColor: NSColor.separatorColor)
        #else
        static let separator: Color = Color.secondary
        #endif

        #if canImport(UIKit)
        static func textBackgroundColor(colorScheme: ColorScheme) -> Color {
                return Color(uiColor: colorScheme.isDark ? UIColor.secondarySystemBackground : UIColor.systemBackground)
        }
        #endif

        #if canImport(AppKit)
        static let textBackgroundColor: Color = Color(nsColor: NSColor.textBackgroundColor)
        #endif
}

extension ColorScheme {
        var isDark: Bool { self == .dark }
}
