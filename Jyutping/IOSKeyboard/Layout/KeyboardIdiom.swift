enum KeyboardIdiom: Hashable {

        case cantonese(ShiftState)
        case cantoneseNumeric
        case cantoneseSymbolic

        case alphabetic(ShiftState)
        case numeric
        case symbolic

        case tenKeyCantonese
        case tenKeyNumeric

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
                case .tenKeyCantonese,
                     .tenKeyNumeric:
                        return true
                default:
                        return false
                }
        }
}


extension KeyboardIdiom {
        func events(keyboardLayout: KeyboardLayout, keyboardInterface: KeyboardInterface, needsInputModeSwitchKey: Bool) -> [[KeyboardEvent]] {
                switch self {
                case .cantonese(.lowercased):
                        switch keyboardLayout {
                        case .saamPing:
                                return saamPingKeys(keyboardInterface: keyboardInterface, needsInputModeSwitchKey: needsInputModeSwitchKey, uppercased: false)
                        default:
                                return cantoneseKeys(keyboardInterface: keyboardInterface, needsInputModeSwitchKey: needsInputModeSwitchKey, uppercased: false)
                        }
                case .cantonese(.uppercased), .cantonese(.capsLocked):
                        switch keyboardLayout {
                        case .saamPing:
                                return saamPingKeys(keyboardInterface: keyboardInterface, needsInputModeSwitchKey: needsInputModeSwitchKey, uppercased: true)
                        default:
                                return cantoneseKeys(keyboardInterface: keyboardInterface, needsInputModeSwitchKey: needsInputModeSwitchKey, uppercased: true)
                        }
                case .alphabetic(.lowercased):
                        return alphabeticKeys(keyboardInterface: keyboardInterface, needsInputModeSwitchKey: needsInputModeSwitchKey, uppercased: false)
                case .alphabetic(.uppercased), .alphabetic(.capsLocked):
                        return alphabeticKeys(keyboardInterface: keyboardInterface, needsInputModeSwitchKey: needsInputModeSwitchKey, uppercased: true)
                case .cantoneseNumeric:
                        return cantoneseNumericKeys(keyboardInterface: keyboardInterface, needsInputModeSwitchKey: needsInputModeSwitchKey)
                case .cantoneseSymbolic:
                        return cantoneseSymbolicKeys(keyboardInterface: keyboardInterface, needsInputModeSwitchKey: needsInputModeSwitchKey)
                case .numeric:
                        return numericKeys(keyboardInterface: keyboardInterface, needsInputModeSwitchKey: needsInputModeSwitchKey)
                case .symbolic:
                        return symbolicKeys(keyboardInterface: keyboardInterface, needsInputModeSwitchKey: needsInputModeSwitchKey)
                default:
                        return []
                }
        }

        func letters(uppercased: Bool) -> [[KeyboardEvent]] {
                let arrayTextArray: [[String]] = {
                        if uppercased {
                                return [
                                        ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
                                        ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
                                        ["Z", "X", "C", "V", "B", "N", "M"]
                                ]
                        } else {
                                return [
                                        ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
                                        ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
                                        ["z", "x", "c", "v", "b", "n", "m"]
                                ]
                        }
                }()
                let eventRows: [[KeyboardEvent]] = arrayTextArray.map({ $0.map({ KeyboardEvent.input(.init(primary: .init($0))) }) })
                return eventRows
        }
}
