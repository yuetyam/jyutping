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
                switch keyboardInterface {
                case .phonePortrait, .phoneLandscape, .padFloating:
                        if uppercased {
                                return compactSaamPingUppercasedKeys(keyboardInterface: keyboardInterface, needsInputModeSwitchKey: needsInputModeSwitchKey)
                        } else {
                                return compactSaamPingKeys(keyboardInterface: keyboardInterface, needsInputModeSwitchKey: needsInputModeSwitchKey)
                        }
                case .padPortraitSmall, .padLandscapeSmall:
                        return compactSaamPingKeys(keyboardInterface: keyboardInterface, needsInputModeSwitchKey: needsInputModeSwitchKey)
                case .padPortraitMedium, .padLandscapeMedium:
                        return compactSaamPingKeys(keyboardInterface: keyboardInterface, needsInputModeSwitchKey: needsInputModeSwitchKey)
                case .padPortraitLarge, .padLandscapeLarge:
                        return compactSaamPingKeys(keyboardInterface: keyboardInterface, needsInputModeSwitchKey: needsInputModeSwitchKey)
                }
        }

        private func compactSaamPingKeys(keyboardInterface: KeyboardInterface, needsInputModeSwitchKey: Bool) -> [[KeyboardEvent]] {
                let first_0: KeyboardEvent = {
                        let primary = KeyElement("aa")
                        let child_0 = KeyElement("q")
                        let seat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let first_3: KeyboardEvent = {
                        let primary = KeyElement("oe")
                        let child_0 = KeyElement("oe")
                        let child_1 = KeyElement("r")
                        let child_2 = KeyElement("eo")
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
                        let child_1 = KeyElement("1", footer: "陰平")
                        let seat = KeySeat(primary: primary, children: [child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                let third_1: KeyboardEvent = {
                        let primary = KeyElement("gw", header: "2")
                        let child_0 = KeyElement("gw")
                        let child_1 = KeyElement("2", footer: "陰上")
                        let child_2 = KeyElement("x")
                        let seat = KeySeat(primary: primary, children: [child_0, child_1, child_2])
                        return KeyboardEvent.input(seat)
                }()
                let third_2: KeyboardEvent = {
                        let primary = KeyElement("c", header: "3")
                        let child_0 = KeyElement("c")
                        let child_1 = KeyElement("3", footer: "陰去")
                        let seat = KeySeat(primary: primary, children: [child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                let third_3: KeyboardEvent = {
                        let primary = KeyElement("ng", header: "4")
                        let child_0 = KeyElement("ng")
                        let child_1 = KeyElement("4", footer: "陽平")
                        let child_2 = KeyElement("v")
                        let seat = KeySeat(primary: primary, children: [child_0, child_1, child_2])
                        return KeyboardEvent.input(seat)
                }()
                let third_4: KeyboardEvent = {
                        let primary = KeyElement("b", header: "5")
                        let child_0 = KeyElement("b")
                        let child_1 = KeyElement("5", footer: "陽上")
                        let seat = KeySeat(primary: primary, children: [child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                let third_5: KeyboardEvent = {
                        let primary = KeyElement("n", header: "6")
                        let child_0 = KeyElement("n")
                        let child_1 = KeyElement("6", footer: "陽去")
                        let seat = KeySeat(primary: primary, children: [child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                let third_6: KeyboardEvent = {
                        let primary = KeyElement("m")
                        let child_0 = KeyElement("m")
                        let child_1 = KeyElement("kw")
                        let seat = KeySeat(primary: primary, children: [child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                var eventRows: [[KeyboardEvent]] = saamPingLetters(uppercased: false)
                eventRows[0][0] = first_0
                eventRows[0][3] = first_3
                eventRows[0][5] = first_5
                eventRows[1][4] = second_4
                eventRows[1][7] = second_7
                eventRows[2] = [third_0, third_1, third_2, third_3, third_4, third_5, third_6]
                eventRows[1].insert(.hidden(.text("a")), at: 0)
                eventRows[1].insert(.hidden(.text("a")), at: 0)
                eventRows[1].append(.hidden(.text("l")))
                eventRows[1].append(.hidden(.text("l")))
                eventRows[2].insert(.shift, at: 0)
                eventRows[2].insert(.hidden(.text("z")), at: 1)
                eventRows[2].append(.hidden(.backspace))
                eventRows[2].append(.backspace)

                let comma: KeyboardEvent = .input(.cantoneseComma)
                let bottomEvents: [KeyboardEvent] = {
                        guard needsInputModeSwitchKey else {
                                return [.transform(.cantoneseNumeric), comma, .space, .newLine]
                        }
                        switch keyboardInterface {
                        case .padFloating:
                                return [.globe, .transform(.cantoneseNumeric), .space, comma, .newLine]
                        default:
                                return [.transform(.cantoneseNumeric), .globe, .space, comma, .newLine]
                        }
                }()
                eventRows.append(bottomEvents)
                return eventRows
        }

        private func compactSaamPingUppercasedKeys(keyboardInterface: KeyboardInterface, needsInputModeSwitchKey: Bool) -> [[KeyboardEvent]] {
                let first_0: KeyboardEvent = {
                        let primary = KeyElement("AA")
                        let child_0 = KeyElement("Q")
                        let seat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let first_3: KeyboardEvent = {
                        let primary = KeyElement("OE")
                        let child_0 = KeyElement("OE")
                        let child_1 = KeyElement("R")
                        let child_2 = KeyElement("EO")
                        let seat = KeySeat(primary: primary, children: [child_0, child_1, child_2])
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
                        let child_1 = KeyElement("1", footer: "陰平")
                        let seat = KeySeat(primary: primary, children: [child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                let third_1: KeyboardEvent = {
                        let primary = KeyElement("GW", header: "2")
                        let child_0 = KeyElement("GW")
                        let child_1 = KeyElement("2", footer: "陰上")
                        let child_2 = KeyElement("X")
                        let seat = KeySeat(primary: primary, children: [child_0, child_1, child_2])
                        return KeyboardEvent.input(seat)
                }()
                let third_2: KeyboardEvent = {
                        let primary = KeyElement("C", header: "3")
                        let child_0 = KeyElement("C")
                        let child_1 = KeyElement("3", footer: "陰去")
                        let seat = KeySeat(primary: primary, children: [child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                let third_3: KeyboardEvent = {
                        let primary = KeyElement("NG", header: "4")
                        let child_0 = KeyElement("NG")
                        let child_1 = KeyElement("4", footer: "陽平")
                        let child_2 = KeyElement("V")
                        let seat = KeySeat(primary: primary, children: [child_0, child_1, child_2])
                        return KeyboardEvent.input(seat)
                }()
                let third_4: KeyboardEvent = {
                        let primary = KeyElement("B", header: "5")
                        let child_0 = KeyElement("B")
                        let child_1 = KeyElement("5", footer: "陽上")
                        let seat = KeySeat(primary: primary, children: [child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                let third_5: KeyboardEvent = {
                        let primary = KeyElement("N", header: "6")
                        let child_0 = KeyElement("N")
                        let child_1 = KeyElement("6", footer: "陽去")
                        let seat = KeySeat(primary: primary, children: [child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                let third_6: KeyboardEvent = {
                        let primary = KeyElement("M")
                        let child_0 = KeyElement("M")
                        let child_1 = KeyElement("KW")
                        let seat = KeySeat(primary: primary, children: [child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                var eventRows: [[KeyboardEvent]] = saamPingLetters(uppercased: true)
                eventRows[0][0] = first_0
                eventRows[0][3] = first_3
                eventRows[0][5] = first_5
                eventRows[2] = [third_0, third_1, third_2, third_3, third_4, third_5, third_6]
                eventRows[1].insert(.hidden(.text("A")), at: 0)
                eventRows[1].insert(.hidden(.text("A")), at: 0)
                eventRows[1].append(.hidden(.text("L")))
                eventRows[1].append(.hidden(.text("L")))
                eventRows[2].insert(.shift, at: 0)
                eventRows[2].insert(.hidden(.text("Z")), at: 1)
                eventRows[2].append(.hidden(.backspace))
                eventRows[2].append(.backspace)
                let comma: KeyboardEvent = .input(.cantoneseComma)
                let bottomEvents: [KeyboardEvent] = {
                        guard needsInputModeSwitchKey else {
                                return [.transform(.cantoneseNumeric), comma, .space, .newLine]
                        }
                        switch keyboardInterface {
                        case .padFloating:
                                return [.globe, .transform(.cantoneseNumeric), .space, comma, .newLine]
                        default:
                                return [.transform(.cantoneseNumeric), .globe, .space, comma, .newLine]
                        }
                }()
                eventRows.append(bottomEvents)
                return eventRows
        }
}
