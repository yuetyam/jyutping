/// Cantonese Keyboard Layout
enum KeyboardLayout: Int {

        /// 26鍵全鍵盤
        case qwerty = 1

        /// 26鍵三拼
        case tripleStroke = 2

        /// 九宮格
        case tenKey = 3

        /// 26鍵全鍵盤
        var isQwerty: Bool { self == .qwerty }

        /// 26鍵三拼
        var isTripleStroke: Bool { self == .tripleStroke }

        /// 九宮格
        var isTenKey: Bool { self == .tenKey }
}
