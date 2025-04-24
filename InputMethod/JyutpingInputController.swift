import SwiftUI
import InputMethodKit
import os.log
import CommonExtensions
import CoreIME

@MainActor
final class JyutpingInputController: IMKInputController, Sendable {

        // MARK: - Window, InputClient

        private lazy var logger = Logger.shared

        /// NSPanel for CandidateBoard and OptionsView
        private lazy var window = CandidateWindow.shared

        private func prepareWindow() {
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
                window.contentViewController = NSHostingController(rootView: MotherBoard().environmentObject(appContext))
                window.orderFrontRegardless()
        }
        @objc private func handleContentSizeChanged(_ notification: Notification) {
                guard let useInfo = notification.userInfo else { return }
                guard let contentSize = useInfo[NotificationKey.contentSize] as? CGSize else { return }
                guard contentSize.width > 2 else { return }
                Task.detached { @MainActor in
                        self.window.setFrame(self.computeWindowFrame(size: contentSize), display: true)
                }
        }
        private func updateWindowFrame(_ frame: CGRect? = nil) {
                window.setFrame(frame ?? computeWindowFrame(), display: true)
        }
        private func computeWindowFrame(size: CGSize? = nil) -> CGRect {
                let quadrant = appContext.quadrant
                let position: CGPoint = {
                        guard let cursorBlock = currentCursorBlock ?? currentClient?.cursorBlock else { return screenOrigin }
                        let x: CGFloat = quadrant.isNegativeHorizontal ? cursorBlock.origin.x : cursorBlock.maxX
                        let y: CGFloat = quadrant.isNegativeVertical ? cursorBlock.origin.y : cursorBlock.maxY
                        guard (x > screenOrigin.x) && (x < maxPointX) && (y > screenOrigin.y) && (y < maxPointY) else { return screenOrigin }
                        return CGPoint(x: x, y: y)
                }()
                let width: CGFloat = switch quadrant {
                case .upperRight:
                        CGFloat.zero
                case .upperLeft:
                        size?.width ?? 800
                case .bottomLeft:
                        size?.width ?? 800
                case .bottomRight:
                        44
                }
                let height: CGFloat = switch quadrant {
                case .upperRight:
                        CGFloat.zero
                case .upperLeft:
                        CGFloat.zero
                case .bottomLeft:
                        44
                case .bottomRight:
                        44
                }
                let x: CGFloat = quadrant.isNegativeHorizontal ? (position.x - width) : position.x
                let y: CGFloat = quadrant.isNegativeVertical ? (position.y - height) : position.y
                return CGRect(x: x, y: y, width: width, height: height)
        }

        private lazy var screenOrigin: CGPoint = NSScreen.main?.visibleFrame.origin ?? window.screen?.visibleFrame.origin ?? .zero
        private lazy var screenSize: CGSize = NSScreen.main?.visibleFrame.size ?? window.screen?.visibleFrame.size ?? CGSize(width: 1280, height: 800)
        private var maxPointX: CGFloat { screenOrigin.x + screenSize.width }
        private var maxPointY: CGFloat { screenOrigin.y + screenSize.height }
        private var maxPoint: CGPoint { CGPoint(x: maxPointX, y: maxPointY) }
        private lazy var currentCursorBlock: CGRect? = nil
        private func updateCurrentCursorBlock(to rect: CGRect?) {
                guard let point = rect?.origin else { return }
                guard (point.x > screenOrigin.x) && (point.x < maxPointX) && (point.y > screenOrigin.y) && (point.y < maxPointY) else { return }
                currentCursorBlock = rect
        }

