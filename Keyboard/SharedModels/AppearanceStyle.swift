import Foundation

/// Visual themes for the keyboard's keys.
///
/// Raw values identify styles in saved preferences and should remain stable.
enum AppearanceStyle: Int, CaseIterable {

        /// Translucent keys with the Liquid Glass appearance. (液態玻璃)
        case glass = 1

        /// A minimal style with a uniform key color and shallow shadows. (平白簡約)
        case clean = 2

        /// A classic style with distinct colors for input keys and action keys. (經典)
        case classic = 3

        /// A multicolored style that uses different colors across keys. (多彩)
        case colorful = 4

        /// A contrasting style using black and white. (黑白撞色)
        case blackAndWhite = 5

        /// A minimal style that defines keys with outlines, without shadows or other decorative effects. (線條)
        case outline = 6
}

extension AppearanceStyle {

        /// Whether this style is Liquid Glass. (液態玻璃)
        var isGlass: Bool { self == .glass }

        /// Whether this style uses a uniform key color and shallow shadows. (平白簡約)
        var isClean: Bool { self == .clean }

        /// Whether this style distinguishes input keys and action keys by color. (經典)
        var isClassic: Bool { self == .classic }

        /// Whether this style uses multiple colors across keys. (多彩)
        var isColorful: Bool { self == .colorful }

        /// Whether this style uses contrasting black and white. (黑白撞色)
        var isBlackAndWhite: Bool { self == .blackAndWhite }

        /// Whether this style defines keys with outlines. (線條)
        var isOutline: Bool { self == .outline }
}

extension AppearanceStyle {

        /// Resolves a saved raw value, falling back to Liquid Glass for an unrecognized value.
        /// - Parameter value: The integer identifying a style in saved preferences.
        static func style(of value: Int) -> AppearanceStyle {
                return allCases.first(where: { $0.rawValue == value }) ?? .glass
        }

        /// Reads the style from standard user defaults, falling back to Liquid Glass if absent or unrecognized.
        static func fetchSavedStyle() -> AppearanceStyle {
                let savedValue: Int = UserDefaults.standard.integer(forKey: UserSettingsKey.AppearanceStyle)
                return AppearanceStyle.style(of: savedValue)
        }

        /// Stores the style's raw value in standard user defaults.
        /// - Parameter style: The keyboard appearance style to save.
        static func save(style: AppearanceStyle) {
                let value: Int = style.rawValue
                UserDefaults.standard.set(value, forKey: UserSettingsKey.AppearanceStyle)
        }
}
