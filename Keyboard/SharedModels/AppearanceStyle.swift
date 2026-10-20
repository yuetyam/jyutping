import Foundation

/// Defines the visual themes for the keyboard's keys.
///
/// The selected theme is persisted as an integer under `UserSettingsKey.AppearanceStyle`.
/// An absent or unrecognized preference resolves to `.clean`.
enum AppearanceStyle: Int, CaseIterable {

        /// The default minimal style, with a uniform key color and shallow shadows. (平白簡約)
        case clean = 1

        /// Translucent keys with the Liquid Glass appearance. (液態玻璃)
        case glass = 2

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

        /// Whether this style uses the translucent Liquid Glass appearance. (液態玻璃)
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

        /// Resolves a saved raw value, falling back to `.clean` for an unrecognized value.
        /// - Parameter value: The integer identifying a style in saved preferences.
        /// - Returns: The matching style, or `.clean` if the value is not defined.
        private static func style(of value: Int) -> AppearanceStyle {
                return allCases.first(where: { $0.rawValue == value }) ?? .clean
        }

        /// User-defaults key storing the selected theme's integer raw value.
        private static let settingsKey: String = UserSettingsKey.AppearanceStyle

        /// Reads the style from standard user defaults, falling back to `.clean` if absent or unrecognized.
        /// - Returns: The saved theme, or the default Clean style.
        static func fetchSavedStyle() -> AppearanceStyle {
                let savedValue: Int = UserDefaults.standard.integer(forKey: settingsKey)
                return style(of: savedValue)
        }

        /// Stores the style's raw value in standard user defaults.
        /// - Parameter style: The keyboard appearance style to save.
        static func save(style: AppearanceStyle) {
                let value: Int = style.rawValue
                UserDefaults.standard.set(value, forKey: settingsKey)
        }
}