        private typealias InputClient = (IMKTextInput & NSObjectProtocol)
        private lazy var currentClient: InputClient? = nil {
                didSet {
                        let position: CGPoint = {
                                guard let point = currentClient?.cursorBlock.origin else { return screenOrigin }
                                guard (point.x > screenOrigin.x) && (point.x < maxPointX) && (point.y > screenOrigin.y) && (point.y < maxPointY) else { return screenOrigin }
                                return point
                        }()
                        let orientation = AppSettings.candidatePageOrientation
                        let isPositiveHorizontal: Bool = switch orientation {
                        case .horizontal:
                                (maxPointX - position.x) > 450
                        case .vertical:
                                (maxPointX - position.x) > 300
                        }
                        let isPositiveVertical: Bool = switch orientation {
                        case .horizontal:
                                (position.y - screenOrigin.y) < 100
                        case .vertical:
                                (position.y - screenOrigin.y) < 300
                        }
                        let newQuadrant: Quadrant = switch (isPositiveHorizontal, isPositiveVertical) {
                        case (true, true):
                                Quadrant.upperRight
                        case (false, true):
                                Quadrant.upperLeft
                        case (true, false):
                                Quadrant.bottomRight
                        case (false, false):
                                Quadrant.bottomLeft
                        }
                        if newQuadrant != appContext.quadrant {
                                appContext.updateQuadrant(to: newQuadrant)
                        }
                }
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
                NotificationCenter.default.removeObserver(self)
                nonisolated(unsafe) let client: InputClient? = (sender as? InputClient) ?? client()
                Task { @MainActor in
                        suggestionTask?.cancel()
                        UserLexicon.prepare()
                        Engine.prepare()
                        if inputStage.isBuffering {
                                clearBufferText()
                        }
                        inputStage = .standby
                        if inputForm.isOptions {
                                updateInputForm()
                        }
                        screenOrigin = NSScreen.main?.visibleFrame.origin ?? window.screen?.visibleFrame.origin ?? .zero
                        screenSize = NSScreen.main?.visibleFrame.size ?? window.screen?.visibleFrame.size ?? CGSize(width: 1280, height: 800)
                        currentClient = client
                        updateCurrentCursorBlock(to: client?.cursorBlock)
                        prepareWindow()
                        client?.overrideKeyboard(withKeyboardNamed: PresetConstant.systemABCKeyboardLayout)
                }
                NotificationCenter.default.addObserver(self, selector: #selector(handleContentSizeChanged(_:)), name: .contentSize, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(highlightIndex(_:)), name: .highlightIndex, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(selectIndex(_:)), name: .selectIndex, object: nil)
        }
        override func deactivateServer(_ sender: Any!) {
                nonisolated(unsafe) let client: InputClient? = (sender as? InputClient) ?? client()
                Task { @MainActor in
                        guard inputStage != .idle else { return }
                        suggestionTask?.cancel()
                        window.setFrame(.zero, display: true)
                        selectedCandidates = []
                        if inputStage.isBuffering {
                                let text: String = bufferText
                                clearBufferText()
                                client?.insertText(text as NSString, replacementRange: replacementRange())
                        } else {
                                clearMarkedText()
                        }
                        if inputForm.isOptions {
                                updateInputForm()
                        }
                        let activatingWindowCount = NSApp.windows.count(where: { $0.windowNumber > 0 })
                        if activatingWindowCount > 30 {
                                logger.fault("Jyutping Input Method terminated due to it contained more than 30 windows")
                                fatalError("Jyutping Input Method terminated due to it contained more than 30 windows")
                        } else if activatingWindowCount > 20 {
                                logger.warning("Jyutping Input Method containing more than 20 windows")
                                NSApp.windows.filter({ $0 != window }).forEach({ $0.close() })
                        } else if activatingWindowCount > 10 {
                                logger.notice("Jyutping Input Method containing more than 10 windows")
                        }
                }
                NotificationCenter.default.removeObserver(self)
                super.deactivateServer(sender)
        }
        override func commitComposition(_ sender: Any!) {
                guard inputStage.isBuffering.negative else { return }
                nonisolated(unsafe) let client: InputClient? = (sender as? InputClient) ?? client()
                Task { @MainActor in
                        suggestionTask?.cancel()
                        window.setFrame(.zero, display: true)
                        selectedCandidates = []
                        if inputStage.isBuffering {
                                let text: String = bufferText
                                clearBufferText()
                                client?.insertText(text as NSString, replacementRange: replacementRange())
                        } else {
                                clearMarkedText()
                        }
                        if inputForm.isOptions {
                                updateInputForm()
                        }
                        inputStage = .idle
                }

                // Do NOT use this line or it will freeze the entire IME
                // super.commitComposition(sender)
        }

        @objc private func highlightIndex(_ notification: Notification) {
                guard let userInfo = notification.userInfo else { return }
                guard let newIndex = userInfo[NotificationKey.highlightIndex] as? Int else { return }
                Task { @MainActor in
                        switch inputForm {
                        case .cantonese:
                                appContext.updateHighlightedIndex(to: newIndex)
                        case .transparent:
                                break
                        case .options:
                                appContext.updateOptionsHighlightedIndex(to: newIndex)
                        }
                }
        }
        @objc private func selectIndex(_ notification: Notification) {
                guard let userInfo = notification.userInfo else { return }
                guard let selectedIndex = userInfo[NotificationKey.selectIndex] as? Int else { return }
                Task { @MainActor in
                        switch inputForm {
                        case .cantonese:
                                guard let selected = appContext.displayCandidates.fetch(selectedIndex) else { return }
                                insert(selected.text)
                                aftercareSelection(selected)
                        case .transparent:
                                break
                        case .options:
                                handleOptions(selectedIndex)
                        }
                }
        }

        private lazy var appContext: AppContext = AppContext()

        nonisolated(unsafe) private var inputForm: InputForm = InputForm.matchInputMethodMode()
        private func updateInputForm(to form: InputForm? = nil) {
                let newForm: InputForm = form ?? InputForm.matchInputMethodMode()
                inputForm = newForm
                appContext.updateInputForm(to: newForm)
        }

        nonisolated(unsafe) private var inputStage: InputStage = .standby

        private func clearBufferText() { bufferText = String.empty }
        private lazy var bufferText: String = String.empty {
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
                                suggestionTask?.cancel()
                                if AppSettings.isInputMemoryOn && selectedCandidates.isNotEmpty {
                                        let concatenated = selectedCandidates.joined()
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
                                structureReverseLookup()
                        case .some(let character) where character.isBasicLatinLetter:
                                suggest()
                        default:
                                mark(text: bufferText)
                                candidates = PunctuationKey.punctuationCandidates(of: bufferText)
                        }
                }
        }

        private func insert(_ text: String) {
                let shouldClearMarkedText: Bool = inputStage.isBuffering.negative
                // let replacementRange = NSRange(location: NSNotFound, length: 0)
                currentClient?.insertText(text as NSString, replacementRange: replacementRange())
                if shouldClearMarkedText {
                        clearMarkedText()
                }
        }
        private func mark(text: String) {
                let attributedText = NSAttributedString(string: text, attributes: markAttributes)
                let selectionRange = NSRange(location: text.utf16.count, length: 0)
                currentClient?.setMarkedText(attributedText, selectionRange: selectionRange, replacementRange: replacementRange())
        }
        private func clearMarkedText() {
                let attributedText = NSAttributedString(string: String.empty, attributes: markAttributes)
                let selectionRange = NSRange(location: 0, length: 0)
                currentClient?.setMarkedText(attributedText, selectionRange: selectionRange, replacementRange: replacementRange())
        }
        private lazy var markAttributes: [NSAttributedString.Key: Any] = {
                let attributes = mark(forStyle: kTSMHiliteSelectedConvertedText, at: replacementRange())
                return (attributes as? [NSAttributedString.Key: Any]) ?? [.underlineStyle: NSUnderlineStyle.thick.rawValue]
        }()

        private func markOptionsViewHintText() {
                guard inputStage.isBuffering.negative else { return }
                mark(text: String.zeroWidthSpace)
        }
        private func clearOptionsViewHintText() {
                guard inputStage.isBuffering.negative else { return }
                clearMarkedText()
        }


        // MARK: - Candidates

        /// Cached Candidate sequence for UserLexicon
        private lazy var selectedCandidates: [Candidate] = []

        private lazy var candidates: [Candidate] = [] {
                didSet {
                        updateDisplayCandidates(.establish, highlight: .start)
                }
        }

        /// DisplayCandidates indices
        private lazy var indices: (first: Int, last: Int) = (0, 0)

        private func updateDisplayCandidates(_ transformation: PageTransformation, highlight: Highlight) {
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
                updateWindowFrame()
                let newDisplayCandidates = (firstIndex..<bound).map({ index -> DisplayCandidate in
                        return DisplayCandidate(candidate: candidates[index], candidateIndex: index)
                })
                appContext.update(with: newDisplayCandidates, highlight: highlight)
        }


        // MARK: - Candidate Suggestions

