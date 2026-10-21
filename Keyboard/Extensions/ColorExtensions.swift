import SwiftUI

extension ColorScheme {

        var isLight: Bool { self == .light }
        var isDark: Bool { self == .dark }

        func inputKeyBackground(style: AppearanceStyle, isPreviewEnabled: Bool, isInteracting: Bool) -> Color {
                switch (isPreviewEnabled, isInteracting) {
                case (true, true): inputBackground(style: style)
                case (true, false): inputBackground(style: style)
                case (false, true): inputReflection(style: style)
                case (false, false): inputBackground(style: style)
                }
        }
        private func inputBackground(style: AppearanceStyle) -> Color {
                switch style {
                case .classic: return isDark ? .shallowDark : .white
                default: return isDark ? .emphaticDark : .shallowLight
                }
        }
        private func inputReflection(style: AppearanceStyle) -> Color {
                switch style {
                case .classic: return isDark ? .emphaticDark : .legacyEmphaticLight
                default: return isDark ? .shallowDark : .emphaticLight
                }
        }

        func actionKeyBackground(style: AppearanceStyle, isInteracting: Bool) -> Color {
                return isInteracting ? actionReflection(style: style) : actionBackground(style: style)
        }
        private func actionBackground(style: AppearanceStyle) -> Color {
                switch style {
                case .classic: return isDark ? .emphaticDark : .legacyEmphaticLight
                default: return isDark ? .emphaticDark : .shallowLight
                }
        }
        private func actionReflection(style: AppearanceStyle) -> Color {
                switch style {
                case .classic: return isDark ? .shallowDark : .shallowLight
                default: return isDark ? .shallowDark : .emphaticLight
                }
        }

        func bubbleBackground(style: AppearanceStyle) -> Color {
                switch style {
                case .classic: return isDark ? .solidShallowDark : .white
                default: return isDark ? .solidEmphaticDark : .shallowLight
                }
        }

        var glassShadow: Color {
                return isDark ? Color.clear : Color.black.opacity(0.66)
        }
}

extension Color {

        /// Clear yet touchable
        static let interactiveClear: Color = Color(white: 0.5, opacity: 0.001)

        /// KeyView shadow color
        static let shadowGray: Color = Color.gray.opacity(0.35)
}

private extension Color {
        static let shallowLight       : Color = Color.white.opacity(0.95)
        static let legacyEmphaticLight: Color = Color(.displayP3, red: 104.0 / 255.0, green: 110.0 / 255.0, blue: 128.0 / 255.0, opacity: 0.25)
        static let emphaticLight      : Color = Color(white: 0.62, opacity: 0.35)

        static let shallowDark        : Color = Color(white: 1, opacity: 0.3)
        static let emphaticDark       : Color = Color(white: 1, opacity: 0.15)
        static let solidShallowDark   : Color = Color(white: 0.45, opacity: 0.95)
        static let solidEmphaticDark  : Color = Color(white: 0.3, opacity: 0.95)
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

