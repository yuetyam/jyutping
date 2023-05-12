enum KeyboardEvent: Hashable {
        case backspace
        case capsLock
        case comma
        case dismiss
        case globe
        case hidden(String)
        case input(KeyUnit)
        case newLine
        case numeric
        case period
        case placeholder
        case shift
        case space
        case tab
        case transform(KeyboardType)
}
