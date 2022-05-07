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
                        #elseif os(macOS)
                        return Color(nsColor: NSColor.windowBackgroundColor)
                        #else
                        return Color.black
                        #endif
                default:
                        #if os(iOS)
                        if #available(iOS 15.0, *) {
                                return Color(uiColor: UIColor.secondarySystemBackground)
                        } else {
                                return Color(UIColor.secondarySystemBackground)
                        }
                        #elseif os(macOS)
                        return Color(nsColor: NSColor.windowBackgroundColor)
                        #else
                        return Color.gray
                        #endif

                }
        }
}

