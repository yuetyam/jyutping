enum KeyboardEvent: Hashable {
        case backspace
        case capsLock
        case dismiss
        case globe
        case hidden(String)
        case input(KeyUnit)
        case newLine
        case placeholder
        case shift
        case space
        case tab
        case transform(KeyboardType)
}
