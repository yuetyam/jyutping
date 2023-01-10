import SwiftUI

extension Color {

        static func backgroundColor(colorScheme: ColorScheme) -> Color {
                switch colorScheme {
                case .dark:
                        #if os(iOS)
                        return Color(uiColor: UIColor.systemBackground)
                        #elseif os(macOS)
                        return Color(nsColor: NSColor.windowBackgroundColor)
                        #else
                        return Color.black
                        #endif
                default:
                        #if os(iOS)
                        return Color(uiColor: UIColor.secondarySystemBackground)
                        #elseif os(macOS)
                        return Color(nsColor: NSColor.windowBackgroundColor)
                        #else
                        return Color.gray
                        #endif

                }
        }

        @available(iOS, unavailable)
        static let textBackgroundColor: Color = {
                #if os(macOS)
                let color: Color = Color(nsColor: NSColor.textBackgroundColor)
                return color
                #else
                return Color.gray
                #endif
        }()

        static let separator: Color = {
                #if os(iOS)
                return Color(uiColor: UIColor.separator)
                #elseif os(macOS)
                return Color(nsColor: NSColor.separatorColor)
                #else
                return Color.secondary
                #endif
        }()
}