        private lazy var suggestionTask: Task<Void, Never>? = nil
        private func suggest() {
                suggestionTask?.cancel()
                let originalText = bufferText
                let processingText: String = bufferText.toneConverted()
                let needsSymbols: Bool = Options.isEmojiSuggestionsOn && selectedCandidates.isEmpty
                let isInputMemoryOn: Bool = AppSettings.isInputMemoryOn
                suggestionTask = Task.detached(priority: .high) { [weak self] in
                        let segmentation = Segmentor.segment(text: processingText)
                        let bestScheme = segmentation.first
                        async let userLexiconCandidates: [Candidate] = isInputMemoryOn ? UserLexicon.suggest(text: processingText, segmentation: segmentation) : []
                        async let engineCandidates: [Candidate] = Engine.suggest(origin: originalText, text: processingText, segmentation: segmentation, needsSymbols: needsSymbols)
                        let suggestions = await (userLexiconCandidates + engineCandidates).transformed(with: Options.characterStandard)
                        if Task.isCancelled.negative {
                                await MainActor.run { [weak self] in
                                        self?.mark(text: {
                                                let hasSeparatorsOrTones: Bool = processingText.contains(where: \.isSeparatorOrTone)
                                                guard hasSeparatorsOrTones.negative else { return processingText.formattedForMark() }
                                                let userInputTextCount: Int = processingText.count
                                                if let firstCandidate = suggestions.first, firstCandidate.inputCount == userInputTextCount { return firstCandidate.mark }
                                                guard let bestScheme else { return processingText.formattedForMark() }
                                                let leadingLength: Int = bestScheme.length
                                                let leadingText: String = bestScheme.map(\.text).joined(separator: String.space)
                                                guard leadingLength != userInputTextCount else { return leadingText }
                                                let tailText = processingText.dropFirst(leadingLength)
                                                return leadingText + String.space + tailText
                                        }())
                                        self?.candidates = suggestions
                                }
                        }
                }
        }
        private func pinyinReverseLookup() {
                let text: String = String(bufferText.dropFirst())
                guard text.isNotEmpty else {
                        mark(text: bufferText)
                        candidates = []
                        return
                }
                let schemes: [[String]] = PinyinSegmentor.segment(text: text)
                let suggestions: [Candidate] = Engine.pinyinReverseLookup(text: text, schemes: schemes)
                let tailText2Mark: String = {
                        if let firstCandidate = suggestions.first, firstCandidate.inputCount == text.count { return firstCandidate.mark }
                        guard let bestScheme = schemes.first else { return text }
                        let leadingLength: Int = bestScheme.summedLength
                        let leadingText: String = bestScheme.joined(separator: String.space)
                        guard leadingLength != text.count else { return leadingText }
                        let tailText = text.dropFirst(leadingLength)
                        return leadingText + String.space + tailText
                }()
                let text2mark: String = "r " + tailText2Mark
                mark(text: text2mark)
                candidates = suggestions.transformed(to: Options.characterStandard).uniqued()
        }
        private func cangjieReverseLookup() {
                let text: String = String(bufferText.dropFirst())
                let converted = text.compactMap({ CharacterStandard.cangjie(of: $0) })
                let isValidSequence: Bool = converted.isNotEmpty && (converted.count == text.count)
                if isValidSequence {
                        mark(text: String(converted))
                        let lookup: [Candidate] = Engine.cangjieReverseLookup(text: text, variant: AppSettings.cangjieVariant)
                        candidates = lookup.transformed(to: Options.characterStandard).uniqued()
                } else {
                        mark(text: bufferText)
                        candidates = []
                }
        }
        private func strokeReverseLookup() {
                let text: String = String(bufferText.dropFirst())
                let transformed: String = CharacterStandard.strokeTransform(text)
                let converted = transformed.compactMap({ CharacterStandard.stroke(of: $0) })
                let isValidSequence: Bool = converted.isNotEmpty && (converted.count == text.count)
                if isValidSequence {
                        mark(text: String(converted))
                        let lookup: [Candidate] = Engine.strokeReverseLookup(text: transformed)
                        candidates = lookup.transformed(to: Options.characterStandard).uniqued()
                } else {
                        mark(text: bufferText)
                        candidates = []
                }
        }

        /// 拆字反查. 例如 木 + 木 = 林: mukmuk
        private func structureReverseLookup() {
                guard bufferText.count > 2 else {
                        mark(text: bufferText)
                        candidates = []
                        return
                }
                let text = bufferText.dropFirst().toneConverted()
                let segmentation = Segmentor.segment(text: text)
                let tailMarkedText: String = {
                        let hasSeparatorsOrTones: Bool = text.contains(where: \.isSeparatorOrTone)
                        guard hasSeparatorsOrTones.negative else { return text.formattedForMark() }
                        guard let bestScheme = segmentation.first else { return text.formattedForMark() }
                        let leadingLength: Int = bestScheme.length
                        let leadingText: String = bestScheme.map(\.text).joined(separator: String.space)
                        guard leadingLength != text.count else { return leadingText }
                        let tailText = text.dropFirst(leadingLength)
                        return leadingText + String.space + tailText
                }()
                let text2mark: String = "q " + tailMarkedText
                mark(text: text2mark)
                let lookup: [Candidate] = Engine.structureReverseLookup(text: text, input: bufferText, segmentation: segmentation)
                candidates = lookup.transformed(to: Options.characterStandard).uniqued()
        }


        // MARK: - Shift to switch InputMethodMode

        nonisolated(unsafe) private var previousModifiers: NSEvent.ModifierFlags = .init()
        nonisolated private func updatePreviousModifiers(to modifiers: NSEvent.ModifierFlags) {
                previousModifiers = modifiers
        }

        nonisolated(unsafe) private var isModifiersBuffering: Bool = false
        nonisolated private func triggerModifiersBuffer() {
                isModifiersBuffering = true
        }
        nonisolated private func resetModifiersBuffer() {
                if isModifiersBuffering {
                        isModifiersBuffering = false
                }
        }

        nonisolated private func shouldSwitchInputMethodMode(with event: NSEvent) -> Bool {
                let currentModifiers: NSEvent.ModifierFlags = event.modifierFlags
                defer {
                        updatePreviousModifiers(to: currentModifiers)
                }
                guard AppSettings.pressShiftOnce == .switchInputMethodMode else {
                        resetModifiersBuffer()
                        return false
                }
                guard (event.keyCode == KeyCode.Modifier.VK_SHIFT_LEFT) || (event.keyCode == KeyCode.Modifier.VK_SHIFT_RIGHT) else {
                        resetModifiersBuffer()
                        return false
                }
                guard event.type == .flagsChanged else {
                        resetModifiersBuffer()
                        return false
                }
                let isShiftKeyPressed: Bool = previousModifiers.isEmpty && (currentModifiers == .shift)
                let isShiftKeyReleased: Bool = (previousModifiers == .shift) && currentModifiers.isEmpty
                if isShiftKeyPressed && isModifiersBuffering.negative {
                        triggerModifiersBuffer()
                        return false
                } else if isShiftKeyReleased && isModifiersBuffering {
                        resetModifiersBuffer()
                        return true
                } else {
                        resetModifiersBuffer()
                        return false
                }
        }


