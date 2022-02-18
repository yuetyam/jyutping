enum Representative: Hashable {
        case alphabet(String?)
        case number(Int)
        case arrow(Direction)
        case modifier(Modifier)
        case instant(String)
        case transparent
        case other
}


extension UInt16 {
        var representative: Representative {
                switch self {
                case KeyCode.Arrow.VK_UP:
                        return .arrow(.up)
                case KeyCode.Arrow.VK_DOWN:
                        return .arrow(.down)
                case KeyCode.Arrow.VK_LEFT:
                        return .arrow(.left)
                case KeyCode.Arrow.VK_RIGHT:
                        return .arrow(.right)
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
                case KeyCode.Symbol.VK_COMMA:
                        return .instant("，")
                case KeyCode.Symbol.VK_SEMICOLON:
                        return .instant("；")
                case KeyCode.Symbol.VK_DOT:
                        return .instant("。")
                case KeyCode.Symbol.VK_BRACKET_LEFT:
                        return .instant("「")
                case KeyCode.Symbol.VK_BRACKET_RIGHT:
                        return .instant("」")
                case KeyCode.Symbol.VK_BACKSLASH:
                        return .instant("、")
                case KeyCode.Keypad.VK_KEYPAD_ENTER:
                        return .other
                case KeyCode.Keypad.VK_KEYPAD_CLEAR:
                        return .other
                case _ where KeyCode.keypadSet.contains(self):
                        return .transparent
                case _ where KeyCode.alphabetSet.contains(self):
                        return .alphabet(nil)
                default:
                        return .other
                }
        }
}

