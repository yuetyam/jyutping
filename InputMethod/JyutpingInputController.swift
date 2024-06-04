import SwiftUI
import InputMethodKit
import CommonExtensions
import CoreIME

@objc(JyutpingInputController)
final class JyutpingInputController: IMKInputController {

        // MARK: - Window, InputClient

        @MainActor
        private let window: NSPanel = {
                let panel: NSPanel = NSPanel(contentRect: .zero, styleMask: [.borderless, .nonactivatingPanel], backing: .buffered, defer: false)
                let levelValue: Int = Int(CGShieldingWindowLevel())
                panel.level = NSWindow.Level(levelValue)
                panel.isFloatingPanel = true
                panel.worksWhenModal = true
                panel.hidesOnDeactivate = false
                panel.isReleasedWhenClosed = true
                panel.collectionBehavior = .moveToActiveSpace
                panel.isMovable = true
                panel.isMovableByWindowBackground = true
                panel.isOpaque = false
                panel.hasShadow = false
                panel.backgroundColor = .clear
                return panel
        }()
        private func prepareWindow() {
                _ = window.contentView?.subviews.map({ $0.removeFromSuperview() })
                _ = window.contentViewController?.children.map({ $0.removeFromParent() })
                let idealValue: Int = Int(CGShieldingWindowLevel())
                let maxValue: Int = idealValue + 2
                let minValue: Int = NSWindow.Level.floating.rawValue
                let levelValue: Int = {
                        guard let clientLevel = currentClient?.windowLevel() else { return idealValue }
                        let preferredValue: Int = Int(clientLevel) + 1
                        guard preferredValue > minValue else { return idealValue }
                        guard preferredValue < maxValue else { return maxValue }
                        return preferredValue
                }()
                window.level = NSWindow.Level(levelValue)
                let motherBoard = NSHostingController(rootView: MotherBoard().environmentObject(appContext))
                window.contentView?.addSubview(motherBoard.view)
                motherBoard.view.translatesAutoresizingMaskIntoConstraints = false
                if let topAnchor = window.contentView?.topAnchor,
                   let bottomAnchor = window.contentView?.bottomAnchor,
                   let leadingAnchor = window.contentView?.leadingAnchor,
                   let trailingAnchor = window.contentView?.trailingAnchor {
                        NSLayoutConstraint.activate([
                                motherBoard.view.topAnchor.constraint(equalTo: topAnchor),
                                motherBoard.view.bottomAnchor.constraint(equalTo: bottomAnchor),
                                motherBoard.view.leadingAnchor.constraint(equalTo: leadingAnchor),
                                motherBoard.view.trailingAnchor.constraint(equalTo: trailingAnchor)
                        ])
                }
                window.contentViewController?.addChild(motherBoard)
                window.orderFrontRegardless()
        }
        private func clearWindow() {
                _ = window.contentView?.subviews.map({ $0.removeFromSuperview() })
                _ = window.contentViewController?.children.map({ $0.removeFromParent() })
                window.setFrame(.zero, display: true)
        }
        func updateWindowFrame(_ frame: CGRect? = nil) {
                DispatchQueue.main.async { [weak self] in
                        self?.window.setFrame(frame ?? self?.windowFrame ?? .zero, display: true)
                }
        }
        private var windowFrame: CGRect {
                let origin: CGPoint = currentOrigin ?? currentClient?.position ?? .zero
                let viewSize: CGSize = {
                        guard let size = window.contentView?.subviews.first?.bounds.size, size.width > 44 else {
                                return CGSize(width: 600, height: 600)
                        }
                        return size
                }()
                let width: CGFloat = viewSize.width
                let height: CGFloat = viewSize.height
                let x: CGFloat = {
                        if appContext.windowPattern.isReversingHorizontal {
                                return origin.x - width - 8
                        } else {
                                return origin.x
                        }
                }()
                let y: CGFloat = {
                        if appContext.windowPattern.isReversingVertical {
                                return origin.y + 16
                        } else {
                                return origin.y - height
                        }
                }()
                return CGRect(x: x, y: y, width: width, height: height)
        }