        // MARK: - Handle Event

        override func recognizedEvents(_ sender: Any!) -> Int {
                let masks: NSEvent.EventTypeMask = [.keyDown, .flagsChanged]
                return Int(masks.rawValue)
        }

        override func handle(_ event: NSEvent!, client sender: Any!) -> Bool {
                guard let event = event else { return false }
                guard shouldSwitchInputMethodMode(with: event).negative else {
                        Task { @MainActor in
                                switch inputForm {
                                case .cantonese:
                                        passBuffer()
                                        Options.updateInputMethodMode(to: .abc)
                                        updateInputForm(to: .transparent)
                                        updateWindowFrame(.zero)
                                case .transparent:
                                        Options.updateInputMethodMode(to: .cantonese)
                                        updateInputForm(to: .cantonese)
                                case .options:
                                        break
                                }
                        }
                        return true
                }
                guard event.type == .keyDown else { return false }
                let modifiers = event.modifierFlags
                let shouldIgnoreCurrentEvent: Bool = modifiers.contains(.command) || modifiers.contains(.option)
                guard shouldIgnoreCurrentEvent.negative else { return false }
                let isBuffering: Bool = inputStage.isBuffering
                let code: UInt16 = event.keyCode
                lazy var hasControlShiftModifiers: Bool = false
                lazy var isEventHandled: Bool = true
                switch modifiers {
                case [.control, .shift] where (code == KeyCode.Symbol.VK_COMMA) || KeyCode.numberSet.contains(code):
                        return false // NSMenu Shortcuts
                case [.control, .shift], .control:
                        switch code {
                        case KeyCode.Symbol.VK_BACKQUOTE:
                                hasControlShiftModifiers = true
                                isEventHandled = true
                        case KeyCode.Special.VK_BACKWARD_DELETE, KeyCode.Special.VK_FORWARD_DELETE:
                                guard isBuffering else { return false }
                                hasControlShiftModifiers = true
                                isEventHandled = true
                        case KeyCode.Alphabet.VK_U:
                                guard isBuffering else { return false }
                                hasControlShiftModifiers = true
                                isEventHandled = true
                        case _ where KeyCode.numberSet.contains(code):
                                hasControlShiftModifiers = true
                                isEventHandled = true
                        default:
                                return false
                        }
                case .shift:
                        isEventHandled = true
                case .capsLock, .function, .help:
                        return false
                default:
                        guard modifiers.contains(.deviceIndependentFlagsMask).negative else { return false }
                }
                let isShifting: Bool = (modifiers == .shift)
                switch code.representative {
                case .alphabet(_):
                        switch inputForm {
                        case .cantonese:
                                isEventHandled = true
                        case .transparent:
                                return false
                        case .options:
                                isEventHandled = true
                        }
                case .number(_):
                        switch inputForm {
                        case .cantonese:
                                isEventHandled = true
                        case .transparent where hasControlShiftModifiers:
                                isEventHandled = true
                        case .transparent:
                                return false
                        case .options:
                                isEventHandled = true
                        }
                case .keypadNumber(_):
                        switch inputForm {
                        case .cantonese:
                                guard isBuffering else { return false }
                                isEventHandled = true
                        case .transparent:
                                return false
                        case .options:
                                isEventHandled = true
                        }
                case .arrow(_):
                        switch inputForm {
                        case .cantonese:
                                guard isBuffering else { return false }
                                isEventHandled = true
                        case .transparent:
                                return false
                        case .options:
                                isEventHandled = true
                        }
                case .backquote where hasControlShiftModifiers:
                        isEventHandled = true
                case .backquote, .punctuation(_):
                        switch inputForm {
                        case .cantonese:
                                isEventHandled = true
                        case .transparent:
                                return false
                        case .options:
                                isEventHandled = true
                        }
                case .separator:
                        switch inputForm {
                        case .cantonese:
                                isEventHandled = true
                        case .transparent:
                                return false
                        case .options:
                                isEventHandled = true
                        }
                case .return:
                        switch inputForm {
                        case .cantonese:
                                guard isBuffering else { return false }
                                isEventHandled = true
                        case .transparent:
                                return false
                        case .options:
                                isEventHandled = true
                        }
                case .backspace, .forwardDelete:
                        switch inputForm {
                        case .cantonese:
                                guard isBuffering else { return false }
                                isEventHandled = true
                        case .transparent:
                                return false
                        case .options:
                                isEventHandled = true
                        }
                case .escape, .clear:
                        switch inputForm {
                        case .cantonese:
                                guard isBuffering else { return false }
                                isEventHandled = true
                        case .transparent:
                                return false
                        case .options:
                                isEventHandled = true
                        }
                case .space:
                        switch inputForm {
                        case .cantonese:
                                let shouldHandle: Bool = isBuffering || isShifting
                                guard shouldHandle else { return false }
                                isEventHandled = true
                        case .transparent:
                                let shouldHandle: Bool = isShifting && (AppSettings.shiftSpaceCombination == .switchInputMethodMode)
                                guard shouldHandle else { return false }
                                isEventHandled = true
                        case .options:
                                isEventHandled = true
                        }
                case .tab:
                        switch inputForm {
                        case .cantonese:
                                guard isBuffering else { return false }
                                isEventHandled = true
                        case .transparent:
                                return false
                        case .options:
                                isEventHandled = true
                        }
                case .previousPage:
                        switch inputForm {
                        case .cantonese:
                                guard isBuffering else { return false }
                                isEventHandled = true
                        case .transparent:
                                return false
                        case .options:
                                isEventHandled = true
                        }
                case .nextPage:
                        switch inputForm {
                        case .cantonese:
                                guard isBuffering else { return false }
                                isEventHandled = true
                        case .transparent:
                                return false
                        case .options:
                                isEventHandled = true
                        }
                case .other:
                        switch code {
                        case KeyCode.Special.VK_HOME where isBuffering:
                                isEventHandled = true
                        default:
                                return false
                        }
                }
                nonisolated(unsafe) let client: InputClient? = (sender as? InputClient)
                if isBuffering.negative && isEventHandled {
                        let attributes: [NSAttributedString.Key: Any] = (mark(forStyle: kTSMHiliteSelectedConvertedText, at: replacementRange()) as? [NSAttributedString.Key: Any]) ?? [.underlineStyle: NSUnderlineStyle.thick.rawValue]
                        let attributedText = NSAttributedString(string: String.zeroWidthSpace, attributes: attributes)
                        let selectionRange = NSRange(location: String.zeroWidthSpace.utf16.count, length: 0)
                        client?.setMarkedText(attributedText, selectionRange: selectionRange, replacementRange: replacementRange())
                }
                Task { @MainActor in
                        process(keyCode: code, client: client, hasControlShiftModifiers: hasControlShiftModifiers, isShifting: isShifting)
                }
                return isEventHandled
        }

