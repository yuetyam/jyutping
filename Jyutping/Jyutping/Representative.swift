/*
/// Corresponding to [NSEvent.ModifierFlags](https://developer.apple.com/documentation/appkit/nsevent/modifierflags)
enum Modifier {
        case capsLock
        case command
        case control
        case function
        case help
        case numericPad
        case option
        case shift
        case unknown
}
*/


enum Representative: Hashable {
        case alphabet(String)
        case number(Int)
        case arrow(Direction)
        case punctuation(PunctuationKey)
        case separator
        case `return`
        case backspace
        case escapeClear
        case space
        case previousPage
        case nextPage
        case other
}


extension UInt16 {
        var representative: Representative {
                switch self {
                case KeyCode.Alphabet.VK_A:
                        return .alphabet("a")
                case KeyCode.Alphabet.VK_B:
                        return .alphabet("b")
                case KeyCode.Alphabet.VK_C:
                        return .alphabet("c")
                case KeyCode.Alphabet.VK_D:
                        return .alphabet("d")
                case KeyCode.Alphabet.VK_E:
                        return .alphabet("e")
                case KeyCode.Alphabet.VK_F:
                        return .alphabet("f")
                case KeyCode.Alphabet.VK_G:
                        return .alphabet("g")
                case KeyCode.Alphabet.VK_H:
                        return .alphabet("h")
                case KeyCode.Alphabet.VK_I:
                        return .alphabet("i")
                case KeyCode.Alphabet.VK_J:
                        return .alphabet("j")
                case KeyCode.Alphabet.VK_K:
                        return .alphabet("k")
                case KeyCode.Alphabet.VK_L:
                        return .alphabet("l")
                case KeyCode.Alphabet.VK_M:
                        return .alphabet("m")
                case KeyCode.Alphabet.VK_N:
                        return .alphabet("n")
                case KeyCode.Alphabet.VK_O:
                        return .alphabet("o")
                case KeyCode.Alphabet.VK_P:
                        return .alphabet("p")
                case KeyCode.Alphabet.VK_Q:
                        return .alphabet("q")
                case KeyCode.Alphabet.VK_R:
                        return .alphabet("r")
                case KeyCode.Alphabet.VK_S:
                        return .alphabet("s")
                case KeyCode.Alphabet.VK_T:
                        return .alphabet("t")
                case KeyCode.Alphabet.VK_U:
                        return .alphabet("u")
                case KeyCode.Alphabet.VK_V:
                        return .alphabet("v")
                case KeyCode.Alphabet.VK_W:
                        return .alphabet("w")
                case KeyCode.Alphabet.VK_X:
                        return .alphabet("x")
                case KeyCode.Alphabet.VK_Y:
                        return .alphabet("y")
                case KeyCode.Alphabet.VK_Z:
                        return .alphabet("z")
                case KeyCode.Number.VK_KEY_0:
                        return .number(0)
                case KeyCode.Number.VK_KEY_1:
                        return .number(1)
                case KeyCode.Number.VK_KEY_2:
                        return .number(2)
                case KeyCode.Number.VK_KEY_3:
                        return .number(3)
                case KeyCode.Number.VK_KEY_4:
                        return .number(4)
                case KeyCode.Number.VK_KEY_5:
                        return .number(5)
                case KeyCode.Number.VK_KEY_6:
                        return .number(6)
                case KeyCode.Number.VK_KEY_7:
                        return .number(7)
                case KeyCode.Number.VK_KEY_8:
                        return .number(8)
                case KeyCode.Number.VK_KEY_9:
                        return .number(9)
                case KeyCode.Special.VK_SPACE:
                        return .space
                case KeyCode.Special.VK_RETURN, KeyCode.Keypad.VK_KEYPAD_ENTER:
                        return .return
                case KeyCode.Special.VK_BACKWARD_DELETE:
                        return .backspace
                case KeyCode.Arrow.VK_UP:
                        return .arrow(.up)
                case KeyCode.Arrow.VK_DOWN:
                        return .arrow(.down)
                case KeyCode.Arrow.VK_LEFT:
                        return .arrow(.left)
                case KeyCode.Arrow.VK_RIGHT:
                        return .arrow(.right)
                case KeyCode.Symbol.VK_COMMA:
                        return .punctuation(.comma)
                case KeyCode.Symbol.VK_DOT:
                        return .punctuation(.period)
                case KeyCode.Symbol.VK_SLASH:
                        return .punctuation(.slash)
                case KeyCode.Symbol.VK_SEMICOLON:
                        return .punctuation(.semicolon)
                case KeyCode.Symbol.VK_BRACKET_LEFT:
                        return .punctuation(.bracketLeft)
                case KeyCode.Symbol.VK_BRACKET_RIGHT:
                        return .punctuation(.bracketRight)
                case KeyCode.Symbol.VK_BACKSLASH:
                        return .punctuation(.backSlash)
                case KeyCode.Symbol.VK_QUOTE:
                        return .separator
                case KeyCode.Special.VK_ESCAPE, KeyCode.Keypad.VK_KEYPAD_CLEAR:
                        return .escapeClear
                case KeyCode.Symbol.VK_MINUS, KeyCode.Special.VK_PAGEUP:
                        return .previousPage
                case KeyCode.Symbol.VK_EQUAL, KeyCode.Special.VK_PAGEDOWN:
                        return .nextPage
                default:
                        return .other
                }
        }
}


