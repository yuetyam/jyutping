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
        case tab
        case transform(KeyboardIdiom)
        case dismiss
        case select(Candidate)
        case tenKey(Combination)
}
