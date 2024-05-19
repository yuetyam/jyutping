import SwiftUI
import InputMethodKit
import CoreIME
import CommonExtensions

private struct Modifier {
        private(set) static var previousModifiers: NSEvent.ModifierFlags = .init()
        static func updatePreviousModifiers(to modifiers: NSEvent.ModifierFlags) {
                previousModifiers = modifiers
        }

        private(set) static var isBuffering: Bool = false
        static func triggerBuffer() {
                isBuffering = true
        }
        static func resetBuffer() {
                if isBuffering {
                        isBuffering = false
                }
        }
}

extension JyutpingInputController {

        override func recognizedEvents(_ sender: Any!) -> Int {
                let masks: NSEvent.EventTypeMask = [.keyDown, .flagsChanged]
                return Int(masks.rawValue)
        }

        private func shouldSwitchInputMethodMode(with event: NSEvent) -> Bool {
                let currentModifiers: NSEvent.ModifierFlags = event.modifierFlags
                defer {
                        Modifier.updatePreviousModifiers(to: currentModifiers)
                }
                guard AppSettings.pressShiftOnce == .switchInputMethodMode else {
                        Modifier.resetBuffer()
                        return false
                }
                guard (event.keyCode == KeyCode.Modifier.VK_SHIFT_LEFT) || (event.keyCode == KeyCode.Modifier.VK_SHIFT_RIGHT) else {
                        Modifier.resetBuffer()
                        return false
                }
                guard event.type == .flagsChanged else {
                        Modifier.resetBuffer()
                        return false
                }
                let isShiftKeyPressed: Bool = Modifier.previousModifiers.isEmpty && (currentModifiers == .shift)
                let isShiftKeyReleased: Bool = (Modifier.previousModifiers == .shift) && currentModifiers.isEmpty
                if isShiftKeyPressed && !(Modifier.isBuffering) {
                        Modifier.triggerBuffer()
                        return false
                } else if isShiftKeyReleased && Modifier.isBuffering {
                        Modifier.resetBuffer()
                        return true
                } else {
                        Modifier.resetBuffer()
                        return false
                }
        }

