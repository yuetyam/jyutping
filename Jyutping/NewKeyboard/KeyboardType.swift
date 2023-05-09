enum KeyboardType: Hashable {

        case abc(KeyboardCase)
        case numeric
        case symbolic

        case cantonese(KeyboardCase)
        case cantoneseNumeric
        case cantoneseSymbolic

        case saamPing(KeyboardCase)

        case tenKeyCantonese
        case tenKeyCantoneseNumeric

        case numberPad
        case decimalPad

        case candidateBoard
        case emojiBoard

        case editingPanel
        case settings
}

extension KeyboardType {

        var isABCMode: Bool {
                switch self {
                case .abc,
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
                     .saamPing,
                     .tenKeyCantonese,
                     .candidateBoard:
                        return true
                default:
                        return false
                }
        }
        var isTenKeyMode: Bool {
                switch self {
                case .tenKeyCantonese,
                     .tenKeyCantoneseNumeric:
                        return true
                default:
                        return false
                }
        }
}
