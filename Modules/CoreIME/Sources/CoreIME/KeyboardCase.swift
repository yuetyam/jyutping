public enum KeyboardCase: Int, CaseIterable, Sendable {

        case lowercased = 1
        case uppercased = 2
        case capsLocked = 3

        public var isLowercased: Bool { self == .lowercased }
        public var isUppercased: Bool { self == .uppercased }
        public var isCapsLocked: Bool { self == .capsLocked }

        /// Is not lowercased
        public var isCapitalized: Bool { self != .lowercased }
}
