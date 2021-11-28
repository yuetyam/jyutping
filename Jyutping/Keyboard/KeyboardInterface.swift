enum KeyboardInterface: Hashable {

        case phonePortrait
        case phoneLandscape
        case padPortrait
        case padLandscape

        /// Keyboard floating on iPad
        case padFloating

        /// App for iPhone only, runs on iPad. iPad portrait mode
        case phoneAppOnPadPortrait

        /// App for iPhone only, runs on iPad. iPad landscape mode
        case phoneAppOnPadLandscape

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
