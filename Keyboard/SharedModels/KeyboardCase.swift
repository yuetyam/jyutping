enum KeyboardCase: Int {

        case lowercased
        case uppercased
        case capsLocked

        var isLowercased: Bool {
                return self == .lowercased
        }
        var isUppercased: Bool {
                return self == .uppercased
        }
        var isCapsLocked: Bool {
                return self == .capsLocked
        }

        /// Is not lowercased
        var isCapitalized: Bool {
                switch self {
                case .lowercased: false
                case .uppercased: true
                case .capsLocked: true
                }
        }
}