        private func process(keyCode: UInt16, client: InputClient?, hasControlShiftModifiers: Bool, isShifting: Bool) {
                updateCurrentCursorBlock(to: client?.cursorBlock)
                let oldClientID = currentClient?.uniqueClientIdentifierString()
                if let clientID = client?.uniqueClientIdentifierString(), clientID != oldClientID {
                        currentClient = client
                }
                let currentInputForm: InputForm = inputForm
                let isBuffering = inputStage.isBuffering
                switch keyCode.representative {
                case .alphabet(_) where hasControlShiftModifiers && isBuffering && (keyCode == KeyCode.Alphabet.VK_U):
                        clearBufferText()
                case .alphabet(let letter):
                        switch currentInputForm {
                        case .cantonese:
                                let text: String = isShifting ? letter.uppercased() : letter
                                bufferText += text
                        case .transparent:
                                return
                        case .options:
                                return
                        }
                case .number(let number):
                        let index: Int = (number == 0) ? 9 : (number - 1)
                        switch currentInputForm {
                        case .cantonese:
                                if hasControlShiftModifiers {
                                        guard isBuffering.negative else { return }
                                        handleOptions(index)
                                } else if isShifting {
                                        switch Options.punctuationForm {
                                        case .cantonese:
                                                if let shiftingBufferText = PunctuationKey.shiftingBufferText(of: number) {
                                                        insert(bufferText)
                                                        bufferText = shiftingBufferText
                                                } else {
                                                        let symbol: String = PunctuationKey.numberKeyShiftingCantoneseSymbol(of: number) ?? String.empty
                                                        insert(bufferText + symbol)
                                                        bufferText = String.empty
                                                }
                                        case .english:
                                                let symbol: String = PunctuationKey.numberKeyShiftingSymbol(of: number) ?? String.empty
                                                insert(bufferText + symbol)
                                                bufferText = String.empty
                                        }
                                } else if isBuffering {
                                        guard let selectedItem = appContext.displayCandidates.fetch(index) else { return }
                                        insert(selectedItem.candidate.text)
                                        aftercareSelection(selectedItem)
                                } else {
                                        let text: String = "\(number)"
                                        let convertedText: String = Options.characterForm.isHalfWidth ? text : text.fullWidth()
                                        insert(convertedText)
                                }
                        case .transparent:
                                if hasControlShiftModifiers {
                                        handleOptions(index)
                                }
                        case .options:
                                handleOptions(index)
                        }
                case .keypadNumber(let number):
                        let isStrokeReverseLookup: Bool = currentInputForm.isCantonese && bufferText.hasPrefix("x")
                        guard isStrokeReverseLookup else { return }
                        bufferText += "\(number)"
                case .arrow(let direction):
                        switch direction {
                        case .up:
                                switch currentInputForm {
                                case .cantonese:
                                        guard isBuffering else { return }
                                        switch AppSettings.candidatePageOrientation {
                                        case .horizontal:
                                                updateDisplayCandidates(.previousPage, highlight: .unchanged)
                                        case .vertical:
                                                if appContext.isHighlightingStart {
                                                        updateDisplayCandidates(.previousPage, highlight: .end)
                                                } else {
                                                        appContext.decreaseHighlightedIndex()
                                                }
                                        }
                                case .transparent:
                                        return
                                case .options:
                                        appContext.decreaseOptionsHighlightedIndex()
                                }
                        case .down:
                                switch currentInputForm {
                                case .cantonese:
                                        guard isBuffering else { return }
                                        switch AppSettings.candidatePageOrientation {
                                        case .horizontal:
                                                updateDisplayCandidates(.nextPage, highlight: .unchanged)
                                        case .vertical:
                                                if appContext.isHighlightingEnd {
                                                        updateDisplayCandidates(.nextPage, highlight: .start)
                                                } else {
                                                        appContext.increaseHighlightedIndex()
                                                }
                                        }
                                case .transparent:
                                        return
                                case .options:
                                        appContext.increaseOptionsHighlightedIndex()
                                }
                        case .left:
                                switch currentInputForm {
                                case .cantonese:
                                        guard isBuffering else { return }
                                        switch AppSettings.candidatePageOrientation {
                                        case .horizontal:
                                                if appContext.isHighlightingStart {
                                                        updateDisplayCandidates(.previousPage, highlight: .end)
                                                } else {
                                                        appContext.decreaseHighlightedIndex()
                                                }
                                        case .vertical:
                                                updateDisplayCandidates(.previousPage, highlight: .unchanged)
                                        }
                                case .transparent:
                                        return
                                case .options:
                                        return
                                }
                        case .right:
                                switch currentInputForm {
                                case .cantonese:
                                        guard isBuffering else { return }
                                        switch AppSettings.candidatePageOrientation {
                                        case .horizontal:
                                                if appContext.isHighlightingEnd {
                                                        updateDisplayCandidates(.nextPage, highlight: .start)
                                                } else {
                                                        appContext.increaseHighlightedIndex()
                                                }
                                        case .vertical:
                                                updateDisplayCandidates(.nextPage, highlight: .unchanged)
                                        }
                                case .transparent:
                                        return
                                case .options:
                                        return
                                }
                        }
                case .backquote where hasControlShiftModifiers:
                        switch currentInputForm {
                        case .cantonese, .transparent:
                                markOptionsViewHintText()
                                updateInputForm(to: .options)
                                updateWindowFrame()
                        case .options:
                                handleOptions(-1)
                        }
                case .backquote:
                        guard currentInputForm.isCantonese else { return }
                        guard isBuffering.negative else { return }
                        guard Options.punctuationForm.isCantoneseMode else { return }
                        let symbolText: String = isShifting ? PunctuationKey.backquote.shiftingKeyText : PunctuationKey.backquote.keyText
                        bufferText = symbolText
                case .punctuation(let punctuationKey):
                        guard currentInputForm.isCantonese else { return }
                        if isBuffering && isShifting.negative {
                                switch punctuationKey {
                                case .comma, .minus:
                                        updateDisplayCandidates(.previousPage, highlight: .unchanged)
                                case .period, .equal:
                                        updateDisplayCandidates(.nextPage, highlight: .unchanged)
                                case .bracketLeft:
                                        let index = appContext.highlightedIndex
                                        guard let displayCandidate = appContext.displayCandidates.fetch(index) else { return }
                                        guard let firstCharacter = displayCandidate.candidate.text.first else { return }
                                        insert(String(firstCharacter))
                                        aftercareSelection(displayCandidate, shouldProcessUserLexicon: false)
                                case .bracketRight:
                                        let index = appContext.highlightedIndex
                                        guard let displayCandidate = appContext.displayCandidates.fetch(index) else { return }
                                        guard let lastCharacter = displayCandidate.candidate.text.last else { return }
                                        insert(String(lastCharacter))
                                        aftercareSelection(displayCandidate, shouldProcessUserLexicon: false)
                                default:
                                        switch Options.punctuationForm {
                                        case .cantonese:
                                                if let symbol = punctuationKey.instantSymbol {
                                                        insert(bufferText + symbol)
                                                        bufferText = String.empty
                                                } else {
                                                        insert(bufferText)
                                                        bufferText = punctuationKey.keyText
                                                }
                                        case .english:
                                                insert(bufferText + punctuationKey.keyText)
                                                bufferText = String.empty
                                        }
                                }
                        } else {
                                switch Options.punctuationForm {
                                case .cantonese:
                                        let symbol: String? = isShifting ? punctuationKey.instantShiftingSymbol : punctuationKey.instantSymbol
                                        if let symbol {
                                                insert(bufferText + symbol)
                                                bufferText = String.empty
                                        } else {
                                                insert(bufferText)
                                                bufferText = isShifting ? punctuationKey.shiftingKeyText : punctuationKey.keyText
                                        }
                                case .english:
                                        let symbol: String = isShifting ? punctuationKey.shiftingKeyText : punctuationKey.keyText
                                        insert(bufferText + symbol)
                                        bufferText = String.empty
                                }
                        }
                case .separator:
                        switch currentInputForm {
                        case .cantonese:
                                let shouldKeepBuffer: Bool = {
                                        guard isShifting.negative else { return false }
                                        guard let type = candidates.first?.type else { return false }
                                        return type != .compose
                                }()
                                if shouldKeepBuffer {
                                        bufferText += String.separator
                                } else {
                                        let text: String = isShifting ? PunctuationKey.quote.shiftingKeyText : PunctuationKey.quote.keyText
                                        switch Options.punctuationForm {
                                        case .cantonese:
                                                insert(bufferText)
                                                bufferText = text
                                        case .english:
                                                insert(bufferText + text)
                                                bufferText = String.empty
                                        }
                                }
                        case .transparent:
                                return
                        case .options:
                                return
                        }
                case .return:
                        switch currentInputForm {
                        case .cantonese:
                                guard isBuffering else { return }
                                let romanization: String? = {
                                        guard isShifting && candidates.isNotEmpty else { return nil }
                                        let index = appContext.highlightedIndex
                                        guard let candidate = appContext.displayCandidates.fetch(index)?.candidate else { return nil }
                                        guard candidate.isCantonese else { return nil }
                                        return candidate.romanization
                                }()
                                if let romanization {
                                        insert(romanization)
                                        clearBufferText()
                                } else {
                                        passBuffer()
                                }
                        case .transparent:
                                return
                        case .options:
                                handleOptions()
                        }
                case .backspace:
                        switch currentInputForm {
                        case .cantonese:
                                guard isBuffering else { return }
                                guard hasControlShiftModifiers else {
                                        bufferText = String(bufferText.dropLast())
                                        return
                                }
                                guard candidates.isNotEmpty else { return }
                                let index = appContext.highlightedIndex
                                guard let candidate = appContext.displayCandidates.fetch(index)?.candidate else { return }
                                guard candidate.isCantonese else { return }
                                UserLexicon.removeItem(candidate: candidate)
                        case .transparent:
                                return
                        case .options:
                                handleOptions(-1)
                        }
                case .forwardDelete:
                        switch currentInputForm {
                        case .cantonese:
                                guard isBuffering else { return }
                                guard hasControlShiftModifiers else { return }
                                guard candidates.isNotEmpty else { return }
                                let index = appContext.highlightedIndex
                                guard let candidate = appContext.displayCandidates.fetch(index)?.candidate else { return }
                                guard candidate.isCantonese else { return }
                                UserLexicon.removeItem(candidate: candidate)
                        case .transparent:
                                return
                        case .options:
                                handleOptions(-1)
                        }
                case .escape, .clear:
                        switch currentInputForm {
                        case .cantonese:
                                guard isBuffering else { return }
                                clearBufferText()
                        case .transparent:
                                return
                        case .options:
                                handleOptions(-1)
                        }
                case .space:
                        switch currentInputForm {
                        case .cantonese:
                                let shouldSwitchToABCMode: Bool = isShifting && (AppSettings.shiftSpaceCombination == .switchInputMethodMode)
                                guard shouldSwitchToABCMode.negative else {
                                        passBuffer()
                                        clearMarkedText()
                                        Options.updateInputMethodMode(to: .abc)
                                        updateInputForm(to: .transparent)
                                        updateWindowFrame(.zero)
                                        return
                                }
                                if candidates.isNotEmpty {
                                        let index = appContext.highlightedIndex
                                        guard let selectedItem = appContext.displayCandidates.fetch(index) else { return }
                                        insert(selectedItem.text)
                                        aftercareSelection(selectedItem)
                                } else if isBuffering {
                                        passBuffer()
                                } else if isShifting || Options.characterForm.isFullWidth {
                                        clearMarkedText()
                                        insert(String.fullWidthSpace)
                                } else {
                                        clearMarkedText()
                                        insert(String.space)
                                }
                        case .transparent:
                                let shouldSwitchToCantoneseMode: Bool = isShifting && (AppSettings.shiftSpaceCombination == .switchInputMethodMode)
                                if shouldSwitchToCantoneseMode {
                                        Options.updateInputMethodMode(to: .cantonese)
                                        updateInputForm(to: .cantonese)
                                } else {
                                        insert(String.space)
                                }
                        case .options:
                                handleOptions()
                        }
                case .tab:
                        switch currentInputForm {
                        case .cantonese:
                                guard isBuffering else { return }
                                if isShifting {
                                        if appContext.isHighlightingStart {
                                                updateDisplayCandidates(.previousPage, highlight: .end)
                                        } else {
                                                appContext.decreaseHighlightedIndex()
                                        }
                                } else {
                                        if appContext.isHighlightingEnd {
                                                updateDisplayCandidates(.nextPage, highlight: .start)
                                        } else {
                                                appContext.increaseHighlightedIndex()
                                        }
                                }
                        case .transparent:
                                return
                        case .options:
                                if isShifting {
                                        appContext.decreaseOptionsHighlightedIndex()
                                } else {
                                        appContext.increaseOptionsHighlightedIndex()
                                }
                        }
                case .previousPage:
                        switch currentInputForm {
                        case .cantonese:
                                guard isBuffering else { return }
                                updateDisplayCandidates(.previousPage, highlight: .unchanged)
                        case .transparent:
                                return
                        case .options:
                                return
                        }
                case .nextPage:
                        switch currentInputForm {
                        case .cantonese:
                                guard isBuffering else { return }
                                updateDisplayCandidates(.nextPage, highlight: .unchanged)
                        case .transparent:
                                return
                        case .options:
                                return
                        }
                case .other:
                        switch keyCode {
                        case KeyCode.Special.VK_HOME:
                                let shouldJump2FirstPage: Bool = currentInputForm.isCantonese && candidates.isNotEmpty
                                guard shouldJump2FirstPage else { return }
                                updateDisplayCandidates(.establish, highlight: .start)
                        default:
                                return
                        }
                }
        }

