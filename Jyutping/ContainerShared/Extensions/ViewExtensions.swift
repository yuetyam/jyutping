import SwiftUI

extension View {

        @available(macOS 12.0, *)
        func block() -> some View {
                let color: Color = {
                        #if os(macOS)
                        return Color(nsColor: NSColor.textBackgroundColor)
                        #else
                        return Color.gray
                        #endif
                }()
                return self.padding().background(color, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
}

