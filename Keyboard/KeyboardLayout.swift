import UIKit

enum ShiftState {
        case lowercased,
             uppercased,
             capsLocked
}

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

        func keys(needsInputModeSwitchKey: Bool, arrangement: Int) -> [[KeyboardEvent]] {
                switch self {
                case .cantonese(.lowercased):
                        switch arrangement {
                        case 2:
                                return saamPingLowercasedKeys(needsInputModeSwitchKey)
                        default:
                                return cantoneseLowercasedKeys(needsInputModeSwitchKey)
                        }
                case .cantonese(.uppercased), .cantonese(.capsLocked):
                        switch arrangement {
                        case 2:
                                return saamPingUppercasedKeys(needsInputModeSwitchKey)
                        default:
                                return cantoneseUppercasedKeys(needsInputModeSwitchKey)
                        }
                case .alphabetic(.lowercased):
                        return alphabeticLowercasedKeys(needsInputModeSwitchKey)
                case .alphabetic(.uppercased), .alphabetic(.capsLocked):
                        return alphabeticUppercasedKeys(needsInputModeSwitchKey)
                case .cantoneseNumeric:
                        return cantoneseNumericKeys(needsInputModeSwitchKey)
                case .cantoneseSymbolic:
                        return cantoneseSymbolicKeys(needsInputModeSwitchKey)
                case .numeric:
                        return numericKeys(needsInputModeSwitchKey)
                case .symbolic:
                        return symbolicKeys(needsInputModeSwitchKey)
                default:
                        return []
                }
        }

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

