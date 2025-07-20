import CoreIME
import CommonExtensions

enum Representative: Hashable {
        case letter(InputEvent)
        case number(InputEvent)
        case keypadNumber(Int)
        case arrow(Direction)
        case punctuation(PunctuationKey)
        /// Grave accent; Backtick; Backquote
        case grave
        /// Apostrophe
        case quote
        case `return`
        case backspace
        case forwardDelete
        case escape
        case clear
        case space
        case tab
        case pageUp
        case pageDown
        case other
}

extension UInt16 {
        var representative: Representative {
                switch self {
                case KeyCode.Keypad.keypad0:
                        return .keypadNumber(0)
                case KeyCode.Keypad.keypad1:
                        return .keypadNumber(1)
                case KeyCode.Keypad.keypad2:
                        return .keypadNumber(2)
                case KeyCode.Keypad.keypad3:
                        return .keypadNumber(3)
                case KeyCode.Keypad.keypad4:
                        return .keypadNumber(4)
                case KeyCode.Keypad.keypad5:
                        return .keypadNumber(5)
                case KeyCode.Keypad.keypad6:
                        return .keypadNumber(6)
                case KeyCode.Keypad.keypad7:
                        return .keypadNumber(7)
                case KeyCode.Keypad.keypad8:
                        return .keypadNumber(8)
                case KeyCode.Keypad.keypad9:
                        return .keypadNumber(9)
                case KeyCode.Special.space:
                        return .space
                case KeyCode.Special.return, KeyCode.Keypad.keypadEnter:
                        return .return
                case KeyCode.Special.backwardDelete:
                        return .backspace
                case KeyCode.Special.forwardDelete:
                        return .forwardDelete
                case KeyCode.Arrow.up:
                        return .arrow(.up)
                case KeyCode.Arrow.down:
                        return .arrow(.down)
                case KeyCode.Arrow.left:
                        return .arrow(.left)
                case KeyCode.Arrow.right:
                        return .arrow(.right)
                case KeyCode.Symbol.grave:
                        return .grave
                case KeyCode.Symbol.comma:
                        return .punctuation(.comma)
                case KeyCode.Symbol.period:
                        return .punctuation(.period)
                case KeyCode.Symbol.slash:
                        return .punctuation(.slash)
                case KeyCode.Symbol.semicolon:
                        return .punctuation(.semicolon)
                case KeyCode.Symbol.bracketLeft:
                        return .punctuation(.bracketLeft)
                case KeyCode.Symbol.bracketRight:
                        return .punctuation(.bracketRight)
                case KeyCode.Symbol.backslash:
                        return .punctuation(.backSlash)
                case KeyCode.Symbol.minus:
                        return .punctuation(.minus)
                case KeyCode.Symbol.equal:
                        return .punctuation(.equal)
                case KeyCode.Symbol.quote:
                        return .quote
                case KeyCode.Special.escape:
                        return .escape
                case KeyCode.Keypad.keypadClear:
                        return .clear
                case KeyCode.Special.tab:
                        return .tab
                case KeyCode.Special.pageUp:
                        return .pageUp
                case KeyCode.Special.pageDown:
                        return .pageDown
                case _ where InputEvent.isMatchedNumber(keyCode: self):
                        guard let numberEvent = InputEvent.matchEvent(for: self) else { return .other }
                        return .number(numberEvent)
                case _ where InputEvent.isMatchedLetter(keyCode: self):
                        guard let letterEvent = InputEvent.matchEvent(for: self) else { return .other }
                        return .letter(letterEvent)
                default:
                        return .other
                }
        }
}
