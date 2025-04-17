import Foundation

/// Cantonese Keyboard Layout
enum KeyboardLayout: Int, CaseIterable {

        /// 26鍵全鍵盤
        case qwerty = 1

        /// 26鍵三拼
        case tripleStroke = 2

        /// 九宮格
        case tenKey = 3

        /// Read KeyboardLayout from UserDefaults
        static func fetchSavedLayout() -> KeyboardLayout {
                let savedValue: Int = UserDefaults.standard.integer(forKey: OptionsKey.KeyboardLayout)
                return Self.allCases.first(where: { $0.rawValue == savedValue }) ?? Self.qwerty
        }

        /// 26鍵全鍵盤
        var isQwerty: Bool { self == .qwerty }

        /// 26鍵三拼
        var isTripleStroke: Bool { self == .tripleStroke }

        /// 九宮格
        var isTenKey: Bool { self == .tenKey }
}

/// Numeric keyboard for the Qwerty KeyboardLayout
enum NumericLayout: Int, CaseIterable {

        /// Normal Numeric Keyboard
        case `default` = 1

        /// 10 Key KeyPad
        case numberKeyPad = 2

        /// Read NumericLayout from UserDefaults
        static func fetchSavedLayout() -> NumericLayout {
                let savedValue: Int = UserDefaults.standard.integer(forKey: OptionsKey.NumericLayout)
                return Self.allCases.first(where: { $0.rawValue == savedValue }) ?? Self.default
        }

        /// 10 Key KeyPad
        var isNumberKeyPad: Bool { self == .numberKeyPad }
}

/// Keyboard Layout for Stroke Reverse Lookup
enum StrokeLayout: Int, CaseIterable {

        /// QWERTY layout
        case `default` = 1

        /// 10 Key KeyPad
        case tenKey = 2

        /// Read StrokeLayout from UserDefaults
        static func fetchSavedLayout() -> StrokeLayout {
                let savedValue: Int = UserDefaults.standard.integer(forKey: OptionsKey.StrokeLayout)
                return Self.allCases.first(where: { $0.rawValue == savedValue }) ?? Self.default
        }

        /// 10 Key KeyPad
        var isTenKey: Bool { self == .tenKey }
}
