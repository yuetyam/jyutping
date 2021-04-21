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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                        if self != nil {
                                if self!.isInteracting {
                                        self!.backspaceTimer?.start()
                                }
                        }
                }
        }
        func performBackspace() {
                if controller.inputText.isEmpty {
                        controller.textDocumentProxy.deleteBackward()
                } else {
                        controller.inputText = String(controller.processingText.dropLast())
                        controller.candidateSequence = []
                }
                AudioFeedback.play(for: .backspace)
        }
        func handleTap() {
                switch event {
                case .key(.cantoneseComma):
                        guard peekingText == nil else { return }
                        if controller.inputText.isEmpty {
                                controller.insert("，")
                                AudioFeedback.perform(.input)
                        } else {
                                let text: String = controller.processingText + "，"
                                controller.output(text)
                                AudioFeedback.perform(.input)
                                controller.inputText = ""
                        }
                case .key(let keySeat):
                        guard peekingText == nil else { return }
                        let text: String = keySeat.primary.text
                        if keyboardLayout.isCantoneseMode {
                                controller.inputText += text
                        } else {
                                controller.insert(text)
                        }
                        AudioFeedback.perform(.input)
                        if keyboardLayout == .alphabetic(.uppercased) {
                                controller.keyboardLayout = .alphabetic(.lowercased)
                        }
                        if keyboardLayout == .cantonese(.uppercased) {
                                controller.keyboardLayout = .cantonese(.lowercased)
                        }
                default:
                        break
                }
        }
        func handleShadowKey(_ text: String) {
                if keyboardLayout.isCantoneseMode {
                        controller.inputText += text
                } else {
                        controller.insert(text)
                }
                if keyboardLayout == .alphabetic(.uppercased) {
                        controller.keyboardLayout = .alphabetic(.lowercased)
                }
                if keyboardLayout == .cantonese(.uppercased) {
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
                let converted: String = controller.processingText.replacingOccurrences(of: "4", with: "xx")
                        .replacingOccurrences(of: "5", with: "vv")
                        .replacingOccurrences(of: "6", with: "qq")
                        .replacingOccurrences(of: "1", with: "v")
                        .replacingOccurrences(of: "2", with: "x")
                        .replacingOccurrences(of: "3", with: "q")
                controller.output(converted)
                AudioFeedback.perform(.input)
                controller.inputText = ""
        }
        func doubleTapShift() {
                controller.keyboardLayout = keyboardLayout.isEnglishMode ? .alphabetic(.capsLocked) : .cantonese(.capsLocked)
        }
        func tapOnShift() {
                switch keyboardLayout {
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
                let text: String = keyboardLayout.isEnglishMode ? ". " : "。"
                controller.insert(text)
                AudioFeedback.perform(.input)
        }
        func tapOnSpace() {
                guard !draggedOnSpace else { return }
                switch keyboardLayout {
                case .cantonese:
                        defer {
                                if keyboardLayout == .cantonese(.uppercased) {
                                        controller.keyboardLayout = .cantonese(.lowercased)
                                }
                        }
                        let inputText: String = controller.inputText
                        let processingText: String = controller.processingText
                        guard !inputText.isEmpty else {
                                controller.insert(" ")
                                AudioFeedback.perform(.input)
                                return
                        }
                        guard let firstCandidate: Candidate = controller.candidates.first else {
                                let converted: String = controller.processingText.replacingOccurrences(of: "4", with: "xx")
                                        .replacingOccurrences(of: "5", with: "vv")
                                        .replacingOccurrences(of: "6", with: "qq")
                                        .replacingOccurrences(of: "1", with: "v")
                                        .replacingOccurrences(of: "2", with: "x")
                                        .replacingOccurrences(of: "3", with: "q")
                                controller.output(converted)
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
                                let tail = processingText.dropFirst(firstCandidate.input.count)
                                controller.inputText = (tail == "'") ? "" : String(tail)
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
