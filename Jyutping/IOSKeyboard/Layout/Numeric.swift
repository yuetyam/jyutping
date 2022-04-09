extension KeyboardIdiom {

        func numericKeys(keyboardInterface: KeyboardInterface, needsInputModeSwitchKey: Bool) -> [[KeyboardEvent]] {
                switch keyboardInterface {
                case .phonePortrait, .phoneLandscape, .padFloating:
                        return compactNumericKeys(keyboardInterface: keyboardInterface, needsInputModeSwitchKey: needsInputModeSwitchKey)
                case .padPortraitSmall, .padLandscapeSmall, .padPortraitMedium, .padLandscapeMedium:
                        return smallMediumNumericKeys(keyboardInterface: keyboardInterface, needsInputModeSwitchKey: needsInputModeSwitchKey)
                case .padPortraitLarge, .padLandscapeLarge:
                        return smallMediumNumericKeys(keyboardInterface: keyboardInterface, needsInputModeSwitchKey: needsInputModeSwitchKey)
                }
        }

        private func smallMediumNumericKeys(keyboardInterface: KeyboardInterface, needsInputModeSwitchKey: Bool) -> [[KeyboardEvent]] {
                let arrayTextArray: [[String]] = [
                        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
                        ["@", "#", "$", "&", "*", "(", ")", "'", "\""],
                        ["%", "-", "+", "=", "/", ";", ":", ",", "."]
                ]
                var eventRows: [[KeyboardEvent]] = arrayTextArray.map({ $0.map({ KeyboardEvent.input(KeySeat(primary: KeyElement($0))) }) })
                let toSymbolic: KeyboardEvent = .transform(.symbolic)
                switch keyboardInterface {
                case .padPortraitSmall, .padLandscapeSmall:
                        eventRows[0].append(.backspace)
                        eventRows[1].insert(.none, at: 0)
                        eventRows[1].insert(.none, at: 0)
                        eventRows[1].append(.newLine)
                        eventRows[2].insert(toSymbolic, at: 0)
                        eventRows[2].append(toSymbolic)
                default:
                        eventRows[0].insert(.tab, at: 0)
                        eventRows[0].append(.backspace)

                        eventRows[1].insert(.none, at: 0)
                        eventRows[1].insert(toSymbolic, at: 0)
                        eventRows[1].append(.newLine)

                        eventRows[2].insert(.none, at: 0)
                        eventRows[2].insert(.none, at: 0)
                        eventRows[2].insert(.none, at: 0)
                        eventRows[2].insert(toSymbolic, at: 0)
                        eventRows[2].append(.none)
                        eventRows[2].append(toSymbolic)
                }
                let bottomRow: [KeyboardEvent] = {
                        let switchKey: KeyboardEvent = needsInputModeSwitchKey ? .globe : .transform(.emoji)
                        let back: KeyboardEvent = .transform(.alphabetic(.lowercased))
                        return [switchKey, back, .space, back, .dismiss]
                }()
                eventRows.append(bottomRow)
                return eventRows
        }

        private func compactNumericKeys(keyboardInterface: KeyboardInterface, needsInputModeSwitchKey: Bool) -> [[KeyboardEvent]] {
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
                var eventRows: [[KeyboardEvent]] = arrayTextArray.map({ $0.map({ KeyboardEvent.input(.init(primary: .init($0))) }) })
                eventRows[0][9] = first_9
                eventRows[1][0] = second_0
                eventRows[1][1] = second_1
                eventRows[1][6] = second_6
                eventRows[1][7] = second_7
                eventRows[1][9] = second_9
                eventRows[2] = [third_0, third_1, third_2, third_3, third_4]
                eventRows[2].insert(.none, at: 0)
                eventRows[2].insert(.transform(.symbolic), at: 0)
                eventRows[2].append(.none)
                eventRows[2].append(.backspace)
                let bottomEvents: [KeyboardEvent] = {
                        let switchKey: KeyboardEvent = needsInputModeSwitchKey ? .globe : .transform(.emoji)
                        let period: KeyboardEvent = KeyboardEvent.input(.period)
                        switch keyboardInterface {
                        case .padFloating:
                                return [switchKey, .transform(.alphabetic(.lowercased)), .space, period, .newLine]
                        default:
                                return [.transform(.alphabetic(.lowercased)), switchKey, .space, period, .newLine]
                        }
                }()
                eventRows.append(bottomEvents)
                return eventRows
        }
}