        private lazy var screenOrigin: CGPoint = NSScreen.main?.visibleFrame.origin ?? window.screen?.visibleFrame.origin ?? .zero
        private lazy var screenSize: CGSize = NSScreen.main?.visibleFrame.size ?? window.screen?.visibleFrame.size ?? CGSize(width: 1920, height: 1080)
        private lazy var currentOrigin: CGPoint? = nil
        func updateCurrentOrigin(to point: CGPoint? ) {
                guard let point else { return }
                currentOrigin = point
        }

        typealias InputClient = (IMKTextInput & NSObjectProtocol)
        private(set) lazy var currentClient: InputClient? = nil {
                didSet {
                        guard let origin = currentClient?.position else { return }
                        let orientation = AppSettings.candidatePageOrientation
                        let isRegularHorizontal: Bool = {
                                switch orientation {
                                case .horizontal:
                                        return (origin.x - screenOrigin.x) < (screenSize.width - 300)
                                case .vertical:
                                        return (origin.x - screenOrigin.x) < (screenSize.width - 300)
                                }
                        }()
                        let isRegularVertical: Bool = {
                                switch orientation {
                                case .horizontal:
                                        return (origin.y - screenOrigin.y) > 100
                                case .vertical:
                                        return (origin.y - screenOrigin.y) > 300
                                }
                        }()
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
                        guard newPattern != appContext.windowPattern else { return }
                        appContext.updateWindowPattern(to: newPattern)
                }
        }
        func updateCurrentClient(to inputClient: InputClient?) {
                guard let inputClient else { return }
                currentClient = inputClient
        }


        // MARK: - Input Server lifecycle

        override init() {
                super.init()
                activateServer(client())
        }
        override init!(server: IMKServer!, delegate: Any!, client inputClient: Any!) {
                super.init(server: server, delegate: delegate, client: inputClient)
                let currentInputClient = (inputClient as? InputClient) ?? client()
                activateServer(currentInputClient)
        }
        override func activateServer(_ sender: Any!) {
                super.activateServer(sender)
                UserLexicon.prepare()
                Engine.prepare()
                if inputStage.isBuffering {
                        clearBufferText()
                }
                if appContext.inputForm.isOptions {
                        appContext.updateInputForm()
                }
                screenOrigin = NSScreen.main?.visibleFrame.origin ?? window.screen?.visibleFrame.origin ?? .zero
                screenSize = NSScreen.main?.visibleFrame.size ?? window.screen?.visibleFrame.size ?? CGSize(width: 1920, height: 1080)
                currentClient = (sender as? InputClient) ?? client()
                currentOrigin = currentClient?.position
                DispatchQueue.main.async { [weak self] in
                        self?.prepareWindow()
                }
                DispatchQueue.main.async { [weak self] in
                        self?.currentClient?.overrideKeyboard(withKeyboardNamed: Constant.systemABCKeyboardName)
                }
        }
        override func deactivateServer(_ sender: Any!) {
                DispatchQueue.main.async { [weak self] in
                        self?.clearWindow()
                }
                let windowCount: Int = NSApp.windows.count
                if windowCount > 20 {
                        NSRunningApplication.current.terminate()
                        NSApp.terminate(self)
                        exit(1)
                } else if windowCount > 10 {
                        _ = NSApp.windows.map({ $0.close() })
                } else {
                        _ = NSApp.windows.filter({ $0.identifier != window.identifier && $0.identifier?.rawValue != Constant.preferencesWindowIdentifier}).map({ $0.close() })
                }
                selectedCandidates = []
                if appContext.inputForm.isOptions {
                        clearOptionsViewHintText()
                        appContext.updateInputForm()
                }
                if inputStage.isBuffering {
                        let text: String = bufferText
                        clearBufferText()
                        (sender as? InputClient)?.insert(text)
                }
                super.deactivateServer(sender)
        }

        private(set) lazy var appContext: AppContext = AppContext()


        // MARK: - Input Texts

