import SwiftUI

extension Color {
        static let interactiveClear   : Color = Color(white: 1, opacity: 0.001)

        @available(*, deprecated, renamed: "accentColor", message: "Use Color.accentColor instead.")
        static let selection          : Color = Color(.displayP3, red:  52.0 / 255.0, green: 120.0 / 255.0, blue: 246.0 / 255.0)

        static let light              : Color = Color.white
        static let lightEmphatic      : Color = Color(.displayP3, red: 172.0 / 255.0, green: 177.0 / 255.0, blue: 185.0 / 255.0)
        static let dark               : Color = Color(white: 1, opacity: 0.35)
        static let darkEmphatic       : Color = Color(white: 1, opacity: 0.15)
        static let darkOpacity        : Color = Color(white: 0.41)
        static let darkEmphaticOpacity: Color = Color(white: 0.27)
}
