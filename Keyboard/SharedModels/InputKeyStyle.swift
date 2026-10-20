import Foundation

/// Controls the extra digit and symbol alternatives offered by supported letter keys.
///
/// This setting is independent of the optional number row controlled by `Options.needsNumberRow`.
/// The selected style is persisted as an integer under `UserSettingsKey.InputKeyStyle`.
enum InputKeyStyle: Int, CaseIterable {

        /// Letter keys without extra digit or symbol alternatives; the default style.
        case clear = 1

        /// Letter keys with extra digit alternatives on the top letter row.
        case numbers = 2

        /// Letter keys with extra digit and symbol alternatives across supported rows.
        case symbols = 3
}

extension InputKeyStyle {

        /// Whether letter keys omit extra digit and symbol alternatives.
        var isClear: Bool { self == .clear }

        /// Whether the selected style adds only digit alternatives, excluding the symbols style.
        var isNumberApplied: Bool { self == .numbers }

        /// Whether the selected style adds both digit and symbol alternatives.
        var isSymbolApplied: Bool { self == .symbols }
}

extension InputKeyStyle {

        /// Resolves a saved raw value, falling back to `.clear` for an unrecognized value.
        /// - Parameter value: The integer identifying a style in saved preferences.
        /// - Returns: The matching style, or `.clear` if the value is not defined.
        private static func style(of value: Int) -> InputKeyStyle {
                return allCases.first(where: { $0.rawValue == value }) ?? .clear
        }

        /// User-defaults key storing the selected style's integer raw value.
        private static let settingsKey: String = UserSettingsKey.InputKeyStyle

        /// Reads the style from standard user defaults, falling back to `.clear` if absent or unrecognized.
        /// - Returns: The saved style, or the default letter-only style.
        static func fetchSavedStyle() -> InputKeyStyle {
                let savedValue: Int = UserDefaults.standard.integer(forKey: settingsKey)
                return style(of: savedValue)
        }

        /// Stores the style's raw value in standard user defaults.
        /// - Parameter style: The letter-key style to save.
        static func save(style: InputKeyStyle) {
                let value: Int = style.rawValue
                UserDefaults.standard.set(value, forKey: settingsKey)
        }
}
