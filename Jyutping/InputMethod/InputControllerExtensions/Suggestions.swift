import CoreIME

extension JyutpingInputController {

        func suggest() {
                let engineCandidates: [Candidate] = {
                        var suggestion: [Candidate] = Engine.suggest(text: processingText, segmentation: segmentation)
                        let shouldContinue: Bool = InstantSettings.needsEmojiCandidates && !suggestion.isEmpty && candidateSequence.isEmpty
                        guard shouldContinue else { return suggestion }
                        let symbols: [Candidate] = Engine.searchEmojiSymbols(for: bufferText)
                        guard !(symbols.isEmpty) else { return suggestion }
                        for symbol in symbols.reversed() {
                                if let index = suggestion.firstIndex(where: { $0.lexiconText == symbol.lexiconText }) {
                                        suggestion.insert(symbol, at: index + 1)
                                }
                        }
                        return suggestion
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
