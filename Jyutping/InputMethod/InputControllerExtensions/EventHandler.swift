import SwiftUI
import InputMethodKit
import CoreIME

extension JyutpingInputController {

        override func recognizedEvents(_ sender: Any!) -> Int {
                let masks: NSEvent.EventTypeMask = [.keyDown]
                return Int(masks.rawValue)
        }

        override func handle(_ event: NSEvent!, client sender: Any!) -> Bool {
                let modifiers = event.modifierFlags
                let shouldIgnoreCurrentEvent: Bool = modifiers.contains(.command) || modifiers.contains(.option)
                guard !shouldIgnoreCurrentEvent else { return false }
                guard let client: IMKTextInput = sender as? IMKTextInput else { return false }
                currentOrigin = client.position
                let currentClientID = currentClient?.uniqueClientIdentifierString()
                let clientID = client.uniqueClientIdentifierString()
                if clientID != currentClientID {
                        currentClient = client
                }
                lazy var hasControlShiftModifiers: Bool = false
                switch modifiers {
                case [.control, .shift], .control:
                        switch event.keyCode {
                        case KeyCode.Symbol.VK_COMMA:
                                // handled by NSMenu
                                return false
                        case KeyCode.Symbol.VK_BACKQUOTE:
                                switch InputState.current {
                                case .cantonese:
                                        passBuffer()
                                        InputState.updateCurrent(to: .switches)
                                        resetWindow()
                                case .transparent:
                                        InputState.updateCurrent(to: .switches)
                                        resetWindow()
                                case .switches:
                                        handleSwitches(-1)
                                }
                                return true
                        case KeyCode.Special.VK_BACKWARD_DELETE, KeyCode.Special.VK_FORWARD_DELETE:
                                switch InputState.current {
                                case .cantonese:
                                        guard !(candidates.isEmpty) else { return false }
                                        let index = displayObject.highlightedIndex
                                        guard let candidate = displayObject.items.fetch(index)?.candidate else { return true }
                                        guard candidate.isCantonese else { return true }
                                        UserLexicon.removeItem(candidate: candidate)
                                        return true
                                case .transparent:
                                        return false
                                case .switches:
                                        return true
                                }
                        case KeyCode.Alphabet.VK_U:
                                guard InputState.current.isCantonese && isBufferState else { return false }
                                clearBufferText()
                                return true
                        case let value where KeyCode.numberSet.contains(value):
                                hasControlShiftModifiers = true
                        default:
                                return false
                        }
                case .capsLock, .function, .help:
                        return false
                default:
                        break
                }
                let isShifting: Bool = modifiers == .shift
                switch event.keyCode.representative {
                case .arrow(let direction):
                        switch direction {
                        case .up:
                                switch InputState.current {
                                case .cantonese:
                                        guard isBufferState else { return false }
                                        if displayObject.isHighlightingStart {
                                                updateDisplayingCandidates(.previousPage, highlight: .end)
                                                return true
                                        } else {
                                                displayObject.decreaseHighlightedIndex()
                                                return true
                                        }
                                case .transparent:
                                        return false
                                case .switches:
                                        switchesObject.decreaseHighlightedIndex()
                                        return true
                                }
                        case .down:
                                switch InputState.current {
                                case .cantonese:
                                        guard isBufferState else { return false }
                                        if displayObject.isHighlightingEnd {
                                                updateDisplayingCandidates(.nextPage, highlight: .start)
                                                return true
                                        } else {
                                                displayObject.increaseHighlightedIndex()
                                                return true
                                        }
                                case .transparent:
                                        return false
                                case .switches:
                                        switchesObject.increaseHighlightedIndex()
                                        return true
                                }
                        case .left:
                                switch InputState.current {
                                case .cantonese:
                                        guard isBufferState else { return false }
                                        updateDisplayingCandidates(.previousPage, highlight: .unchanged)
                                        return true
                                case .transparent:
                                        return false
                                case .switches:
                                        return true
                                }
                        case .right:
                                switch InputState.current {
                                case .cantonese:
                                        guard isBufferState else { return false }
                                        updateDisplayingCandidates(.nextPage, highlight: .unchanged)
                                        return true
                                case .transparent:
                                        return false
                                case .switches:
                                        return true
                                }
                        }
                case .number(let number):
                        let index: Int = number == 0 ? 9 : (number - 1)
                        switch InputState.current {
                        case .cantonese:
                                if isBufferState {
                                        guard let selectedItem = displayObject.items.fetch(index) else { return true }
                                        let text = selectedItem.text
                                        client.insert(text)
                                        aftercareSelection(selectedItem)
                                        return true
                                } else {
                                        if hasControlShiftModifiers {
                                                handleSwitches(index)
                                                return true
                                        } else {
                                                switch InstantSettings.characterForm {
                                                case .halfWidth:
                                                        let shouldInsertCantoneseSymbol: Bool = InstantSettings.punctuation.isCantoneseMode && isShifting
                                                        guard shouldInsertCantoneseSymbol else { return false }
                                                        let text: String = KeyCode.shiftingSymbol(of: number)
                                                        client.insert(text)
                                                        return true
                                                case .fullWidth:
                                                        let text: String = isShifting ? KeyCode.shiftingSymbol(of: number) : "\(number)"
                                                        let fullWidthText: String = text.fullWidth()
                                                        client.insert(fullWidthText)
                                                        return true
                                                }
                                        }
                                }
                        case .transparent:
                                if hasControlShiftModifiers {
                                        handleSwitches(index)
                                        return true
                                } else {
                                        return false
                                }
                        case .switches:
                                handleSwitches(index)
                                return true
                        }
                case .keypadNumber(let number):
                        let isStrokeReverseLookup: Bool = InputState.current.isCantonese && bufferText.hasPrefix("x")
                        guard isStrokeReverseLookup else { return false }
                        bufferText += "\(number)"
                        return true
                case .punctuation(let punctuationKey):
                        switch InputState.current {
                        case .cantonese:
                                guard candidates.isEmpty else {
                                        switch punctuationKey {
                                        case .bracketLeft, .comma, .minus:
                                                updateDisplayingCandidates(.previousPage, highlight: .unchanged)
                                                return true
                                        case .bracketRight, .period, .equal:
                                                updateDisplayingCandidates(.nextPage, highlight: .unchanged)
                                                return true
                                        default:
                                                return true
                                        }
                                }
                                passBuffer()
                                guard InstantSettings.punctuation.isCantoneseMode else { return false }
                                if isShifting {
                                        if let symbol = punctuationKey.instantShiftingSymbol {
                                                client.insert(symbol)
                                        } else {
                                                bufferText = punctuationKey.shiftingKeyText
                                        }
                                } else {
                                        if let symbol = punctuationKey.instantSymbol {
                                                client.insert(symbol)
                                        } else {
                                                bufferText = punctuationKey.keyText
                                        }
                                }
                                return true
                        case .transparent:
                                return false
                        case .switches:
                                return true
                        }
                case .alphabet(let letter):
                        switch InputState.current {
                        case .cantonese:
                                let text: String = isShifting ? letter.uppercased() : letter
                                bufferText += text
                                return true
                        case .transparent:
                                return false
                        case .switches:
                                return true
                        }
                case .separator:
                        switch InputState.current {
                        case .cantonese:
                                guard isBufferState else { return false }
                                bufferText += "'"
                                return true
                        case .transparent:
                                return false
                        case .switches:
                                return true
                        }
                case .return:
                        switch InputState.current {
                        case .cantonese:
                                guard isBufferState else { return false }
                                passBuffer()
                                return true
                        case .transparent:
                                return false
                        case .switches:
                                handleSwitches()
                                return true
                        }
                case .backspace:
                        switch InputState.current {
                        case .cantonese:
                                guard isBufferState else { return false }
                                bufferText = String(bufferText.dropLast())
                                return true
                        case .transparent:
                                return false
                        case .switches:
                                handleSwitches(-1)
                                return true
                        }
                case .escapeClear:
                        switch InputState.current {
                        case .cantonese:
                                guard isBufferState else { return false }
                                clearBufferText()
                                return true
                        case .transparent:
                                return false
                        case .switches:
                                handleSwitches(-1)
                                return true
                        }
                case .space:
                        switch InputState.current {
                        case .cantonese:
                                let shouldSwitchToABCMode: Bool = isShifting && AppSettings.shiftSpaceCombination == .switchInputMethodMode
                                guard !shouldSwitchToABCMode else {
                                        passBuffer()
                                        InstantSettings.updateInputMethodMode(to: .abc)
                                        InputState.updateCurrent(to: .transparent)
                                        return true
                                }
                                if candidates.isEmpty {
                                        passBuffer()
                                        let shouldInsertFullWidthSpace: Bool = isShifting || InstantSettings.characterForm == .fullWidth
                                        let text: String = shouldInsertFullWidthSpace ? "　" : " "
                                        client.insert(text)
                                        return true
                                } else {
                                        let index = displayObject.highlightedIndex
                                        guard let selectedItem = displayObject.items.fetch(index) else { return true }
                                        let text = selectedItem.text
                                        client.insert(text)
                                        aftercareSelection(selectedItem)
                                        return true
                                }
                        case .transparent:
                                let shouldSwitchToCantoneseMode: Bool = isShifting && AppSettings.shiftSpaceCombination == .switchInputMethodMode
                                guard shouldSwitchToCantoneseMode else { return false }
                                InstantSettings.updateInputMethodMode(to: .cantonese)
                                InputState.updateCurrent(to: .cantonese)
                                return true
                        case .switches:
                                handleSwitches()
                                return true
                        }
                case .tab:
                        switch InputState.current {
                        case .cantonese:
                                guard isBufferState else { return false }
                                if displayObject.isHighlightingEnd {
                                        updateDisplayingCandidates(.nextPage, highlight: .start)
                                        return true
                                } else {
                                        displayObject.increaseHighlightedIndex()
                                        return true
                                }
                        case .transparent:
                                return false
                        case .switches:
                                switchesObject.increaseHighlightedIndex()
                                return true
                        }
                case .previousPage:
                        switch InputState.current {
                        case .cantonese:
                                guard isBufferState else { return false }
                                updateDisplayingCandidates(.previousPage, highlight: .unchanged)
                                return true
                        case .transparent:
                                return false
                        case .switches:
                                return true
                        }
                case .nextPage:
                        switch InputState.current {
                        case .cantonese:
                                guard isBufferState else { return false }
                                updateDisplayingCandidates(.nextPage, highlight: .unchanged)
                                return true
                        case .transparent:
                                return false
                        case .switches:
                                return true
                        }
                case .other:
                        switch event.keyCode {
                        case KeyCode.Special.VK_HOME:
                                let shouldJump2FirstPage: Bool = InputState.current.isCantonese && !(candidates.isEmpty)
                                guard shouldJump2FirstPage else { return false }
                                updateDisplayingCandidates(.establish, highlight: .start)
                                return true
                        default:
                                return false
                        }
                }
        }