        private func passBuffer() {
                guard inputStage.isBuffering else { return }
                let text: String = Options.characterForm.isHalfWidth ? bufferText : bufferText.fullWidth()
                insert(text)
                clearBufferText()
        }

        private func handleOptions(_ index: Int? = nil) {
                let selectedIndex: Int = index ?? appContext.optionsHighlightedIndex
                var didCharacterStandardChanged: Bool = false
                defer {
                        clearOptionsViewHintText()
                        updateInputForm()
                        if Options.inputMethodMode.isABC {
                                passBuffer()
                                updateWindowFrame(.zero)
                        } else if candidates.isEmpty {
                                updateWindowFrame(.zero)
                        } else if didCharacterStandardChanged {
                                bufferText += String.empty
                        } else {
                                updateWindowFrame()
                        }
                }
                switch selectedIndex {
                case -1:
                        break
                case 4:
                        Options.updateCharacterForm(to: .halfWidth)
                case 5:
                        Options.updateCharacterForm(to: .fullWidth)
                case 6:
                        Options.updatePunctuationForm(to: .cantonese)
                case 7:
                        Options.updatePunctuationForm(to: .english)
                case 8:
                        Options.updateInputMethodMode(to: .cantonese)
                case 9:
                        Options.updateInputMethodMode(to: .abc)
                default:
                        break
                }
                let newVariant: CharacterStandard? = switch selectedIndex {
                case 0: .traditional
                case 1: .hongkong
                case 2: .taiwan
                case 3: .simplified
                default: nil
                }
                guard let newVariant, newVariant != Options.characterStandard else { return }
                Options.updateCharacterStandard(to: newVariant)
                didCharacterStandardChanged = true
        }

