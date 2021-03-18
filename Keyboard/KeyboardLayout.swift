import UIKit

enum ShiftStatus {
        case lowercased,
             uppercased,
             capsLocked
}

enum KeyboardLayout: Hashable {
        case cantonese(ShiftStatus),
             cantoneseNumeric,
             cantoneseSymbolic,

             alphabetic(ShiftStatus),
             numeric,
             symbolic,

             emoji,
             numberPad,
             decimalPad,
             candidateBoard,
             settingsView
        
        func keys(for viewController: UIInputViewController) -> [[KeyboardEvent]] {
                switch self {
                case .cantonese(.lowercased):
                        return jyutpingKeys(for: viewController)
                case .cantonese(.uppercased), .cantonese(.capsLocked):
                        return jyutpingUppercaseKeys(for: viewController)
                case .alphabetic(.lowercased):
                        return alphabeticLowercaseKeys(for: viewController)
                case .alphabetic(.uppercased), .alphabetic(.capsLocked):
                        return alphabeticUppercaseKeys(for: viewController)
                case .cantoneseNumeric:
                        return cantoneseNumericKeys(for: viewController)
                case .cantoneseSymbolic:
                        return cantoneseSymbolicKeys(for: viewController)
                case .numeric:
                        return numericKeys(for: viewController)
                case .symbolic:
                        return symbolicKeys(for: viewController)
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
        func jyutpingKeys(for viewController: UIInputViewController) -> [[KeyboardEvent]] {
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
                let comma: KeyboardEvent = KeyboardEvent.key(.cantoneseCommaSeat)
                let bottomEvents: [KeyboardEvent] = viewController.needsInputModeSwitchKey ?
                        [.switchTo(.cantoneseNumeric), .switchInputMethod, .space, comma, .newLine] :
                        [.switchTo(.cantoneseNumeric), comma, .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
        func jyutpingUppercaseKeys(for viewController: UIInputViewController) -> [[KeyboardEvent]] {
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
                let comma: KeyboardEvent = KeyboardEvent.key(.cantoneseCommaSeat)
                let bottomEvents: [KeyboardEvent] = viewController.needsInputModeSwitchKey ?
                        [.switchTo(.cantoneseNumeric), .switchInputMethod, .space, comma, .newLine] :
                        [.switchTo(.cantoneseNumeric), comma, .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
        func alphabeticLowercaseKeys(for viewController: UIInputViewController) -> [[KeyboardEvent]] {
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
                let period: KeyboardEvent = KeyboardEvent.key(.periodSeat)
                let bottomEvents: [KeyboardEvent] = viewController.needsInputModeSwitchKey ?
                        [.switchTo(.numeric), .switchInputMethod, .space, period, .newLine] :
                        [.switchTo(.numeric), period, .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
        func alphabeticUppercaseKeys(for viewController: UIInputViewController) -> [[KeyboardEvent]] {
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
                let period: KeyboardEvent = KeyboardEvent.key(.periodSeat)
                let bottomEvents: [KeyboardEvent] = viewController.needsInputModeSwitchKey ?
                        [.switchTo(.numeric), .switchInputMethod, .space, period, .newLine] :
                        [.switchTo(.numeric), period, .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
        func cantoneseNumericKeys(for viewController: UIInputViewController) -> [[KeyboardEvent]] {
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
                let bottomEvents: [KeyboardEvent] = viewController.needsInputModeSwitchKey ?
                        [.switchTo(.cantonese(.lowercased)), .switchInputMethod, .space, .newLine] :
                        [.switchTo(.cantonese(.lowercased)), .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
        func numericKeys(for viewController: UIInputViewController) -> [[KeyboardEvent]] {
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
                let bottomEvents: [KeyboardEvent] = viewController.needsInputModeSwitchKey ?
                        [.switchTo(.alphabetic(.lowercased)), .switchInputMethod, .space, .newLine] :
                        [.switchTo(.alphabetic(.lowercased)), .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
        func cantoneseSymbolicKeys(for viewController: UIInputViewController) -> [[KeyboardEvent]] {
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
                let bottomEvents: [KeyboardEvent] = viewController.needsInputModeSwitchKey ?
                        [.switchTo(.cantonese(.lowercased)), .switchInputMethod, .space, .newLine] :
                        [.switchTo(.cantonese(.lowercased)), .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
        func symbolicKeys(for viewController: UIInputViewController) -> [[KeyboardEvent]] {
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
                let bottomEvents: [KeyboardEvent] = viewController.needsInputModeSwitchKey ?
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
