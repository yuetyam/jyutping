import SwiftUI
import InputMethodKit
import CommonExtensions
import CoreIME

@objc(JyutpingInputController)
final class JyutpingInputController: IMKInputController {

        /// CandidateBoard Window
        lazy var window: NSWindow? = nil
        let windowOffset: CGFloat = 10

        private(set) lazy var windowPattern: WindowPattern = .regular

        lazy var currentOrigin: CGPoint? = nil
        lazy var currentClient: IMKTextInput? = nil {
                didSet {
                        guard let origin = currentClient?.position else { return }
                        let screenWidth: CGFloat = NSScreen.main?.frame.size.width ?? 1920
                        let isRegularHorizontal: Bool = origin.x < (screenWidth - 400)
                        let isRegularVertical: Bool = origin.y > 400
                        let newPattern: WindowPattern = {
                                switch (isRegularHorizontal, isRegularVertical) {
                                case (true, true):
                                        return .regular
                                case (false, true):
                                        return .horizontalReversed
                                case (true, false):
                                        return .verticalReversed
                                case (false, false):
                                        return .reversed
                                }
                        }()
                        guard newPattern != windowPattern else { return }
                        windowPattern = newPattern
                        if window != nil {
                                resetWindow()
                        }
                }
        }

        override func activateServer(_ sender: Any!) {
                currentClient = sender as? IMKTextInput
                currentOrigin = currentClient?.position
                DispatchQueue.main.async { [weak self] in
                        self?.currentClient?.overrideKeyboard(withKeyboardNamed: "com.apple.keylayout.ABC")
                }
                UserLexicon.prepare()
                Engine.prepare()
                if InputState.current.isSwitches {
                        InputState.updateCurrent()
                }
                if isBufferState {
                        clearBufferText()
                }
        }
        override func deactivateServer(_ sender: Any!) {
                candidateSequence = []
                unmarkText()
                window?.setFrame(.zero, display: true)
        }

        private(set) lazy var candidates: [Candidate] = [] {
                willSet {
                        if window == nil {
                                resetWindow()
                        }
                }
                didSet {
                        updateDisplayingCandidates(.establish, highlight: .start)
                        switch (oldValue.isEmpty, candidates.isEmpty) {
                        case (true, true):
                                // Stay empty
                                break
                        case (true, false):
                                // Starting
                                adjustCandidateWindow()
                        case (false, true):
                                // Ending
                                window?.setFrame(.zero, display: true)
                        case (false, false):
                                // Ongoing
                                adjustCandidateWindow()
                        }
                }
        }
        private func adjustCandidateWindow() {
                window?.setFrame(windowFrame(), display: true)
                /*
                let expanded: CGFloat = windowOffset * 2
                guard let size: CGSize = window?.contentView?.subviews.first?.frame.size else { return }
                guard size.width > 44 else { return }
                let windowSize: CGSize = CGSize(width: size.width + expanded, height: size.height + expanded)
                window?.setFrame(windowFrame(size: windowSize), display: true)
                */
        }

        lazy var displayObject = DisplayObject()
        lazy var settingsObject = InstantSettingsObject()

        /// DisplayCandidates indices
        private lazy var indices: (first: Int, last: Int) = (0, 0)

        func updateDisplayingCandidates(_ mode: PageTransformation, highlight: Highlight) {
                guard !candidates.isEmpty else {
                        indices = (0, 0)
                        displayObject.reset()
                        return
                }
                let pageSize: Int = AppSettings.displayCandidatePageSize
                let newFirstIndex: Int? = {
                        switch mode {
                        case .establish:
                                return 0
                        case .previousPage:
                                let oldFirstIndex: Int = indices.first
                                guard oldFirstIndex > 0 else { return nil }
                                return max(0, oldFirstIndex - pageSize)
                        case .nextPage:
                                let oldLastIndex: Int = indices.last
                                guard oldLastIndex < candidates.count - 1 else { return nil }
                                return oldLastIndex + 1
                        }
                }()
                guard let firstIndex: Int = newFirstIndex else { return }
                let bound: Int = min(firstIndex + pageSize, candidates.count)
                indices = (firstIndex, bound - 1)
                let newItems = (firstIndex..<bound).map({ index -> DisplayCandidate in
                        return DisplayCandidate(candidate: candidates[index], candidateIndex: index)
                })
                displayObject.update(with: newItems, highlight: highlight)
        }

