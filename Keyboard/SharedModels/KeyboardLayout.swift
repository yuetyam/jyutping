import Foundation

/// Cantonese Keyboard Layout
enum KeyboardLayout: Int {

        /// 26鍵全鍵盤
        case qwerty = 1

        /// 26鍵三拼
        case tripleStroke = 2

        /// 九宮格
        case tenKey = 3

        /// Read KeyboardLayout from UserDefaults
        static func fetchSavedLayout() -> KeyboardLayout {
                let savedValue: Int = UserDefaults.standard.integer(forKey: OptionsKey.KeyboardLayout)
                switch savedValue {
                case qwerty.rawValue:
                        return .qwerty
                case tripleStroke.rawValue:
                        return .tripleStroke
                case tenKey.rawValue:
                        return .tenKey
                default:
                        return .qwerty
                }
        }

        /// 26鍵全鍵盤
        var isQwerty: Bool { self == .qwerty }

        /// 26鍵三拼
        var isTripleStroke: Bool { self == .tripleStroke }

        /// 九宮格
        var isTenKey: Bool { self == .tenKey }
}
