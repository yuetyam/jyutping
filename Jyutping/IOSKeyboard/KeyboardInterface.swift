enum KeyboardInterface {

        case phonePortrait
        case phoneLandscape

        /// Keyboard floating on iPad
        case padFloating

        case padPortraitSmall
        case padPortraitMedium
        case padPortraitLarge

        case padLandscapeSmall
        case padLandscapeMedium
        case padLandscapeLarge

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
