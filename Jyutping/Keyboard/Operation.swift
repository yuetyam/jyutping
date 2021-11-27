enum Operation: Hashable {
        case input(String)
        case separator
        case punctuation(String)
        case space
        case doubleSpace
        case backspace
        case clear
        case `return`
        case shift
        case doubleShift
        case switchTo(KeyboardIdiom)
}


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
}
