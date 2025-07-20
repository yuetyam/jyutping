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

        case copyAllText
        case cutAllText
        case clearAllText
        case convertAllText
        case clearClipboard
        case paste
        case moveCursorBackward
        case moveCursorForward
        case jumpToHead
        case jumpToTail
        case forwardDelete
}
