import SwiftUI

extension View {

        @available(macOS 12.0, *)
        @available(iOS, unavailable)
        func block() -> some View {
                #if os(macOS)
                let color: Color = Color(nsColor: NSColor.textBackgroundColor)
                return self.padding().background(color, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                #else
                return self
                #endif
        }
}

