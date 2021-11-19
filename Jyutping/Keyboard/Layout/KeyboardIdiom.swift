enum KeyboardIdiom: Hashable {
        case cantonese(ShiftState),
             cantoneseNumeric,
             cantoneseSymbolic,
             alphabetic(ShiftState),
             numeric,
             symbolic,
             candidateBoard,
             settingsView,
             numberPad,
             decimalPad,
             emoji
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
        var isCantoneseMode: Bool {
                switch self {
                case .cantonese,
                     .candidateBoard:
                        return true
                default:
                        return false
                }
        }
}
