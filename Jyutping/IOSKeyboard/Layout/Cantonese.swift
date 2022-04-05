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
                let head: [String] = {
                        if uppercased {
                                return ["～", "！", "@", "#", "$", "%", "⋯⋯", "&", "*", "（", "）", "——", "+"]
                        } else {
                                return ["·", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "="]
                        }
                }()
                let headRow: [KeyboardEvent] = head.map({ KeyboardEvent.input(KeySeat(primary: KeyElement($0))) })

                var eventRows: [[KeyboardEvent]] = letters(uppercased: uppercased)
                eventRows.insert(headRow, at: 0)
                eventRows[0].append(.backspace)

                eventRows[1].insert(.tab, at: 0)
                let openQuoteText: String = uppercased ? "『" : "「"
                let closeQuoteText: String = uppercased ? "』" : "」"
                let ideographicCommaText: String = uppercased ? "｜" : "、"
                let openQuote: KeyboardEvent = .input(KeySeat(primary: KeyElement(openQuoteText)))
                let closeQuote: KeyboardEvent = .input(KeySeat(primary: KeyElement(closeQuoteText)))
                let ideographicComma: KeyboardEvent = .input(KeySeat(primary: KeyElement(ideographicCommaText)))
                eventRows[1].append(openQuote)
                eventRows[1].append(closeQuote)
                eventRows[1].append(ideographicComma)

                eventRows[2].insert(.none, at: 0)
                eventRows[2].insert(.transform(.alphabetic(uppercased ? .uppercased : .lowercased)), at: 0)
                let semicolonText: String = uppercased ? "：" : "；"
                let singleQuoteText: String = uppercased ? "\"" : "'"
                let semicolon: KeyboardEvent = .input(KeySeat(primary: KeyElement(semicolonText)))
                let singleQuote: KeyboardEvent = .input(KeySeat(primary: KeyElement(singleQuoteText)))
                eventRows[2].append(semicolon)
                eventRows[2].append(singleQuote)
                eventRows[2].append(.newLine)

                eventRows[3].insert(.shift, at: 0)
                let commaText: String = uppercased ? "《" : "，"
                let periodText: String = uppercased ? "》" : "。"
                let slashText: String = uppercased ? "？" : "/"
                let comma: KeyboardEvent = .input(KeySeat(primary: KeyElement(commaText)))
                let period: KeyboardEvent = .input(KeySeat(primary: KeyElement(periodText)))
                let slash: KeyboardEvent = .input(KeySeat(primary: KeyElement(slashText)))
                eventRows[3].append(comma)
                eventRows[3].append(period)
                eventRows[3].append(slash)
                eventRows[3].append(.shift)

                let bottomEvents: [KeyboardEvent] = {
                        let leftBottom: KeyboardEvent = needsInputModeSwitchKey ? .globe : .transform(.cantoneseSymbolic)
                        return [leftBottom, .transform(.cantoneseNumeric), .space, .transform(.cantoneseNumeric), .dismiss]
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
                let comma: KeyboardEvent = .input(KeySeat(primary: KeyElement("，")))
                let period: KeyboardEvent = .input(KeySeat(primary: KeyElement("。")))
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
                        let leftBottom: KeyboardEvent = needsInputModeSwitchKey ? .globe : .transform(.cantoneseSymbolic)
                        return [leftBottom, .transform(.cantoneseNumeric), .space, .transform(.cantoneseNumeric), .dismiss]
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
                let comma: KeyboardEvent = .input(KeySeat(primary: KeyElement("，")))
                let period: KeyboardEvent = .input(KeySeat(primary: KeyElement("。")))
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
                        let leftBottom: KeyboardEvent = needsInputModeSwitchKey ? .globe : .transform(.cantoneseSymbolic)
                        return [leftBottom, .transform(.cantoneseNumeric), .space, .transform(.cantoneseNumeric), .dismiss]
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
                let comma: KeyboardEvent = .input(.cantoneseComma)
                let bottomEvents: [KeyboardEvent] = {
                        guard needsInputModeSwitchKey else {
                                return [.transform(.cantoneseNumeric), .transform(.emoji), .space, comma, .newLine]
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
