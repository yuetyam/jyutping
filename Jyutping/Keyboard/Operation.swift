import CoreIME

enum Operation: Hashable {
        case input(String)
        case process(String)
        case combine(Combo)
        case space
        case doubleSpace
        case backspace
        case clearBuffer
        case `return`
        case shift
        case doubleShift
        case tab
        case dismiss
        case select(Candidate)

        case paste
        case clearClipboard
        case clearLeadingText
        case moveCursorBackward
        case moveCursorForward
        case jumpToHead
        case jumpToTail
}
