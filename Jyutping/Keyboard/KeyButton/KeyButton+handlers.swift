import UIKit

extension KeyButton {

        func setupKeyActions() {
                switch event {
                case .none, .backspace, .shadowBackspace:
                        break
                case .shift:
                        addTarget(self, action: #selector(handleShift(sender:event:)), for: .touchUpInside)
                case .space:
                        addTarget(self, action: #selector(handleSpace(sender:event:)), for: .touchUpInside)
                default:
                        addTarget(self, action: #selector(handleTap), for: .touchUpInside)
                }
        }
        @objc private func handleTap() {
                switch event {
                case .key(.cantoneseComma):
                        guard peekingText == nil else { return }
                        if controller.inputText.isEmpty {
                                controller.textDocumentProxy.insertText("，")
                        } else {
                                let text: String = controller.processingText + "，"
                                controller.inputText = ""
                                controller.textDocumentProxy.insertText(text)
                        }
                case .key(let keySeat):
                        guard peekingText == nil else { return }
                        let text: String = keySeat.primary.text
                        if controller.keyboardLayout.isCantoneseMode {
                                controller.inputText += text
                        } else {
                                controller.textDocumentProxy.insertText(text)
                        }
                        if controller.keyboardLayout == .alphabetic(.uppercased) {
                                controller.keyboardLayout = .alphabetic(.lowercased)
                        }
                        if controller.keyboardLayout == .cantonese(.uppercased) {
                                controller.keyboardLayout = .cantonese(.lowercased)
                        }
                case .shadowKey(let text):
                        if controller.keyboardLayout.isCantoneseMode {
                                controller.inputText += text
                        } else {
                                controller.textDocumentProxy.insertText(text)
                        }
                        if controller.keyboardLayout == .alphabetic(.uppercased) {
                                controller.keyboardLayout = .alphabetic(.lowercased)
                        }
                        if controller.keyboardLayout == .cantonese(.uppercased) {
                                controller.keyboardLayout = .cantonese(.lowercased)
                        }
                case .newLine:
                        if controller.inputText.isEmpty {
                                controller.textDocumentProxy.insertText("\n")
                        } else {
                                let converted: String = controller.processingText.replacingOccurrences(of: "4", with: "xx")
                                        .replacingOccurrences(of: "5", with: "vv")
                                        .replacingOccurrences(of: "6", with: "qq")
                                        .replacingOccurrences(of: "1", with: "v")
                                        .replacingOccurrences(of: "2", with: "x")
                                        .replacingOccurrences(of: "3", with: "q")
                                controller.inputText = ""
                                controller.textDocumentProxy.insertText(converted)
                        }
                case .switchTo(let layout):
                        controller.keyboardLayout = layout
                default:
                        break
                }
                AudioFeedback.play(for: event)
        }
        func handleLongPress() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        guard self.isInteracting else { return }
                        self.displayCallout()
                }
        }
        func handleBackspace() {
                performBackspace()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        guard self.isInteracting else { return }
                        self.backspaceTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.performBackspace), userInfo: nil, repeats: true)
                }
        }
        @objc private func performBackspace() {
                if controller.inputText.isEmpty {
                        controller.textDocumentProxy.deleteBackward()
                } else {
                        controller.inputText = String(controller.processingText.dropLast())
                        controller.candidateSequence = []
                }
                AudioFeedback.play(for: .backspace)
        }
        @objc private func handleShift(sender: UIButton, event: UIEvent?) {
                guard let touch: UITouch = event?.allTouches?.first else { return }
                let layout: KeyboardLayout = controller.keyboardLayout
                switch touch.tapCount {
                case 1:
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
                case 2:
                        controller.keyboardLayout = layout.isEnglishMode ? .alphabetic(.capsLocked) : .cantonese(.capsLocked)
                default:
                        break
                }
                AudioFeedback.perform(.modify)
        }
        @objc private func handleSpace(sender: UIButton, event: UIEvent) {
                guard let touchEvent: UITouch = event.allTouches?.first else { return }
                switch touchEvent.tapCount {
                case 2:
                        guard controller.inputText.isEmpty else { return }
                        guard let isSpaceAhead: Bool = controller.textDocumentProxy.documentContextBeforeInput?.last?.isWhitespace, isSpaceAhead else {
                                controller.textDocumentProxy.insertText(" ")
                                AudioFeedback.perform(.input)
                                return
                        }
                        controller.textDocumentProxy.deleteBackward()
                        let text: String = controller.keyboardLayout.isEnglishMode ? ". " : "。"
                        controller.textDocumentProxy.insertText(text)
                        AudioFeedback.perform(.input)
                default:
                        tapOnSpace()
                }
        }
        private func tapOnSpace() {
                guard !draggedOnSpace else { return }
                let layout: KeyboardLayout = controller.keyboardLayout
                switch layout {
                case .cantonese:
                        defer {
                                if layout == .cantonese(.uppercased) {
                                        controller.keyboardLayout = .cantonese(.lowercased)
                                }
                        }
                        let inputText: String = controller.inputText
                        let processingText: String = controller.processingText
                        guard !inputText.isEmpty else {
                                controller.textDocumentProxy.insertText(" ")
                                AudioFeedback.play(for: .space)
                                return
                        }
                        guard let firstCandidate: Candidate = controller.candidates.first else {
                                let converted: String = controller.processingText.replacingOccurrences(of: "4", with: "xx")
                                        .replacingOccurrences(of: "5", with: "vv")
                                        .replacingOccurrences(of: "6", with: "qq")
                                        .replacingOccurrences(of: "1", with: "v")
                                        .replacingOccurrences(of: "2", with: "x")
                                        .replacingOccurrences(of: "3", with: "q")
                                controller.inputText = ""
                                controller.textDocumentProxy.insertText(converted)
                                AudioFeedback.perform(.modify)
                                return
                        }
                        controller.textDocumentProxy.insertText(firstCandidate.text)
                        AudioFeedback.perform(.modify)
                        if inputText.hasPrefix("r") {
                                if inputText.count == (firstCandidate.input.count + 1) {
                                        controller.inputText = ""
                                } else {
                                        controller.inputText = "r" + processingText.dropFirst(firstCandidate.input.count + 1)
                                }
                        } else if inputText.hasPrefix("v") {
                                if inputText.count == (firstCandidate.input.count + 1) {
                                        controller.inputText = ""
                                } else {
                                        controller.inputText = "v" + processingText.dropFirst(firstCandidate.input.count + 1)
                                }
                        } else {
                                controller.candidateSequence.append(firstCandidate)
                                let left = processingText.dropFirst(firstCandidate.input.count)
                                controller.inputText = (left == "'") ? "" : String(left)
                        }
                        if controller.inputText.isEmpty && !controller.candidateSequence.isEmpty {
                                let concatenatedCandidate: Candidate = controller.candidateSequence.joined()
                                controller.candidateSequence = []
                                controller.imeQueue.async {
                                        self.controller.lexiconManager.handle(candidate: concatenatedCandidate)
                                }
                        }
                case .alphabetic(.uppercased):
                        controller.textDocumentProxy.insertText(" ")
                        AudioFeedback.play(for: .space)
                        controller.keyboardLayout = .alphabetic(.lowercased)
                default:
                        controller.textDocumentProxy.insertText(" ")
                        AudioFeedback.play(for: .space)
                }
        }
}
