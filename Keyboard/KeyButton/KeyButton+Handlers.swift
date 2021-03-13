import UIKit

extension KeyButton {
        
        func setupKeyActions() {
                switch keyboardEvent {
                case .backspace, .shadowBackspace:
                        addTarget(self, action: #selector(handleBackspace), for: .touchDown)
                case .shift, .shiftDown:
                        addTarget(self, action: #selector(handleShift(sender:event:)), for: .touchUpInside)
                case .space, .none:
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
                                viewController.currentInputText += text
                        } else {
                                viewController.textDocumentProxy.insertText(text)
                        }
                        if viewController.keyboardLayout == .alphabeticUppercase && !viewController.isCapsLocked {
                                viewController.keyboardLayout = .alphabetic
                        }
                        if viewController.keyboardLayout == .jyutpingUppercase && !viewController.isCapsLocked {
                                viewController.keyboardLayout = .jyutping
                        }
                case .shadowKey(let text):
                        if viewController.keyboardLayout.isJyutpingMode {
                                viewController.currentInputText += text
                        } else {
                                viewController.textDocumentProxy.insertText(text)
                        }
                        if viewController.keyboardLayout == .alphabeticUppercase && !viewController.isCapsLocked {
                                viewController.keyboardLayout = .alphabetic
                        }
                        if viewController.keyboardLayout == .jyutpingUppercase && !viewController.isCapsLocked {
                                viewController.keyboardLayout = .jyutping
                        }
                case .newLine:
                        if viewController.currentInputText.isEmpty {
                                viewController.textDocumentProxy.insertText("\n")
                        } else {
                                viewController.textDocumentProxy.insertText(viewController.currentInputText)
                                viewController.currentInputText = ""
                                if viewController.keyboardLayout == .jyutpingUppercase && !viewController.isCapsLocked {
                                        viewController.keyboardLayout = .jyutping
                                }
                        }
                case .switchTo(let layout):
                        viewController.keyboardLayout = layout
                default:
                        break
                }
                AudioFeedback.play(for: self.keyboardEvent)
        }
        @objc private func handleShift(sender: UIButton, event: UIEvent) {
                guard let touchEvent: UITouch = event.allTouches?.first else { return }
                if touchEvent.tapCount == 2 {
                        viewController.isCapsLocked = true
                        viewController.keyboardLayout = viewController.keyboardLayout.isEnglishLayout ?
                                .alphabeticUppercase : .jyutpingUppercase
                } else if touchEvent.tapCount == 1 {
                        if keyboardEvent == .shift {
                                viewController.keyboardLayout = viewController.keyboardLayout.isEnglishLayout ?
                                        .alphabeticUppercase : .jyutpingUppercase
                        } else {
                                viewController.isCapsLocked = false
                                viewController.keyboardLayout = viewController.keyboardLayout.isEnglishLayout ?
                                        .alphabetic : .jyutping
                        }
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
                if viewController.currentInputText.isEmpty {
                        viewController.textDocumentProxy.deleteBackward()
                } else {
                        viewController.currentInputText = String(viewController.currentInputText.dropLast())
                        viewController.candidateSequence = []
                }
                AudioFeedback.play(for: .backspace)
        }
}
