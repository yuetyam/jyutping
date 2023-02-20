extension KeyboardIdiom {

        func cantoneseSymbolicKeys(keyboardInterface: KeyboardInterface, needsInputModeSwitchKey: Bool) -> [[KeyboardEvent]] {
                if keyboardInterface.isCompact {
                        return compactCantoneseSymbolicKeys(keyboardInterface: keyboardInterface, needsInputModeSwitchKey: needsInputModeSwitchKey)
                } else {
                        return padCantoneseSymbolicKeys(keyboardInterface: keyboardInterface, needsInputModeSwitchKey: needsInputModeSwitchKey)
                }
        }

        private func padCantoneseSymbolicKeys(keyboardInterface: KeyboardInterface, needsInputModeSwitchKey: Bool) -> [[KeyboardEvent]] {
                let first_0: KeyboardEvent = {
                        let primary = KeyElement("^")
                        let child_0 = KeyElement("＾", header: "全形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let first_1: KeyboardEvent = {
                        let primary = KeyElement("_")
                        let child_0 = KeyElement("＿", header: "全形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let first_2: KeyboardEvent = {
                        let primary = KeyElement("｜")
                        let child_0 = KeyElement("|", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let first_3: KeyboardEvent = {
                        let primary = KeyElement("\\")
                        let child_0 = KeyElement("＼", header: "全形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let first_4: KeyboardEvent = {
                        let primary = KeyElement("<")
                        let seat: KeySeat = KeySeat(primary: primary)
                        return KeyboardEvent.input(seat)
                }()
                let first_5: KeyboardEvent = {
                        let primary = KeyElement(">")
                        let seat: KeySeat = KeySeat(primary: primary)
                        return KeyboardEvent.input(seat)
                }()
                let first_6: KeyboardEvent = {
                        let primary = KeyElement("{")
                        let seat: KeySeat = KeySeat(primary: primary)
                        return KeyboardEvent.input(seat)
                }()
                let first_7: KeyboardEvent = {
                        let primary = KeyElement("}")
                        let seat: KeySeat = KeySeat(primary: primary)
                        return KeyboardEvent.input(seat)
                }()
                let first_8: KeyboardEvent = {
                        let primary = KeyElement(",")
                        let child_0 = KeyElement("，", header: "全形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let first_9: KeyboardEvent = {
                        let primary = KeyElement(".")
                        let child_0 = KeyElement(".", header: "英", footer: "002E")
                        let child_1 = KeyElement("．", header: "全形", footer: "FF0E")
                        let child_2 = KeyElement("…")
                        let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1, child_2])
                        return KeyboardEvent.input(seat)
                }()

                let second_0: KeyboardEvent = {
                        let primary = KeyElement("&")
                        let child_0 = KeyElement("＆", header: "全形")
                        let child_1 = KeyElement("§")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                let second_1: KeyboardEvent = {
                        let primary = KeyElement("€")
                        let seat: KeySeat = KeySeat(primary: primary)
                        return KeyboardEvent.input(seat)
                }()
                let second_2: KeyboardEvent = {
                        let primary = KeyElement("£")
                        let seat: KeySeat = KeySeat(primary: primary)
                        return KeyboardEvent.input(seat)
                }()
                let second_3: KeyboardEvent = {
                        let primary = KeyElement("*")
                        let child_0 = KeyElement("＊", header: "全形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let second_4: KeyboardEvent = {
                        let primary = KeyElement("【")
                        let child_0 = KeyElement("〔")
                        let child_1 = KeyElement("［")
                        let child_2 = KeyElement("[", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1, child_2])
                        return KeyboardEvent.input(seat)
                }()
                let second_5: KeyboardEvent = {
                        let primary = KeyElement("】")
                        let child_0 = KeyElement("〕")
                        let child_1 = KeyElement("］")
                        let child_2 = KeyElement("]", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1, child_2])
                        return KeyboardEvent.input(seat)
                }()
                let second_6: KeyboardEvent = {
                        let primary = KeyElement("『")
                        let seat: KeySeat = KeySeat(primary: primary)
                        return KeyboardEvent.input(seat)
                }()
                let second_7: KeyboardEvent = {
                        let primary = KeyElement("』")
                        let seat: KeySeat = KeySeat(primary: primary)
                        return KeyboardEvent.input(seat)
                }()
                let second_8: KeyboardEvent = {
                        let primary = KeyElement("\u{0022}")
                        let child_0 = KeyElement("\u{0022}", footer: "0022")
                        let child_1 = KeyElement("\u{201C}", footer: "201C")
                        let child_2 = KeyElement("\u{201D}", footer: "201D")
                        let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1, child_2])
                        return KeyboardEvent.input(seat)
                }()

                let third_0: KeyboardEvent = {
                        let primary = KeyElement("¥")
                        let seat: KeySeat = KeySeat(primary: primary)
                        return KeyboardEvent.input(seat)
                }()
                let third_1: KeyboardEvent = {
                        let primary = KeyElement("—")
                        let seat: KeySeat = KeySeat(primary: primary)
                        return KeyboardEvent.input(seat)
                }()
                let third_2: KeyboardEvent = {
                        let primary = KeyElement("+")
                        let child_0 = KeyElement("＋", header: "全形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let third_3: KeyboardEvent = {
                        let primary = KeyElement("=")
                        let child_0 = KeyElement("＝", header: "全形")
                        let child_1 = KeyElement("≈")
                        let child_2 = KeyElement("≠")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1, child_2])
                        return KeyboardEvent.input(seat)
                }()
                let third_4: KeyboardEvent = {
                        let primary = KeyElement("·")
                        let child_0 = KeyElement("·", footer: "00B7")
                        let child_1 = KeyElement("•", footer: "2022")
                        let child_2 = KeyElement("°", footer: "00B0")
                        let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1, child_2])
                        return KeyboardEvent.input(seat)
                }()
                let third_5: KeyboardEvent = {
                        let primary = KeyElement("《")
                        let child_0 = KeyElement("〈")
                        let child_1 = KeyElement("＜")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                let third_6: KeyboardEvent = {
                        let primary = KeyElement("》")
                        let child_0 = KeyElement("〉")
                        let child_1 = KeyElement("＞")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                let third_7: KeyboardEvent = {
                        let primary = KeyElement("！")
                        let child_0 = KeyElement("!", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let third_8: KeyboardEvent = {
                        let primary = KeyElement("？")
                        let child_0 = KeyElement("?", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()

                let bottomEvents: [KeyboardEvent] = {
                        let switchKey: KeyboardEvent = needsInputModeSwitchKey ? .globe : .transform(.emoji)
                        return [switchKey, .transform(.cantonese(.lowercased)), .space, .transform(.cantonese(.lowercased)), .dismiss]
                }()

                switch keyboardInterface {
                case .padPortraitSmall, .padLandscapeSmall:
                        let eventRows: [[KeyboardEvent]] = [
                                [first_0, first_1, first_2, first_3, first_4, first_5, first_6, first_7, first_8, first_9, .backspace],
                                [.none, .none, second_0, second_1, second_2, second_3, second_4, second_5, second_6, second_7, second_8, .newLine],
                                [.transform(.cantoneseNumeric), third_0, third_1, third_2, third_3, third_4, third_5, third_6, third_7, third_8, .transform(.cantoneseNumeric)],
                                bottomEvents
                        ]
                        return eventRows
                default:
                        let eventRows: [[KeyboardEvent]] = [
                                [.tab, first_0, first_1, first_2, first_3, first_4, first_5, first_6, first_7, first_8, first_9, .backspace],
                                [.transform(.cantoneseNumeric), .none, second_0, second_1, second_2, second_3, second_4, second_5, second_6, second_7, second_8, .newLine],
                                [.transform(.cantoneseNumeric), .none, .none, .none, third_0, third_1, third_2, third_3, third_4, third_5, third_6, third_7, third_8, .none,  .transform(.cantoneseNumeric)],
                                bottomEvents
                        ]
                        return eventRows
                }
        }

        private func compactCantoneseSymbolicKeys(keyboardInterface: KeyboardInterface, needsInputModeSwitchKey: Bool) -> [[KeyboardEvent]] {
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
                        let primary = KeyElement("…")
                        let child_0 = KeyElement("…", footer: "2026")
                        let child_1 = KeyElement("……", footer: "2026*2")
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

                let bottomEvents: [KeyboardEvent] = {
                        let switchKey: KeyboardEvent = needsInputModeSwitchKey ? .globe : .transform(.emoji)
                        let comma: KeyboardEvent = KeyboardEvent.input(.cantoneseComma)
                        switch keyboardInterface {
                        case .padFloating:
                                return [switchKey, .transform(.cantonese(.lowercased)), .space, comma, .newLine]
                        default:
                                return [.transform(.cantonese(.lowercased)), switchKey, .space, comma, .newLine]
                        }
                }()
                let eventRows: [[KeyboardEvent]] = [
                        [first_0, first_1, first_2, first_3, first_4, first_5, first_6, first_7, first_8, first_9],
                        [second_0, second_1, second_2, second_3, second_4, second_5, second_6, second_7, second_8, second_9],
                        [.transform(.cantoneseNumeric), .none, third_0, third_1, third_2, third_3, third_4, third_5, .none, .backspace],
                        bottomEvents
                ]
                return eventRows
        }
}
