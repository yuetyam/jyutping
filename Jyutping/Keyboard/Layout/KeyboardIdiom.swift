enum KeyboardIdiom: Hashable {

        case cantonese(ShiftState)
        case cantoneseNumeric
        case cantoneseSymbolic

        case alphabetic(ShiftState)
        case numeric
        case symbolic

        case gridKeyboard
        case gridNumeric
        case gridSymbolic

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
                     .candidates,
                     .gridKeyboard:
                        return true
                default:
                        return false
                }
        }
}