        private func aftercareSelection(_ selected: DisplayCandidate, shouldProcessUserLexicon: Bool = true) {
                let candidate = candidates.fetch(selected.candidateIndex) ?? candidates.first(where: { $0 == selected.candidate })
                guard let candidate, candidate.isCantonese else {
                        selectedCandidates = []
                        clearBufferText()
                        return
                }
                switch bufferText.first {
                case .none:
                        return
                case .some(let character) where character.isBasicLatinLetter.negative:
                        selectedCandidates = []
                        clearBufferText()
                case .some(let character) where character.isReverseLookupTrigger:
                        selectedCandidates = []
                        let leadingCount: Int = candidate.inputCount + 1
                        if bufferText.count > leadingCount {
                                let tail = bufferText.dropFirst(leadingCount)
                                bufferText = String(character) + tail
                        } else {
                                clearBufferText()
                        }
                default:
                        if shouldProcessUserLexicon {
                                selectedCandidates.append(candidate)
                        } else {
                                selectedCandidates = []
                        }
                        let inputCount: Int = candidate.input.replacingOccurrences(of: "[456]", with: "RR", options: .regularExpression).count
                        var tail = bufferText.dropFirst(inputCount)
                        while tail.hasPrefix(String.separator) {
                                tail = tail.dropFirst()
                        }
                        bufferText = String(tail)
                }
        }


        // MARK: - macOS Menu

