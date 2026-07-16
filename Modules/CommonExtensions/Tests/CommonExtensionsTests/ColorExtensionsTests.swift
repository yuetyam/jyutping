#if canImport(SwiftUI)

import SwiftUI
import Testing
@testable import CommonExtensions

@Suite("Color extensions")
struct ColorExtensionsTests {

        @Test("rgb initializer extracts channels and forwards alpha and color space")
        func rgb() {
                #expect(Color(rgb: 0xFF0000) == Color(.sRGB, red: 1, green: 0, blue: 0, opacity: 1))
                #expect(Color(rgb: 0x00FF00, alpha: 0.5) == Color(.sRGB, red: 0, green: 1, blue: 0, opacity: 0.5))
                #expect(Color(rgb: 0x0000FF, colorSpace: .displayP3) == Color(.displayP3, red: 0, green: 0, blue: 1, opacity: 1))
        }

        @Test("argb initializer extracts the leading alpha channel")
        func argb() {
                #expect(Color(argb: 0xFFFF0000) == Color(.sRGB, red: 1, green: 0, blue: 0, opacity: 1))
                #expect(Color(argb: 0x0000FF00) == Color(.sRGB, red: 0, green: 1, blue: 0, opacity: 0))
                #expect(Color(argb: 0xFF0000FF, colorSpace: .displayP3) == Color(.displayP3, red: 0, green: 0, blue: 1, opacity: 1))
        }

        @Test("rgba initializer extracts the trailing alpha channel")
        func rgba() {
                #expect(Color(rgba: 0xFF0000FF) == Color(.sRGB, red: 1, green: 0, blue: 0, opacity: 1))
                #expect(Color(rgba: 0x00FF0000) == Color(.sRGB, red: 0, green: 1, blue: 0, opacity: 0))
                #expect(Color(rgba: 0x0000FFFF, colorSpace: .displayP3) == Color(.displayP3, red: 0, green: 0, blue: 1, opacity: 1))
        }
}

#endif
