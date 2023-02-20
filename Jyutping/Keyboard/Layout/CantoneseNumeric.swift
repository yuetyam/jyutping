extension KeyboardIdiom {

        func digitalKeys() -> [KeyboardEvent] {
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
                                let child_5 = KeyElement("〇")
                                let child_6 = KeyElement("拾")
                                let child_7 = KeyElement("°", footer: "00B0")
                                let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1, child_2, child_3, child_4, child_5, child_6, child_7])
                                return KeyboardEvent.input(seat)
                        } else {
                                let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1, child_2, child_3, child_4])
                                return KeyboardEvent.input(seat)
                        }
                }
                return keys
        }

        func cantoneseNumericKeys(keyboardInterface: KeyboardInterface, needsInputModeSwitchKey: Bool) -> [[KeyboardEvent]] {
                switch keyboardInterface {
                case .phonePortrait, .phoneLandscape, .padFloating:
                        return compactCantoneseNumericKeys(keyboardInterface: keyboardInterface, needsInputModeSwitchKey: needsInputModeSwitchKey)
                case .padPortraitSmall, .padLandscapeSmall, .padPortraitMedium, .padLandscapeMedium:
                        return smallMediumPadCantoneseNumericKeys(keyboardInterface: keyboardInterface, needsInputModeSwitchKey: needsInputModeSwitchKey)
                case .padPortraitLarge, .padLandscapeLarge:
                        return largePadCantoneseNumericKeys(keyboardInterface: keyboardInterface, needsInputModeSwitchKey: needsInputModeSwitchKey)
                }
        }

        private func largePadCantoneseNumericKeys(keyboardInterface: KeyboardInterface, needsInputModeSwitchKey: Bool) -> [[KeyboardEvent]] {
                let leftTop: KeyboardEvent = {
                        let primary = KeyElement(".")
                        let child_0 = KeyElement(".", footer: "002E")
                        let child_1 = KeyElement("．", footer: "FF0E")
                        let child_2 = KeyElement("…")
                        let seat = KeySeat(primary: primary, children: [child_0, child_1, child_2])
                        return KeyboardEvent.input(seat)
                }()
                let firstRow: [KeyboardEvent] = [leftTop] + digitalKeys() + [.input(KeySeat(primary: KeyElement("<"))), .input(KeySeat(primary: KeyElement(">"))), .backspace]

                let second_0: KeyboardEvent = {
                        let primary = KeyElement("［")
                        let child_0 = KeyElement("〔")
                        let child_1 = KeyElement("[", header: "半形")
                        let child_2 = KeyElement("【")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1, child_2])
                        return KeyboardEvent.input(seat)
                }()
                let second_1: KeyboardEvent = {
                        let primary = KeyElement("］")
                        let child_0 = KeyElement("〕")
                        let child_1 = KeyElement("]", header: "半形")
                        let child_2 = KeyElement("】")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1, child_2])
                        return KeyboardEvent.input(seat)
                }()
                let second_2: KeyboardEvent = {
                        let primary = KeyElement("｛")
                        let child_0 = KeyElement("{", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let second_3: KeyboardEvent = {
                        let primary = KeyElement("｝")
                        let child_0 = KeyElement("}", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let second_4: KeyboardEvent = {
                        let primary = KeyElement("#")
                        let child_0 = KeyElement("＃", header: "全形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let second_5: KeyboardEvent = {
                        let primary = KeyElement("%")
                        let child_0 = KeyElement("％", header: "全形")
                        let child_1 = KeyElement("‰")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                let second_6: KeyboardEvent = {
                        let primary = KeyElement("^")
                        let child_0 = KeyElement("＾", header: "全形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let second_7: KeyboardEvent = {
                        let primary = KeyElement("*")
                        let child_0 = KeyElement("＊", header: "全形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let second_8: KeyboardEvent = {
                        let primary = KeyElement("+")
                        let child_0 = KeyElement("＋", header: "全形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let second_9: KeyboardEvent = {
                        let primary = KeyElement("=")
                        let child_0 = KeyElement("＝", header: "全形")
                        let child_1 = KeyElement("≈")
                        let child_2 = KeyElement("≠")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1, child_2])
                        return KeyboardEvent.input(seat)
                }()
                let second_10: KeyboardEvent = {
                        let primary = KeyElement("\\")
                        let child_0 = KeyElement("＼", header: "全形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let second_11: KeyboardEvent = {
                        let primary = KeyElement("|")
                        let child_0 = KeyElement("｜", header: "全形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let second_12: KeyboardEvent = {
                        let primary = KeyElement("_")
                        let child_0 = KeyElement("_", footer: "005F")
                        let child_1 = KeyElement("＿", header: "全形", footer: "FF3F")
                        let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()

                let third_0: KeyboardEvent = {
                        let primary = KeyElement("-")
                        let child_0 = KeyElement("-", footer: "002D")
                        let child_1 = KeyElement("–", footer: "2013")
                        let child_2 = KeyElement("—", footer: "2014")
                        let child_3 = KeyElement("－", header: "全形", footer: "FF0D")
                        let child_4 = KeyElement("•", footer: "2022")
                        let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1, child_2, child_3, child_4])
                        return KeyboardEvent.input(seat)
                }()
                let third_1: KeyboardEvent = {
                        let primary = KeyElement("/")
                        let child_0 = KeyElement("／", header: "全形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let third_2: KeyboardEvent = {
                        let primary = KeyElement("：")
                        let child_0 = KeyElement(":", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let third_3: KeyboardEvent = {
                        let primary = KeyElement("；")
                        let child_0 = KeyElement(";", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let third_4: KeyboardEvent = {
                        let primary = KeyElement("（")
                        let child_0 = KeyElement("(", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let third_5: KeyboardEvent = {
                        let primary = KeyElement("）")
                        let child_0 = KeyElement(")", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let third_6: KeyboardEvent = {
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
                let third_7: KeyboardEvent = {
                        let primary = KeyElement("&")
                        let child_0 = KeyElement("＆", header: "全形")
                        let child_1 = KeyElement("§")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                let third_8: KeyboardEvent = {
                        let primary = KeyElement("@")
                        let child_0 = KeyElement("＠", header: "全形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let third_9: KeyboardEvent = {
                        let primary = KeyElement("'") // U+0027
                        let child_0 = KeyElement("\u{0027}", footer: "0027")
                        let child_1 = KeyElement("\u{2018}", footer: "2018")
                        let child_2 = KeyElement("\u{2019}", footer: "2019")
                        let child_3 = KeyElement("\u{0060}", footer: "0060")
                        let child_4 = KeyElement("\u{FF07}", footer: "FF07")
                        let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1, child_2, child_3, child_4])
                        return KeyboardEvent.input(seat)
                }()
                let third_10: KeyboardEvent = {
                        let primary = KeyElement("¥")
                        let seat: KeySeat = KeySeat(primary: primary)
                        return KeyboardEvent.input(seat)
                }()

                let fourth_0: KeyboardEvent = {
                        let primary = KeyElement("^_^")
                        let seat: KeySeat = KeySeat(primary: primary)
                        return KeyboardEvent.input(seat)
                }()
                let fourth_1: KeyboardEvent = {
                        let primary = KeyElement("…")
                        let child_0 = KeyElement("…", footer: "2026")
                        let child_1 = KeyElement("……", footer: "2026*2")
                        let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                let fourth_2: KeyboardEvent = {
                        let primary = KeyElement("。")
                        let child_0 = KeyElement("…", footer: "2026")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let fourth_3: KeyboardEvent = {
                        let primary = KeyElement("，")
                        let child_0 = KeyElement(",", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let fourth_4: KeyboardEvent = {
                        let primary = KeyElement("、")
                        let seat: KeySeat = KeySeat(primary: primary)
                        return KeyboardEvent.input(seat)
                }()
                let fourth_5: KeyboardEvent = {
                        let primary = KeyElement("？")
                        let child_0 = KeyElement("?", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let fourth_6: KeyboardEvent = {
                        let primary = KeyElement("！")
                        let child_0 = KeyElement("!", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let fourth_7: KeyboardEvent = {
                        let primary = KeyElement("～")
                        let child_0 = KeyElement("~", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let fourth_8: KeyboardEvent = {
                        let primary = KeyElement("\u{201C}")
                        let child_0 = KeyElement("\u{201C}", footer: "201C")
                        let child_1 = KeyElement("\u{0022}", footer: "0022")
                        let child_2 = KeyElement("\u{FF02}", footer: "FF02")
                        let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1, child_2])
                        return KeyboardEvent.input(seat)
                }()
                let fourth_9: KeyboardEvent = {
                        let primary = KeyElement("\u{201D}")
                        let child_0 = KeyElement("\u{201D}", footer: "201D")
                        let child_1 = KeyElement("\u{0022}", footer: "0022")
                        let child_2 = KeyElement("\u{FF02}", footer: "FF02")
                        let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1, child_2])
                        return KeyboardEvent.input(seat)
                }()
                let fourth_10: KeyboardEvent = {
                        let primary = KeyElement("「")
                        let child_0 = KeyElement("『")
                        let child_1 = KeyElement("\u{FE41}")
                        let child_2 = KeyElement("\u{FE43}")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1, child_2])
                        return KeyboardEvent.input(seat)
                }()
                let fourth_11: KeyboardEvent = {
                        let primary = KeyElement("」")
                        let child_0 = KeyElement("』")
                        let child_1 = KeyElement("\u{FE42}")
                        let child_2 = KeyElement("\u{FE44}")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1, child_2])
                        return KeyboardEvent.input(seat)
                }()

                let back = KeyboardEvent.transform(.cantonese(.lowercased))
                let bottomRow: [KeyboardEvent] = {
                        let switchKey: KeyboardEvent = needsInputModeSwitchKey ? .globe : .transform(.emoji)
                        return [switchKey, back, .space, back, .dismiss]
                }()

                let eventRows: [[KeyboardEvent]] = [
                        firstRow,
                        [.tab, second_0, second_1, second_2, second_3, second_4, second_5, second_6, second_7, second_8, second_9, second_10, second_11, second_12],
                        [back, .none, third_0, third_1, third_2, third_3, third_4, third_5, third_6, third_7, third_8, third_9, third_10, .newLine],
                        [.shift, fourth_0, fourth_1, fourth_2, fourth_3, fourth_4, fourth_5, fourth_6, fourth_7, fourth_8, fourth_9, fourth_10, fourth_11],
                        bottomRow
                ]
                return eventRows
        }

        private func smallMediumPadCantoneseNumericKeys(keyboardInterface: KeyboardInterface, needsInputModeSwitchKey: Bool) -> [[KeyboardEvent]] {
                let second_0: KeyboardEvent = {
                        let primary = KeyElement("@")
                        let child_0 = KeyElement("＠", header: "全形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let second_1: KeyboardEvent = {
                        let primary = KeyElement("#")
                        let child_0 = KeyElement("＃", header: "全形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let second_2: KeyboardEvent = {
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
                let second_3: KeyboardEvent = {
                        let primary = KeyElement("/")
                        let child_0 = KeyElement("／", header: "全形")
                        let child_1 = KeyElement("\\")
                        let child_2 = KeyElement("＼", header: "全形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1, child_2])
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
                let second_7: KeyboardEvent = {
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
                let second_8: KeyboardEvent = {
                        let primary = KeyElement("'") // U+0027
                        let child_0 = KeyElement("\u{0027}", footer: "0027")
                        let child_1 = KeyElement("\u{2018}", footer: "2018")
                        let child_2 = KeyElement("\u{2019}", footer: "2019")
                        let child_3 = KeyElement("\u{0060}", footer: "0060")
                        let child_4 = KeyElement("\u{FF07}", footer: "FF07")
                        let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1, child_2, child_3, child_4])
                        return KeyboardEvent.input(seat)
                }()

                let third_0: KeyboardEvent = {
                        let primary = KeyElement("%")
                        let child_0 = KeyElement("％", header: "全形")
                        let child_1 = KeyElement("‰")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                let third_1: KeyboardEvent = {
                        let primary = KeyElement("-")
                        let child_0 = KeyElement("-", footer: "002D")
                        let child_1 = KeyElement("－", header: "全形", footer: "FF0D")
                        let child_2 = KeyElement("—", footer: "2014")
                        let child_3 = KeyElement("–", footer: "2013")
                        let child_4 = KeyElement("•", footer: "2022")
                        let seat: KeySeat = KeySeat(primary: primary, children: [child_0, child_1, child_2, child_3, child_4])
                        return KeyboardEvent.input(seat)
                }()
                let third_2: KeyboardEvent = {
                        let primary = KeyElement("～")
                        let child_0 = KeyElement("~", header: "半形")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let third_3: KeyboardEvent = {
                        let primary = KeyElement("…")
                        let child_0 = KeyElement("……")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let third_4: KeyboardEvent = {
                        let primary = KeyElement("、")
                        let child_0 = KeyElement("·", footer: "00B7")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let third_5: KeyboardEvent = {
                        let primary = KeyElement("；")
                        let child_0 = KeyElement(";", header: "英")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let third_6: KeyboardEvent = {
                        let primary = KeyElement("：")
                        let child_0 = KeyElement(":", header: "英")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0])
                        return KeyboardEvent.input(seat)
                }()
                let third_7: KeyboardEvent = {
                        let primary = KeyElement("，")
                        let child_0 = KeyElement(",", header: "英")
                        let child_1 = KeyElement("！")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()
                let third_8: KeyboardEvent = {
                        let primary = KeyElement("。")
                        let child_0 = KeyElement(".", header: "英")
                        let child_1 = KeyElement("？")
                        let seat: KeySeat = KeySeat(primary: primary, children: [primary, child_0, child_1])
                        return KeyboardEvent.input(seat)
                }()

                let bottomEvents: [KeyboardEvent] = {
                        let switchKey: KeyboardEvent = needsInputModeSwitchKey ? .globe : .transform(.emoji)
                        return [switchKey, .transform(.cantonese(.lowercased)), .space, .transform(.cantonese(.lowercased)), .dismiss]
                }()

                switch keyboardInterface {
                case .padPortraitSmall, .padLandscapeSmall:
                        var eventRows: [[KeyboardEvent]] = [
                                digitalKeys(),
                                [.none, .none, second_0, second_1, second_2, second_3, second_4, second_5, second_6, second_7, second_8, .newLine],
                                [.transform(.cantoneseSymbolic), third_0, third_1, third_2, third_3, third_4, third_5, third_6, third_7, third_8, .transform(.cantoneseSymbolic)],
                                bottomEvents
                        ]
                        eventRows[0].append(.backspace)
                        return eventRows
                default:
                        var eventRows: [[KeyboardEvent]] = [
                                digitalKeys(),
                                [.transform(.cantoneseSymbolic), .none, second_0, second_1, second_2, second_3, second_4, second_5, second_6, second_7, second_8, .newLine],
                                [.transform(.cantoneseSymbolic), .none, .none, .none, third_0, third_1, third_2, third_3, third_4, third_5, third_6, third_7, third_8, .none,  .transform(.cantoneseSymbolic)],
                                bottomEvents
                        ]
                        eventRows[0].insert(.tab, at: 0)
                        eventRows[0].append(.backspace)
                        return eventRows
                }
        }

        private func compactCantoneseNumericKeys(keyboardInterface: KeyboardInterface, needsInputModeSwitchKey: Bool) -> [[KeyboardEvent]] {
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
                        let child_0 = KeyElement("…", footer: "2026")
                        let child_1 = KeyElement("……", footer: "2026*2")
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
                        digitalKeys(),
                        [second_0, second_1, second_2, second_3, second_4, second_5, second_6, second_7, second_8, second_9],
                        [.transform(.cantoneseSymbolic), .none, third_0, third_1, third_2, third_3, third_4, third_5, .none, .backspace],
                        bottomEvents
                ]
                return eventRows
        }
}
