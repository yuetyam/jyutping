import UIKit

enum KeyboardLayout: Equatable {
        case
        jyutping,
        cantoneseSymbolic,
        
        alphabetLowercase,
        alphabetUppercase,
        
        numericJyutping,
        symbolicJyutping,
        
        numericAlphabet,
        symbolicAlphabet,
        
        wordsBoard,
        settingsView
        
        func keys(for viewController: UIInputViewController) -> [[KeyboardEvent]] {
                switch self {
                case .jyutping:
                        return jyutpingKeys(for: viewController)
                case .cantoneseSymbolic:
                        return cantoneseSymbolicKeys(for: viewController)
                case .alphabetLowercase:
                        return alphabetLowercaseKeys(for: viewController)
                case .alphabetUppercase:
                        return alphabetUppercaseKeys(for: viewController)
                case .numericJyutping:
                        return numericJyutpingKeys(for: viewController)
                case .symbolicJyutping:
                        return symbolicJyutping(for: viewController)
                case .numericAlphabet:
                        return numericAlphabetKeys(for: viewController)
                case .symbolicAlphabet:
                        return symbolicAlphabet(for: viewController)
                default:
                        return []
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
                eventRows[1].insert(.none, at: 0)
                eventRows[1].insert(.none, at: 0)
                eventRows[1].append(.none)
                eventRows[1].append(.none)
                eventRows[2].insert(.switchTo(.cantoneseSymbolic), at: 0)
                eventRows[2].insert(.none, at: 1)
                eventRows[2].append(.none)
                eventRows[2].append(.backspace)
                let bottomEvents: [KeyboardEvent] = viewController.needsInputModeSwitchKey ?
                        [.switchTo(.numericJyutping), .switchInputMethod, .space, .switchTo(.alphabetLowercase), .newLine] :
                        [.switchTo(.numericJyutping), .switchTo(.alphabetLowercase), .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
        func alphabetLowercaseKeys(for viewController: UIInputViewController) -> [[KeyboardEvent]] {
                let arrayWithTextArray: [[String]] = [
                        ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
                        ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
                        ["z", "x", "c", "v", "b", "n", "m"]
                ]
                var eventRows: [[KeyboardEvent]] = arrayWithTextArray.keysRows
                eventRows[1].insert(.none, at: 0)
                eventRows[1].insert(.none, at: 0)
                eventRows[1].append(.none)
                eventRows[1].append(.none)
                eventRows[2].insert(.shiftUp, at: 0)
                eventRows[2].insert(.none, at: 1)
                eventRows[2].append(.none)
                eventRows[2].append(.backspace)
                let bottomEvents: [KeyboardEvent] = viewController.needsInputModeSwitchKey ?
                        [.switchTo(.numericAlphabet), .switchInputMethod, .space, .switchTo(.jyutping), .newLine] :
                        [.switchTo(.numericAlphabet), .switchTo(.jyutping), .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
        func alphabetUppercaseKeys(for viewController: UIInputViewController) -> [[KeyboardEvent]] {
                let arrayWithTextArray: [[String]] = [
                        ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
                        ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
                        ["Z", "X", "C", "V", "B", "N", "M"]
                ]
                var eventRows: [[KeyboardEvent]] = arrayWithTextArray.keysRows
                eventRows[1].insert(.none, at: 0)
                eventRows[1].insert(.none, at: 0)
                eventRows[1].append(.none)
                eventRows[1].append(.none)
                eventRows[2].insert(.shiftDown, at: 0)
                eventRows[2].insert(.none, at: 1)
                eventRows[2].append(.none)
                eventRows[2].append(.backspace)
                let bottomEvents: [KeyboardEvent] = viewController.needsInputModeSwitchKey ?
                        [.switchTo(.numericAlphabet), .switchInputMethod, .space, .switchTo(.jyutping), .newLine] :
                        [.switchTo(.numericAlphabet), .switchTo(.jyutping), .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
        func cantoneseSymbolicKeys(for viewController: UIInputViewController) -> [[KeyboardEvent]] {
                let arrayWithTextArray: [[String]] = [
                        ["（",    "）",    "〖",    "〗",    "～",    "【",    "】",    "〔",    "〕"],
                        ["《",    "》",    "「",    "」",    "：",    "『",    "』",    "\u{00B7}",     "、"],
                        ["。",    "，",    "；",    "？",    "！"]
                ]
                var eventRows: [[KeyboardEvent]] = arrayWithTextArray.keysRows
                eventRows[2].insert(.switchTo(.jyutping), at: 0)
                eventRows[2].insert(.none, at: 1)
                eventRows[2].append(.none)
                eventRows[2].append(.backspace)
                let bottomEvents: [KeyboardEvent] = viewController.needsInputModeSwitchKey ?
                        [.switchTo(.numericJyutping), .switchInputMethod, .space, .switchTo(.alphabetLowercase), .newLine] :
                        [.switchTo(.numericJyutping), .switchTo(.alphabetLowercase), .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
        func numericJyutpingKeys(for viewController: UIInputViewController) -> [[KeyboardEvent]] {
                let arrayWithTextArray: [[String]] = [
                        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
                        ["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""],
                        [".", ",", "?", "!", "´"]
                ]
                var eventRows: [[KeyboardEvent]] = arrayWithTextArray.keysRows
                eventRows[2].insert(.switchTo(.symbolicJyutping), at: 0)
                eventRows[2].insert(.none, at: 1)
                eventRows[2].append(.none)
                eventRows[2].append(.backspace)
                let bottomEvents: [KeyboardEvent] = viewController.needsInputModeSwitchKey ?
                        [.switchTo(.jyutping), .switchInputMethod, .space, .switchTo(.alphabetLowercase), .newLine] :
                        [.switchTo(.jyutping), .switchTo(.alphabetLowercase), .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
        func numericAlphabetKeys(for viewController: UIInputViewController) -> [[KeyboardEvent]] {
                let arrayWithTextArray: [[String]] = [
                        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
                        ["-", "/", ":", ";", "(", ")", "$", "&", "@", "\""],
                        [".", ",", "?", "!", "´"]
                ]
                var eventRows: [[KeyboardEvent]] = arrayWithTextArray.keysRows
                eventRows[2].insert(.switchTo(.symbolicAlphabet), at: 0)
                eventRows[2].insert(.none, at: 1)
                eventRows[2].append(.none)
                eventRows[2].append(.backspace)
                let bottomEvents: [KeyboardEvent] = viewController.needsInputModeSwitchKey ?
                        [.switchTo(.alphabetLowercase), .switchInputMethod, .space, .switchTo(.jyutping), .newLine] :
                        [.switchTo(.alphabetLowercase), .switchTo(.jyutping), .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
        func symbolicJyutping(for viewController: UIInputViewController) -> [[KeyboardEvent]] {
                let arrayWithTextArray: [[String]] = [
                        ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="],
                        ["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "•"],
                        [".", ",", "?", "!", "´"]
                ]
                var eventRows: [[KeyboardEvent]] = arrayWithTextArray.keysRows
                eventRows[2].insert(.switchTo(.numericJyutping), at: 0)
                eventRows[2].insert(.none, at: 1)
                eventRows[2].append(.none)
                eventRows[2].append(.backspace)
                let bottomEvents: [KeyboardEvent] = viewController.needsInputModeSwitchKey ?
                        [.switchTo(.jyutping), .switchInputMethod, .space, .switchTo(.alphabetLowercase), .newLine] :
                        [.switchTo(.jyutping), .switchTo(.alphabetLowercase), .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
        func symbolicAlphabet(for viewController: UIInputViewController) -> [[KeyboardEvent]] {
                let arrayWithTextArray: [[String]] = [
                        ["[", "]", "{", "}", "#", "%", "^", "*", "+", "="],
                        ["_", "\\", "|", "~", "<", ">", "€", "£", "¥", "•"],
                        [".", ",", "?", "!", "´"]
                ]
                var eventRows: [[KeyboardEvent]] = arrayWithTextArray.keysRows
                eventRows[2].insert(.switchTo(.numericAlphabet), at: 0)
                eventRows[2].insert(.none, at: 1)
                eventRows[2].append(.none)
                eventRows[2].append(.backspace)
                let bottomEvents: [KeyboardEvent] = viewController.needsInputModeSwitchKey ?
                        [.switchTo(.alphabetLowercase), .switchInputMethod, .space, .switchTo(.jyutping), .newLine] :
                        [.switchTo(.alphabetLowercase), .switchTo(.jyutping), .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
}

private extension Array where Element == [String] {
        var keysRows: [[KeyboardEvent]] {
                return self.map { $0.map { KeyboardEvent.text($0) } }
        }
}
