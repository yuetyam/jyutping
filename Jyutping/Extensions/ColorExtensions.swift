import SwiftUI

extension Color {

        #if os(iOS)
        static func textBackgroundColor(colorScheme: ColorScheme) -> Color {
                switch colorScheme {
                case .dark:
                        return Color(uiColor: UIColor.secondarySystemBackground)
                case .light:
                        return Color(uiColor: UIColor.systemBackground)
                @unknown default:
                        return Color(uiColor: UIColor.systemBackground)
                }
        }
        static let separator: Color = Color(uiColor: UIColor.separator)
        #endif

        #if os(macOS)
        static let textBackgroundColor: Color = Color(nsColor: NSColor.textBackgroundColor).opacity(0.66)
        static let separator: Color = Color(nsColor: NSColor.separatorColor)
        #endif
}
