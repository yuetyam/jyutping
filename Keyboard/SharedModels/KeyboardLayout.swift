import Foundation
import CommonExtensions

/// Cantonese Keyboard Layout
enum KeyboardLayout: Int, CaseIterable {

        /// 26鍵全鍵盤
        case qwerty = 1

        /// 26鍵三拼
        case tripleStroke = 2

        /// 9鍵／九宮格
        case nineKey = 3

        /// 14鍵
        case fourteenKey = 14

        /// 15鍵
        case fifteenKey = 15

        /// 18鍵
        case eighteenKey = 18

        /// 19鍵
        case nineteenKey = 19

        /// 21鍵
        case twentyOneKey = 21

        /// Read KeyboardLayout from UserDefaults
        static func fetchSavedLayout() -> KeyboardLayout {
                let hasSavedValue: Bool = UserDefaults.standard.object(forKey: OptionsKey.KeyboardLayout) != nil
                let hasLegacySavedValue: Bool = UserDefaults.standard.object(forKey: LegacyOptionsKey.KeyboardLayout) != nil
                defer {
                        if hasLegacySavedValue {
                                UserDefaults.standard.removeObject(forKey: LegacyOptionsKey.KeyboardLayout)
                        }
                }
                let savedValue: Int = {
                        if hasSavedValue.negative && hasLegacySavedValue {
                                let oldValue: Int = UserDefaults.standard.integer(forKey: LegacyOptionsKey.KeyboardLayout)
                                UserDefaults.standard.set(oldValue, forKey: OptionsKey.KeyboardLayout)
                                return oldValue
                        } else {
                                return UserDefaults.standard.integer(forKey: OptionsKey.KeyboardLayout)
                        }
                }()
                return allCases.first(where: { $0.rawValue == savedValue }) ?? .qwerty
        }

        /// 26鍵全鍵盤
        var isQwerty: Bool { self == .qwerty }

        /// 26鍵三拼
        var isTripleStroke: Bool { self == .tripleStroke }

        /// 9鍵／九宮格
        var isNineKey: Bool { self == .nineKey }

        /// 14鍵
        var isFourteenKey: Bool { self == .fourteenKey }

        /// 15鍵
        var isFifteenKey: Bool { self == .fifteenKey }

        /// 18鍵
        var isEighteenKey: Bool { self == .eighteenKey }

        /// 19鍵
        var isNineteenKey: Bool { self == .nineteenKey }

        /// 21鍵
        var isTwentyOneKey: Bool { self == .twentyOneKey }

        /// Should use AmbiguousInputEvent
        var isAmbiguous: Bool {
                switch self {
                case .fourteenKey,
                .fifteenKey,
                .eighteenKey,
                .nineteenKey: true
                default: false
                }
        }
}

/// Numeric keyboard for the Qwerty KeyboardLayout
enum NumericLayout: Int, CaseIterable {

        /// Normal numeric keyboard
        case `default` = 1

        /// 10-key keypad-style digit keyboard with a symbol sidebar and some other keys
        case tailored = 2

        /// Read NumericLayout from UserDefaults
        static func fetchSavedLayout() -> NumericLayout {
                let savedValue: Int = UserDefaults.standard.integer(forKey: OptionsKey.NumericLayout)
                return allCases.first(where: { $0.rawValue == savedValue }) ?? .default
        }

        /// 10-key keypad-style digit keyboard with a symbol sidebar and some other keys
        var isTailored: Bool { self == .tailored }
}

/// Keyboard Layout for Stroke Reverse Lookup
enum StrokeLayout: Int, CaseIterable {

        /// QWERTY layout
        case `default` = 1

        /// 9-key (T9) layout
        case tailored = 2

        /// Read StrokeLayout from UserDefaults
        static func fetchSavedLayout() -> StrokeLayout {
                let savedValue: Int = UserDefaults.standard.integer(forKey: OptionsKey.StrokeLayout)
                return allCases.first(where: { $0.rawValue == savedValue }) ?? .default
        }

        /// 9-key (T9) layout
        var isTailored: Bool { self == .tailored }
}
