import CoreIME

extension JyutpingInputController {

        func suggest() {
                let engineCandidates: [Candidate] = {
                        let convertedSegmentation: Segmentation = segmentation.converted()
                        var normal: [Candidate] = Engine.suggest(for: processingText, segmentation: convertedSegmentation)
                        let droppedLast = processingText.dropLast()
                        let shouldDropSeparator: Bool = normal.isEmpty && processingText.hasSuffix("'") && !droppedLast.contains("'")
                        guard !shouldDropSeparator else {
                                let droppedSeparator: String = String(droppedLast)
                                let newSchemes: [[String]] = Segmentor.segment(droppedSeparator).filter({ $0.joined() == droppedSeparator || $0.count == 1 })
                                return Engine.suggest(for: droppedSeparator, segmentation: newSchemes)
                        }
                        let shouldContinue: Bool = InstantSettings.needsEmojiCandidates && !normal.isEmpty && candidateSequence.isEmpty
                        guard shouldContinue else { return normal }
                        let symbols: [Candidate] = Engine.searchEmojiSymbols(for: bufferText)
                        for symbol in symbols.reversed() {
                                if let index = normal.firstIndex(where: { $0.lexiconText == symbol.lexiconText }) {
                                        normal.insert(symbol, at: index + 1)
                                }
                        }
                        return normal
                }()
                let lexiconCandidates: [Candidate] = UserLexicon.suggest(for: processingText)
                let combined: [Candidate] = lexiconCandidates + engineCandidates
                push(combined)
        }

        func pinyinReverseLookup() {
                let text: String = String(processingText.dropFirst())
                guard !text.isEmpty else {
                        clearCandidates()
                        return
                }
                let lookup: [Candidate] = Engine.pinyinLookup(for: text)
                push(lookup)
        }
        func cangjieReverseLookup() {
                let text: String = String(processingText.dropFirst())
                let converted = text.map({ Logogram.cangjie(of: $0) }).compactMap({ $0 })
                let isValidSequence: Bool = !converted.isEmpty && converted.count == text.count
                if isValidSequence {
                        markedText = String(converted)
                        let lookup: [Candidate] = Engine.cangjieLookup(for: text)
                        push(lookup)
                } else {
                        markedText = processingText
                        clearCandidates()
                }
        }
        func strokeReverseLookup() {
                let text: String = String(processingText.dropFirst())
                let transformed: String = Logogram.strokeTransform(text)
                let converted = transformed.map({ Logogram.stroke(of: $0) }).compactMap({ $0 })
                let isValidSequence: Bool = !converted.isEmpty && converted.count == text.count
                if isValidSequence {
                        markedText = String(converted)
                        let lookup: [Candidate] = Engine.strokeLookup(for: transformed)
                        push(lookup)
                } else {
                        markedText = processingText
                        clearCandidates()
                }
        }
        func leungFanReverseLookup() {
                let text: String = String(processingText.dropFirst())
                guard !text.isEmpty else {
                        clearCandidates()
                        return
                }
                let lookup: [Candidate] = Engine.leungFanLookup(for: text)
                push(lookup)
        }
}