        override func menu() -> NSMenu! {
                let menu = NSMenu(title: String(localized: "Menu.MenuTitle"))

                let settings = NSMenuItem(title: String(localized: "Menu.General.Settings"), action: #selector(openSettingsWindow), keyEquivalent: ",")
                settings.keyEquivalentModifierMask = [.control, .shift]
                menu.addItem(settings)

                let check4updates = NSMenuItem(title: String(localized: "Menu.General.CheckForUpdates"), action: #selector(checkForUpdates), keyEquivalent: String.empty)
                menu.addItem(check4updates)

                let help = NSMenuItem(title: String(localized: "Menu.General.Help"), action: #selector(openHelpWindow), keyEquivalent: String.empty)
                menu.addItem(help)

                let about = NSMenuItem(title: String(localized: "Menu.General.About"), action: #selector(openAboutWindow), keyEquivalent: String.empty)
                menu.addItem(about)

                menu.addItem(.separator())

                let traditional = NSMenuItem(title: String(localized: "Menu.CharacterStandard.Traditional"), action: #selector(toggleTraditionalCharacterStandard), keyEquivalent: "1")
                traditional.keyEquivalentModifierMask = [.control, .shift]
                traditional.state = (Options.characterStandard == .traditional) ? .on : .off
                menu.addItem(traditional)

                let hongkong = NSMenuItem(title: String(localized: "Menu.CharacterStandard.TraditionalHongKong"), action: #selector(toggleHongKongCharacterStandard), keyEquivalent: "2")
                hongkong.keyEquivalentModifierMask = [.control, .shift]
                hongkong.state = (Options.characterStandard == .hongkong) ? .on : .off
                menu.addItem(hongkong)

                let taiwan = NSMenuItem(title: String(localized: "Menu.CharacterStandard.TraditionalTaiwan"), action: #selector(toggleTaiwanCharacterStandard), keyEquivalent: "3")
                taiwan.keyEquivalentModifierMask = [.control, .shift]
                taiwan.state = (Options.characterStandard == .taiwan) ? .on : .off
                menu.addItem(taiwan)

                let simplified = NSMenuItem(title: String(localized: "Menu.CharacterStandard.Simplified"), action: #selector(toggleSimplifiedCharacterStandard), keyEquivalent: "4")
                simplified.keyEquivalentModifierMask = [.control, .shift]
                simplified.state = Options.characterStandard.isSimplified ? .on : .off
                menu.addItem(simplified)

                menu.addItem(.separator())

                let halfWidth = NSMenuItem(title: String(localized: "Menu.CharacterForm.HalfWidth"), action: #selector(toggleHalfWidthCharacterForm), keyEquivalent: "5")
                halfWidth.keyEquivalentModifierMask = [.control, .shift]
                halfWidth.state = Options.characterForm.isHalfWidth ? .on : .off
                menu.addItem(halfWidth)

                let fullWidth = NSMenuItem(title: String(localized: "Menu.CharacterForm.FullWidth"), action: #selector(toggleFullWidthCharacterForm), keyEquivalent: "6")
                fullWidth.keyEquivalentModifierMask = [.control, .shift]
                fullWidth.state = Options.characterForm.isFullWidth ? .on : .off
                menu.addItem(fullWidth)

                menu.addItem(.separator())

                let cantonesePunctuationForm = NSMenuItem(title: String(localized: "Menu.PunctuationForm.Cantonese"), action: #selector(toggleCantonesePunctuationForm), keyEquivalent: "7")
                cantonesePunctuationForm.keyEquivalentModifierMask = [.control, .shift]
                cantonesePunctuationForm.state = Options.punctuationForm.isCantoneseMode ? .on : .off
                menu.addItem(cantonesePunctuationForm)

                let englishPunctuationForm = NSMenuItem(title: String(localized: "Menu.PunctuationForm.English"), action: #selector(toggleEnglishPunctuationForm), keyEquivalent: "8")
                englishPunctuationForm.keyEquivalentModifierMask = [.control, .shift]
                englishPunctuationForm.state = Options.punctuationForm.isEnglishMode ? .on : .off
                menu.addItem(englishPunctuationForm)

                menu.addItem(.separator())

                let cantoneseInputMethodMode = NSMenuItem(title: String(localized: "Menu.InputMethodMode.Cantonese"), action: #selector(toggleCantoneseInputMethodMode), keyEquivalent: "9")
                cantoneseInputMethodMode.keyEquivalentModifierMask = [.control, .shift]
                cantoneseInputMethodMode.state = Options.inputMethodMode.isCantonese ? .on : .off
                menu.addItem(cantoneseInputMethodMode)

                let abcInputMethodMode = NSMenuItem(title: String(localized: "Menu.InputMethodMode.ABC"), action: #selector(toggleABCInputMethodMode), keyEquivalent: "0")
                abcInputMethodMode.keyEquivalentModifierMask = [.control, .shift]
                abcInputMethodMode.state = Options.inputMethodMode.isABC ? .on : .off
                menu.addItem(abcInputMethodMode)

                return menu
        }

        @objc private func openSettingsWindow() {
                AppSettings.updateSelectedPreferencesSidebarRow(to: .general)
                displaySettingsView()
        }
        @objc func checkForUpdates() {
                AppDelegate.shared.checkForUpdates()
        }
        @objc private func openHelpWindow() {
                AppSettings.updateSelectedPreferencesSidebarRow(to: .hotkeys)
                displaySettingsView()
        }
        @objc private func openAboutWindow() {
                AppSettings.updateSelectedPreferencesSidebarRow(to: .about)
                displaySettingsView()
        }
        private func displaySettingsView() {
                guard inputStage.isBuffering.negative else { return }
                guard SettingsWindow.shared.isVisible.negative else { return }
                SettingsWindow.shared.level = window.level
                SettingsWindow.shared.contentViewController = NSHostingController(rootView: PreferencesView())
                SettingsWindow.shared.setFrame(settingsWindowFrame(), display: true)
                SettingsWindow.shared.orderFrontRegardless()
        }
        private func settingsWindowFrame() -> CGRect {
                let origin: CGPoint = NSScreen.main?.visibleFrame.origin ?? window.screen?.visibleFrame.origin ?? .zero
                let maxSize: CGSize = NSScreen.main?.visibleFrame.size ?? window.screen?.visibleFrame.size ?? CGSize(width: 1280, height: 800)
                let maxWidth: CGFloat = maxSize.width
                let maxHeight: CGFloat = maxSize.height
                let halfWidth: CGFloat = maxWidth / 2.0
                let halfHeight: CGFloat = maxHeight / 2.0
                let idealWidth: CGFloat = 720
                let width: CGFloat = min(maxWidth - 16, max(idealWidth, halfWidth))
                let idealHeight: CGFloat = (maxHeight / 3.0) * 2.0
                let height: CGFloat = (maxWidth > maxHeight) ? idealHeight : halfHeight
                let x: CGFloat = origin.x + ((maxWidth - width) / 2.0)
                let y: CGFloat = origin.y + ((maxHeight - height) / 2.0)
                return CGRect(x: x, y: y, width: width, height: height)
        }

        @objc private func toggleTraditionalCharacterStandard() { handleOptions(0) }
        @objc private func toggleHongKongCharacterStandard()    { handleOptions(1) }
        @objc private func toggleTaiwanCharacterStandard()      { handleOptions(2) }
        @objc private func toggleSimplifiedCharacterStandard()  { handleOptions(3) }
        @objc private func toggleHalfWidthCharacterForm()       { handleOptions(4) }
        @objc private func toggleFullWidthCharacterForm()       { handleOptions(5) }
        @objc private func toggleCantonesePunctuationForm()     { handleOptions(6) }
        @objc private func toggleEnglishPunctuationForm()       { handleOptions(7) }
        @objc private func toggleCantoneseInputMethodMode()     { handleOptions(8) }
        @objc private func toggleABCInputMethodMode()           { handleOptions(9) }
}