        lazy var candidateSequence: [Candidate] = []

        func clearBufferText() {
                bufferText = .empty
        }
        var isBufferState: Bool {
                return !(bufferText.isEmpty)
        }
        lazy var bufferText: String = .empty {
                willSet {
                        switch (bufferText.isEmpty, newValue.isEmpty) {
                        case (true, true):
                                // Stay empty
                                break
                        case (true, false):
                                // Starting
                                UserLexicon.prepare()
                                Engine.prepare()
                        case (false, true):
                                // Ending
                                let shouldHandleCandidateSequence: Bool = !(candidateSequence.isEmpty)
                                guard shouldHandleCandidateSequence else { return }
                                let concatenated: Candidate = candidateSequence.joined()
                                candidateSequence = []
                                UserLexicon.handle(concatenated)
                        case (false, false):
                                // Ongoing
                                break
                        }
                }
                didSet {
                        indices = (0, 0)
                        switch bufferText.first {
                        case .none:
                                unmarkText()
                                candidates = []
                        case .some("r"):
                                pinyinReverseLookup()
                        case .some("v"):
                                cangjieReverseLookup()
                        case .some("x"):
                                strokeReverseLookup()
                        case .some("q"):
                                composeReverseLookup()
                        case .some(let character) where character.isBasicLatinLetter:
                                suggest()
                        default:
                                mark(text: bufferText)
                                handlePunctuation()
                        }
                }
        }

        private func mark(text: String) {
                currentClient?.mark(text)
        }
        private func unmarkText() {
                currentClient?.clearMarkedText()
        }


        // MARK: - Candidate Suggestion

