import UIKit

extension KeyButton {
        
        func setupKeyActions() {
                switch keyboardEvent {
                case .backspace, .shadowBackspace:
                        addTarget(self, action: #selector(handleBackspace), for: .touchDown)
                case .shift:
                        addTarget(self, action: #selector(handleShift(sender:event:)), for: .touchUpInside)
                case .space:
                        addTarget(self, action: #selector(handleSpace), for: .touchUpInside)
                case .none:
                        break
                default:
                        addTarget(self, action: #selector(handleTap), for: .touchUpInside)
                }
        }
        @objc private func handleTap() {
                switch keyboardEvent {
                case .key(let keySeat):
                        let text: String = keySeat.primary.text
                        if viewController.keyboardLayout.isJyutpingMode {
                                viewController.inputText += text
                        } else {
                                viewController.textDocumentProxy.insertText(text)
                        }
                        if viewController.keyboardLayout == .alphabetic(.uppercased) {
                                viewController.keyboardLayout = .alphabetic(.lowercased)
                        }
                        if viewController.keyboardLayout == .jyutping(.uppercased) {
                                viewController.keyboardLayout = .jyutping(.lowercased)
                        }
                case .shadowKey(let text):
                        if viewController.keyboardLayout.isJyutpingMode {
                                viewController.inputText += text
                        } else {
                                viewController.textDocumentProxy.insertText(text)
                        }
                        if viewController.keyboardLayout == .alphabetic(.uppercased) {
                                viewController.keyboardLayout = .alphabetic(.lowercased)
                        }
                        if viewController.keyboardLayout == .jyutping(.uppercased) {
                                viewController.keyboardLayout = .jyutping(.lowercased)
                        }
                case .newLine:
                        if viewController.inputText.isEmpty {
                                viewController.textDocumentProxy.insertText("\n")
                        } else {
                                viewController.textDocumentProxy.insertText(viewController.processingText)
                                viewController.inputText = ""
                                if viewController.keyboardLayout == .jyutping(.uppercased) {
                                        viewController.keyboardLayout = .jyutping(.lowercased)
                                }
                        }
                case .switchTo(let layout):
                        viewController.keyboardLayout = layout
                default:
                        break
                }
                AudioFeedback.play(for: self.keyboardEvent)
        }
        @objc private func handleBackspace() {
                performBackspace()
                slowBackspaceTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { _ in
                        self.fastBackspaceTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.performBackspace), userInfo: nil, repeats: true)
                }
        }
        @objc private func performBackspace() {
                if viewController.inputText.isEmpty {
                        viewController.textDocumentProxy.deleteBackward()
                } else {
                        viewController.inputText = String(viewController.processingText.dropLast())
                        viewController.candidateSequence = []
                }
                AudioFeedback.play(for: .backspace)
        }
        @objc private func handleShift(sender: UIButton, event: UIEvent) {
                guard let touchEvent: UITouch = event.allTouches?.first else { return }
                let layout: KeyboardLayout = viewController.keyboardLayout
                switch touchEvent.tapCount {
                case 1:
                        switch layout {
                        case .jyutping(.lowercased):
                                viewController.keyboardLayout = .jyutping(.uppercased)
                        case .jyutping(.uppercased), .jyutping(.capsLocked):
                                viewController.keyboardLayout = .jyutping(.lowercased)
                        case .alphabetic(.lowercased):
                                viewController.keyboardLayout = .alphabetic(.uppercased)
                        case .alphabetic(.uppercased), .alphabetic(.capsLocked):
                                viewController.keyboardLayout = .alphabetic(.lowercased)
                        default:
                                break
                        }
                case 2:
                        viewController.keyboardLayout = layout.isEnglishLayout ? .alphabetic(.capsLocked) : .jyutping(.capsLocked)
                default:
                        break
                }
                AudioFeedback.play(for: self.keyboardEvent)
        }
        @objc private func handleSpace() {
                guard !performedDraggingOnSpace else { return }
                let layout: KeyboardLayout = viewController.keyboardLayout
                switch layout {
                case .jyutping:
                        defer {
                                if layout == .jyutping(.uppercased) {
                                        viewController.keyboardLayout = .jyutping(.lowercased)
                                }
                        }
                        let inputText: String = viewController.inputText
                        let processingText: String = viewController.processingText
                        guard !inputText.isEmpty else {
                                viewController.textDocumentProxy.insertText(" ")
                                AudioFeedback.play(for: .space)
                                return
                        }
                        guard let firstCandidate: Candidate = viewController.candidates.first else {
                                viewController.textDocumentProxy.insertText(processingText)
                                AudioFeedback.perform(.modify)
                                viewController.inputText = ""
                                return
                        }
                        viewController.textDocumentProxy.insertText(firstCandidate.text)
                        AudioFeedback.perform(.modify)
                        if inputText.hasPrefix("r") {
                                if inputText.count == (firstCandidate.input.count + 1) {
                                        viewController.inputText = ""
                                } else {
                                        viewController.inputText = "r" + processingText.dropFirst(firstCandidate.input.count + 1)
                                }
                        } else if inputText.hasPrefix("v") {
                                if inputText.count == (firstCandidate.input.count + 1) {
                                        viewController.inputText = ""
                                } else {
                                        viewController.inputText = "v" + processingText.dropFirst(firstCandidate.input.count + 1)
                                }
                        } else {
                                viewController.candidateSequence.append(firstCandidate)
                                viewController.inputText = String(processingText.dropFirst(firstCandidate.input.count))
                        }
                        if viewController.inputText.isEmpty && !viewController.candidateSequence.isEmpty {
                                let concatenatedCandidate: Candidate = viewController.candidateSequence.joined()
                                viewController.candidateSequence = []
                                viewController.imeQueue.async {
                                        self.viewController.lexiconManager?.handle(candidate: concatenatedCandidate)
                                }
                        }
                case .alphabetic(.uppercased):
                        viewController.textDocumentProxy.insertText(" ")
                        AudioFeedback.play(for: .space)
                        viewController.keyboardLayout = .alphabetic(.lowercased)
                default:
                        viewController.textDocumentProxy.insertText(" ")
                        AudioFeedback.play(for: .space)
                }
        }
}
