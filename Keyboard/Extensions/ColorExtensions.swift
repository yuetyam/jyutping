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

extension Color {
        private static let isLiquidGlassPreferred: Bool = {
                if #available(iOSApplicationExtension 26.0, *) {
                        return true
                } else {
                        return false
                }
        }()

        private static let legacyEmphaticLight: Color = Color(.displayP3, red: 172.0 / 255.0, green: 177.0 / 255.0, blue: 185.0 / 255.0)
        private static let emphaticLight      : Color = Color(.displayP3, red: 190.0 / 255.0, green: 192.0 / 255.0, blue: 196.0 / 255.0)

        private static let shallowDark        : Color = Color(white: 1, opacity: 0.35)
        private static let emphaticDark       : Color = Color(white: 1, opacity: 0.15)
        private static let solidShallowDark   : Color = Color(white: 0.41)
        private static let solidEmphaticDark  : Color = Color(white: 0.27)

        static let lightInput       : Color = white
        static let lightAction      : Color = isLiquidGlassPreferred ? white : legacyEmphaticLight
        static let activeLightInput : Color = isLiquidGlassPreferred ? emphaticLight : legacyEmphaticLight
        static let activeLightAction: Color = isLiquidGlassPreferred ? emphaticLight : white

        static let darkInput        : Color = isLiquidGlassPreferred ? emphaticDark : shallowDark
        static let darkAction       : Color = emphaticDark
        static let activeDarkInput  : Color = isLiquidGlassPreferred ? shallowDark : emphaticDark
        static let activeDarkAction : Color = shallowDark

        static let solidDarkInput   : Color = isLiquidGlassPreferred ? solidEmphaticDark : solidShallowDark
        static let solidDarkAction  : Color = solidEmphaticDark
}
