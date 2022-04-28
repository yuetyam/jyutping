import SwiftUI

extension Color {
        static func backgroundColor(colorScheme: ColorScheme) -> Color {
                switch colorScheme {
                case .dark:
                        #if os(iOS)
                        if #available(iOS 15.0, *) {
                                return Color(uiColor: UIColor.systemBackground)
                        } else {
                                return Color(UIColor.systemBackground)
                        }
                        #else
                        return Color(nsColor: NSColor.windowBackgroundColor)
                        #endif
                default:
                        #if os(iOS)
                        if #available(iOS 15.0, *) {
                                return Color(uiColor: UIColor.secondarySystemBackground)
                        } else {
                                return Color(UIColor.secondarySystemBackground)
                        }
                        #else
                        return Color(nsColor: NSColor.controlBackgroundColor)
                        #endif

                }
        }
}