        private func passBuffer() {
                guard isBufferState else { return }
                let text: String = InstantSettings.characterForm == .halfWidth ? bufferText : bufferText.fullWidth()
                currentClient?.insert(text)
                clearBufferText()
        }

        private func handleSwitches(_ index: Int? = nil) {
                let selectedIndex: Int = index ?? switchesObject.highlightedIndex
                defer {
                        let newInputState: InputState = {
                                switch InstantSettings.inputMethodMode {
                                case .cantonese:
                                        return .cantonese
                                case .abc:
                                        return .transparent
                                }
                        }()
                        InputState.updateCurrent(to: newInputState)
                        resetWindow()
                }
                switch selectedIndex {
                case -1:
                        return
                case 4:
                        InstantSettings.updateCharacterFormState(to: .halfWidth)
                case 5:
                        InstantSettings.updateCharacterFormState(to: .fullWidth)
                case 6:
                        InstantSettings.updatePunctuationState(to: .cantonese)
                case 7:
                        InstantSettings.updatePunctuationState(to: .english)
                case 8:
                        InstantSettings.updateNeedsEmojiCandidates(to: true)
                case 9:
                        InstantSettings.updateNeedsEmojiCandidates(to: false)
                default:
                        break
                }
                let newSelection: Logogram = {
                        switch selectedIndex {
                        case 0:
                                return .traditional
                        case 1:
                                return .hongkong
                        case 2:
                                return .taiwan
                        case 3:
                                return .simplified
                        default:
                                return Logogram.current
                        }
                }()
                guard newSelection != Logogram.current else { return }
                Logogram.updateCurrent(to: newSelection)
        }

        private func aftercareSelection(_ selected: DisplayCandidate) {
                let candidate = candidates.fetch(selected.candidateIndex) ?? candidates.first(where: { $0 == selected.candidate })
                guard let candidate, candidate.isCantonese else {
                        clearBufferText()
                        return
                }
                switch bufferText.first {
                case .none:
                        return
                case .some(let character) where !(character.isBasicLatinLetter):
                        candidateSequence = []
                        clearBufferText()
                case .some(let character) where character.isReverseLookupTrigger:
                        candidateSequence = []
                        let leadingCount: Int = candidate.input.count + 1
                        if bufferText.count > leadingCount {
                                let tail = bufferText.dropFirst(candidate.input.count + 1)
                                bufferText = String(character) + tail
                        } else {
                                clearBufferText()
                        }
                default:
                        candidateSequence.append(candidate)
                        let inputCount: Int = candidate.input.replacingOccurrences(of: "(4|5|6)", with: "RR", options: .regularExpression).count
                        var tail = bufferText.dropFirst(inputCount)
                        while tail.hasPrefix("'") {
                                tail = tail.dropFirst()
                        }
                        bufferText = String(tail)
                }
        }
}
