import UIKit

extension KeyButton {
        
        func setupKeyActions() {
                switch keyboardEvent {
                case .backspace:
                        addTarget(self, action: #selector(handleBackspace), for: .touchDown)
                case .shiftUp, .shiftDown:
                        addTarget(self, action: #selector(handleShift(_:event:)), for: .touchUpInside)
                case .space, .none:
                        break
                default:
                        addTarget(self, action: #selector(handleTap), for: .touchUpInside)
                }
        }
        @objc private func handleTap() {
                switch keyboardEvent {
                case .text(let text):
                        if viewController.keyboardLayout == .jyutping {
                                viewController.currentInputText += text
                        } else {
                                viewController.textDocumentProxy.insertText(text)
                        }
                        if viewController.keyboardLayout == .alphabetUppercase && !viewController.isCapsLocked {
                                viewController.keyboardLayout = .alphabetLowercase
                        }
                case .newLine:
                        if viewController.currentInputText.isEmpty {
                                viewController.textDocumentProxy.insertText("\n")
                        } else {
                                viewController.textDocumentProxy.insertText(viewController.currentInputText)
                                viewController.currentInputText = ""
                        }
                case .switchTo(let layout):
                        viewController.keyboardLayout = layout
                default:
                        break
                }
                DispatchQueue.global().async {
                        AudioFeedback.play(for: self.keyboardEvent)
                }
        }
        @objc private func handleShift(_ sender: UIButton, event: UIEvent) {
                guard let touchEvent: UITouch = event.allTouches?.first else { return }
                if touchEvent.tapCount == 2 {
                        if keyboardEvent == .shiftUp {
                                viewController.isCapsLocked = true
                                viewController.keyboardLayout = .alphabetUppercase
                        } else {// keyboardEvent == .shiftDown
                                if viewController.isCapsLocked {
                                        viewController.isCapsLocked = false
                                        viewController.keyboardLayout = .alphabetLowercase
                                } else {
                                        viewController.isCapsLocked = true
                                        viewController.setupKeyboard()
                                }
                        }
                } else if touchEvent.tapCount == 1 {
                        if keyboardEvent == .shiftUp {
                                viewController.keyboardLayout = .alphabetUppercase
                        } else { // keyboardEvent == .shiftDown
                                if viewController.isCapsLocked {
                                        viewController.isCapsLocked = false
                                }
                                viewController.keyboardLayout = .alphabetLowercase
                        }
                }
        }
        @objc private func handleBackspace() {
                performBackspace()
                slowBackspaceTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { _ in
                        self.fastBackspaceTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.performBackspace), userInfo: nil, repeats: true)
                }
        }
        @objc private func performBackspace() {
                
                guard !viewController.currentInputText.isEmpty || viewController.textDocumentProxy.hasText else { return }
                
                if viewController.currentInputText.isEmpty {
                        viewController.textDocumentProxy.deleteBackward()
                } else {
                        viewController.currentInputText = String(viewController.currentInputText.dropLast())
                }
                DispatchQueue.global().async {
                        AudioFeedback.play(for: .backspace)
                }
        }
}
