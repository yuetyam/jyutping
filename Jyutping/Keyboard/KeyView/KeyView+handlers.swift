import UIKit

extension KeyView {
        func handleLongPress() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
                        if self != nil {
                                if self!.isInteracting {
                                        self!.displayCallout()
                                }
                        }
                }
        }
        func handleBackspace() {
                performBackspace()
                backspaceTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { _ in
                        self.repeatingBackspaceTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.performBackspace), userInfo: nil, repeats: true)
                }
        }
        @objc private func performBackspace() {
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
                                controller.inputText += text
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
                        if inputText.hasPrefix("r") {
                                if inputText.count == (firstCandidate.input.count + 1) {
                                        controller.inputText = ""
                                } else {
                                        let tail = inputText.dropFirst(firstCandidate.input.count + 1)
                                        controller.inputText = "r" + tail
                                }
                        } else if inputText.hasPrefix("v") {
                                if inputText.count == (firstCandidate.input.count + 1) {
                                        controller.inputText = ""
                                } else {
                                        let tail = inputText.dropFirst(firstCandidate.input.count + 1)
                                        controller.inputText = "v" + tail
                                }
                        } else {
                                controller.candidateSequence.append(firstCandidate)
                                if controller.arrangement < 2 {
                                        let converted: String = firstCandidate.input.replacingOccurrences(of: "4", with: "vv").replacingOccurrences(of: "5", with: "xx").replacingOccurrences(of: "6", with: "qq")
                                        let tail = inputText.dropFirst(converted.count)
                                        controller.inputText = (tail == "'") ? "" : String(tail)
                                } else {
                                        let tail = inputText.dropFirst(firstCandidate.input.count)
                                        controller.inputText = (tail == "'") ? "" : String(tail)
                                }
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
