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
                        let isRegularHorizontal: Bool = origin.x < (screenWidth - 600)
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
                UserLexicon.prepare()
                Lychee.prepare()
                DispatchQueue.main.async { [weak self] in
                        self?.currentClient?.overrideKeyboard(withKeyboardNamed: "com.apple.keylayout.ABC")
                }
                if !bufferText.isEmpty {
                        bufferText = .empty
                }
        }
        override func deactivateServer(_ sender: Any!) {
                markedText = .empty
                candidateSequence = []
                window?.setFrame(.zero, display: true)
        }

        private(set) lazy var candidates: [Candidate] = [] {
                willSet {
                        if window == nil {
                                resetWindow()
                        }
                }
                didSet {
                        updateDisplayingCandidates(.establish)
                        switch (oldValue.isEmpty, candidates.isEmpty) {
                        case (true, true):
                                // Stay empty
                                break
                        case (true, false):
                                // Starting
                                window?.setFrame(currentWindowFrame, display: true)
                        case (false, true):
                                // Ending
                                window?.setFrame(.zero, display: true)
                        case (false, false):
                                // Ongoing
                                window?.setFrame(currentWindowFrame, display: true)
                        }
                }
        }
        func push(_ origin: [Candidate]) {
                candidates = origin.map({ $0.transformed(to: Logogram.current) }).uniqued()
        }
        func empty() {
                candidates = []
        }

        lazy var displayObject = DisplayObject()
        lazy var settingsObject = InstantSettingsObject()

        /// DisplayCandidates indices
        lazy var indices: (first: Int, last: Int) = (0, 0)

        func updateDisplayingCandidates(_ mode: CandidatesTransformation) {
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
                displayObject.update(with: newItems)
        }

        var isBufferState: Bool {
                return !(bufferText.isEmpty)
        }
        lazy var bufferText: String = .empty {
                willSet {
                        let shouldHandleCandidateSequence: Bool = !(candidateSequence.isEmpty) && newValue.isEmpty
                        guard shouldHandleCandidateSequence else { return }
                        let concatenatedCandidate: Candidate = candidateSequence.joined()
                        candidateSequence = []
                        UserLexicon.handle(concatenatedCandidate)
                }
                didSet {
                        indices = (0, 0)
                        switch bufferText.first {
                        case .none:
                                processingText = .empty
                        case .some("r"), .some("v"), .some("x"), .some("q"):
                                processingText = bufferText
                        case .some(let character) where character.isBasicLatinLetter:
                                processingText = bufferText.replacingOccurrences(of: "vv", with: "4")
                                        .replacingOccurrences(of: "xx", with: "5")
                                        .replacingOccurrences(of: "qq", with: "6")
                                        .replacingOccurrences(of: "v", with: "1")
                                        .replacingOccurrences(of: "x", with: "2")
                                        .replacingOccurrences(of: "q", with: "3")
                        default:
                                processingText = bufferText
                        }
                }
        }
        private(set) lazy var processingText: String = .empty {
                willSet {
                        let isStarting: Bool = processingText.isEmpty && !newValue.isEmpty
                        guard isStarting else { return }
                        Lychee.prepare()
                        UserLexicon.prepare()
                }
                didSet {
                        switch processingText.first {
                        case .none:
                                segmentation = []
                                markedText = .empty
                                candidates = []
                                displayObject.reset()
                        case .some("r"):
                                segmentation = []
                                markedText = processingText
                                pinyinReverseLookup()
                        case .some("v"):
                                segmentation = []
                                cangjieReverseLookup()
                        case .some("x"):
                                segmentation = []
                                strokeReverseLookup()
                        case .some("q"):
                                segmentation = []
                                markedText = processingText
                                leungFanReverseLookup()
                        case .some(let character) where character.isBasicLatinLetter:
                                segmentation = Segmentor.segment(processingText)
                                markedText = {
                                        guard !(processingText.contains("'")) else { return processingText.replacingOccurrences(of: "'", with: "' ") }
                                        guard let bestScheme = segmentation.first else { return processingText }
                                        let leading: String = bestScheme.joined(separator: " ")
                                        let isFullScheme: Bool = bestScheme.length == processingText.count
                                        guard !isFullScheme else { return leading }
                                        let tail = processingText.dropFirst(bestScheme.length)
                                        return leading + " " + tail
                                }()
                                suggest()
                        default:
                                segmentation = []
                                markedText = processingText
                                let symbols: [PunctuationSymbol] = {
                                        switch processingText {
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
                                candidates = symbols.map({ Candidate(key: bufferText, symbol: $0.symbol, comment: $0.comment, secondaryComment: $0.secondaryComment) })
                        }
                }
        }

        lazy var markedText: String = .empty {
                didSet {
                        let convertedText: NSString = markedText as NSString
                        currentClient?.setMarkedText(convertedText, selectionRange: NSRange(location: convertedText.length, length: 0), replacementRange: NSRange(location: NSNotFound, length: 0))
                }
        }

        lazy var candidateSequence: [Candidate] = []

        /// Flexible Segmentation
        private(set) lazy var segmentation: Segmentation = []
}

enum CandidatesTransformation {
        case establish
        case previousPage
        case nextPage
}
