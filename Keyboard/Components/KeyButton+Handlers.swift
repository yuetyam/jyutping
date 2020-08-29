import UIKit

extension KeyButton {
        
        func setupKeyActions() {
                switch keyboardEvent {
                case .backspace, .keyBackspaceLeft:
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
                case .text(let text):
                        if viewController.keyboardLayout == .jyutping || viewController.keyboardLayout == .jyutpingUppercase {
                                viewController.currentInputText += text
                        } else {
                                viewController.textDocumentProxy.insertText(text)
                        }
                        if viewController.keyboardLayout == .alphabetUppercase && !viewController.isCapsLocked {
                                viewController.keyboardLayout = .alphabetLowercase
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
                        }
                case .switchTo(let layout):
                        viewController.keyboardLayout = layout
                case .keyALeft:
                        switch viewController.keyboardLayout {
                        case .jyutping:
                                viewController.currentInputText += "a"
                        case .jyutpingUppercase:
                                viewController.currentInputText += "A"
                                if !viewController.isCapsLocked {
                                        viewController.keyboardLayout = .jyutping
                                }
                        case .alphabetLowercase:
                                viewController.textDocumentProxy.insertText("a")
                        case .alphabetUppercase:
                                viewController.textDocumentProxy.insertText("A")
                                if !viewController.isCapsLocked {
                                        viewController.keyboardLayout = .alphabetLowercase
                                }
                        default:
                                break
                        }
                case .keyLRight:
                        switch viewController.keyboardLayout {
                        case .jyutping:
                                viewController.currentInputText += "l"
                        case .jyutpingUppercase:
                                viewController.currentInputText += "L"
                                if !viewController.isCapsLocked {
                                        viewController.keyboardLayout = .jyutping
                                }
                        case .alphabetLowercase:
                                viewController.textDocumentProxy.insertText("l")
                        case .alphabetUppercase:
                                viewController.textDocumentProxy.insertText("L")
                                if !viewController.isCapsLocked {
                                        viewController.keyboardLayout = .alphabetLowercase
                                }
                        default:
                                break
                        }
                case .keyZLeft:
                        switch viewController.keyboardLayout {
                        case .jyutping:
                                viewController.currentInputText += "z"
                        case .jyutpingUppercase:
                                viewController.currentInputText += "Z"
                                if !viewController.isCapsLocked {
                                        viewController.keyboardLayout = .jyutping
                                }
                        case .alphabetLowercase:
                                viewController.textDocumentProxy.insertText("z")
                        case .alphabetUppercase:
                                viewController.textDocumentProxy.insertText("Z")
                                if !viewController.isCapsLocked {
                                        viewController.keyboardLayout = .alphabetLowercase
                                }
                        default:
                                break
                        }
                default:
                        break
                }
                DispatchQueue.global().async {
                        AudioFeedback.play(for: self.keyboardEvent)
                }
        }
        @objc private func handleShift(sender: UIButton, event: UIEvent) {
                guard let touchEvent: UITouch = event.allTouches?.first else { return }
                if touchEvent.tapCount == 2 {
                        viewController.isCapsLocked = true
                        viewController.keyboardLayout = viewController.keyboardLayout.isEnglish ?
                                .alphabetUppercase : .jyutpingUppercase
                } else if touchEvent.tapCount == 1 {
                        if keyboardEvent == .shift {
                                viewController.keyboardLayout = viewController.keyboardLayout.isEnglish ?
                                        .alphabetUppercase : .jyutpingUppercase
                        } else {
                                viewController.isCapsLocked = false
                                viewController.keyboardLayout = viewController.keyboardLayout.isEnglish ?
                                        .alphabetLowercase : .jyutping
                        }
                }
        }
        @objc private func handleBackspace() {
                DispatchQueue.main.async {
                        self.performBackspace()
                }
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
                DispatchQueue.global().async {
                        AudioFeedback.play(for: .backspace)
                }
        }
}
