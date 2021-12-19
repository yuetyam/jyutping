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
        case transform(KeyboardIdiom)
        case select(Candidate)
}
