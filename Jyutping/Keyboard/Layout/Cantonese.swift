extension KeyboardIdiom {

        func cantoneseKeys(keyboardInterface: KeyboardInterface, needsInputModeSwitchKey: Bool, uppercased: Bool) -> [[KeyboardEvent]] {
                switch keyboardInterface {
                case .phonePortrait, .phoneLandscape, .padFloating:
                        return compactCantoneseKeys(keyboardInterface: keyboardInterface, needsInputModeSwitchKey: needsInputModeSwitchKey, uppercased: uppercased)
                case .padPortraitSmall, .padLandscapeSmall:
                        return smallPadCantoneseKeys(keyboardInterface: keyboardInterface, needsInputModeSwitchKey: needsInputModeSwitchKey, uppercased: uppercased)
                case .padPortraitMedium, .padLandscapeMedium:
                        return mediumPadCantoneseKeys(keyboardInterface: keyboardInterface, needsInputModeSwitchKey: needsInputModeSwitchKey, uppercased: uppercased)
                case .padPortraitLarge, .padLandscapeLarge:
                        return largePadCantoneseKeys(keyboardInterface: keyboardInterface, needsInputModeSwitchKey: needsInputModeSwitchKey, uppercased: uppercased)
                }
        }

        private func largePadCantoneseKeys(keyboardInterface: KeyboardInterface, needsInputModeSwitchKey: Bool, uppercased: Bool) -> [[KeyboardEvent]] {
                let headRow: [KeyboardEvent] = {
                        // TODO: Reimplement
                        if uppercased {
                                // lowercase ["·", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "="]
                                let texts: [String] = ["～", "！", "@", "#", "$", "%", "……", "&", "*", "（", "）", "——", "+"]
                                return texts.map({ KeyboardEvent.input(KeySeat(primary: KeyElement($0))) })
                        } else {
                                let left: KeyboardEvent = {
                                        let primary = KeyElement("·")
                                        let child_0 = KeyElement("～")
                                        let seat = KeySeat(primary: primary, children: [primary, child_0])
                                        return KeyboardEvent.input(seat)
                                }()
                                let right_0: KeyboardEvent = {
                                        let primary = KeyElement("-")
                                        let child_0 = KeyElement("——")
                                        let seat = KeySeat(primary: primary, children: [primary, child_0])
                                        return KeyboardEvent.input(seat)
                                }()
                                let right_1: KeyboardEvent = {
                                        let primary = KeyElement("=")
                                        let child_0 = KeyElement("+")
                                        let seat = KeySeat(primary: primary, children: [primary, child_0])
                                        return KeyboardEvent.input(seat)
                                }()
                                return [left] + digitalKeys() + [right_0, right_1]
                        }
                }()

                var eventRows: [[KeyboardEvent]] = letters(uppercased: uppercased)
                eventRows.insert(headRow, at: 0)
                eventRows[0].append(.backspace)

                eventRows[1].insert(.tab, at: 0)
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
                eventRows[1].append(row_1_extra_0)
                eventRows[1].append(row_1_extra_1)
                eventRows[1].append(row_1_extra_2)

                eventRows[2].insert(.none, at: 0)
                eventRows[2].insert(.transform(.alphabetic(uppercased ? .uppercased : .lowercased)), at: 0)
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
                eventRows[2].append(row_2_extra_0)
                eventRows[2].append(row_2_extra_1)
                eventRows[2].append(.newLine)

                eventRows[3].insert(.shift, at: 0)
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
                eventRows[3].append(row_3_extra_0)
                eventRows[3].append(row_3_extra_1)
                eventRows[3].append(row_3_extra_2)
                eventRows[3].append(.shift)

                let bottomEvents: [KeyboardEvent] = {
                        let numeric: KeyboardEvent = .transform(.cantoneseNumeric)
                        let switchKey: KeyboardEvent = needsInputModeSwitchKey ? .globe : numeric
                        return [switchKey, numeric, .space, numeric, .dismiss]
                }()
                eventRows.append(bottomEvents)
                return eventRows
        }
        private func mediumPadCantoneseKeys(keyboardInterface: KeyboardInterface, needsInputModeSwitchKey: Bool, uppercased: Bool) -> [[KeyboardEvent]] {
                var eventRows: [[KeyboardEvent]] = letters(uppercased: uppercased)

                eventRows[0].insert(.tab, at: 0)
                eventRows[0].append(.backspace)

                eventRows[1].insert(.none, at: 0)
                eventRows[1].insert(.transform(.alphabetic(uppercased ? .uppercased : .lowercased)), at: 0)
                eventRows[1].append(.newLine)

                eventRows[2].insert(.none, at: 0)
                eventRows[2].insert(.none, at: 0)
                eventRows[2].insert(.shift, at: 0)
                let comma: KeyboardEvent = {
                        let primary: KeyElement = KeyElement("，")
                        let child: KeyElement = KeyElement("！")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child])
                        return KeyboardEvent.input(seat)
                }()
                let period: KeyboardEvent = {
                        let primary: KeyElement = KeyElement("。")
                        let child: KeyElement = KeyElement("？")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child])
                        return KeyboardEvent.input(seat)
                }()
                let exclamationMark: KeyboardEvent = .input(KeySeat(primary: KeyElement("！")))
                let questionMark: KeyboardEvent = .input(KeySeat(primary: KeyElement("？")))
                if uppercased {
                        eventRows[2].append(exclamationMark)
                        eventRows[2].append(questionMark)
                } else {
                        eventRows[2].append(comma)
                        eventRows[2].append(period)
                }
                eventRows[2].append(.shift)

                let bottomEvents: [KeyboardEvent] = {
                        let numeric: KeyboardEvent = .transform(.cantoneseNumeric)
                        let switchKey: KeyboardEvent = needsInputModeSwitchKey ? .globe : numeric
                        return [switchKey, numeric, .space, numeric, .dismiss]
                }()
                eventRows.append(bottomEvents)
                return eventRows
        }
        private func smallPadCantoneseKeys(keyboardInterface: KeyboardInterface, needsInputModeSwitchKey: Bool, uppercased: Bool) -> [[KeyboardEvent]] {

                var eventRows: [[KeyboardEvent]] = letters(uppercased: uppercased)

                eventRows[0].append(.backspace)
                let letterA: String = uppercased ? "A" : "a"
                eventRows[1].insert(.hidden(.text(letterA)), at: 0)
                eventRows[1].insert(.hidden(.text(letterA)), at: 0)
                eventRows[1].append(.newLine)

                eventRows[2].insert(.shift, at: 0)
                let comma: KeyboardEvent = {
                        let primary: KeyElement = KeyElement("，")
                        let child: KeyElement = KeyElement("！")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child])
                        return KeyboardEvent.input(seat)
                }()
                let period: KeyboardEvent = {
                        let primary: KeyElement = KeyElement("。")
                        let child: KeyElement = KeyElement("？")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child])
                        return KeyboardEvent.input(seat)
                }()
                let exclamationMark: KeyboardEvent = .input(KeySeat(primary: KeyElement("！")))
                let questionMark: KeyboardEvent = .input(KeySeat(primary: KeyElement("？")))
                if uppercased {
                        eventRows[2].append(exclamationMark)
                        eventRows[2].append(questionMark)
                } else {
                        eventRows[2].append(comma)
                        eventRows[2].append(period)
                }
                eventRows[2].append(.shift)

                let bottomEvents: [KeyboardEvent] = {
                        let numeric: KeyboardEvent = .transform(.cantoneseNumeric)
                        let switchKey: KeyboardEvent = needsInputModeSwitchKey ? .globe : numeric
                        return [switchKey, numeric, .space, numeric, .dismiss]
                }()
                eventRows.append(bottomEvents)
                return eventRows
        }
        private func compactCantoneseKeys(keyboardInterface: KeyboardInterface, needsInputModeSwitchKey: Bool, uppercased: Bool) -> [[KeyboardEvent]] {
                var eventRows: [[KeyboardEvent]] = letters(uppercased: uppercased)
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
                        let isPadFloating: Bool = keyboardInterface == .padFloating
                        switch (needsInputModeSwitchKey, isPadFloating) {
                        case (true, true):
                                return [.globe, .transform(.cantoneseNumeric), .space, .input(.cantoneseComma), .newLine]
                        case (true, false):
                                return [.transform(.cantoneseNumeric), .globe, .space, .input(.cantoneseComma), .newLine]
                        case (false, true):
                                return [.transform(.cantoneseNumeric), .input(.cantoneseComma), .space, .input(.cantonesePeriod), .newLine]
                        case (false, false):
                                return [.transform(.cantoneseNumeric), .input(.cantoneseComma), .space, .input(.cantonesePeriod), .newLine]
                        }
                }()
                eventRows.append(bottomEvents)
                return eventRows
        }
}
