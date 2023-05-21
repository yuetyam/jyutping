enum KeyboardCase: Int {

        case lowercased
        case uppercased
        case capsLocked

        var isLowercased: Bool {
                return self == .lowercased
        }
}