        private(set) lazy var inputStage: InputStage = .standby
        lazy var bufferText: String = .empty {
                willSet {
                        switch (bufferText.isEmpty, newValue.isEmpty) {
                        case (true, true):
                                inputStage = .standby
                        case (true, false):
                                inputStage = .starting
                                UserLexicon.prepare()
                                Engine.prepare()
                        case (false, true):
                                inputStage = .ending
                        case (false, false):
                                inputStage = .ongoing
                        }
                }
                didSet {
                        switch bufferText.first {
                        case .none:
                                if AppSettings.isInputMemoryOn && !(selectedCandidates.isEmpty) {
                                        let concatenated: Candidate = selectedCandidates.filter(\.isCantonese).joined()
                                        UserLexicon.handle(concatenated)
                                }
                                selectedCandidates = []
                                clearMarkedText()
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
        func clearBufferText() {
                bufferText = .empty
        }

        private func mark(text: String) {
                let markAttributes = mark(forStyle: kTSMHiliteSelectedConvertedText, at: NSRange(location: NSNotFound, length: 0))
                let fallbackAttributes: [NSAttributedString.Key: Any] = [.underlineStyle: NSUnderlineStyle.thick.rawValue]
                let attributes = (markAttributes as? [NSAttributedString.Key: Any]) ?? fallbackAttributes
                let attributedText = NSAttributedString(string: text, attributes: attributes)
                let selectionRange = NSRange(location: text.utf16.count, length: 0)
                currentClient?.setMarkedText(attributedText, selectionRange: selectionRange, replacementRange: NSRange(location: NSNotFound, length: 0))
        }
        private func clearMarkedText() {
                let markAttributes = mark(forStyle: kTSMHiliteSelectedConvertedText, at: NSRange(location: NSNotFound, length: 0))
                let fallbackAttributes: [NSAttributedString.Key: Any] = [.underlineStyle: NSUnderlineStyle.thick.rawValue]
                let attributes = (markAttributes as? [NSAttributedString.Key: Any]) ?? fallbackAttributes
                let attributedText = NSAttributedString(string: String(), attributes: attributes)
                let selectionRange = NSRange(location: 0, length: 0)
                currentClient?.setMarkedText(attributedText, selectionRange: selectionRange, replacementRange: NSRange(location: NSNotFound, length: 0))
        }
        func markOptionsViewHintText() {
                guard !(inputStage.isBuffering) else { return }
                mark(text: String.zeroWidthSpace)
        }
        func clearOptionsViewHintText() {
                guard !(inputStage.isBuffering) else { return }
                clearMarkedText()
        }


        // MARK: - Candidates

        /// Cached Candidate sequence for UserLexicon
        lazy var selectedCandidates: [Candidate] = []

        private(set) lazy var candidates: [Candidate] = [] {
                didSet {
                        updateDisplayCandidates(.establish, highlight: .start)
                }
        }

        /// DisplayCandidates indices
        private lazy var indices: (first: Int, last: Int) = (0, 0)

        func updateDisplayCandidates(_ transformation: PageTransformation, highlight: Highlight) {
                let candidateCount: Int = candidates.count
                guard candidateCount > 0 else {
                        indices = (0, 0)
                        appContext.resetDisplayContext()
                        updateWindowFrame(.zero)
                        return
                }
                let pageSize: Int = AppSettings.displayCandidatePageSize
                let newFirstIndex: Int? = {
                        switch transformation {
                        case .establish:
                                return 0
                        case .previousPage:
                                let oldFirstIndex: Int = indices.first
                                guard oldFirstIndex > 0 else { return nil }
                                return max(0, oldFirstIndex - pageSize)
                        case .nextPage:
                                let oldLastIndex: Int = indices.last
                                let maxIndex: Int = candidateCount - 1
                                guard oldLastIndex < maxIndex else { return nil }
                                return oldLastIndex + 1
                        }
                }()
                guard let firstIndex: Int = newFirstIndex else { return }
                let bound: Int = min(firstIndex + pageSize, candidateCount)
                indices = (firstIndex, bound - 1)
                let newDisplayCandidates = (firstIndex..<bound).map({ index -> DisplayCandidate in
                        return DisplayCandidate(candidate: candidates[index], candidateIndex: index)
                })
                appContext.update(with: newDisplayCandidates, highlight: highlight)
                updateWindowFrame()
        }


        // MARK: - Candidate Suggestions

        private func suggest() {
                let processingText: String = bufferText.toneConverted()
                let segmentation = Segmentor.segment(text: processingText)
                let userLexiconCandidates: [Candidate] = AppSettings.isInputMemoryOn ? UserLexicon.suggest(text: processingText, segmentation: segmentation) : []
                let needsSymbols: Bool = Options.isEmojiSuggestionsOn && selectedCandidates.isEmpty
                let asap: Bool = !(userLexiconCandidates.isEmpty)
                let engineCandidates: [Candidate] = Engine.suggest(origin: bufferText, text: processingText, segmentation: segmentation, needsSymbols: needsSymbols, asap: asap)
                let text2mark: String = {
                        if let mark = userLexiconCandidates.first?.mark { return mark }
                        let hasSeparatorsOrTones: Bool = processingText.contains(where: \.isSeparatorOrTone)
                        guard !hasSeparatorsOrTones else { return processingText.formattedForMark() }
                        let userInputTextCount: Int = processingText.count
                        if let firstCandidate = engineCandidates.first, firstCandidate.input.count == userInputTextCount { return firstCandidate.mark }
                        guard let bestScheme = segmentation.first else { return processingText.formattedForMark() }
                        let leadingLength: Int = bestScheme.length
                        let leadingText: String = bestScheme.map(\.text).joined(separator: String.space)
                        guard leadingLength != userInputTextCount else { return leadingText }
                        let tailText = processingText.dropFirst(leadingLength)
                        return leadingText + String.space + tailText
                }()
                mark(text: text2mark)
                candidates = (userLexiconCandidates + engineCandidates).map({ $0.transformed(to: Options.characterStandard) }).uniqued()
        }
        private func pinyinReverseLookup() {
                let text: String = String(bufferText.dropFirst())
                guard !(text.isEmpty) else {
                        mark(text: bufferText)
                        candidates = []
                        return
                }
                let schemes: [[String]] = PinyinSegmentor.segment(text: text)
                let suggestions: [Candidate] = Engine.pinyinReverseLookup(text: text, schemes: schemes)
                let tailText2Mark: String = {
                        if let firstCandidate = suggestions.first, firstCandidate.input.count == text.count { return firstCandidate.mark }
                        guard let bestScheme = schemes.first else { return text }
                        let leadingLength: Int = bestScheme.summedLength
                        let leadingText: String = bestScheme.joined(separator: " ")
                        guard leadingLength != text.count else { return leadingText }
                        let tailText = text.dropFirst(leadingLength)
                        return leadingText + " " + tailText
                }()
                let text2mark: String = "r " + tailText2Mark
                mark(text: text2mark)
                candidates = suggestions.map({ $0.transformed(to: Options.characterStandard) }).uniqued()
        }
        private func cangjieReverseLookup() {
                let text: String = String(bufferText.dropFirst())
                let converted = text.compactMap({ CharacterStandard.cangjie(of: $0) })
                let isValidSequence: Bool = !(converted.isEmpty) && (converted.count == text.count)
                if isValidSequence {
                        mark(text: String(converted))
                        let lookup: [Candidate] = Engine.cangjieReverseLookup(text: text, variant: AppSettings.cangjieVariant)
                        candidates = lookup.map({ $0.transformed(to: Options.characterStandard) }).uniqued()
                } else {
                        mark(text: bufferText)
                        candidates = []
                }
        }
        private func strokeReverseLookup() {
                let text: String = String(bufferText.dropFirst())
                let transformed: String = CharacterStandard.strokeTransform(text)
                let converted = transformed.compactMap({ CharacterStandard.stroke(of: $0) })
                let isValidSequence: Bool = !(converted.isEmpty) && (converted.count == text.count)
                if isValidSequence {
                        mark(text: String(converted))
                        let lookup: [Candidate] = Engine.strokeReverseLookup(text: transformed)
                        candidates = lookup.map({ $0.transformed(to: Options.characterStandard) }).uniqued()
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
                        let hasSeparatorsOrTones: Bool = text.contains(where: \.isSeparatorOrTone)
                        guard !hasSeparatorsOrTones else { return text.formattedForMark() }
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
                candidates = lookup.map({ $0.transformed(to: Options.characterStandard) }).uniqued()
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
                        case PunctuationKey.quote.keyText:
                                return PunctuationKey.quote.symbols
                        case PunctuationKey.quote.shiftingKeyText:
                                return PunctuationKey.quote.shiftingSymbols
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
                                return []
                        }
                }()
                candidates = symbols.map({ Candidate(text: $0.symbol, comment: $0.comment, secondaryComment: $0.secondaryComment, input: bufferText) })
        }
}
