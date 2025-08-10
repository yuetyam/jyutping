import SwiftUI

extension ColorScheme {
        var isDark: Bool {
                return self == .dark
        }

        /// Input key background color
        var inputKeyColor: Color {
                return isDark ? .darkInput : .lightInput
        }

        /// Input key tapping / highlighting background color
        var activeInputKeyColor: Color {
                return isDark ? .activeDarkInput : .activeLightInput
        }

        /// Action (modifier) key background color
        var actionKeyColor: Color {
                return isDark ? .darkAction : .lightAction
        }

        /// Action (modifier) key tapping / highlighting background color
        var activeActionKeyColor: Color {
                return isDark ? .activeDarkAction : .activeLightAction
        }

        /// Input key bubble preview background color
        var previewBubbleColor: Color {
                return isDark ? .solidDarkInput : .solidLightInput
        }
}

extension Color {

        static let interactiveClear: Color = Color(white: 0.5, opacity: 0.001)

        /// KeyView shadow color
        static let shadowGray      : Color = Color.gray.opacity(0.5)

        private static let isLiquidGlassPreferred: Bool = {
                if #available(iOSApplicationExtension 26.0, *) {
                        return true
                } else {
                        return false
                }
        }()

        private static let shallowLight       : Color = white
        private static let legacyEmphaticLight: Color = Color(.displayP3, red: 104.0 / 255.0, green: 110.0 / 255.0, blue: 128.0 / 255.0, opacity: 0.25)
        private static let emphaticLight      : Color = Color(white: 0.62, opacity: 0.35)

        private static let shallowDark        : Color = Color(white: 1, opacity: 0.3)
        private static let emphaticDark       : Color = Color(white: 1, opacity: 0.15)
        private static let solidShallowDark   : Color = Color(white: 0.45)
        private static let solidEmphaticDark  : Color = Color(white: 0.3)

        static let lightInput       : Color = shallowLight
        static let lightAction      : Color = isLiquidGlassPreferred ? shallowLight : legacyEmphaticLight
        static let activeLightInput : Color = isLiquidGlassPreferred ? emphaticLight : legacyEmphaticLight
        static let activeLightAction: Color = isLiquidGlassPreferred ? emphaticLight : shallowLight

        static let darkInput        : Color = isLiquidGlassPreferred ? emphaticDark : shallowDark
        static let darkAction       : Color = emphaticDark
        static let activeDarkInput  : Color = isLiquidGlassPreferred ? shallowDark : emphaticDark
        static let activeDarkAction : Color = shallowDark

        static let solidLightInput  : Color = white
        static let solidDarkInput   : Color = isLiquidGlassPreferred ? solidEmphaticDark : solidShallowDark
}


/*
oldKeyboardLightBackground
Color(.displayP3, red: 208.0 / 255.0, green: 212.0 / 255.0, blue: 216.0 / 255.0)

oldKeyboardDarkBackground
Color(.displayP3, red: 50.0 / 255.0, green: 50.0 / 255.0, blue: 50.0 / 255.0)

oldEmphaticLight
Color(.displayP3, red: 172.0 / 255.0, green: 176.0 / 255.0, blue: 186.0 / 255.0)

newEmphaticLight
Color(.displayP3, red: 188.0 / 255.0, green: 190.0 / 255.0, blue: 194.0 / 255.0)
*/