        override func handle(_ event: NSEvent!, client sender: Any!) -> Bool {
                guard let event = event else { return false }
                guard !shouldSwitchInputMethodMode(with: event) else {
                        switch appContext.inputForm {
                        case .cantonese:
                                passBuffer()
                                Options.updateInputMethodMode(to: .abc)
                                appContext.updateInputForm(to: .transparent)
                                updateWindowFrame(.zero)
                                return true
                        case .transparent:
                                Options.updateInputMethodMode(to: .cantonese)
                                appContext.updateInputForm(to: .cantonese)
                                return true
                        case .options:
                                return true
                        }
                }
                guard event.type == .keyDown else { return false }
                let modifiers = event.modifierFlags
                let shouldIgnoreCurrentEvent: Bool = modifiers.contains(.command) || modifiers.contains(.option)
                guard !shouldIgnoreCurrentEvent else { return false }
                let client: InputClient? = (sender as? InputClient) ?? currentClient
                currentOrigin = client?.position
                let currentClientID = currentClient?.uniqueClientIdentifierString()
                let clientID = client?.uniqueClientIdentifierString()
                if clientID != currentClientID {
                        currentClient = client
                }
                lazy var hasControlShiftModifiers: Bool = false
                let currentInputForm: InputForm = appContext.inputForm
                switch modifiers {
                case [.control, .shift], .control:
                        switch event.keyCode {
                        case KeyCode.Symbol.VK_COMMA:
                                // handled by NSMenu
                                return false
                        case KeyCode.Symbol.VK_BACKQUOTE:
                                switch currentInputForm {
                                case .cantonese, .transparent:
                                        markOptionsViewHintText()
                                        appContext.updateInputForm(to: .options)
                                        updateWindowFrame()
                                case .options:
                                        handleOptions(-1)
                                }
                                return true
                        case KeyCode.Special.VK_BACKWARD_DELETE, KeyCode.Special.VK_FORWARD_DELETE:
                                switch currentInputForm {
                                case .cantonese:
                                        guard !(candidates.isEmpty) else { return false }
                                        let index = appContext.highlightedIndex
                                        guard let candidate = appContext.displayCandidates.fetch(index)?.candidate else { return true }
                                        guard candidate.isCantonese else { return true }
                                        UserLexicon.removeItem(candidate: candidate)
                                        return true
                                case .transparent:
                                        return false
                                case .options:
                                        return true
                                }
                        case KeyCode.Alphabet.VK_U:
                                guard inputStage.isBuffering && currentInputForm.isCantonese else { return false }
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
                                switch currentInputForm {
                                case .cantonese:
                                        guard inputStage.isBuffering else { return false }
                                        switch AppSettings.candidatePageOrientation {
                                        case .horizontal:
                                                updateDisplayCandidates(.previousPage, highlight: .unchanged)
                                        case .vertical:
                                                if appContext.isHighlightingStart {
                                                        updateDisplayCandidates(.previousPage, highlight: .end)
                                                } else {
                                                        appContext.decreaseHighlightedIndex()
                                                }
                                        }
                                        return true
                                case .transparent:
                                        return false
                                case .options:
                                        appContext.decreaseOptionsHighlightedIndex()
                                        return true
                                }
                        case .down:
                                switch currentInputForm {
                                case .cantonese:
                                        guard inputStage.isBuffering else { return false }
                                        switch AppSettings.candidatePageOrientation {
                                        case .horizontal:
                                                updateDisplayCandidates(.nextPage, highlight: .unchanged)
                                        case .vertical:
                                                if appContext.isHighlightingEnd {
                                                        updateDisplayCandidates(.nextPage, highlight: .start)
                                                } else {
                                                        appContext.increaseHighlightedIndex()
                                                }
                                        }
                                        return true
                                case .transparent:
                                        return false
                                case .options:
                                        appContext.increaseOptionsHighlightedIndex()
                                        return true
                                }
                        case .left:
                                switch currentInputForm {
                                case .cantonese:
                                        guard inputStage.isBuffering else { return false }
                                        switch AppSettings.candidatePageOrientation {
                                        case .horizontal:
                                                if appContext.isHighlightingStart {
                                                        updateDisplayCandidates(.previousPage, highlight: .end)
                                                } else {
                                                        appContext.decreaseHighlightedIndex()
                                                }
                                        case .vertical:
                                                updateDisplayCandidates(.previousPage, highlight: .unchanged)
                                        }
                                        return true
                                case .transparent:
                                        return false
                                case .options:
                                        return true
                                }
                        case .right:
                                switch currentInputForm {
                                case .cantonese:
                                        guard inputStage.isBuffering else { return false }
                                        switch AppSettings.candidatePageOrientation {
                                        case .horizontal:
                                                if appContext.isHighlightingEnd {
                                                        updateDisplayCandidates(.nextPage, highlight: .start)
                                                } else {
                                                        appContext.increaseHighlightedIndex()
                                                }
                                        case .vertical:
                                                updateDisplayCandidates(.nextPage, highlight: .unchanged)
                                        }
                                        return true
                                case .transparent:
                                        return false
                                case .options:
                                        return true
                                }
                        }
                case .number(let number):
                        let index: Int = number == 0 ? 9 : (number - 1)
                        switch currentInputForm {
                        case .cantonese:
                                if inputStage.isBuffering {
                                        guard let selectedItem = appContext.displayCandidates.fetch(index) else { return true }
                                        client?.insert(selectedItem.text)
                                        aftercareSelection(selectedItem)
                                        return true
                                } else {
                                        if hasControlShiftModifiers {
                                                handleOptions(index)
                                                return true
                                        } else {
                                                switch Options.characterForm {
                                                case .halfWidth:
                                                        let shouldInsertCantoneseSymbol: Bool = isShifting && Options.punctuationForm.isCantoneseMode
                                                        guard shouldInsertCantoneseSymbol else { return false }
                                                        let text: String = KeyCode.shiftingSymbol(of: number)
                                                        client?.insert(text)
                                                        return true
                                                case .fullWidth:
                                                        let text: String = isShifting ? KeyCode.shiftingSymbol(of: number) : "\(number)"
                                                        let fullWidthText: String = text.fullWidth()
                                                        client?.insert(fullWidthText)
                                                        return true
                                                }
                                        }
                                }
                        case .transparent:
                                if hasControlShiftModifiers {
                                        handleOptions(index)
                                        return true
                                } else {
                                        return false
                                }
                        case .options:
                                handleOptions(index)
                                return true
                        }
                case .keypadNumber(let number):
                        let isStrokeReverseLookup: Bool = currentInputForm.isCantonese && bufferText.hasPrefix("x")
                        guard isStrokeReverseLookup else { return false }
                        bufferText += "\(number)"
                        return true
                case .punctuation(let punctuationKey):
                        switch currentInputForm {
                        case .cantonese:
                                guard candidates.isEmpty else {
                                        switch punctuationKey {
                                        case .bracketLeft, .comma, .minus:
                                                updateDisplayCandidates(.previousPage, highlight: .unchanged)
                                                return true
                                        case .bracketRight, .period, .equal:
                                                updateDisplayCandidates(.nextPage, highlight: .unchanged)
                                                return true
                                        default:
                                                return true
                                        }
                                }
                                passBuffer()
                                guard Options.punctuationForm.isCantoneseMode else { return false }
                                if isShifting {
                                        if let symbol = punctuationKey.instantShiftingSymbol {
                                                client?.insert(symbol)
                                        } else {
                                                bufferText = punctuationKey.shiftingKeyText
                                        }
                                } else {
                                        if let symbol = punctuationKey.instantSymbol {
                                                client?.insert(symbol)
                                        } else {
                                                bufferText = punctuationKey.keyText
                                        }
                                }
                                return true
                        case .transparent:
                                return false
                        case .options:
                                return true
                        }
                case .alphabet(let letter):
                        switch currentInputForm {
                        case .cantonese:
                                let text: String = isShifting ? letter.uppercased() : letter
                                bufferText += text
                                return true
                        case .transparent:
                                return false
                        case .options:
                                return true
                        }
                case .separator:
                        switch currentInputForm {
                        case .cantonese:
                                if inputStage.isBuffering {
                                        bufferText += "'"
                                        return true
                                } else {
                                        let text: String = isShifting ? PunctuationKey.quote.shiftingKeyText : PunctuationKey.quote.keyText
                                        bufferText = text
                                        return true
                                }
                        case .transparent:
                                return false
                        case .options:
                                return true
                        }
                case .return:
                        switch currentInputForm {
                        case .cantonese:
                                guard inputStage.isBuffering else { return false }
                                passBuffer()
                                return true
                        case .transparent:
                                return false
                        case .options:
                                handleOptions()
                                return true
                        }
                case .backspace:
                        switch currentInputForm {
                        case .cantonese:
                                guard inputStage.isBuffering else { return false }
                                bufferText = String(bufferText.dropLast())
                                return true
                        case .transparent:
                                return false
                        case .options:
                                handleOptions(-1)
                                return true
                        }
                case .escape, .clear:
                        switch currentInputForm {
                        case .cantonese:
                                guard inputStage.isBuffering else { return false }
                                clearBufferText()
                                return true
                        case .transparent:
                                return false
                        case .options:
                                handleOptions(-1)
                                return true
                        }
                case .space:
                        switch currentInputForm {
                        case .cantonese:
                                let shouldSwitchToABCMode: Bool = isShifting && (AppSettings.shiftSpaceCombination == .switchInputMethodMode)
                                guard !shouldSwitchToABCMode else {
                                        passBuffer()
                                        Options.updateInputMethodMode(to: .abc)
                                        appContext.updateInputForm(to: .transparent)
                                        updateWindowFrame(.zero)
                                        return true
                                }
                                if candidates.isEmpty {
                                        passBuffer()
                                        let shouldInsertFullWidthSpace: Bool = isShifting || (Options.characterForm == .fullWidth)
                                        let text: String = shouldInsertFullWidthSpace ? String.fullWidthSpace : String.space
                                        client?.insert(text)
                                        return true
                                } else {
                                        let index = appContext.highlightedIndex
                                        guard let selectedItem = appContext.displayCandidates.fetch(index) else { return true }
                                        client?.insert(selectedItem.text)
                                        aftercareSelection(selectedItem)
                                        return true
                                }
                        case .transparent:
                                let shouldSwitchToCantoneseMode: Bool = isShifting && (AppSettings.shiftSpaceCombination == .switchInputMethodMode)
                                guard shouldSwitchToCantoneseMode else { return false }
                                Options.updateInputMethodMode(to: .cantonese)
                                appContext.updateInputForm(to: .cantonese)
                                return true
                        case .options:
                                handleOptions()
                                return true
                        }
                case .tab:
                        switch currentInputForm {
                        case .cantonese:
                                guard inputStage.isBuffering else { return false }
                                if isShifting {
                                        if appContext.isHighlightingStart {
                                                updateDisplayCandidates(.previousPage, highlight: .end)
                                        } else {
                                                appContext.decreaseHighlightedIndex()
                                        }
                                } else {
                                        if appContext.isHighlightingEnd {
                                                updateDisplayCandidates(.nextPage, highlight: .start)
                                        } else {
                                                appContext.increaseHighlightedIndex()
                                        }
                                }
                                return true
                        case .transparent:
                                return false
                        case .options:
                                if isShifting {
                                        appContext.decreaseOptionsHighlightedIndex()
                                } else {
                                        appContext.increaseOptionsHighlightedIndex()
                                }
                                return true
                        }
                case .previousPage:
                        switch currentInputForm {
                        case .cantonese:
                                guard inputStage.isBuffering else { return false }
                                updateDisplayCandidates(.previousPage, highlight: .unchanged)
                                return true
                        case .transparent:
                                return false
                        case .options:
                                return true
                        }
                case .nextPage:
                        switch currentInputForm {
                        case .cantonese:
                                guard inputStage.isBuffering else { return false }
                                updateDisplayCandidates(.nextPage, highlight: .unchanged)
                                return true
                        case .transparent:
                                return false
                        case .options:
                                return true
                        }
                case .other:
                        switch event.keyCode {
                        case KeyCode.Special.VK_HOME:
                                let shouldJump2FirstPage: Bool = currentInputForm.isCantonese && !(candidates.isEmpty)
                                guard shouldJump2FirstPage else { return false }
                                updateDisplayCandidates(.establish, highlight: .start)
                                return true
                        default:
                                return false
                        }
                }
        }

