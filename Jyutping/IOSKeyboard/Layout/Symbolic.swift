extension KeyboardIdiom {

        func symbolicKeys(keyboardInterface: KeyboardInterface, needsInputModeSwitchKey: Bool) -> [[KeyboardEvent]] {
                switch keyboardInterface {
                case .phonePortrait, .phoneLandscape, .padFloating:
                        return compactSymbolicKeys(keyboardInterface: keyboardInterface, needsInputModeSwitchKey: needsInputModeSwitchKey)
                case .padPortraitSmall, .padLandscapeSmall:
                        return compactSymbolicKeys(keyboardInterface: keyboardInterface, needsInputModeSwitchKey: needsInputModeSwitchKey)
                case .padPortraitMedium, .padLandscapeMedium:
                        return compactSymbolicKeys(keyboardInterface: keyboardInterface, needsInputModeSwitchKey: needsInputModeSwitchKey)
                case .padPortraitLarge, .padLandscapeLarge:
                        return compactSymbolicKeys(keyboardInterface: keyboardInterface, needsInputModeSwitchKey: needsInputModeSwitchKey)
                }
        }

        private func compactSymbolicKeys(keyboardInterface: KeyboardInterface, needsInputModeSwitchKey: Bool) -> [[KeyboardEvent]] {
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
                var eventRows: [[KeyboardEvent]] = arrayTextArray.map({ $0.map({ KeyboardEvent.input(.init(primary: .init($0))) }) })
                eventRows[0][5] = first_5
                eventRows[0][9] = first_9
                eventRows[2] = [third_0, third_1, third_2, third_3, third_4]
                eventRows[2].insert(.none, at: 0)
                eventRows[2].insert(.transform(.numeric), at: 0)
                eventRows[2].append(.none)
                eventRows[2].append(.backspace)
                let bottomEvents: [KeyboardEvent] = {
                        let switchKey: KeyboardEvent = needsInputModeSwitchKey ? .globe : .transform(.emoji)
                        let period: KeyboardEvent = KeyboardEvent.input(.period)
                        switch keyboardInterface {
                        case .padPortraitSmall, .padLandscapeSmall, .padFloating:
                                return [switchKey, .transform(.alphabetic(.lowercased)), .space, period, .newLine]
                        default:
                                return [.transform(.alphabetic(.lowercased)), switchKey, .space, period, .newLine]
                        }
                }()
                eventRows.append(bottomEvents)
                return eventRows
        }
}
