enum KeyboardIdiom: Hashable {

        case cantonese(ShiftState)
        case cantoneseNumeric
        case cantoneseSymbolic

        case alphabetic(ShiftState)
        case numeric
        case symbolic

        case gridKeyboard
        case gridNumeric

        case candidates
        case settings
        case emoji

        case numberPad
        case decimalPad
}

extension KeyboardIdiom {

        var isEnglishMode: Bool {
                switch self {
                case .alphabetic,
                     .numeric,
                     .symbolic:
                        return true
                default:
                        return false
                }
        }

        var isPingMode: Bool {
                switch self {
                case .cantonese,
                     .candidates:
                        return true
                default:
                        return false
                }
        }

        var isGridMode: Bool {
                switch self {
                case .gridKeyboard,
                     .gridNumeric:
                        return true
                default:
                        return false
                }
        }
}
