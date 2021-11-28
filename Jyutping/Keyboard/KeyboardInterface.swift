enum KeyboardInterface: Hashable {

        case phonePortrait
        case phoneLandscape
        case padFloating
        case padPortrait
        case padLandscape

        var isCompact: Bool {
                switch self {
                case .phonePortrait, .phoneLandscape, .padFloating:
                        return true
                default:
                        return false
                }
        }

        var isPhonePortrait: Bool {
                return self == .phonePortrait
        }
}
