import SwiftUI

extension Color {
        static let interactiveClear   : Color = Color(white: 0.5, opacity: 0.001)

        static let light              : Color = Color.white
        static let lightEmphatic      : Color = Color(.displayP3, red: 172.0 / 255.0, green: 177.0 / 255.0, blue: 185.0 / 255.0)
        static let dark               : Color = Color(white: 1, opacity: 0.35)
        static let darkEmphatic       : Color = Color(white: 1, opacity: 0.15)
        static let darkOpacity        : Color = Color(white: 0.41)
        static let darkEmphaticOpacity: Color = Color(white: 0.27)

        /// KeyView shadow color
        static let shadowGray         : Color = Color.black.opacity(0.33)
}