private extension KeyboardLayout {
        func cantoneseLowercasedKeys(_ needsInputModeSwitchKey: Bool) -> [[KeyboardEvent]] {
                let arrayTextArray: [[String]] = [
                        ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
                        ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
                        ["z", "x", "c", "v", "b", "n", "m"]
                ]
                var eventRows: [[KeyboardEvent]] = arrayTextArray.keysRows
                eventRows[1].insert(.shadowKey("a"), at: 0)
                eventRows[1].insert(.shadowKey("a"), at: 0)
                eventRows[1].append(.shadowKey("l"))
                eventRows[1].append(.shadowKey("l"))
                eventRows[2].insert(.shift, at: 0)
                eventRows[2].insert(.shadowKey("z"), at: 1)
                eventRows[2].append(.shadowBackspace)
                eventRows[2].append(.backspace)
                let comma: KeyboardEvent = .key(.cantoneseCommaSeat)
                let bottomEvents: [KeyboardEvent] = needsInputModeSwitchKey ?
                        [.switchTo(.cantoneseNumeric), .switchInputMethod, .space, comma, .newLine] :
                        [.switchTo(.cantoneseNumeric), comma, .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
        func cantoneseUppercasedKeys(_ needsInputModeSwitchKey: Bool) -> [[KeyboardEvent]] {
                let arrayTextArray: [[String]] = [
                        ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
                        ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
                        ["Z", "X", "C", "V", "B", "N", "M"]
                ]
                var eventRows: [[KeyboardEvent]] = arrayTextArray.keysRows
                eventRows[1].insert(.shadowKey("A"), at: 0)
                eventRows[1].insert(.shadowKey("A"), at: 0)
                eventRows[1].append(.shadowKey("L"))
                eventRows[1].append(.shadowKey("L"))
                eventRows[2].insert(.shift, at: 0)
                eventRows[2].insert(.shadowKey("Z"), at: 1)
                eventRows[2].append(.shadowBackspace)
                eventRows[2].append(.backspace)
                let comma: KeyboardEvent = .key(.cantoneseCommaSeat)
                let bottomEvents: [KeyboardEvent] = needsInputModeSwitchKey ?
                        [.switchTo(.cantoneseNumeric), .switchInputMethod, .space, comma, .newLine] :
                        [.switchTo(.cantoneseNumeric), comma, .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
        func saamPingLowercasedKeys(_ needsInputModeSwitchKey: Bool) -> [[KeyboardEvent]] {
                let arrayTextArray: [[String]] = [
                        ["aa", "w", "e", "eo", "t", "yu", "u", "i", "o", "p"],
                        ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
                        ["z", "oe", "c", "ng", "b", "n", "m"]
                ]
                var eventRows: [[KeyboardEvent]] = arrayTextArray.keysRows
                eventRows[1].insert(.shadowKey("a"), at: 0)
                eventRows[1].insert(.shadowKey("a"), at: 0)
                eventRows[1].append(.shadowKey("l"))
                eventRows[1].append(.shadowKey("l"))
                eventRows[2].insert(.shift, at: 0)
                eventRows[2].insert(.shadowKey("z"), at: 1)
                eventRows[2].append(.shadowBackspace)
                eventRows[2].append(.backspace)
                let comma: KeyboardEvent = .key(.cantoneseCommaSeat)
                let bottomEvents: [KeyboardEvent] = needsInputModeSwitchKey ?
                        [.switchTo(.cantoneseNumeric), .switchInputMethod, .space, comma, .newLine] :
                        [.switchTo(.cantoneseNumeric), comma, .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
        func saamPingUppercasedKeys(_ needsInputModeSwitchKey: Bool) -> [[KeyboardEvent]] {
                let arrayTextArray: [[String]] = [
                        ["AA", "W", "E", "EO", "T", "YU", "U", "I", "O", "P"],
                        ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
                        ["Z", "OE", "C", "NG", "B", "N", "M"]
                ]
                var eventRows: [[KeyboardEvent]] = arrayTextArray.keysRows
                eventRows[1].insert(.shadowKey("A"), at: 0)
                eventRows[1].insert(.shadowKey("A"), at: 0)
                eventRows[1].append(.shadowKey("L"))
                eventRows[1].append(.shadowKey("L"))
                eventRows[2].insert(.shift, at: 0)
                eventRows[2].insert(.shadowKey("Z"), at: 1)
                eventRows[2].append(.shadowBackspace)
                eventRows[2].append(.backspace)
                let comma: KeyboardEvent = .key(.cantoneseCommaSeat)
                let bottomEvents: [KeyboardEvent] = needsInputModeSwitchKey ?
                        [.switchTo(.cantoneseNumeric), .switchInputMethod, .space, comma, .newLine] :
                        [.switchTo(.cantoneseNumeric), comma, .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
        func alphabeticLowercasedKeys(_ needsInputModeSwitchKey: Bool) -> [[KeyboardEvent]] {
                let arrayTextArray: [[String]] = [
                        ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
                        ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
                        ["z", "x", "c", "v", "b", "n", "m"]
                ]
                var eventRows: [[KeyboardEvent]] = arrayTextArray.keysRows
                eventRows[1].insert(.shadowKey("a"), at: 0)
                eventRows[1].insert(.shadowKey("a"), at: 0)
                eventRows[1].append(.shadowKey("l"))
                eventRows[1].append(.shadowKey("l"))
                eventRows[2].insert(.shift, at: 0)
                eventRows[2].insert(.shadowKey("z"), at: 1)
                eventRows[2].append(.shadowBackspace)
                eventRows[2].append(.backspace)
                let period: KeyboardEvent = .key(.periodSeat)
                let bottomEvents: [KeyboardEvent] = needsInputModeSwitchKey ?
                        [.switchTo(.numeric), .switchInputMethod, .space, period, .newLine] :
                        [.switchTo(.numeric), period, .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
        func alphabeticUppercasedKeys(_ needsInputModeSwitchKey: Bool) -> [[KeyboardEvent]] {
                let arrayTextArray: [[String]] = [
                        ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
                        ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
                        ["Z", "X", "C", "V", "B", "N", "M"]
                ]
                var eventRows: [[KeyboardEvent]] = arrayTextArray.keysRows
                eventRows[1].insert(.shadowKey("A"), at: 0)
                eventRows[1].insert(.shadowKey("A"), at: 0)
                eventRows[1].append(.shadowKey("L"))
                eventRows[1].append(.shadowKey("L"))
                eventRows[2].insert(.shift, at: 0)
                eventRows[2].insert(.shadowKey("Z"), at: 1)
                eventRows[2].append(.shadowBackspace)
                eventRows[2].append(.backspace)
                let period: KeyboardEvent = .key(.periodSeat)
                let bottomEvents: [KeyboardEvent] = needsInputModeSwitchKey ?
                        [.switchTo(.numeric), .switchInputMethod, .space, period, .newLine] :
                        [.switchTo(.numeric), period, .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
        func cantoneseNumericKeys(_ needsInputModeSwitchKey: Bool) -> [[KeyboardEvent]] {
                let arrayTextArray: [[String]] = [
                        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
                        ["-", "/", "：", "；", "（", "）", "$", "@", "「", "」"],
                        ["。", "，", "、", "？", "！", "."]
                ]
                var eventRows: [[KeyboardEvent]] = arrayTextArray.keysRows
                eventRows[2].insert(.switchTo(.cantoneseSymbolic), at: 0)
                eventRows[2].insert(.none, at: 1)
                eventRows[2].append(.none)
                eventRows[2].append(.backspace)
                let bottomEvents: [KeyboardEvent] = needsInputModeSwitchKey ?
                        [.switchTo(.cantonese(.lowercased)), .switchInputMethod, .space, .newLine] :
                        [.switchTo(.cantonese(.lowercased)), .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
        func numericKeys(_ needsInputModeSwitchKey: Bool) -> [[KeyboardEvent]] {
                let arrayTextArray: [[String]] = [
                        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
                        ["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""],
                        [".", ",", "?", "!", "'"]
                ]
                var eventRows: [[KeyboardEvent]] = arrayTextArray.keysRows
                eventRows[2].insert(.switchTo(.symbolic), at: 0)
                eventRows[2].insert(.none, at: 1)
                eventRows[2].append(.none)
                eventRows[2].append(.backspace)
                let bottomEvents: [KeyboardEvent] = needsInputModeSwitchKey ?
                        [.switchTo(.alphabetic(.lowercased)), .switchInputMethod, .space, .newLine] :
                        [.switchTo(.alphabetic(.lowercased)), .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
        func cantoneseSymbolicKeys(_ needsInputModeSwitchKey: Bool) -> [[KeyboardEvent]] {
                let arrayTextArray: [[String]] = [
                        ["［", "］", "｛", "｝", "#", "%", "^", "*", "+", "="],
                        ["_", "—", "＼", "｜", "～", "《", "》", "¥", "&", "\u{00B7}"],
                        ["⋯", "【", "】", "〔", "〕", "£"]
                ]
                var eventRows: [[KeyboardEvent]] = arrayTextArray.keysRows
                eventRows[2].insert(.switchTo(.cantoneseNumeric), at: 0)
                eventRows[2].insert(.none, at: 1)
                eventRows[2].append(.none)
                eventRows[2].append(.backspace)
                let bottomEvents: [KeyboardEvent] = needsInputModeSwitchKey ?
                        [.switchTo(.cantonese(.lowercased)), .switchInputMethod, .space, .newLine] :
                        [.switchTo(.cantonese(.lowercased)), .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
        func symbolicKeys(_ needsInputModeSwitchKey: Bool) -> [[KeyboardEvent]] {
                let arrayTextArray: [[String]] = [
                        ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="],
                        ["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "•"],
                        [".", ",", "?", "!", "'"]
                ]
                var eventRows: [[KeyboardEvent]] = arrayTextArray.keysRows
                eventRows[2].insert(.switchTo(.numeric), at: 0)
                eventRows[2].insert(.none, at: 1)
                eventRows[2].append(.none)
                eventRows[2].append(.backspace)
                let bottomEvents: [KeyboardEvent] = needsInputModeSwitchKey ?
                        [.switchTo(.alphabetic(.lowercased)), .switchInputMethod, .space, .newLine] :
                        [.switchTo(.alphabetic(.lowercased)), .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
}

private extension Array where Element == [String] {
        var keysRows: [[KeyboardEvent]] {
                return map { $0.map { KeyboardEvent.key(KeySeat(primary: KeyElement(text: $0))) } }
        }
}
