import UIKit

extension KeyView {
        func handleBackspace() {
                performBackspace()
                guard backspaceTimer == nil && repeatingBackspaceTimer == nil else {
                        backspaceTimer?.invalidate()
                        repeatingBackspaceTimer?.invalidate()
                        backspaceTimer = nil
                        repeatingBackspaceTimer = nil
                        return
                }
                backspaceTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { [weak self] timer in
                        guard let self = self else { return }
                        guard self.isInteracting, self.backspaceTimer == timer else { return }
                        self.repeatingBackspaceTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
                                guard let self = self else {
                                        timer.invalidate()
                                        return
                                }
                                guard self.isInteracting, self.repeatingBackspaceTimer == timer else {
                                        self.repeatingBackspaceTimer?.invalidate()
                                        self.repeatingBackspaceTimer = nil
                                        timer.invalidate()
                                        return
                                }
                                self.performBackspace()
                        }
                }
        }
        private func performBackspace() {
                let inputText: String = controller.inputText
                if inputText.isEmpty {
                        controller.textDocumentProxy.deleteBackward()
                } else {
                        let hasLightToneSuffix: Bool = inputText.hasSuffix("vv") || inputText.hasSuffix("xx") || inputText.hasSuffix("qq")
                        if controller.arrangement < 2 && hasLightToneSuffix {
                                controller.inputText = String(inputText.dropLast(2))
                        } else {
                                controller.inputText = String(inputText.dropLast())
                        }
                        controller.candidateSequence = []
                }
                AudioFeedback.perform(.delete)
        }
        func handleTap() {
                switch event {
                case .key(.cantoneseComma):
                        guard peekingText == nil else { return }
                        if controller.inputText.isEmpty {
                                controller.insert("，")
                                AudioFeedback.perform(.input)
                        } else {
                                let text: String = controller.inputText + "，"
                                controller.output(text)
                                AudioFeedback.perform(.input)
                                controller.inputText = ""
                        }
                case .key(let keySeat):
                        guard peekingText == nil else { return }
                        let text: String = keySeat.primary.text
                        if layout.isCantoneseMode {
                                if text == "gw" && controller.arrangement == 2 {
                                        let newInputText: String = controller.inputText + text
                                        controller.inputText = newInputText.replacingOccurrences(of: "gwgw", with: "kw")
                                } else {
                                        controller.inputText += text
                                }
                        } else {
                                controller.insert(text)
                        }
                        AudioFeedback.perform(.input)
                        switch layout {
                        case .alphabetic(.uppercased):
                                controller.keyboardLayout = .alphabetic(.lowercased)
                        case .cantonese(.uppercased):
                                controller.keyboardLayout = .cantonese(.lowercased)
                        default:
                                break
                        }
                default:
                        break
                }
        }
        func handleShadowKey(_ text: String) {
                if layout.isCantoneseMode {
                        controller.inputText += text
                } else {
                        controller.insert(text)
                }
                if layout == .alphabetic(.uppercased) {
                        controller.keyboardLayout = .alphabetic(.lowercased)
                }
                if layout == .cantonese(.uppercased) {
                        controller.keyboardLayout = .cantonese(.lowercased)
                }
                AudioFeedback.perform(.input)
        }
        func handleNewLine() {
                guard !(controller.inputText.isEmpty) else {
                        controller.insert("\n")
                        AudioFeedback.perform(.input)
                        return
                }
                controller.output(controller.inputText)
                AudioFeedback.perform(.input)
                controller.inputText = ""
        }
        func doubleTapShift() {
                controller.keyboardLayout = layout.isEnglishMode ? .alphabetic(.capsLocked) : .cantonese(.capsLocked)
        }
        func tapOnShift() {
                switch layout {
                case .cantonese(.lowercased):
                        controller.keyboardLayout = .cantonese(.uppercased)
                case .cantonese(.uppercased),
                     .cantonese(.capsLocked):
                        controller.keyboardLayout = .cantonese(.lowercased)
                case .alphabetic(.lowercased):
                        controller.keyboardLayout = .alphabetic(.uppercased)
                case .alphabetic(.uppercased),
                     .alphabetic(.capsLocked):
                        controller.keyboardLayout = .alphabetic(.lowercased)
                default:
                        break
                }
        }
        func doubleTapSpace() {
                guard controller.inputText.isEmpty else { return }
                guard let isSpaceAhead: Bool = controller.textDocumentProxy.documentContextBeforeInput?.last?.isWhitespace, isSpaceAhead else {
                        controller.insert(" ")
                        AudioFeedback.perform(.input)
                        return
                }
                controller.textDocumentProxy.deleteBackward()
                let text: String = layout.isEnglishMode ? ". " : "。"
                controller.insert(text)
                AudioFeedback.perform(.input)
        }
        func tapOnSpace() {
                guard !draggedOnSpace else { return }
                switch layout {
                case .cantonese:
                        defer {
                                if layout == .cantonese(.uppercased) {
                                        controller.keyboardLayout = .cantonese(.lowercased)
                                }
                        }
                        let inputText: String = controller.inputText
                        guard !inputText.isEmpty else {
                                controller.insert(" ")
                                AudioFeedback.perform(.input)
                                return
                        }
                        guard let firstCandidate: Candidate = controller.candidates.first else {
                                controller.output(inputText)
                                AudioFeedback.perform(.modify)
                                controller.inputText = ""
                                return
                        }
                        controller.output(firstCandidate.text)
                        AudioFeedback.perform(.modify)

                        switch inputText.first {
                        case .none:
                                break
                        case .some("r"), .some("v"), .some("x"):
                                if inputText.count == (firstCandidate.input.count + 1) {
                                        controller.inputText = ""
                                } else {
                                        let first: String = String(inputText.first!)
                                        let tail = inputText.dropFirst(firstCandidate.input.count + 1)
                                        controller.inputText = first + tail
                                }
                        default:
                                controller.candidateSequence.append(firstCandidate)
                                let inputCount: Int = {
                                        if controller.arrangement > 1 {
                                                return firstCandidate.input.count
                                        } else {
                                                let converted: String = firstCandidate.input.replacingOccurrences(of: "4", with: "vv").replacingOccurrences(of: "5", with: "xx").replacingOccurrences(of: "6", with: "qq")
                                                return converted.count
                                        }
                                }()
                                let leading = inputText.dropLast(inputText.count - inputCount)
                                let filtered = leading.replacingOccurrences(of: "'", with: "")
                                var tail: String.SubSequence = {
                                        if filtered.count == leading.count {
                                                return inputText.dropFirst(inputCount)
                                        } else {
                                                let separatorsCount: Int = leading.count - filtered.count
                                                return inputText.dropFirst(inputCount + separatorsCount)
                                        }
                                }()
                                while tail.hasPrefix("'") {
                                        tail = tail.dropFirst()
                                }
                                controller.inputText = String(tail)
                        }

                        if controller.inputText.isEmpty && !controller.candidateSequence.isEmpty {
                                let concatenatedCandidate: Candidate = controller.candidateSequence.joined()
                                controller.candidateSequence = []
                                controller.handleLexicon(concatenatedCandidate)
                        }
                case .alphabetic(.uppercased):
                        controller.insert(" ")
                        AudioFeedback.perform(.input)
                        controller.keyboardLayout = .alphabetic(.lowercased)
                default:
                        controller.insert(" ")
                        AudioFeedback.perform(.input)
                }
        }
}
