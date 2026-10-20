import Foundation

// MARK: - InputMethodMode

/// Describes the input mode currently used by the keyboard.
///
/// The raw value is persisted under `UserSettingsKey.LatestInputMethodMode`.
enum InputMethodMode: Int, CaseIterable {

        /// Cantonese Jyutping input.
        case cantonese = 1

        /// Direct alphabetic input.
        case abc = 2
}

extension InputMethodMode {

        /// Whether the mode accepts Cantonese Jyutping input.
        var isCantonese: Bool { self == .cantonese }

        /// Whether the mode accepts direct alphabetic input.
        var isABC: Bool { self == .abc }
}

extension InputMethodMode {

        /// Resolves a saved raw value, falling back to Cantonese for an unknown value.
        /// - Parameter value: The integer identifying an input mode in saved preferences.
        /// - Returns: The matching input mode, or `.cantonese` if the value is undefined.
        private static func mode(of value: Int) -> InputMethodMode {
                return allCases.first(where: { $0.rawValue == value }) ?? .cantonese
        }

        /// User-defaults key storing the most recently used input mode.
        private static let latestKey: String = UserSettingsKey.LatestInputMethodMode

        /// Reads the most recently used input mode from standard user defaults.
        /// - Returns: The saved input mode, or Cantonese if absent or unrecognized.
        static func fetchSavedLatestInputMode() -> InputMethodMode {
                let savedValue: Int = UserDefaults.standard.integer(forKey: latestKey)
                return mode(of: savedValue)
        }

        /// Stores the most recently used input mode in standard user defaults.
        /// - Parameter mode: The input mode to save.
        static func saveLatestInputMode(mode: InputMethodMode) {
                let value: Int = mode.rawValue
                UserDefaults.standard.set(value, forKey: latestKey)
        }
}


// MARK: - PreferredInputMode

/// Describes which input mode the keyboard should use when it starts.
///
/// The raw value is persisted under `UserSettingsKey.PreferredInputMethodMode`.
enum PreferredInputMode: Int, CaseIterable {

        /// Start in Cantonese Jyutping input.
        case cantonese = 1

        /// Start in direct alphabetic input.
        case abc = 2

        /// Restore the most recently used input mode.
        case previous = 3
}

extension PreferredInputMode {

        /// Resolves a saved raw value, falling back to Cantonese for an unknown value.
        /// - Parameter value: The integer identifying a startup preference in saved preferences.
        /// - Returns: The matching preference, or `.cantonese` if the value is undefined.
        private static func mode(of value: Int) -> PreferredInputMode {
                return allCases.first(where: { $0.rawValue == value }) ?? .cantonese
        }

        /// User-defaults key storing the preferred startup input mode.
        private static let preferredKey: String = UserSettingsKey.PreferredInputMethodMode

        /// The saved startup input-mode preference.
        ///
        /// An absent or unrecognized value resolves to `.cantonese`.
        static var saved: PreferredInputMode {
                let savedValue: Int = UserDefaults.standard.integer(forKey: preferredKey)
                return mode(of: savedValue)
        }

        /// Stores the preferred startup input-mode preference in standard user defaults.
        /// - Parameter mode: The startup preference to save.
        static func updateSaved(mode: PreferredInputMode) {
                let value: Int = mode.rawValue
                UserDefaults.standard.set(value, forKey: preferredKey)
        }
}
