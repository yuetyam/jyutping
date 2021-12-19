enum KeyboardInterface: Hashable {

        case phonePortrait
        case phoneLandscape
        case padPortrait
        case padLandscape

        /// Keyboard floating on iPad
        case padFloating

        /// `KeyboardInterface == .phonePortrait || .phoneLandscape || .padFloating`
        var isCompact: Bool {
                switch self {
                case .phonePortrait, .phoneLandscape, .padFloating:
                        return true
                default:
                        return false
                }
        }

        /// `KeyboardInterface == .phonePortrait`
        var isPhonePortrait: Bool {
                return self == .phonePortrait
        }
}
