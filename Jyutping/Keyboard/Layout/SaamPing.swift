extension KeyboardIdiom {

        private func saamPingLetters(uppercased: Bool) -> [[KeyboardEvent]] {
                let arrayTextArray: [[String]] = {
                        if uppercased {
                                return [
                                        ["AA", "W", "E", "EO", "T", "YU", "U", "I", "O", "P"],
                                        ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
                                        ["Z", "OE", "C", "NG", "B", "N", "M"]
                                ]
                        } else {
                                return [
                                        ["aa", "w", "e", "eo", "t", "yu", "u", "i", "o", "p"],
                                        ["a", "s", "d", "f", "g", "h", "j", "k", "l"],
                                        ["z", "oe", "c", "ng", "b", "n", "m"]
                                ]
                        }
                }()
                return arrayTextArray.map({ $0.map({ KeyboardEvent.input(KeySeat(primary: KeyElement($0))) }) })
        }

        func saamPingKeys(keyboardInterface: KeyboardInterface, needsInputModeSwitchKey: Bool, uppercased: Bool) -> [[KeyboardEvent]] {

                func cased(_ text: String) -> String {
                        return uppercased ? text.uppercased() : text.lowercased()
                }

                let first_0: KeyboardEvent = {
                        let primary = KeyElement(cased("aa"))
                        let child_0 = KeyElement(cased("q"))
                        let seat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let first_3: KeyboardEvent = {
                        let primary = KeyElement(cased("oe"))
                        let child_0 = KeyElement(cased("oe"))
                        let child_1 = KeyElement(cased("r"))
                        let child_2 = KeyElement(cased("eo"))
                        let seat = KeySeat(primary: primary, children: [child_0, child_1, child_2])
                        return KeyboardEvent.input(seat)
                }()
                let first_5: KeyboardEvent = {
                        let primary = KeyElement(cased("yu"))
                        let child_0 = KeyElement(cased("y"))
                        let seat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()

                let second_4: KeyboardEvent = {
                        let primary = KeyElement(cased("g"))
                        let child_0 = KeyElement(cased("gw"))
                        let seat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let second_7: KeyboardEvent = {
                        let primary = KeyElement(cased("k"))
                        let child_0 = KeyElement(cased("kw"))
                        let seat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()

                let third_0: KeyboardEvent = {
                        let primary = KeyElement(cased("z"), header: "1")
                        let child_0 = KeyElement(cased("z"))
                        let child_1 = KeyElement("1", footer: "陰平")
                        let seat = KeySeat(primary: primary, children: [child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                let third_1: KeyboardEvent = {
                        let primary = KeyElement(cased("gw"), header: "2")
                        let child_0 = KeyElement(cased("gw"))
                        let child_1 = KeyElement("2", footer: "陰上")
                        let child_2 = KeyElement(cased("x"))
                        let seat = KeySeat(primary: primary, children: [child_0, child_1, child_2])
                        return KeyboardEvent.input(seat)
                }()
                let third_2: KeyboardEvent = {
                        let primary = KeyElement(cased("c"), header: "3")
                        let child_0 = KeyElement(cased("c"))
                        let child_1 = KeyElement("3", footer: "陰去")
                        let seat = KeySeat(primary: primary, children: [child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                let third_3: KeyboardEvent = {
                        let primary = KeyElement(cased("ng"), header: "4")
                        let child_0 = KeyElement(cased("ng"))
                        let child_1 = KeyElement("4", footer: "陽平")
                        let child_2 = KeyElement(cased("v"))
                        let seat = KeySeat(primary: primary, children: [child_0, child_1, child_2])
                        return KeyboardEvent.input(seat)
                }()
                let third_4: KeyboardEvent = {
                        let primary = KeyElement(cased("b"), header: "5")
                        let child_0 = KeyElement(cased("b"))
                        let child_1 = KeyElement("5", footer: "陽上")
                        let seat = KeySeat(primary: primary, children: [child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                let third_5: KeyboardEvent = {
                        let primary = KeyElement(cased("n"), header: "6")
                        let child_0 = KeyElement(cased("n"))
                        let child_1 = KeyElement("6", footer: "陽去")
                        let seat = KeySeat(primary: primary, children: [child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                let third_6: KeyboardEvent = {
                        let primary = KeyElement(cased("m"))
                        let child_0 = KeyElement(cased("m"))
                        let child_1 = KeyElement(cased("kw"))
                        let seat = KeySeat(primary: primary, children: [child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()

                var eventRows: [[KeyboardEvent]] = saamPingLetters(uppercased: uppercased)
                eventRows[0][0] = first_0
                eventRows[0][3] = first_3
                eventRows[0][5] = first_5
                eventRows[1][4] = second_4
                eventRows[1][7] = second_7

                guard !keyboardInterface.isCompact else {
                        eventRows[2] = [third_0, third_1, third_2, third_3, third_4, third_5, third_6]
                        let letterA: String = uppercased ? "A" : "a"
                        let letterL: String = uppercased ? "L" : "l"
                        let letterZ: String = uppercased ? "Z" : "z"
                        eventRows[1].insert(.hidden(.text(letterA)), at: 0)
                        eventRows[1].insert(.hidden(.text(letterA)), at: 0)
                        eventRows[1].append(.hidden(.text(letterL)))
                        eventRows[1].append(.hidden(.text(letterL)))
                        eventRows[2].insert(.hidden(.text(letterZ)), at: 0)
                        eventRows[2].insert(.shift, at: 0)
                        eventRows[2].append(.hidden(.backspace))
                        eventRows[2].append(.backspace)
                        let bottomEvents: [KeyboardEvent] = {
                                let switchKey: KeyboardEvent = needsInputModeSwitchKey ? .globe : .transform(.emoji)
                                let comma: KeyboardEvent = KeyboardEvent.input(.cantoneseComma)
                                switch keyboardInterface {
                                case .padFloating:
                                        return [switchKey, .transform(.cantoneseNumeric), .space, comma, .newLine]
                                default:
                                        return [.transform(.cantoneseNumeric), switchKey, .space, comma, .newLine]
                                }
                        }()
                        eventRows.append(bottomEvents)
                        return eventRows
                }

                let comma: KeyboardEvent = {
                        if uppercased {
                                return KeyboardEvent.input(KeySeat(primary: KeyElement("！")))
                        } else {
                                let primary: KeyElement = KeyElement("，")
                                let child_0: KeyElement = KeyElement("！")
                                let child_1: KeyElement = KeyElement(",")
                                let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1])
                                return KeyboardEvent.input(seat)
                        }
                }()
                let period: KeyboardEvent = {
                        if uppercased {
                                return KeyboardEvent.input(KeySeat(primary: KeyElement("？")))
                        } else {
                                let primary: KeyElement = KeyElement("。")
                                let child_0: KeyElement = KeyElement("？")
                                let child_1: KeyElement = KeyElement(".")
                                let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1])
                                return KeyboardEvent.input(seat)
                        }
                }()

                switch keyboardInterface {
                case .padPortraitSmall, .padLandscapeSmall:
                        eventRows[0].append(.backspace)
                        eventRows[1].insert(.none, at: 0)
                        eventRows[1].insert(.none, at: 0)
                        eventRows[1].append(.newLine)
                        eventRows[2] = [.shift, third_0, third_1, third_2, third_3, third_4, third_5, third_6, comma, period, .shift]
                case .padPortraitMedium, .padLandscapeMedium:
                        eventRows[0].insert(.tab, at: 0)
                        eventRows[0].append(.backspace)
                        let trans: KeyboardEvent = .transform(.alphabetic(uppercased ? .uppercased : .lowercased))
                        eventRows[1].insert(.none, at: 0)
                        eventRows[1].insert(trans, at: 0)
                        eventRows[1].append(.newLine)
                        eventRows[2] = [.shift, .none, .none, third_0, third_1, third_2, third_3, third_4, third_5, third_6, comma, period, .shift]
                case .padPortraitLarge, .padLandscapeLarge:
                        let head: [String] = {
                                if uppercased {
                                        return ["～", "！", "@", "#", "$", "%", "……", "&", "*", "（", "）", "——", "+"]
                                } else {
                                        return ["·", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "="]
                                }
                        }()
                        let headRow: [KeyboardEvent] = head.map({ KeyboardEvent.input(KeySeat(primary: KeyElement($0))) })
                        eventRows.insert(headRow, at: 0)
                        eventRows[0].append(.backspace)

                        let row_1_extra_0: KeyboardEvent = {
                                if uppercased {
                                        return KeyboardEvent.input(KeySeat(primary: KeyElement("『")))
                                } else {
                                        let primary: KeyElement = KeyElement("「")
                                        let child_0: KeyElement = KeyElement("『")
                                        let child_1: KeyElement = KeyElement("\u{201C}", footer: "201C")
                                        let child_2: KeyElement = KeyElement("\"", footer: "0022")
                                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1, child_2])
                                        return KeyboardEvent.input(seat)
                                }
                        }()
                        let row_1_extra_1: KeyboardEvent = {
                                if uppercased {
                                        return KeyboardEvent.input(KeySeat(primary: KeyElement("』")))
                                } else {
                                        let primary: KeyElement = KeyElement("」")
                                        let child_0: KeyElement = KeyElement("』")
                                        let child_1: KeyElement = KeyElement("\u{201D}", footer: "201D")
                                        let child_2: KeyElement = KeyElement("\"", footer: "0022")
                                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1, child_2])
                                        return KeyboardEvent.input(seat)
                                }
                        }()
                        let row_1_extra_2: KeyboardEvent = {
                                if uppercased {
                                        let primary: KeyElement = KeyElement("｜")
                                        let child: KeyElement = KeyElement("|", header: "半形")
                                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child])
                                        return KeyboardEvent.input(seat)
                                } else {
                                        let primary: KeyElement = KeyElement("、")
                                        let child_0: KeyElement = KeyElement("｜")
                                        let child_1: KeyElement = KeyElement("\\", header: "半形")
                                        let child_2: KeyElement = KeyElement("＼", header: "全形")
                                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1, child_2])
                                        return KeyboardEvent.input(seat)
                                }
                        }()

                        let row_2_extra_0: KeyboardEvent = {
                                if uppercased {
                                        let primary: KeyElement = KeyElement("：")
                                        let child_0: KeyElement = KeyElement(":", header: "半形")
                                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                                        return KeyboardEvent.input(seat)
                                } else {
                                        let primary: KeyElement = KeyElement("；")
                                        let child_0: KeyElement = KeyElement("：")
                                        let child_1: KeyElement = KeyElement(";", header: "英")
                                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1])
                                        return KeyboardEvent.input(seat)
                                }
                        }()
                        let row_2_extra_1: KeyboardEvent = {
                                if uppercased {
                                        return KeyboardEvent.input(KeySeat(primary: KeyElement("\"")))
                                } else {
                                        let primary: KeyElement = KeyElement("'")
                                        let child_0: KeyElement = KeyElement("'", footer: "0027")
                                        let child_1: KeyElement = KeyElement("\"", footer: "0022")
                                        let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1])
                                        return KeyboardEvent.input(seat)
                                }
                        }()

                        let row_3_extra_0: KeyboardEvent = {
                                if uppercased {
                                        let primary: KeyElement = KeyElement("《")
                                        let child_0: KeyElement = KeyElement("〈")
                                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                                        return KeyboardEvent.input(seat)
                                } else {
                                        let primary: KeyElement = KeyElement("，")
                                        let child_0: KeyElement = KeyElement("《")
                                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                                        return KeyboardEvent.input(seat)
                                }
                        }()
                        let row_3_extra_1: KeyboardEvent = {
                                if uppercased {
                                        let primary: KeyElement = KeyElement("》")
                                        let child_0: KeyElement = KeyElement("〉")
                                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                                        return KeyboardEvent.input(seat)
                                } else {
                                        let primary: KeyElement = KeyElement("。")
                                        let child_0: KeyElement = KeyElement("》")
                                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                                        return KeyboardEvent.input(seat)
                                }
                        }()
                        let row_3_extra_2: KeyboardEvent = {
                                if uppercased {
                                        let primary: KeyElement = KeyElement("？")
                                        let child_0: KeyElement = KeyElement("?", header: "半形")
                                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                                        return KeyboardEvent.input(seat)
                                } else {
                                        let primary: KeyElement = KeyElement("/")
                                        let child_0: KeyElement = KeyElement("？")
                                        let child_1: KeyElement = KeyElement("／", header: "全形")
                                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1])
                                        return KeyboardEvent.input(seat)
                                }
                        }()
                        eventRows[1].insert(.tab, at: 0)
                        eventRows[1].append(row_1_extra_0)
                        eventRows[1].append(row_1_extra_1)
                        eventRows[1].append(row_1_extra_2)

                        let trans: KeyboardEvent = .transform(.alphabetic(uppercased ? .uppercased : .lowercased))
                        eventRows[2].insert(.none, at: 0)
                        eventRows[2].insert(trans, at: 0)
                        eventRows[2].append(row_2_extra_0)
                        eventRows[2].append(row_2_extra_1)
                        eventRows[2].append(.newLine)

                        eventRows[3] = [.shift, third_0, third_1, third_2, third_3, third_4, third_5, third_6, row_3_extra_0, row_3_extra_1, row_3_extra_2, .shift]
                default:
                        break
                }

                let bottomEvents: [KeyboardEvent] = {
                        let switchKey: KeyboardEvent = needsInputModeSwitchKey ? .globe : .transform(.emoji)
                        return [switchKey, .transform(.cantoneseNumeric), .space, .transform(.cantoneseNumeric), .dismiss]
                }()
                eventRows.append(bottomEvents)
                return eventRows
        }
}
