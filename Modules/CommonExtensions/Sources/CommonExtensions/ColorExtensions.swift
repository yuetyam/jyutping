#if canImport(SwiftUI)

import SwiftUI

extension Color {
        public init(rgb: UInt32, alpha: Double = 1.0, colorSpace: Color.RGBColorSpace = .sRGB) {
                let red = Double((rgb >> 16) & 0xFF) / 255
                let green = Double((rgb >> 8) & 0xFF) / 255
                let blue = Double(rgb & 0xFF) / 255
                self.init(colorSpace, red: red, green: green, blue: blue, opacity: alpha)
        }
        public init(argb: UInt32, colorSpace: Color.RGBColorSpace = .sRGB) {
                let alpha = Double((argb >> 24) & 0xFF) / 255
                let red = Double((argb >> 16) & 0xFF) / 255
                let green = Double((argb >> 8) & 0xFF) / 255
                let blue = Double(argb & 0xFF) / 255
                self.init(colorSpace, red: red, green: green, blue: blue, opacity: alpha)
        }
        public init(rgba: UInt32, colorSpace: Color.RGBColorSpace = .sRGB) {
                let red = Double((rgba >> 24) & 0xFF) / 255
                let green = Double((rgba >> 16) & 0xFF) / 255
                let blue = Double((rgba >> 8) & 0xFF) / 255
                let alpha = Double(rgba & 0xFF) / 255
                self.init(colorSpace, red: red, green: green, blue: blue, opacity: alpha)
        }
}

#endif
