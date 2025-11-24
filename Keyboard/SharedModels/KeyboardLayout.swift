import Foundation

/// Cantonese Keyboard Layout
enum KeyboardLayout: Int, CaseIterable {

        /// 26鍵全鍵盤
        case qwerty = 1

        /// 26鍵三拼
        case tripleStroke = 2

        /// 9鍵（九宮格）
        case nineKey = 3

        /// 14鍵
        case fourteenKey = 4

        /// 18鍵
        case eighteenKey = 5

        /// Read KeyboardLayout from UserDefaults
        static func fetchSavedLayout() -> KeyboardLayout {
                let savedValue: Int = UserDefaults.standard.integer(forKey: OptionsKey.KeyboardLayout)
                return Self.allCases.first(where: { $0.rawValue == savedValue }) ?? Self.qwerty
        }

        /// 26鍵全鍵盤
        var isQwerty: Bool { self == .qwerty }

        /// 26鍵三拼
        var isTripleStroke: Bool { self == .tripleStroke }

        /// 9鍵（九宮格）
        var isNineKey: Bool { self == .nineKey }

        /// 14鍵
        var isFourteenKey: Bool { self == .fourteenKey }

        /// 18鍵
        var isEighteenKey: Bool { self == .fourteenKey }
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
