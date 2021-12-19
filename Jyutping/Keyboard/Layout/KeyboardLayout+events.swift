extension KeyboardIdiom {
        func events(for keyboardLayout: Int, needsInputModeSwitchKey: Bool) -> [[KeyboardEvent]] {
                switch self {
                case .cantonese(.lowercased):
                        switch keyboardLayout {
                        case 2:
                                return saamPingLowercasedKeys(needsInputModeSwitchKey)
                        default:
                                return cantoneseLowercasedKeys(needsInputModeSwitchKey)
                        }
                case .cantonese(.uppercased), .cantonese(.capsLocked):
                        switch keyboardLayout {
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
}

private extension KeyboardIdiom {
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
                eventRows[2].append(.hidden(.backspace))
                eventRows[2].append(.backspace)
                let comma: KeyboardEvent = .input(.cantoneseComma)
                let bottomEvents: [KeyboardEvent] = needsInputModeSwitchKey ?
                        [.transform(.cantoneseNumeric), .globe, .space, comma, .newLine] :
                        [.transform(.cantoneseNumeric), comma, .space, .newLine]
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
                eventRows[2].append(.hidden(.backspace))
                eventRows[2].append(.backspace)
                let comma: KeyboardEvent = .input(.cantoneseComma)
                let bottomEvents: [KeyboardEvent] = needsInputModeSwitchKey ?
                        [.transform(.cantoneseNumeric), .globe, .space, comma, .newLine] :
                        [.transform(.cantoneseNumeric), comma, .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
        func saamPingLowercasedKeys(_ needsInputModeSwitchKey: Bool, needsGWKW: Bool = false) -> [[KeyboardEvent]] {
                let arrayTextArray: [[String]] = [
                        ["aa", "w", "e", "eo", "t", "yu", "u", "i", "o", "p"],
                        ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
                        ["z", "oe", "c", "ng", "b", "n", "m"]
                ]
                let first_0: KeyboardEvent = {
                        let primary = KeyElement("aa")
                        let child_0 = KeyElement("q")
                        let seat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let first_3: KeyboardEvent = {
                        let primary = KeyElement("oe", header: "eo")
                        let child_0 = KeyElement("oe")
                        let child_1 = KeyElement("eo")
                        let child_2 = KeyElement("r")
                        let seat = KeySeat(primary: primary, children: [child_0, child_1, child_2])
                        return KeyboardEvent.input(seat)
                }()
                let first_5: KeyboardEvent = {
                        let primary = KeyElement("yu")
                        let child_0 = KeyElement("y")
                        let seat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()

                let second_4: KeyboardEvent = {
                        let primary = KeyElement("g")
                        let child_0 = KeyElement("gw")
                        let seat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let second_7: KeyboardEvent = {
                        let primary = KeyElement("k")
                        let child_0 = KeyElement("kw")
                        let seat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()

                let third_0: KeyboardEvent = {
                        let primary = KeyElement("z", header: "1")
                        let child_0 = KeyElement("z")
                        let child_1 = KeyElement("1", header: "聲調", footer: "陰平")
                        let seat = KeySeat(primary: primary, children: [child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                let third_1: KeyboardEvent = {
                        let primary = KeyElement("gw", header: "2")
                        let child_0 = KeyElement("gw")
                        let child_1 = KeyElement("kw")
                        let child_2 = KeyElement("2", header: "聲調", footer: "陰上")
                        let child_3 = KeyElement("x")
                        let seat = KeySeat(primary: primary, children: [child_0, child_1, child_2, child_3])
                        return KeyboardEvent.input(seat)
                }()
                let third_2: KeyboardEvent = {
                        let primary = KeyElement("c", header: "3")
                        let child_0 = KeyElement("c")
                        let child_1 = KeyElement("3", header: "聲調", footer: "陰去")
                        let seat = KeySeat(primary: primary, children: [child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                let third_3: KeyboardEvent = {
                        let primary = KeyElement("ng", header: "4")
                        let child_0 = KeyElement("ng")
                        let child_1 = KeyElement("4", header: "聲調", footer: "陽平")
                        let child_2 = KeyElement("v")
                        let seat = KeySeat(primary: primary, children: [child_0, child_1, child_2])
                        return KeyboardEvent.input(seat)
                }()
                let third_4: KeyboardEvent = {
                        let primary = KeyElement("b", header: "5")
                        let child_0 = KeyElement("b")
                        let child_1 = KeyElement("5", header: "聲調", footer: "陽上")
                        let seat = KeySeat(primary: primary, children: [child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                let third_5: KeyboardEvent = {
                        let primary = KeyElement("n", header: "6")
                        let child_0 = KeyElement("n")
                        let child_1 = KeyElement("6", header: "聲調", footer: "陽去")
                        let seat = KeySeat(primary: primary, children: [child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                let third_6: KeyboardEvent = {
                        let primary = KeyElement("m")
                        let seat = KeySeat(primary: primary)
                        return KeyboardEvent.input(seat)
                }()
                var eventRows: [[KeyboardEvent]] = arrayTextArray.keysRows
                eventRows[0][0] = first_0
                eventRows[0][3] = first_3
                eventRows[0][5] = first_5
                eventRows[1][4] = second_4
                eventRows[1][7] = second_7
                eventRows[2] = [third_0, third_1, third_2, third_3, third_4, third_5, third_6]
                eventRows[1].insert(.shadowKey("a"), at: 0)
                eventRows[1].insert(.shadowKey("a"), at: 0)
                eventRows[1].append(.shadowKey("l"))
                eventRows[1].append(.shadowKey("l"))
                eventRows[2].insert(.shift, at: 0)
                eventRows[2].insert(.shadowKey("z"), at: 1)
                eventRows[2].append(.hidden(.backspace))
                eventRows[2].append(.backspace)
                if needsGWKW {
                        let keyGW: KeyboardEvent = {
                                let primary: KeyElement = KeyElement("gw")
                                let seat = KeySeat(primary: primary)
                                return KeyboardEvent.input(seat)
                        }()
                        let keyKW: KeyboardEvent = {
                                let primary: KeyElement = KeyElement("kw")
                                let seat = KeySeat(primary: primary)
                                return KeyboardEvent.input(seat)
                        }()
                        let bottomEvents: [KeyboardEvent] = needsInputModeSwitchKey ?
                                [.transform(.cantoneseNumeric), .globe, keyGW, .space, keyKW, .newLine] :
                                [.transform(.cantoneseNumeric), keyGW, .space, keyKW, .newLine]
                        eventRows.append(bottomEvents)
                } else {
                        let comma: KeyboardEvent = .input(.cantoneseComma)
                        let bottomEvents: [KeyboardEvent] = needsInputModeSwitchKey ?
                                [.transform(.cantoneseNumeric), .globe, .space, comma, .newLine] :
                                [.transform(.cantoneseNumeric), comma, .space, .newLine]
                        eventRows.append(bottomEvents)
                }
                return eventRows
        }
        func saamPingUppercasedKeys(_ needsInputModeSwitchKey: Bool, needsGWKW: Bool = false) -> [[KeyboardEvent]] {
                let arrayTextArray: [[String]] = [
                        ["AA", "W", "E", "EO", "T", "YU", "U", "I", "O", "P"],
                        ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
                        ["Z", "OE", "C", "NG", "B", "N", "M"]
                ]
                let first_0: KeyboardEvent = {
                        let primary = KeyElement("AA")
                        let child_0 = KeyElement("Q")
                        let seat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let first_3: KeyboardEvent = {
                        let primary = KeyElement("EO")
                        let child_0 = KeyElement("R")
                        let seat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let first_5: KeyboardEvent = {
                        let primary = KeyElement("YU")
                        let child_0 = KeyElement("Y")
                        let seat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let third_0: KeyboardEvent = {
                        let primary = KeyElement("Z", header: "1")
                        let child_0 = KeyElement("Z")
                        let child_1 = KeyElement("1", header: "聲調", footer: "陰平")
                        let seat = KeySeat(primary: primary, children: [child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                let third_1: KeyboardEvent = {
                        let primary = KeyElement("OE", header: "2")
                        let child_0 = KeyElement("OE")
                        let child_1 = KeyElement("2", header: "聲調", footer: "陰上")
                        let child_2 = KeyElement("X")
                        let seat = KeySeat(primary: primary, children: [child_0, child_1, child_2])
                        return KeyboardEvent.input(seat)
                }()
                let third_2: KeyboardEvent = {
                        let primary = KeyElement("C", header: "3")
                        let child_0 = KeyElement("C")
                        let child_1 = KeyElement("3", header: "聲調", footer: "陰去")
                        let seat = KeySeat(primary: primary, children: [child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                let third_3: KeyboardEvent = {
                        let primary = KeyElement("NG", header: "4")
                        let child_0 = KeyElement("NG")
                        let child_1 = KeyElement("4", header: "聲調", footer: "陽平")
                        let child_2 = KeyElement("V")
                        let seat = KeySeat(primary: primary, children: [child_0, child_1, child_2])
                        return KeyboardEvent.input(seat)
                }()
                let third_4: KeyboardEvent = {
                        let primary = KeyElement("B", header: "5")
                        let child_0 = KeyElement("B")
                        let child_1 = KeyElement("5", header: "聲調", footer: "陽上")
                        let seat = KeySeat(primary: primary, children: [child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                let third_5: KeyboardEvent = {
                        let primary = KeyElement("N", header: "6")
                        let child_0 = KeyElement("N")
                        let child_1 = KeyElement("6", header: "聲調", footer: "陽去")
                        let seat = KeySeat(primary: primary, children: [child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                let third_6: KeyboardEvent = {
                        let primary = KeyElement("M")
                        let seat = KeySeat(primary: primary)
                        return KeyboardEvent.input(seat)
                }()
                var eventRows: [[KeyboardEvent]] = arrayTextArray.keysRows
                eventRows[0][0] = first_0
                eventRows[0][3] = first_3
                eventRows[0][5] = first_5
                eventRows[2] = [third_0, third_1, third_2, third_3, third_4, third_5, third_6]
                eventRows[1].insert(.shadowKey("A"), at: 0)
                eventRows[1].insert(.shadowKey("A"), at: 0)
                eventRows[1].append(.shadowKey("L"))
                eventRows[1].append(.shadowKey("L"))
                eventRows[2].insert(.shift, at: 0)
                eventRows[2].insert(.shadowKey("Z"), at: 1)
                eventRows[2].append(.hidden(.backspace))
                eventRows[2].append(.backspace)
                if needsGWKW {
                        let keyGW: KeyboardEvent = {
                                let primary: KeyElement = KeyElement("GW")
                                let seat = KeySeat(primary: primary)
                                return KeyboardEvent.input(seat)
                        }()
                        let keyKW: KeyboardEvent = {
                                let primary: KeyElement = KeyElement("KW")
                                let seat = KeySeat(primary: primary)
                                return KeyboardEvent.input(seat)
                        }()
                        let bottomEvents: [KeyboardEvent] = needsInputModeSwitchKey ?
                                [.transform(.cantoneseNumeric), .globe, keyGW, .space, keyKW, .newLine] :
                                [.transform(.cantoneseNumeric), keyGW, .space, keyKW, .newLine]
                        eventRows.append(bottomEvents)
                } else {
                        let comma: KeyboardEvent = .input(.cantoneseComma)
                        let bottomEvents: [KeyboardEvent] = needsInputModeSwitchKey ?
                                [.transform(.cantoneseNumeric), .globe, .space, comma, .newLine] :
                                [.transform(.cantoneseNumeric), comma, .space, .newLine]
                        eventRows.append(bottomEvents)
                }
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
                eventRows[2].append(.hidden(.backspace))
                eventRows[2].append(.backspace)
                let period: KeyboardEvent = .input(.period)
                let bottomEvents: [KeyboardEvent] = needsInputModeSwitchKey ?
                        [.transform(.numeric), .globe, .space, period, .newLine] :
                        [.transform(.numeric), period, .space, .newLine]
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
                eventRows[2].append(.hidden(.backspace))
                eventRows[2].append(.backspace)
                let period: KeyboardEvent = .input(.period)
                let bottomEvents: [KeyboardEvent] = needsInputModeSwitchKey ?
                        [.transform(.numeric), .globe, .space, period, .newLine] :
                        [.transform(.numeric), period, .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
        func cantoneseNumericKeys(_ needsInputModeSwitchKey: Bool) -> [[KeyboardEvent]] {
                let arrayTextArray: [[String]] = [
                        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
                        ["-", "/", "：", "；", "（", "）", "$", "@", "「", "」"],
                        ["。", "，", "、", "？", "！", "."]
                ]
                let digitalKeys: [KeyboardEvent] = {
                        let digits: [[String]] = [
                                ["1", "１", "壹", "¹", "₁"],
                                ["2", "２", "貳", "²", "₂"],
                                ["3", "３", "叁", "³", "₃"],
                                ["4", "４", "肆", "⁴", "₄"],
                                ["5", "５", "伍", "⁵", "₅"],
                                ["6", "６", "陸", "⁶", "₆"],
                                ["7", "７", "柒", "⁷", "₇"],
                                ["8", "８", "捌", "⁸", "₈"],
                                ["9", "９", "玖", "⁹", "₉"],
                                ["0", "０", "零", "⁰", "₀"]
                        ]
                        let keys: [KeyboardEvent] = digits.map { block -> KeyboardEvent in
                                let primary = KeyElement(block[0])
                                let child_0 = KeyElement(block[0])
                                let child_1 = KeyElement(block[1], header: "全形")
                                let child_2 = KeyElement(block[2])
                                let child_3 = KeyElement(block[3], header: "上標")
                                let child_4 = KeyElement(block[4], header: "下標")
                                if block[0] == "0" {
                                        let child_5 = KeyElement("拾")
                                        let child_6 = KeyElement("°", footer: "00B0")
                                        let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1, child_2, child_3, child_4, child_5, child_6])
                                        return KeyboardEvent.input(seat)
                                } else {
                                        let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1, child_2, child_3, child_4])
                                        return KeyboardEvent.input(seat)
                                }
                        }
                        return keys
                }()
                let second_0: KeyboardEvent = {
                        let primary = KeyElement("-")
                        let child_0 = KeyElement("-", footer: "002D")
                        let child_1 = KeyElement("－", header: "全形", footer: "FF0D")
                        let child_2 = KeyElement("—", footer: "2014")
                        let child_3 = KeyElement("–", footer: "2013")
                        let child_4 = KeyElement("•", footer: "2022")
                        let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1, child_2, child_3, child_4])
                        return KeyboardEvent.input(seat)
                }()
                let second_1: KeyboardEvent = {
                        let primary = KeyElement("\u{002F}")
                        let child_0 = KeyElement("\u{002F}")
                        let child_1 = KeyElement("\u{FF0F}", header: "全形")
                        let child_2 = KeyElement("\u{005C}")
                        let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1, child_2])
                        return KeyboardEvent.input(seat)
                }()
                let second_2: KeyboardEvent = {
                        let primary = KeyElement("：")
                        let child_0 = KeyElement(":", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let second_3: KeyboardEvent = {
                        let primary = KeyElement("；")
                        let child_0 = KeyElement(";", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let second_4: KeyboardEvent = {
                        let primary = KeyElement("（")
                        let child_0 = KeyElement("(", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let second_5: KeyboardEvent = {
                        let primary = KeyElement("）")
                        let child_0 = KeyElement(")", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let second_6: KeyboardEvent = {
                        let primary = KeyElement("$")
                        let child_0 = KeyElement("€")
                        let child_1 = KeyElement("£")
                        let child_2 = KeyElement("¥")
                        let child_3 = KeyElement("₩")
                        let child_4 = KeyElement("₽")
                        let child_5 = KeyElement("¢")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1, child_2, child_3, child_4, child_5])
                        return KeyboardEvent.input(seat)
                }()
                let second_7: KeyboardEvent = {
                        let primary = KeyElement("@")
                        let child_0 = KeyElement("＠", header: "全形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let second_8: KeyboardEvent = {
                        let primary = KeyElement("「")
                        let child_0 = KeyElement("『")
                        let child_1 = KeyElement("\u{0022}", footer: "0022")
                        let child_2 = KeyElement("\u{201C}", footer: "201C")
                        let child_3 = KeyElement("\u{2018}", footer: "2018")
                        let child_4 = KeyElement("\u{FE41}")
                        let child_5 = KeyElement("\u{FE43}")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1, child_2, child_3, child_4, child_5])
                        return KeyboardEvent.input(seat)
                }()
                let second_9: KeyboardEvent = {
                        let primary = KeyElement("」")
                        let child_0 = KeyElement("』")
                        let child_1 = KeyElement("\u{0022}", footer: "0022")
                        let child_2 = KeyElement("\u{201D}", footer: "201D")
                        let child_3 = KeyElement("\u{2019}", footer: "2019")
                        let child_4 = KeyElement("\u{FE42}")
                        let child_5 = KeyElement("\u{FE44}")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1, child_2, child_3, child_4, child_5])
                        return KeyboardEvent.input(seat)
                }()
                let third_0: KeyboardEvent = {
                        let primary = KeyElement("。")
                        let child_0 = KeyElement("⋯", footer: "22EF")
                        let child_1 = KeyElement("⋯⋯")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                let third_1: KeyboardEvent = {
                        let primary = KeyElement("，")
                        let child_0 = KeyElement(",", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let third_2: KeyboardEvent = {
                        let primary = KeyElement("、")
                        let seat: KeySeat = KeySeat(primary: primary)
                        return KeyboardEvent.input(seat)
                }()
                let third_3: KeyboardEvent = {
                        let primary = KeyElement("？")
                        let child_0 = KeyElement("?", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let third_4: KeyboardEvent = {
                        let primary = KeyElement("！")
                        let child_0 = KeyElement("!", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let third_5: KeyboardEvent = {
                        let primary = KeyElement(".")
                        let child_0 = KeyElement("．", header: "全形", footer: "FF0E")
                        let child_1 = KeyElement("…", footer: "2026")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                var eventRows: [[KeyboardEvent]] = arrayTextArray.placeholders
                eventRows[0] = digitalKeys
                eventRows[1] = [second_0, second_1, second_2, second_3, second_4, second_5, second_6, second_7, second_8, second_9]
                eventRows[2] = [third_0, third_1, third_2, third_3, third_4, third_5]
                eventRows[2].insert(.transform(.cantoneseSymbolic), at: 0)
                eventRows[2].insert(.none, at: 1)
                eventRows[2].append(.none)
                eventRows[2].append(.backspace)
                let bottomEvents: [KeyboardEvent] = needsInputModeSwitchKey ?
                        [.transform(.cantonese(.lowercased)), .globe, .space, .newLine] :
                        [.transform(.cantonese(.lowercased)), .space, .newLine]
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
                        let primary = KeyElement("0")
                        let child_0 = KeyElement("°")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let second_0: KeyboardEvent = {
                        let primary = KeyElement("\u{002D}")
                        let child_0 = KeyElement("\u{002D}", footer: "002D")
                        let child_1 = KeyElement("\u{2013}", footer: "2013")
                        let child_2 = KeyElement("\u{2014}", footer: "2014")
                        let child_3 = KeyElement("\u{2022}", footer: "2022")
                        let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1, child_2, child_3])
                        return KeyboardEvent.input(seat)
                }()
                let second_1: KeyboardEvent = {
                        let text: String = #"\"#
                        let primary = KeyElement("/")
                        let child_0 = KeyElement(text)
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let second_6: KeyboardEvent = {
                        let primary = KeyElement("$")
                        let child_0 = KeyElement("€")
                        let child_1 = KeyElement("£")
                        let child_2 = KeyElement("¥")
                        let child_3 = KeyElement("₩")
                        let child_4 = KeyElement("₽")
                        let child_5 = KeyElement("¢")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1, child_2, child_3, child_4, child_5])
                        return KeyboardEvent.input(seat)
                }()
                let second_7: KeyboardEvent = {
                        let primary = KeyElement("&")
                        let child_0 = KeyElement("§")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let second_9: KeyboardEvent = {
                        let primary = KeyElement("\u{0022}")
                        let child_0 = KeyElement("\u{0022}", footer: "0022")
                        let child_1 = KeyElement("\u{201C}", footer: "201C")
                        let child_2 = KeyElement("\u{201D}", footer: "201D")
                        let child_3 = KeyElement("\u{201E}", footer: "201E")
                        let child_4 = KeyElement("\u{00BB}", footer: "00BB")
                        let child_5 = KeyElement("\u{00AB}", footer: "00AB")
                        let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1, child_2, child_3, child_4, child_5])
                        return KeyboardEvent.input(seat)
                }()
                let third_0: KeyboardEvent = {
                        let primary = KeyElement(".")
                        let child_0 = KeyElement("…")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let third_1: KeyboardEvent = {
                        let primary = KeyElement(",")
                        let seat: KeySeat = KeySeat(primary: primary)
                        return KeyboardEvent.input(seat)
                }()
                let third_2: KeyboardEvent = {
                        let primary = KeyElement("?")
                        let child_0 = KeyElement("¿")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let third_3: KeyboardEvent = {
                        let primary = KeyElement("!")
                        let child_0 = KeyElement("¡")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let third_4: KeyboardEvent = {
                        let primary = KeyElement("\u{0027}")
                        let child_0 = KeyElement("\u{0027}", footer: "0027")
                        let child_1 = KeyElement("\u{2018}", footer: "2018")
                        let child_2 = KeyElement("\u{2019}", footer: "2019")
                        let child_3 = KeyElement("\u{0060}", footer: "0060")
                        let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1, child_2, child_3])
                        return KeyboardEvent.input(seat)
                }()
                var eventRows: [[KeyboardEvent]] = arrayTextArray.keysRows
                eventRows[0][9] = first_9
                eventRows[1][0] = second_0
                eventRows[1][1] = second_1
                eventRows[1][6] = second_6
                eventRows[1][7] = second_7
                eventRows[1][9] = second_9
                eventRows[2] = [third_0, third_1, third_2, third_3, third_4]
                eventRows[2].insert(.transform(.symbolic), at: 0)
                eventRows[2].insert(.none, at: 1)
                eventRows[2].append(.none)
                eventRows[2].append(.backspace)
                let bottomEvents: [KeyboardEvent] = needsInputModeSwitchKey ?
                        [.transform(.alphabetic(.lowercased)), .globe, .space, .newLine] :
                        [.transform(.alphabetic(.lowercased)), .space, .newLine]
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
                        let primary = KeyElement("［")
                        let child_0 = KeyElement("[", header: "半形")
                        let child_1 = KeyElement("【")
                        let child_2 = KeyElement("〖")
                        let child_3 = KeyElement("〔")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1, child_2, child_3])
                        return KeyboardEvent.input(seat)
                }()
                let first_1: KeyboardEvent = {
                        let primary = KeyElement("］")
                        let child_0 = KeyElement("]", header: "半形")
                        let child_1 = KeyElement("】")
                        let child_2 = KeyElement("〗")
                        let child_3 = KeyElement("〕")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1, child_2, child_3])
                        return KeyboardEvent.input(seat)
                }()
                let first_2: KeyboardEvent = {
                        let primary = KeyElement("｛")
                        let child_0 = KeyElement("{", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let first_3: KeyboardEvent = {
                        let primary = KeyElement("｝")
                        let child_0 = KeyElement("}", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let first_4: KeyboardEvent = {
                        let primary = KeyElement("#")
                        let child_0 = KeyElement("＃", header: "全形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let first_5: KeyboardEvent = {
                        let primary = KeyElement("%")
                        let child_0 = KeyElement("％", header: "全形")
                        let child_1 = KeyElement("‰")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                let first_6: KeyboardEvent = {
                        let primary = KeyElement("^")
                        let child_0 = KeyElement("＾", header: "全形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let first_7: KeyboardEvent = {
                        let primary = KeyElement("*")
                        let child_0 = KeyElement("＊", header: "全形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let first_8: KeyboardEvent = {
                        let primary = KeyElement("+")
                        let child_0 = KeyElement("＋", header: "全形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let first_9: KeyboardEvent = {
                        let primary = KeyElement("=")
                        let child_0 = KeyElement("＝", header: "全形")
                        let child_1 = KeyElement("≠")
                        let child_2 = KeyElement("≈")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1, child_2])
                        return KeyboardEvent.input(seat)
                }()
                let second_0: KeyboardEvent = {
                        let primary = KeyElement("_")
                        let child_0 = KeyElement("＿", header: "全形", footer: "FF3F")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let second_1: KeyboardEvent = {
                        let primary = KeyElement("—")
                        let seat: KeySeat = KeySeat(primary: primary)
                        return KeyboardEvent.input(seat)
                }()
                let second_2: KeyboardEvent = {
                        let text: String = #"\"#
                        let primary = KeyElement(text)
                        let child_0 = KeyElement("＼", header: "全形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let second_3: KeyboardEvent = {
                        let primary = KeyElement("｜")
                        let child_0 = KeyElement("|", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let second_4: KeyboardEvent = {
                        let primary = KeyElement("～")
                        let child_0 = KeyElement("~", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let second_5: KeyboardEvent = {
                        let primary = KeyElement("《")
                        let child_0 = KeyElement("〈", footer: "3008")
                        let child_1 = KeyElement("\u{003C}", footer: "003C")
                        let child_2 = KeyElement("＜", footer: "FF1C")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1, child_2])
                        return KeyboardEvent.input(seat)
                }()
                let second_6: KeyboardEvent = {
                        let primary = KeyElement("》")
                        let child_0 = KeyElement("〉", footer: "3009")
                        let child_1 = KeyElement("\u{003E}", footer: "003E")
                        let child_2 = KeyElement("＞", footer: "FF1E")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1, child_2])
                        return KeyboardEvent.input(seat)
                }()
                let second_7: KeyboardEvent = {
                        let primary = KeyElement("¥")
                        let seat: KeySeat = KeySeat(primary: primary)
                        return KeyboardEvent.input(seat)
                }()
                let second_8: KeyboardEvent = {
                        let primary = KeyElement("&")
                        let child_0 = KeyElement("＆", header: "全形")
                        let child_1 = KeyElement("§")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                let second_9: KeyboardEvent = {
                        let primary = KeyElement("\u{00B7}")
                        let child_0 = KeyElement("\u{00B7}", footer: "00B7")
                        let child_1 = KeyElement("\u{2022}", footer: "2022")
                        let child_2 = KeyElement("\u{00B0}", footer: "00B0")
                        let child_3 = KeyElement("\u{30FB}", footer: "30FB")
                        let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1, child_2, child_3])
                        return KeyboardEvent.input(seat)
                }()
                let third_0: KeyboardEvent = {
                        let primary = KeyElement("⋯")
                        let child_0 = KeyElement("⋯", footer: "22EF")
                        let child_1 = KeyElement("…", footer: "2026")
                        let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                let third_1: KeyboardEvent = {
                        let primary = KeyElement("，")
                        let child_0 = KeyElement(",", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let third_2: KeyboardEvent = {
                        let primary = KeyElement("\u{00A9}")
                        let child_0 = KeyElement("\u{2117}")
                        let child_1 = KeyElement("\u{00AE}")
                        let child_2 = KeyElement("\u{2122}")
                        let child_3 = KeyElement("\u{F8FF}")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1, child_2, child_3])
                        return KeyboardEvent.input(seat)
                }()
                let third_3: KeyboardEvent = {
                        let primary = KeyElement("？")
                        let child_0 = KeyElement("?", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let third_4: KeyboardEvent = {
                        let primary = KeyElement("！")
                        let child_0 = KeyElement("!", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let third_5: KeyboardEvent = {
                        let primary = KeyElement("\u{0027}")
                        let child_0 = KeyElement("\u{0027}", footer: "0027")
                        let child_1 = KeyElement("\u{FF07}", header: "全形", footer: "FF07")
                        let child_2 = KeyElement("\u{2018}", footer: "2018")
                        let child_3 = KeyElement("\u{2019}", footer: "2019")
                        let child_4 = KeyElement("\u{0060}", footer: "0060")
                        let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1, child_2, child_3, child_4])
                        return KeyboardEvent.input(seat)
                }()
                var eventRows: [[KeyboardEvent]] = arrayTextArray.placeholders
                eventRows[0] = [first_0, first_1, first_2, first_3, first_4, first_5, first_6, first_7, first_8, first_9]
                eventRows[1] = [second_0, second_1, second_2, second_3, second_4, second_5, second_6, second_7, second_8, second_9]
                eventRows[2] = [third_0, third_1, third_2, third_3, third_4, third_5]
                eventRows[2].insert(.transform(.cantoneseNumeric), at: 0)
                eventRows[2].insert(.none, at: 1)
                eventRows[2].append(.none)
                eventRows[2].append(.backspace)
                let bottomEvents: [KeyboardEvent] = needsInputModeSwitchKey ?
                        [.transform(.cantonese(.lowercased)), .globe, .space, .newLine] :
                        [.transform(.cantonese(.lowercased)), .space, .newLine]
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
                        let primary = KeyElement("%")
                        let child_0 = KeyElement("‰")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let first_9: KeyboardEvent = {
                        let primary = KeyElement("=")
                        let child_0 = KeyElement("≠")
                        let child_1 = KeyElement("≈")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                let third_0: KeyboardEvent = {
                        let primary = KeyElement(".")
                        let child_0 = KeyElement("…")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let third_1: KeyboardEvent = {
                        let primary = KeyElement(",")
                        let seat: KeySeat = KeySeat(primary: primary)
                        return KeyboardEvent.input(seat)
                }()
                let third_2: KeyboardEvent = {
                        let primary = KeyElement("?")
                        let child_0 = KeyElement("¿")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let third_3: KeyboardEvent = {
                        let primary = KeyElement("!")
                        let child_0 = KeyElement("¡")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let third_4: KeyboardEvent = {
                        let primary = KeyElement("\u{0027}")
                        let child_0 = KeyElement("\u{0027}", footer: "0027")
                        let child_1 = KeyElement("\u{2018}", footer: "2018")
                        let child_2 = KeyElement("\u{2019}", footer: "2019")
                        let child_3 = KeyElement("\u{0060}", footer: "0060")
                        let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1, child_2, child_3])
                        return KeyboardEvent.input(seat)
                }()
                var eventRows: [[KeyboardEvent]] = arrayTextArray.keysRows
                eventRows[0][5] = first_5
                eventRows[0][9] = first_9
                eventRows[2] = [third_0, third_1, third_2, third_3, third_4]
                eventRows[2].insert(.transform(.numeric), at: 0)
                eventRows[2].insert(.none, at: 1)
                eventRows[2].append(.none)
                eventRows[2].append(.backspace)
                let bottomEvents: [KeyboardEvent] = needsInputModeSwitchKey ?
                        [.transform(.alphabetic(.lowercased)), .globe, .space, .newLine] :
                        [.transform(.alphabetic(.lowercased)), .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }

        /*
        func longPressLowercasedKeys(_ needsInputModeSwitchKey: Bool) -> [[KeyboardEvent]] {
                let arrayTextArray: [[String]] = [
                        ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
                        ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
                        ["z", "x", "c", "v", "b", "n", "m"]
                ]
                let third: [KeyboardEvent] = {
                        let tones = [("z", "1", "陰平"), ("x", "2", "陰上"), ("c", "3", "陰去"), ("v", "4", "陽平"), ("b", "5", "陽上"), ("n", "6", "陽去")]
                        let keys: [KeyboardEvent] = tones.map { tuple -> KeyboardEvent in
                                let primary: KeyElement = KeyElement(tuple.0, header: tuple.1)
                                let child_0: KeyElement = KeyElement(tuple.0)
                                let child_1: KeyElement = KeyElement(tuple.1, header: "聲調", footer: tuple.2)
                                let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1])
                                return KeyboardEvent.input(seat)
                        }
                        let last: KeyboardEvent = {
                                let primary: KeyElement = KeyElement("m", header: "'")
                                let child_0: KeyElement = KeyElement("m")
                                let child_1: KeyElement = KeyElement("'", header: "分隔")
                                let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1])
                                return KeyboardEvent.input(seat)
                        }()
                        return keys + [last]
                }()
                var eventRows: [[KeyboardEvent]] = arrayTextArray.keysRows
                eventRows[1].insert(.shadowKey("a"), at: 0)
                eventRows[1].insert(.shadowKey("a"), at: 0)
                eventRows[1].append(.shadowKey("l"))
                eventRows[1].append(.shadowKey("l"))
                eventRows[2] = third
                eventRows[2].insert(.shift, at: 0)
                eventRows[2].insert(.shadowKey("z"), at: 1)
                eventRows[2].append(.hidden(.backspace))
                eventRows[2].append(.backspace)
                let comma: KeyboardEvent = .input(.cantoneseComma)
                let bottomEvents: [KeyboardEvent] = needsInputModeSwitchKey ?
                        [.transform(.cantoneseNumeric), .globe, .space, comma, .newLine] :
                        [.transform(.cantoneseNumeric), comma, .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
        func longPressUppercasedKeys(_ needsInputModeSwitchKey: Bool) -> [[KeyboardEvent]] {
                let arrayTextArray: [[String]] = [
                        ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
                        ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
                        ["Z", "X", "C", "V", "B", "N", "M"]
                ]
                let third: [KeyboardEvent] = {
                        let tones = [("Z", "1", "陰平"), ("X", "2", "陰上"), ("C", "3", "陰去"), ("V", "4", "陽平"), ("B", "5", "陽上"), ("N", "6", "陽去")]
                        let keys: [KeyboardEvent] = tones.map { tuple -> KeyboardEvent in
                                let primary: KeyElement = KeyElement(tuple.0, header: tuple.1)
                                let child_0: KeyElement = KeyElement(tuple.0)
                                let child_1: KeyElement = KeyElement(tuple.1, header: "聲調", footer: tuple.2)
                                let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1])
                                return KeyboardEvent.input(seat)
                        }
                        let last: KeyboardEvent = {
                                let primary: KeyElement = KeyElement("M", header: "'")
                                let child_0: KeyElement = KeyElement("M")
                                let child_1: KeyElement = KeyElement("'", header: "分隔")
                                let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1])
                                return KeyboardEvent.input(seat)
                        }()
                        return keys + [last]
                }()
                var eventRows: [[KeyboardEvent]] = arrayTextArray.keysRows
                eventRows[1].insert(.shadowKey("A"), at: 0)
                eventRows[1].insert(.shadowKey("A"), at: 0)
                eventRows[1].append(.shadowKey("L"))
                eventRows[1].append(.shadowKey("L"))
                eventRows[2] = third
                eventRows[2].insert(.shift, at: 0)
                eventRows[2].insert(.shadowKey("Z"), at: 1)
                eventRows[2].append(.hidden(.backspace))
                eventRows[2].append(.backspace)
                let comma: KeyboardEvent = .input(.cantoneseComma)
                let bottomEvents: [KeyboardEvent] = needsInputModeSwitchKey ?
                        [.transform(.cantoneseNumeric), .globe, .space, comma, .newLine] :
                        [.transform(.cantoneseNumeric), comma, .space, .newLine]
                eventRows.append(bottomEvents)
                return eventRows
        }
        */
}

private extension Array where Element == [String] {
        var keysRows: [[KeyboardEvent]] {
                return map { $0.map { KeyboardEvent.input(KeySeat(primary: KeyElement($0))) } }
        }
        var placeholders: [[KeyboardEvent]] {
                return map { $0.map { _ in KeyboardEvent.none } }
        }
}