        private func passBuffer() {
                guard inputStage.isBuffering else { return }
                let text: String = Options.characterForm == .halfWidth ? bufferText : bufferText.fullWidth()
                currentClient?.insert(text)
                clearBufferText()
        }

        private func handleOptions(_ index: Int? = nil) {
                let selectedIndex: Int = index ?? appContext.optionsHighlightedIndex
                defer {
                        clearOptionsViewHintText()
                        appContext.updateInputForm()
                        if Options.inputMethodMode.isABC {
                                passBuffer()
                                updateWindowFrame(.zero)
                        } else {
                                let frame: CGRect? = candidates.isEmpty ? .zero : nil
                                updateWindowFrame(frame)
                        }
                }
                switch selectedIndex {
                case -1:
                        break
                case 4:
                        Options.updateCharacterForm(to: .halfWidth)
                case 5:
                        Options.updateCharacterForm(to: .fullWidth)
                case 6:
                        Options.updatePunctuationForm(to: .cantonese)
                case 7:
                        Options.updatePunctuationForm(to: .english)
                case 8:
                        Options.updateInputMethodMode(to: .cantonese)
                case 9:
                        Options.updateInputMethodMode(to: .abc)
                default:
                        break
                }
                let newVariant: CharacterStandard? = {
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
                                return nil
                        }
                }()
                guard let newVariant, newVariant != Options.characterStandard else { return }
                Options.updateCharacterStandard(to: newVariant)
        }

        private func aftercareSelection(_ selected: DisplayCandidate) {
                let candidate = candidates.fetch(selected.candidateIndex) ?? candidates.first(where: { $0 == selected.candidate })
                guard let candidate, candidate.isCantonese else {
                        selectedCandidates = []
                        clearBufferText()
                        return
                }
                switch bufferText.first {
                case .none:
                        return
                case .some(let character) where !(character.isBasicLatinLetter):
                        selectedCandidates = []
                        clearBufferText()
                case .some(let character) where character.isReverseLookupTrigger:
                        selectedCandidates = []
                        let leadingCount: Int = candidate.input.count + 1
                        if bufferText.count > leadingCount {
                                let tail = bufferText.dropFirst(leadingCount)
                                bufferText = String(character) + tail
                        } else {
                                clearBufferText()
                        }
                default:
                        selectedCandidates.append(candidate)
                        let inputCount: Int = candidate.input.replacingOccurrences(of: "(4|5|6)", with: "RR", options: .regularExpression).count
                        var tail = bufferText.dropFirst(inputCount)
                        while tail.hasPrefix("'") {
                                tail = tail.dropFirst()
                        }
                        bufferText = String(tail)
                }
        }
}
