enum KeyboardLayout: Hashable {
        case cantonese(ShiftState),
             cantoneseNumeric,
             cantoneseSymbolic,

             alphabetic(ShiftState),
             numeric,
             symbolic,

             emoji,
             numberPad,
             decimalPad,
             candidateBoard,
             settingsView

        var isEnglishLayout: Bool {
                switch self {
                case .alphabetic,
                     .numeric,
                     .symbolic:
                        return true
                default:
                        return false
                }
        }
        var isJyutpingMode: Bool {
                switch self {
                case .cantonese,
                     .candidateBoard:
                        return true
                default:
                        return false
                }
        }
}
