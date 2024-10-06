import SwiftUI

extension Color {

        #if os(iOS)
        static let separator: Color = Color(uiColor: UIColor.separator)
        #endif

        #if os(macOS)
        static let textBackgroundColor: Color = Color(nsColor: NSColor.textBackgroundColor).opacity(0.8)
        static let separator: Color = Color(nsColor: NSColor.separatorColor)
        #endif
}
