extension KeyboardIdiom {

        func alphabeticKeys(keyboardInterface: KeyboardInterface, needsInputModeSwitchKey: Bool, uppercased: Bool) -> [[KeyboardEvent]] {
                switch keyboardInterface {
                case .phonePortrait, .phoneLandscape, .padFloating:
                        return compactAlphabeticKeys(keyboardInterface: keyboardInterface, needsInputModeSwitchKey: needsInputModeSwitchKey, uppercased: uppercased)
                case .padPortraitSmall, .padLandscapeSmall:
                        return smallPadAlphabeticKeys(keyboardInterface: keyboardInterface, needsInputModeSwitchKey: needsInputModeSwitchKey, uppercased: uppercased)
                case .padPortraitMedium, .padLandscapeMedium:
                        return mediumPadAlphabeticKeys(keyboardInterface: keyboardInterface, needsInputModeSwitchKey: needsInputModeSwitchKey, uppercased: uppercased)
                case .padPortraitLarge, .padLandscapeLarge:
                        return largePadAlphabeticKeys(keyboardInterface: keyboardInterface, needsInputModeSwitchKey: needsInputModeSwitchKey, uppercased: uppercased)
                }
        }

        private func largePadAlphabeticKeys(keyboardInterface: KeyboardInterface, needsInputModeSwitchKey: Bool, uppercased: Bool = false) -> [[KeyboardEvent]] {
                let head: [String] = {
                        if uppercased {
                                return ["~", "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "_", "+"]
                        } else {
                                return ["`", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "-", "="]
                        }
                }()
                let headRow: [KeyboardEvent] = head.map({ KeyboardEvent.input(KeySeat(primary: KeyElement($0))) })

                var eventRows: [[KeyboardEvent]] = letters(uppercased: uppercased)
                eventRows.insert(headRow, at: 0)
                eventRows[0].append(.backspace)

                eventRows[1].insert(.tab, at: 0)
                let openQuoteText: String = uppercased ? "{" : "["
                let closeQuoteText: String = uppercased ? "}" : "]"
                let ideographicCommaText: String = uppercased ? "|" : "\\"
                let openQuote: KeyboardEvent = .input(KeySeat(primary: KeyElement(openQuoteText)))
                let closeQuote: KeyboardEvent = .input(KeySeat(primary: KeyElement(closeQuoteText)))
                let ideographicComma: KeyboardEvent = .input(KeySeat(primary: KeyElement(ideographicCommaText)))
                eventRows[1].append(openQuote)
                eventRows[1].append(closeQuote)
                eventRows[1].append(ideographicComma)

                eventRows[2].insert(.none, at: 0)
                let cantonese: KeyboardEvent = .transform(.cantonese(uppercased ? .uppercased : .lowercased))
                eventRows[2].insert(cantonese, at: 0)
                let semicolonText: String = uppercased ? ":" : ";"
                let singleQuoteText: String = uppercased ? "\"" : "'"
                let semicolon: KeyboardEvent = .input(KeySeat(primary: KeyElement(semicolonText)))
                let singleQuote: KeyboardEvent = .input(KeySeat(primary: KeyElement(singleQuoteText)))
                eventRows[2].append(semicolon)
                eventRows[2].append(singleQuote)
                eventRows[2].append(.newLine)

                eventRows[3].insert(.shift, at: 0)
                let commaText: String = uppercased ? "<" : ","
                let periodText: String = uppercased ? ">" : "."
                let slashText: String = uppercased ? "?" : "/"
                let comma: KeyboardEvent = .input(KeySeat(primary: KeyElement(commaText)))
                let period: KeyboardEvent = .input(KeySeat(primary: KeyElement(periodText)))
                let slash: KeyboardEvent = .input(KeySeat(primary: KeyElement(slashText)))
                eventRows[3].append(comma)
                eventRows[3].append(period)
                eventRows[3].append(slash)
                eventRows[3].append(.shift)

                let bottomEvents: [KeyboardEvent] = {
                        let switchKey: KeyboardEvent = needsInputModeSwitchKey ? .globe : .transform(.emoji)
                        return [switchKey, .transform(.numeric), .space, .transform(.numeric), .dismiss]
                }()
                eventRows.append(bottomEvents)
                return eventRows
        }

        private func mediumPadAlphabeticKeys(keyboardInterface: KeyboardInterface, needsInputModeSwitchKey: Bool, uppercased: Bool) -> [[KeyboardEvent]] {
                var eventRows: [[KeyboardEvent]] = letters(uppercased: uppercased)

                eventRows[0].insert(.tab, at: 0)
                eventRows[0].append(.backspace)

                eventRows[1].insert(.none, at: 0)
                let cantonese: KeyboardEvent = .transform(.cantonese(uppercased ? .uppercased : .lowercased))
                eventRows[1].insert(cantonese, at: 0)
                eventRows[1].append(.newLine)

                eventRows[2].insert(.none, at: 0)
                eventRows[2].insert(.none, at: 0)
                eventRows[2].insert(.shift, at: 0)
                let comma: KeyboardEvent = .input(KeySeat(primary: KeyElement(",")))
                let period: KeyboardEvent = .input(KeySeat(primary: KeyElement(".")))
                let exclamationMark: KeyboardEvent = .input(KeySeat(primary: KeyElement("!")))
                let questionMark: KeyboardEvent = .input(KeySeat(primary: KeyElement("?")))
                if uppercased {
                        eventRows[2].append(exclamationMark)
                        eventRows[2].append(questionMark)
                } else {
                        eventRows[2].append(comma)
                        eventRows[2].append(period)
                }
                eventRows[2].append(.shift)

                let bottomEvents: [KeyboardEvent] = {
                        let switchKey: KeyboardEvent = needsInputModeSwitchKey ? .globe : .transform(.emoji)
                        return [switchKey, .transform(.numeric), .space, .transform(.numeric), .dismiss]
                }()
                eventRows.append(bottomEvents)
                return eventRows
        }

        private func smallPadAlphabeticKeys(keyboardInterface: KeyboardInterface, needsInputModeSwitchKey: Bool, uppercased: Bool) -> [[KeyboardEvent]] {
                var eventRows: [[KeyboardEvent]] = letters(uppercased: uppercased)
                eventRows[0].append(.backspace)

                let letterA: String = uppercased ? "A" : "a"
                eventRows[1].insert(.hidden(.text(letterA)), at: 0)
                eventRows[1].insert(.hidden(.text(letterA)), at: 0)
                eventRows[1].append(.newLine)

                eventRows[2].insert(.shift, at: 0)
                let comma: KeyboardEvent = .input(KeySeat(primary: KeyElement(",")))
                let period: KeyboardEvent = .input(KeySeat(primary: KeyElement(".")))
                let exclamationMark: KeyboardEvent = .input(KeySeat(primary: KeyElement("!")))
                let questionMark: KeyboardEvent = .input(KeySeat(primary: KeyElement("?")))
                if uppercased {
                        eventRows[2].append(exclamationMark)
                        eventRows[2].append(questionMark)
                } else {
                        eventRows[2].append(comma)
                        eventRows[2].append(period)
                }
                eventRows[2].append(.shift)

                let bottomEvents: [KeyboardEvent] = {
                        let switchKey: KeyboardEvent = needsInputModeSwitchKey ? .globe : .transform(.emoji)
                        return [switchKey, .transform(.numeric), .space, .transform(.numeric), .dismiss]
                }()
                eventRows.append(bottomEvents)
                return eventRows
        }

        private func compactAlphabeticKeys(keyboardInterface: KeyboardInterface, needsInputModeSwitchKey: Bool, uppercased: Bool) -> [[KeyboardEvent]] {
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
                        let switchKey: KeyboardEvent = needsInputModeSwitchKey ? .globe : .transform(.emoji)
                        let period: KeyboardEvent = KeyboardEvent.input(.period)
                        switch keyboardInterface {
                        case .padFloating:
                                return [switchKey, .transform(.numeric), .space, period, .newLine]
                        default:
                                return [.transform(.numeric), switchKey, .space, period, .newLine]
                        }
                }()
                eventRows.append(bottomEvents)
                return eventRows
        }
}
