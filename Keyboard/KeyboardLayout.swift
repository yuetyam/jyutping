import UIKit

enum KeyboardLayout {
        case jyutping,
             jyutpingUppercase,

             alphabetic,
             alphabeticUppercase,

             cantoneseNumeric,
             cantoneseSymbolic,

             numeric,
             symbolic,

             emoji,
             numberPad,
             decimalPad,

             candidateBoard,
             settingsView
        
        func keys(for viewController: UIInputViewController) -> [[KeyboardEvent]] {
                switch self {
                case .jyutping:
                        return jyutpingKeys(for: viewController)
                case .jyutpingUppercase:
                        return jyutpingUppercaseKeys(for: viewController)
                case .alphabetic:
                        return alphabeticLowercaseKeys(for: viewController)
                case .alphabeticUppercase:
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
                     .alphabeticUppercase,
                     .numeric,
                     .symbolic:
                        return true
                default:
                        return false
                }
        }
        
        var isJyutpingMode: Bool {
                switch self {
                case .jyutping,
                     .jyutpingUppercase,
                     .candidateBoard:
                        return true
                default:
                        return false
                }
        }
}

private extension KeyboardLayout {
        func jyutpingKeys(for viewController: UIInputViewController) -> [[KeyboardEvent]] {
                let arrayWithTextArray: [[String]] = [
                        ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
                        ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
                        ["z", "x", "c", "v", "b", "n", "m"]
                ]
                var eventRows: [[KeyboardEvent]] = arrayWithTextArray.keysRows
                eventRows[1].insert(.keyALeft, at: 0)
                eventRows[1].insert(.keyALeft, at: 0)
                eventRows[1].append(.keyLRight)
                eventRows[1].append(.keyLRight)
                eventRows[2].insert(.shift, at: 0)
                eventRows[2].insert(.keyZLeft, at: 1)
                eventRows[2].append(.keyBackspaceLeft)
                eventRows[2].append(.backspace)
                let bottomEvents: [KeyboardEvent] = viewController.needsInputModeSwitchKey ?
                        [.switchTo(.cantoneseNumeric), .switchInputMethod, .space, .newLine] :
                        [.switchTo(.cantoneseNumeric), .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
        func jyutpingUppercaseKeys(for viewController: UIInputViewController) -> [[KeyboardEvent]] {
                let arrayWithTextArray: [[String]] = [
                        ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
                        ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
                        ["Z", "X", "C", "V", "B", "N", "M"]
                ]
                var eventRows: [[KeyboardEvent]] = arrayWithTextArray.keysRows
                eventRows[1].insert(.keyALeft, at: 0)
                eventRows[1].insert(.keyALeft, at: 0)
                eventRows[1].append(.keyLRight)
                eventRows[1].append(.keyLRight)
                eventRows[2].insert(.shiftDown, at: 0)
                eventRows[2].insert(.keyZLeft, at: 1)
                eventRows[2].append(.keyBackspaceLeft)
                eventRows[2].append(.backspace)
                let bottomEvents: [KeyboardEvent] = viewController.needsInputModeSwitchKey ?
                        [.switchTo(.cantoneseNumeric), .switchInputMethod, .space, .newLine] :
                        [.switchTo(.cantoneseNumeric), .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
        func alphabeticLowercaseKeys(for viewController: UIInputViewController) -> [[KeyboardEvent]] {
                let arrayWithTextArray: [[String]] = [
                        ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
                        ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
                        ["z", "x", "c", "v", "b", "n", "m"]
                ]
                var eventRows: [[KeyboardEvent]] = arrayWithTextArray.keysRows
                eventRows[1].insert(.keyALeft, at: 0)
                eventRows[1].insert(.keyALeft, at: 0)
                eventRows[1].append(.keyLRight)
                eventRows[1].append(.keyLRight)
                eventRows[2].insert(.shift, at: 0)
                eventRows[2].insert(.keyZLeft, at: 1)
                eventRows[2].append(.keyBackspaceLeft)
                eventRows[2].append(.backspace)
                let bottomEvents: [KeyboardEvent] = viewController.needsInputModeSwitchKey ?
                        [.switchTo(.numeric), .switchInputMethod, .space, .text("."), .newLine] :
                        [.switchTo(.numeric), .text("."), .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
        func alphabeticUppercaseKeys(for viewController: UIInputViewController) -> [[KeyboardEvent]] {
                let arrayWithTextArray: [[String]] = [
                        ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
                        ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
                        ["Z", "X", "C", "V", "B", "N", "M"]
                ]
                var eventRows: [[KeyboardEvent]] = arrayWithTextArray.keysRows
                eventRows[1].insert(.keyALeft, at: 0)
                eventRows[1].insert(.keyALeft, at: 0)
                eventRows[1].append(.keyLRight)
                eventRows[1].append(.keyLRight)
                eventRows[2].insert(.shiftDown, at: 0)
                eventRows[2].insert(.keyZLeft, at: 1)
                eventRows[2].append(.keyBackspaceLeft)
                eventRows[2].append(.backspace)
                let bottomEvents: [KeyboardEvent] = viewController.needsInputModeSwitchKey ?
                        [.switchTo(.numeric), .switchInputMethod, .space, .text("."), .newLine] :
                        [.switchTo(.numeric), .text("."), .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
        func cantoneseNumericKeys(for viewController: UIInputViewController) -> [[KeyboardEvent]] {
                let arrayWithTextArray: [[String]] = [
                        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
                        ["-", "/", "：", "；", "（", "）", "$", "@", "「", "」"],
                        ["。", "，", "、", "？", "！", "."]
                ]
                var eventRows: [[KeyboardEvent]] = arrayWithTextArray.keysRows
                eventRows[2].insert(.switchTo(.cantoneseSymbolic), at: 0)
                eventRows[2].insert(.none, at: 1)
                eventRows[2].append(.none)
                eventRows[2].append(.backspace)
                let bottomEvents: [KeyboardEvent] = viewController.needsInputModeSwitchKey ?
                        [.switchTo(.jyutping), .switchInputMethod, .space, .newLine] :
                        [.switchTo(.jyutping), .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
        func numericKeys(for viewController: UIInputViewController) -> [[KeyboardEvent]] {
                let arrayWithTextArray: [[String]] = [
                        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
                        ["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""],
                        [".", ",", "?", "!", "'"]
                ]
                var eventRows: [[KeyboardEvent]] = arrayWithTextArray.keysRows
                eventRows[2].insert(.switchTo(.symbolic), at: 0)
                eventRows[2].insert(.none, at: 1)
                eventRows[2].append(.none)
                eventRows[2].append(.backspace)
                let bottomEvents: [KeyboardEvent] = viewController.needsInputModeSwitchKey ?
                        [.switchTo(.alphabetic), .switchInputMethod, .space, .newLine] :
                        [.switchTo(.alphabetic), .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
        func cantoneseSymbolicKeys(for viewController: UIInputViewController) -> [[KeyboardEvent]] {
                let arrayWithTextArray: [[String]] = [
                        ["［", "］", "｛", "｝", "#", "%", "^", "*", "+", "="],
                        ["_", "—", "＼", "｜", "～", "《", "》", "¥", "&", "\u{00B7}"],
                        ["⋯", "【", "】", "〔", "〕", "£"]
                ]
                var eventRows: [[KeyboardEvent]] = arrayWithTextArray.keysRows
                eventRows[2].insert(.switchTo(.cantoneseNumeric), at: 0)
                eventRows[2].insert(.none, at: 1)
                eventRows[2].append(.none)
                eventRows[2].append(.backspace)
                let bottomEvents: [KeyboardEvent] = viewController.needsInputModeSwitchKey ?
                        [.switchTo(.jyutping), .switchInputMethod, .space, .newLine] :
                        [.switchTo(.jyutping), .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
        func symbolicKeys(for viewController: UIInputViewController) -> [[KeyboardEvent]] {
                let arrayWithTextArray: [[String]] = [
                        ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="],
                        ["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "•"],
                        [".", ",", "?", "!", "'"]
                ]
                var eventRows: [[KeyboardEvent]] = arrayWithTextArray.keysRows
                eventRows[2].insert(.switchTo(.numeric), at: 0)
                eventRows[2].insert(.none, at: 1)
                eventRows[2].append(.none)
                eventRows[2].append(.backspace)
                let bottomEvents: [KeyboardEvent] = viewController.needsInputModeSwitchKey ?
                        [.switchTo(.alphabetic), .switchInputMethod, .space, .newLine] :
                        [.switchTo(.alphabetic), .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
}

private extension Array where Element == [String] {
        var keysRows: [[KeyboardEvent]] {
                return self.map { $0.map { KeyboardEvent.text($0) } }
        }
}
