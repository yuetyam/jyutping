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
                let digits: [[String]] = [
                        ["1", "壹", "１", "①"],
                        ["2", "貳", "２", "②"],
                        ["3", "叁", "３", "③"],
                        ["4", "肆", "４", "④"],
                        ["5", "伍", "５", "⑤"],
                        ["6", "陸", "６", "⑥"],
                        ["7", "柒", "７", "⑦"],
                        ["8", "捌", "８", "⑧"],
                        ["9", "玖", "９", "⑨"],
                        ["0", "零", "０", "⓪"]
                ]
                let digitKeys: [KeyboardEvent] = {
                        return digits.map { block -> KeyboardEvent in
                                let primary = KeyElement(text: block[0])
                                let child_0 = KeyElement(text: block[1])
                                let child_1 = KeyElement(text: block[2], header: "全形")
                                let child_2 = KeyElement(text: block[3])
                                let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1, child_2])
                                return KeyboardEvent.key(seat)
                        }
                }()
                let second_0: KeyboardEvent = {
                        let primary = KeyElement(text: "-")
                        let child_0 = KeyElement(text: "-", footer: "002D")
                        let child_1 = KeyElement(text: "－", header: "全形", footer: "FF0D")
                        let child_2 = KeyElement(text: "—", footer: "2014")
                        let child_3 = KeyElement(text: "–", footer: "2013")
                        let child_4 = KeyElement(text: "•", footer: "2022")
                        let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1, child_2, child_3, child_4])
                        return KeyboardEvent.key(seat)
                }()
                let second_1: KeyboardEvent = {
                        let primary = KeyElement(text: "\u{002F}")
                        let child_0 = KeyElement(text: "\u{002F}")
                        let child_1 = KeyElement(text: "\u{FF0F}", header: "全形")
                        let child_2 = KeyElement(text: "\u{005C}")
                        let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1, child_2])
                        return KeyboardEvent.key(seat)
                }()
                let second_2: KeyboardEvent = {
                        let primary = KeyElement(text: "：")
                        let child_0 = KeyElement(text: ":", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.key(seat)
                }()
                let second_3: KeyboardEvent = {
                        let primary = KeyElement(text: "；")
                        let child_0 = KeyElement(text: ";", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.key(seat)
                }()
                let second_4: KeyboardEvent = {
                        let primary = KeyElement(text: "（")
                        let child_0 = KeyElement(text: "(", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.key(seat)
                }()
                let second_5: KeyboardEvent = {
                        let primary = KeyElement(text: "）")
                        let child_0 = KeyElement(text: ")", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.key(seat)
                }()
                let second_6: KeyboardEvent = {
                        let primary = KeyElement(text: "$")
                        let child_0 = KeyElement(text: "€")
                        let child_1 = KeyElement(text: "£")
                        let child_2 = KeyElement(text: "¥")
                        let child_3 = KeyElement(text: "₩")
                        let child_4 = KeyElement(text: "₽")
                        let child_5 = KeyElement(text: "¢")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1, child_2, child_3, child_4, child_5])
                        return KeyboardEvent.key(seat)
                }()
                let second_7: KeyboardEvent = {
                        let primary = KeyElement(text: "@")
                        let child_0 = KeyElement(text: "＠", header: "全形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.key(seat)
                }()
                let second_8: KeyboardEvent = {
                        let primary = KeyElement(text: "「")
                        let child_0 = KeyElement(text: "『")
                        let child_1 = KeyElement(text: "\u{0022}", footer: "0022")
                        let child_2 = KeyElement(text: "\u{201C}", footer: "201C")
                        let child_3 = KeyElement(text: "\u{2018}", footer: "2018")
                        let child_4 = KeyElement(text: "\u{FE41}")
                        let child_5 = KeyElement(text: "\u{FE43}")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1, child_2, child_3, child_4, child_5])
                        return KeyboardEvent.key(seat)
                }()
                let second_9: KeyboardEvent = {
                        let primary = KeyElement(text: "」")
                        let child_0 = KeyElement(text: "』")
                        let child_1 = KeyElement(text: "\u{0022}", footer: "0022")
                        let child_2 = KeyElement(text: "\u{201D}", footer: "201D")
                        let child_3 = KeyElement(text: "\u{2019}", footer: "2019")
                        let child_4 = KeyElement(text: "\u{FE42}")
                        let child_5 = KeyElement(text: "\u{FE44}")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1, child_2, child_3, child_4, child_5])
                        return KeyboardEvent.key(seat)
                }()
                let third_0: KeyboardEvent = {
                        let primary = KeyElement(text: "。")
                        let child_0 = KeyElement(text: "⋯", footer: "22EF")
                        let child_1 = KeyElement(text: "⋯⋯")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1])
                        return KeyboardEvent.key(seat)
                }()
                let third_1: KeyboardEvent = {
                        let primary = KeyElement(text: "，")
                        let child_0 = KeyElement(text: ",", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.key(seat)
                }()
                let third_2: KeyboardEvent = {
                        let primary = KeyElement(text: "、")
                        let seat: KeySeat = KeySeat(primary: primary)
                        return KeyboardEvent.key(seat)
                }()
                let third_3: KeyboardEvent = {
                        let primary = KeyElement(text: "？")
                        let child_0 = KeyElement(text: "?", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.key(seat)
                }()
                let third_4: KeyboardEvent = {
                        let primary = KeyElement(text: "！")
                        let child_0 = KeyElement(text: "!", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.key(seat)
                }()
                let third_5: KeyboardEvent = {
                        let primary = KeyElement(text: ".")
                        let child_0 = KeyElement(text: "．", header: "全形", footer: "FF0E")
                        let child_1 = KeyElement(text: "…", footer: "2026")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1])
                        return KeyboardEvent.key(seat)
                }()
                var eventRows: [[KeyboardEvent]] = arrayTextArray.placeholders
                eventRows[0] = digitKeys
                eventRows[1] = [second_0, second_1, second_2, second_3, second_4, second_5, second_6, second_7, second_8, second_9]
                eventRows[2] = [third_0, third_1, third_2, third_3, third_4, third_5]
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
                let first_9: KeyboardEvent = {
                        let primary = KeyElement(text: "0")
                        let child_0 = KeyElement(text: "°")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.key(seat)
                }()
                let second_0: KeyboardEvent = {
                        let primary = KeyElement(text: "\u{002D}")
                        let child_0 = KeyElement(text: "\u{002D}", footer: "002D")
                        let child_1 = KeyElement(text: "\u{2013}", footer: "2013")
                        let child_2 = KeyElement(text: "\u{2014}", footer: "2014")
                        let child_3 = KeyElement(text: "\u{2022}", footer: "2022")
                        let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1, child_2, child_3])
                        return KeyboardEvent.key(seat)
                }()
                let second_1: KeyboardEvent = {
                        let text: String = #"\"#
                        let primary = KeyElement(text: "/")
                        let child_0 = KeyElement(text: text)
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.key(seat)
                }()
                let second_6: KeyboardEvent = {
                        let primary = KeyElement(text: "$")
                        let child_0 = KeyElement(text: "€")
                        let child_1 = KeyElement(text: "£")
                        let child_2 = KeyElement(text: "¥")
                        let child_3 = KeyElement(text: "₩")
                        let child_4 = KeyElement(text: "₽")
                        let child_5 = KeyElement(text: "¢")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1, child_2, child_3, child_4, child_5])
                        return KeyboardEvent.key(seat)
                }()
                let second_7: KeyboardEvent = {
                        let primary = KeyElement(text: "&")
                        let child_0 = KeyElement(text: "§")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.key(seat)
                }()
                let second_9: KeyboardEvent = {
                        let primary = KeyElement(text: "\u{0022}")
                        let child_0 = KeyElement(text: "\u{0022}", footer: "0022")
                        let child_1 = KeyElement(text: "\u{201C}", footer: "201C")
                        let child_2 = KeyElement(text: "\u{201D}", footer: "201D")
                        let child_3 = KeyElement(text: "\u{201E}", footer: "201E")
                        let child_4 = KeyElement(text: "\u{00BB}", footer: "00BB")
                        let child_5 = KeyElement(text: "\u{00AB}", footer: "00AB")
                        let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1, child_2, child_3, child_4, child_5])
                        return KeyboardEvent.key(seat)
                }()
                let third_0: KeyboardEvent = {
                        let primary = KeyElement(text: ".")
                        let child_0 = KeyElement(text: "…")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.key(seat)
                }()
                let third_1: KeyboardEvent = {
                        let primary = KeyElement(text: ",")
                        let seat: KeySeat = KeySeat(primary: primary)
                        return KeyboardEvent.key(seat)
                }()
                let third_2: KeyboardEvent = {
                        let primary = KeyElement(text: "?")
                        let child_0 = KeyElement(text: "¿")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.key(seat)
                }()
                let third_3: KeyboardEvent = {
                        let primary = KeyElement(text: "!")
                        let child_0 = KeyElement(text: "¡")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.key(seat)
                }()
                let third_4: KeyboardEvent = {
                        let primary = KeyElement(text: "\u{0027}")
                        let child_0 = KeyElement(text: "\u{0027}", footer: "0027")
                        let child_1 = KeyElement(text: "\u{2018}", footer: "2018")
                        let child_2 = KeyElement(text: "\u{2019}", footer: "2019")
                        let child_3 = KeyElement(text: "\u{0060}", footer: "0060")
                        let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1, child_2, child_3])
                        return KeyboardEvent.key(seat)
                }()
                var eventRows: [[KeyboardEvent]] = arrayTextArray.keysRows
                eventRows[0][9] = first_9
                eventRows[1][0] = second_0
                eventRows[1][1] = second_1
                eventRows[1][6] = second_6
                eventRows[1][7] = second_7
                eventRows[1][9] = second_9
                eventRows[2] = [third_0, third_1, third_2, third_3, third_4]
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
                let first_0: KeyboardEvent = {
                        let primary = KeyElement(text: "［")
                        let child_0 = KeyElement(text: "[", header: "半形")
                        let child_1 = KeyElement(text: "【")
                        let child_2 = KeyElement(text: "〖")
                        let child_3 = KeyElement(text: "〔")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1, child_2, child_3])
                        return KeyboardEvent.key(seat)
                }()
                let first_1: KeyboardEvent = {
                        let primary = KeyElement(text: "］")
                        let child_0 = KeyElement(text: "]", header: "半形")
                        let child_1 = KeyElement(text: "】")
                        let child_2 = KeyElement(text: "〗")
                        let child_3 = KeyElement(text: "〕")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1, child_2, child_3])
                        return KeyboardEvent.key(seat)
                }()
                let first_2: KeyboardEvent = {
                        let primary = KeyElement(text: "｛")
                        let child_0 = KeyElement(text: "{", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.key(seat)
                }()
                let first_3: KeyboardEvent = {
                        let primary = KeyElement(text: "｝")
                        let child_0 = KeyElement(text: "}", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.key(seat)
                }()
                let first_4: KeyboardEvent = {
                        let primary = KeyElement(text: "#")
                        let child_0 = KeyElement(text: "＃", header: "全形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.key(seat)
                }()
                let first_5: KeyboardEvent = {
                        let primary = KeyElement(text: "%")
                        let child_0 = KeyElement(text: "％", header: "全形")
                        let child_1 = KeyElement(text: "‰")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1])
                        return KeyboardEvent.key(seat)
                }()
                let first_6: KeyboardEvent = {
                        let primary = KeyElement(text: "^")
                        let child_0 = KeyElement(text: "＾", header: "全形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.key(seat)
                }()
                let first_7: KeyboardEvent = {
                        let primary = KeyElement(text: "*")
                        let child_0 = KeyElement(text: "＊", header: "全形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.key(seat)
                }()
                let first_8: KeyboardEvent = {
                        let primary = KeyElement(text: "+")
                        let child_0 = KeyElement(text: "＋", header: "全形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.key(seat)
                }()
                let first_9: KeyboardEvent = {
                        let primary = KeyElement(text: "=")
                        let child_0 = KeyElement(text: "＝", header: "全形")
                        let child_1 = KeyElement(text: "≠")
                        let child_2 = KeyElement(text: "≈")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1, child_2])
                        return KeyboardEvent.key(seat)
                }()
                let second_0: KeyboardEvent = {
                        let primary = KeyElement(text: "_")
                        let child_0 = KeyElement(text: "＿", header: "全形", footer: "FF3F")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.key(seat)
                }()
                let second_1: KeyboardEvent = {
                        let primary = KeyElement(text: "—")
                        let seat: KeySeat = KeySeat(primary: primary)
                        return KeyboardEvent.key(seat)
                }()
                let second_2: KeyboardEvent = {
                        let text: String = #"\"#
                        let primary = KeyElement(text: text)
                        let child_0 = KeyElement(text: "＼", header: "全形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.key(seat)
                }()
                let second_3: KeyboardEvent = {
                        let primary = KeyElement(text: "｜")
                        let child_0 = KeyElement(text: "|", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.key(seat)
                }()
                let second_4: KeyboardEvent = {
                        let primary = KeyElement(text: "～")
                        let child_0 = KeyElement(text: "~", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.key(seat)
                }()
                let second_5: KeyboardEvent = {
                        let primary = KeyElement(text: "《")
                        let child_0 = KeyElement(text: "〈", footer: "3008")
                        let child_1 = KeyElement(text: "\u{003C}", footer: "003C")
                        let child_2 = KeyElement(text: "＜", footer: "FF1C")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1, child_2])
                        return KeyboardEvent.key(seat)
                }()
                let second_6: KeyboardEvent = {
                        let primary = KeyElement(text: "》")
                        let child_0 = KeyElement(text: "〉", footer: "3009")
                        let child_1 = KeyElement(text: "\u{003E}", footer: "003E")
                        let child_2 = KeyElement(text: "＞", footer: "FF1E")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1, child_2])
                        return KeyboardEvent.key(seat)
                }()
                let second_7: KeyboardEvent = {
                        let primary = KeyElement(text: "¥")
                        let seat: KeySeat = KeySeat(primary: primary)
                        return KeyboardEvent.key(seat)
                }()
                let second_8: KeyboardEvent = {
                        let primary = KeyElement(text: "&")
                        let child_0 = KeyElement(text: "＆", header: "全形")
                        let child_1 = KeyElement(text: "§")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1])
                        return KeyboardEvent.key(seat)
                }()
                let second_9: KeyboardEvent = {
                        let primary = KeyElement(text: "\u{00B7}")
                        let child_0 = KeyElement(text: "\u{00B7}", footer: "00B7")
                        let child_1 = KeyElement(text: "\u{2022}", footer: "2022")
                        let child_2 = KeyElement(text: "\u{00B0}", footer: "00B0")
                        let child_3 = KeyElement(text: "\u{30FB}", footer: "30FB")
                        let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1, child_2, child_3])
                        return KeyboardEvent.key(seat)
                }()
                let third_0: KeyboardEvent = {
                        let primary = KeyElement(text: "⋯")
                        let child_0 = KeyElement(text: "⋯", footer: "22EF")
                        let child_1 = KeyElement(text: "…", footer: "2026")
                        let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1])
                        return KeyboardEvent.key(seat)
                }()
                let third_1: KeyboardEvent = {
                        let primary = KeyElement(text: "，")
                        let child_0 = KeyElement(text: ",", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.key(seat)
                }()
                let third_2: KeyboardEvent = {
                        let primary = KeyElement(text: "。")
                        let seat: KeySeat = KeySeat(primary: primary)
                        return KeyboardEvent.key(seat)
                }()
                let third_3: KeyboardEvent = {
                        let primary = KeyElement(text: "？")
                        let child_0 = KeyElement(text: "?", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.key(seat)
                }()
                let third_4: KeyboardEvent = {
                        let primary = KeyElement(text: "！")
                        let child_0 = KeyElement(text: "!", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.key(seat)
                }()
                let third_5: KeyboardEvent = {
                        let primary = KeyElement(text: "\u{0027}")
                        let child_0 = KeyElement(text: "\u{0027}", footer: "0027")
                        let child_1 = KeyElement(text: "\u{FF07}", header: "全形", footer: "FF07")
                        let child_2 = KeyElement(text: "\u{2018}", footer: "2018")
                        let child_3 = KeyElement(text: "\u{2019}", footer: "2019")
                        let child_4 = KeyElement(text: "\u{0060}", footer: "0060")
                        let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1, child_2, child_3, child_4])
                        return KeyboardEvent.key(seat)
                }()
                var eventRows: [[KeyboardEvent]] = arrayTextArray.placeholders
                eventRows[0] = [first_0, first_1, first_2, first_3, first_4, first_5, first_6, first_7, first_8, first_9]
                eventRows[1] = [second_0, second_1, second_2, second_3, second_4, second_5, second_6, second_7, second_8, second_9]
                eventRows[2] = [third_0, third_1, third_2, third_3, third_4, third_5]
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
                let first_5: KeyboardEvent = {
                        let primary = KeyElement(text: "%")
                        let child_0 = KeyElement(text: "‰")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.key(seat)
                }()
                let first_9: KeyboardEvent = {
                        let primary = KeyElement(text: "=")
                        let child_0 = KeyElement(text: "≠")
                        let child_1 = KeyElement(text: "≈")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1])
                        return KeyboardEvent.key(seat)
                }()
                let third_0: KeyboardEvent = {
                        let primary = KeyElement(text: ".")
                        let child_0 = KeyElement(text: "…")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.key(seat)
                }()
                let third_1: KeyboardEvent = {
                        let primary = KeyElement(text: ",")
                        let seat: KeySeat = KeySeat(primary: primary)
                        return KeyboardEvent.key(seat)
                }()
                let third_2: KeyboardEvent = {
                        let primary = KeyElement(text: "?")
                        let child_0 = KeyElement(text: "¿")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.key(seat)
                }()
                let third_3: KeyboardEvent = {
                        let primary = KeyElement(text: "!")
                        let child_0 = KeyElement(text: "¡")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.key(seat)
                }()
                let third_4: KeyboardEvent = {
                        let primary = KeyElement(text: "\u{0027}")
                        let child_0 = KeyElement(text: "\u{0027}", footer: "0027")
                        let child_1 = KeyElement(text: "\u{2018}", footer: "2018")
                        let child_2 = KeyElement(text: "\u{2019}", footer: "2019")
                        let child_3 = KeyElement(text: "\u{0060}", footer: "0060")
                        let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1, child_2, child_3])
                        return KeyboardEvent.key(seat)
                }()
                var eventRows: [[KeyboardEvent]] = arrayTextArray.keysRows
                eventRows[0][5] = first_5
                eventRows[0][9] = first_9
                eventRows[2] = [third_0, third_1, third_2, third_3, third_4]
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
        var placeholders: [[KeyboardEvent]] {
                return map { $0.map { _ in KeyboardEvent.none } }
        }
}