        private func suggest() {
                let processingText = bufferText.toneConverted()
                let segmentation = Segmentor.segment(text: processingText)
                let text2mark: String = {
                        let isMarkFree: Bool = processingText.first(where: { $0.isSeparatorOrTone }) == nil
                        guard isMarkFree else { return processingText.formattedForMark() }
                        guard let bestScheme = segmentation.first else { return processingText.formattedForMark() }
                        let leadingLength: Int = bestScheme.length
                        let leadingText: String = bestScheme.map(\.text).joined(separator: " ")
                        guard leadingLength != processingText.count else { return leadingText }
                        let tailText = processingText.dropFirst(leadingLength)
                        return leadingText + " " + tailText
                }()
                mark(text: text2mark)
                let engineCandidates: [Candidate] = {
                        var suggestion: [Candidate] = Engine.suggest(text: processingText, segmentation: segmentation)
                        let shouldContinue: Bool = InstantSettings.needsEmojiCandidates && !suggestion.isEmpty && candidateSequence.isEmpty
                        guard shouldContinue else { return suggestion }
                        let symbols: [Candidate] = Engine.searchSymbols(text: bufferText, segmentation: segmentation)
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
                candidates = combined.map({ $0.transformed(to: Logogram.current) }).uniqued()
        }

        private func pinyinReverseLookup() {
                let text: String = String(bufferText.dropFirst())
                guard !(text.isEmpty) else {
                        mark(text: bufferText)
                        candidates = []
                        return
                }
                let schemes: [[String]] = PinyinSegmentor.segment(text: text)
                let tailMarkedText: String = {
                        guard let bestScheme = schemes.first else { return text }
                        let leadingLength: Int = bestScheme.summedLength
                        let leadingText: String = bestScheme.joined(separator: " ")
                        guard leadingLength != text.count else { return leadingText }
                        let tailText = text.dropFirst(leadingLength)
                        return leadingText + " " + tailText
                }()
                let text2mark: String = "r " + tailMarkedText
                mark(text: text2mark)
                let lookup: [Candidate] = Engine.pinyinReverseLookup(text: text, schemes: schemes)
                candidates = lookup.map({ $0.transformed(to: Logogram.current) }).uniqued()
        }

        private func cangjieReverseLookup() {
                let text: String = String(bufferText.dropFirst())
                let converted = text.map({ Logogram.cangjie(of: $0) }).compactMap({ $0 })
                let isValidSequence: Bool = !converted.isEmpty && converted.count == text.count
                if isValidSequence {
                        mark(text: String(converted))
                        let lookup: [Candidate] = Engine.cangjieLookup(for: text)
                        candidates = lookup.map({ $0.transformed(to: Logogram.current) }).uniqued()
                } else {
                        mark(text: bufferText)
                        candidates = []
                }
        }
        private func strokeReverseLookup() {
                let text: String = String(bufferText.dropFirst())
                let transformed: String = Logogram.strokeTransform(text)
                let converted = transformed.map({ Logogram.stroke(of: $0) }).compactMap({ $0 })
                let isValidSequence: Bool = !converted.isEmpty && converted.count == text.count
                if isValidSequence {
                        mark(text: String(converted))
                        let lookup: [Candidate] = Engine.strokeLookup(for: transformed)
                        candidates = lookup.map({ $0.transformed(to: Logogram.current) }).uniqued()
                } else {
                        mark(text: bufferText)
                        candidates = []
                }
        }

        /// Compose(LoengFan) Reverse Lookup
        private func composeReverseLookup() {
                guard bufferText.count > 2 else {
                        mark(text: bufferText)
                        candidates = []
                        return
                }
                let text = bufferText.dropFirst().toneConverted()
                let segmentation = Segmentor.segment(text: text)
                let tailMarkedText: String = {
                        let isMarkFree: Bool = text.first(where: { $0.isSeparatorOrTone }) == nil
                        guard isMarkFree else { return text.formattedForMark() }
                        guard let bestScheme = segmentation.first else { return text.formattedForMark() }
                        let leadingLength: Int = bestScheme.length
                        let leadingText: String = bestScheme.map(\.text).joined(separator: " ")
                        guard leadingLength != text.count else { return leadingText }
                        let tailText = text.dropFirst(leadingLength)
                        return leadingText + " " + tailText
                }()
                let text2mark: String = "q " + tailMarkedText
                mark(text: text2mark)
                let lookup: [Candidate] = Engine.composeReverseLookup(text: text, input: bufferText, segmentation: segmentation)
                candidates = lookup.map({ $0.transformed(to: Logogram.current) }).uniqued()
        }

        private func handlePunctuation() {
                let symbols: [PunctuationSymbol] = {
                        switch bufferText {
                        case PunctuationKey.comma.shiftingKeyText:
                                return PunctuationKey.comma.shiftingSymbols
                        case PunctuationKey.period.shiftingKeyText:
                                return PunctuationKey.period.shiftingSymbols
                        case PunctuationKey.slash.keyText:
                                return PunctuationKey.slash.symbols
                        case PunctuationKey.bracketLeft.shiftingKeyText:
                                return PunctuationKey.bracketLeft.shiftingSymbols
                        case PunctuationKey.bracketRight.shiftingKeyText:
                                return PunctuationKey.bracketRight.shiftingSymbols
                        case PunctuationKey.backSlash.shiftingKeyText:
                                return PunctuationKey.backSlash.shiftingSymbols
                        case PunctuationKey.backquote.keyText:
                                return PunctuationKey.backquote.symbols
                        case PunctuationKey.backquote.shiftingKeyText:
                                return PunctuationKey.backquote.shiftingSymbols
                        default:
                                return PunctuationKey.slash.symbols
                        }
                }()
                candidates = symbols.map({ Candidate(text: $0.symbol, comment: $0.comment, secondaryComment: $0.secondaryComment, input: bufferText) })
        }
}

// TODO: - Move this to a separate file
/// DisplayCandidate page transformation
enum PageTransformation {
        case establish
        case previousPage
        case nextPage
}
