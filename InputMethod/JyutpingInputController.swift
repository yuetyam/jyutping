import SwiftUI
import Combine
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
                let idealValue: Int = Int(max(
                        CGShieldingWindowLevel(),
                        CGWindowLevelForKey(CGWindowLevelKey.popUpMenuWindow)
                ))
                let maxValue: Int = idealValue + 2
                let levelValue: Int = {
                        guard let clientLevel = currentClient?.windowLevel() else { return maxValue }
                        let relatedValue: Int = Int(clientLevel) + 1
                        guard relatedValue < maxValue else { return maxValue }
                        return max(relatedValue, idealValue)
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
                let frame: CGRect = frame ?? computeWindowFrame()
                guard frame != window.frame else { return }
                window.setFrame(frame, display: true)
        }
        private func computeWindowFrame(size: CGSize? = nil) -> CGRect {
                let quadrant = appContext.quadrant
                let position: CGPoint = {
                        func checkedPoint(of frame: CGRect?) -> CGPoint? {
                                guard let frame else { return nil }
                                let x: CGFloat = quadrant.isNegativeHorizontal ? frame.minX : frame.maxX
                                let y: CGFloat = quadrant.isNegativeVertical ? frame.minY : frame.maxY
                                let point = CGPoint(x: x, y: y)
                                let isLocatable: Bool = NSScreen.screens.contains(where: { $0.frame.contains(point) })
                                return isLocatable ? point : nil
                        }
                        if let point = checkedPoint(of: caretFrame) {
                                return point
                        } else if let point = checkedPoint(of: currentClient?.caretRect) {
                                return point
                        } else if let point = checkedPoint(of: client().caretRect) {
                                return point
                        } else {
                                return NSEvent.mouseLocation
                        }
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

        nonisolated(unsafe) private var caretFrame: CGRect? = nil

        private typealias InputClient = (IMKTextInput & NSObjectProtocol)
        private lazy var currentClient: InputClient? = nil {
                didSet {
                        guard let position: CGPoint = currentClient?.caretRect.origin else { return }
                        let screenFrame: CGRect? = {
                                if let screen = NSScreen.screens.first(where: { $0.frame.contains(position) }) {
                                        return screen.frame
                                } else {
                                        let mouseLocation = NSEvent.mouseLocation
                                        return NSScreen.screens.first(where: { $0.frame.contains(mouseLocation) })?.frame
                                }
                        }()
                        guard let screenFrame else { return }
                        let orientation = AppSettings.candidatePageOrientation
                        let isPositiveHorizontal: Bool = switch orientation {
                        case .horizontal:
                                (screenFrame.maxX - position.x) > 450
                        case .vertical:
                                (screenFrame.maxX - position.x) > 300
                        }
                        let isPositiveVertical: Bool = switch orientation {
                        case .horizontal:
                                (position.y - screenFrame.minY) < 100
                        case .vertical:
                                (position.y - screenFrame.minY) < 300
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
                caretFrame = client?.caretRect
                Task { @MainActor in
                        suggestionTask?.cancel()
                        InputMemory.prepare()
                        Engine.prepare()
                        if inputStage.isBuffering {
                                clearBuffer()
                        }
                        inputStage = .standby
                        isCompositionCommitted = false
                        if inputForm.isOptions {
                                updateInputForm()
                        }
                        currentClient = client
                        prepareWindow()
                        client?.overrideKeyboard(withKeyboardNamed: PresetConstant.systemABCKeyboardLayout)
                }
                Task {
                        await obtainSupplementaryLexicon()
                }
                NotificationCenter.default.addObserver(self, selector: #selector(handleContentSizeChanged(_:)), name: .contentSize, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(highlightIndex(_:)), name: .highlightIndex, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(selectIndex(_:)), name: .selectIndex, object: nil)
        }
        override func deactivateServer(_ sender: Any!) {
                nonisolated(unsafe) let client: InputClient? = (sender as? InputClient) ?? client()
                Task { @MainActor in
                        guard isCompositionCommitted.negative else { return }
                        suggestionTask?.cancel()
                        appContext.updateIndicatorTexts(to: nil)
                        window.setContentSize(.zero)
                        selectedCandidates = []
                        if inputStage.isBuffering {
                                let text: String = joinedBufferTexts()
                                clearBuffer()
                                client?.insertText(text as NSString, replacementRange: replacementRange())
                        } else {
                                clearMarkedText()
                        }
                        if inputForm.isOptions {
                                updateInputForm()
                        }
                        let activatingWindowCount = NSApp.windows.count(where: { $0.windowNumber > 0 })
                        if activatingWindowCount > 30 {
                                logger.fault("Jyutping Input Method was terminated because it contained more than 30 windows")
                                fatalError("Jyutping Input Method was terminated because it contained more than 30 windows")
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
                        appContext.updateIndicatorTexts(to: nil)
                        window.setContentSize(.zero)
                        selectedCandidates = []
                        if inputStage.isBuffering {
                                let text: String = joinedBufferTexts()
                                clearBuffer()
                                client?.insertText(text as NSString, replacementRange: replacementRange())
                        } else {
                                clearMarkedText()
                        }
                        if inputForm.isOptions {
                                updateInputForm()
                        }
                        isCompositionCommitted = true
                }

                // Do NOT use this line or it will freeze the entire IME
                // super.commitComposition(sender)
        }
        private lazy var isCompositionCommitted: Bool = false

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

        private func clearBuffer() {
                bufferEvents = []
                placeholderText = nil
        }
        private lazy var bufferEvents: [BasicInputEvent] = [] {
                didSet {
                        switch (oldValue.isEmpty, bufferEvents.isEmpty) {
                        case (true, true):
                                inputStage = .standby
                        case (true, false):
                                inputStage = .starting
                                InputMemory.prepare()
                                Engine.prepare()
                                prepareWindow()
                        case (false, false):
                                inputStage = .ongoing
                        case (false, true):
                                inputStage = .ending
                        }
                        switch bufferEvents.first?.key {
                        case .none:
                                suggestionTask?.cancel()
                                appContext.updateIndicatorTexts(to: nil)
                                if AppSettings.isInputMemoryOn && selectedCandidates.isNotEmpty {
                                        let concatenated = selectedCandidates.filter(\.isCantonese).joined()
                                        concatenated.flatMap(InputMemory.handle(_:))
                                }
                                selectedCandidates = []
                                clearMarkedText()
                                candidates = []
                        case VirtualInputKey.letterR:
                                appContext.updateIndicatorTexts(to: .pinyinReverseLookup)
                                pinyinReverseLookup()
                        case VirtualInputKey.letterV:
                                appContext.updateIndicatorTexts(to: IndicatorTexts.cangjieReverseLookup(for: AppSettings.cangjieVariant))
                                cangjieReverseLookup()
                        case VirtualInputKey.letterX:
                                appContext.updateIndicatorTexts(to: .strokeReverseLookup)
                                strokeReverseLookup()
                        case VirtualInputKey.letterQ:
                                appContext.updateIndicatorTexts(to: .structureReverseLookup)
                                structureReverseLookup()
                        case .some(let inputEvent) where inputEvent.isLetter:
                                appContext.updateIndicatorTexts(to: nil)
                                suggest()
                        default:
                                appContext.updateIndicatorTexts(to: nil)
                                mark(text: joinedBufferTexts())
                        }
                }
        }
        private func joinedBufferTexts() -> String {
                return bufferEvents.map({ $0.isCapitalized ? $0.key.text.uppercased() : $0.key.text }).joined()
        }
        private lazy var placeholderText: String? = nil {
                didSet {
                        let shouldClearUp: Bool = placeholderText?.isEmpty ?? true
                        guard shouldClearUp else {
                                mark(text: placeholderText ?? String.empty)
                                return
                        }
                        guard inputStage == .composing else { return }
                        clearMarkedText()
                        candidates = []
                        inputStage = .standby
                }
        }
        private func punctuation(_ key: PunctuationKey, isShifting: Bool) {
                inputStage = .composing
                let text: String = isShifting ? key.shiftingKeyText : key.keyText
                placeholderText = text
                let symbols = isShifting ? key.shiftingSymbols : key.symbols
                candidates = symbols.map({ Candidate(text: $0.symbol, comment: $0.comment, secondaryComment: $0.secondaryComment, input: text) })
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
                return (attributes as? [NSAttributedString.Key: Any]) ?? [.underlineStyle: NSUnderlineStyle.single.rawValue]
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

        /// System Text Replacements
        private lazy var definedLexicons: [DefinedLexicon] = []
        private func obtainSupplementaryLexicon() async {
                let kUserDictionary: String = "NSUserDictionaryReplacementItems"
                let kOn: String = "on"
                let kReplace: String = "replace"
                let kWith: String = "with"
                guard let items = CFPreferencesCopyAppValue(kUserDictionary as CFString, kCFPreferencesAnyApplication) as? [[String: Any]] else { return }
                definedLexicons = items.compactMap({ dict -> DefinedLexicon? in
                        let isDisabled: Bool = (dict[kOn] as? Bool) == false || (dict[kOn] as? Int) == 0
                        guard isDisabled.negative else { return nil }
                        guard let input = (dict[kReplace] as? String)?.lowercased(), input.isNotEmpty else { return nil }
                        let events = input.lowercased().compactMap(VirtualInputKey.matchInputKey(for:))
                        guard events.count == input.count else { return nil }
                        guard let text = (dict[kWith] as? String), text.isNotEmpty else { return nil }
                        return DefinedLexicon(input: input, text: text, events: events)
                }).distinct()
        }
        private func searchDefinedCandidates(for events: [VirtualInputKey]) -> [Candidate] {
                guard AppSettings.isTextReplacementsOn else { return [] }
                if events.count < 10 {
                        let charCode: Int = events.map(\.code).radix100Combined()
                        return definedLexicons.filter({ $0.charCode == charCode }).map(\.candidate)
                } else {
                        return definedLexicons.filter({ $0.events == events }).map(\.candidate)
                }
        }

        /// Cached Candidate sequence for InputMemory
        private lazy var selectedCandidates: [Candidate] = []
        private func appendSelectedCandidate(_ candidate: Candidate) {
                guard candidate.isCantonese else { return }
                selectedCandidates.append(candidate)
        }

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
                        updateWindowFrame()
                        appContext.resetDisplayContext()
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
                let standard: CharacterStandard = Options.legacyCharacterStandard.isPreset ? Options.traditionalCharacterStandard : Options.legacyCharacterStandard
                let newDisplayCandidates = (firstIndex..<bound).map({ index -> DisplayCandidate in
                        return DisplayCandidate(candidate: candidates[index], candidateIndex: index, characterStandard: standard)
                })
                appContext.update(with: newDisplayCandidates, highlight: highlight)
        }


        // MARK: - Candidate Suggestions

        private lazy var suggestionTask: Task<Void, Never>? = nil
        private func suggest() {
                suggestionTask?.cancel()
                let isPeculiar: Bool = bufferEvents.contains(where: { $0.isCapitalized || $0.key.isSyllableLetter.negative })
                let keys = bufferEvents.map(\.key)
                let isInputMemoryOn: Bool = AppSettings.isInputMemoryOn
                let isEmojiSuggestionsOn: Bool = AppSettings.isEmojiSuggestionsOn
                let standard: CharacterStandard = Options.legacyCharacterStandard.isPreset ? Options.traditionalCharacterStandard : Options.legacyCharacterStandard
                suggestionTask = Task.detached(priority: .high) { [weak self] in
                        guard let self else { return }
                        let segmentation = Segmenter.segment(keys)
                        async let memory: [Candidate] = isInputMemoryOn ? InputMemory.suggest(events: keys, segmentation: segmentation) : []
                        async let defined: [Candidate] = searchDefinedCandidates(for: keys)
                        async let textMarks: [Candidate] = isEmojiSuggestionsOn ? Engine.searchTextMarks(for: keys) : []
                        async let symbols: [Candidate] = isEmojiSuggestionsOn ? Engine.searchSymbols(for: keys, segmentation: segmentation) : []
                        async let queried: [Candidate] = Engine.suggest(events: keys, segmentation: segmentation)
                        let suggestions: [Candidate] = await Converter.dispatch(memory: memory, defined: defined, marks: textMarks, symbols: symbols, queried: queried, characterStandard: standard)
                        if Task.isCancelled.negative {
                                await MainActor.run { [weak self] in
                                        guard let self else { return }
                                        let text2mark: String = {
                                                lazy var text: String = joinedBufferTexts()
                                                guard isPeculiar.negative else { return text.toneConverted().markFormatted() }
                                                guard let firstCandidate = suggestions.first else { return text }
                                                guard firstCandidate.inputCount != keys.count else { return firstCandidate.mark }
                                                guard let bestScheme = segmentation.first else { return text }
                                                let leadingLength: Int = bestScheme.length
                                                guard leadingLength < keys.count else { return bestScheme.mark }
                                                return bestScheme.mark + String.space + text.dropFirst(leadingLength)
                                        }()
                                        self.mark(text: text2mark)
                                        self.candidates = suggestions
                                }
                        }
                }
        }
        private func pinyinReverseLookup() {
                suggestionTask?.cancel()
                let allKeys = bufferEvents.map(\.key)
                let definedCandidates: [Candidate] = searchDefinedCandidates(for: allKeys)
                let textMarkCandidates: [Candidate] = AppSettings.isEmojiSuggestionsOn ? Engine.searchTextMarks(for: allKeys) : []
                let keys = allKeys.dropFirst()
                guard keys.isNotEmpty else {
                        mark(text: joinedBufferTexts())
                        candidates = (definedCandidates + textMarkCandidates).distinct()
                        return
                }
                let standard: CharacterStandard = Options.legacyCharacterStandard.isPreset ? Options.traditionalCharacterStandard : Options.legacyCharacterStandard
                suggestionTask = Task.detached(priority: .high) { [weak self] in
                        guard let self else { return }
                        let segmentation = PinyinSegmenter.segment(keys)
                        let suggestions: [Candidate] = await Engine.pinyinReverseLookup(events: keys, segmentation: segmentation).transformed(to: standard)
                        if Task.isCancelled.negative {
                                await MainActor.run { [weak self] in
                                        guard let self else { return }
                                        let bufferText = joinedBufferTexts()
                                        let headMark: String = bufferText.prefix(1) + String.space
                                        let tailMark: String = {
                                                // TODO: Handle separators
                                                guard let firstCandidate = suggestions.first else { return String(bufferText.dropFirst()) }
                                                guard firstCandidate.inputCount != keys.count else { return firstCandidate.mark }
                                                guard let bestScheme = segmentation.first else { return String(bufferText.dropFirst()) }
                                                let leadingLength: Int = bestScheme.length
                                                guard leadingLength < keys.count else { return bestScheme.mark }
                                                return bestScheme.mark + String.space + bufferText.dropFirst(leadingLength + 1)
                                        }()
                                        mark(text: headMark + tailMark)
                                        self.candidates = (definedCandidates + textMarkCandidates + suggestions).distinct()
                                }
                        }
                }
        }
        private func cangjieReverseLookup() {
                let allKeys = bufferEvents.map(\.key)
                let definedCandidates: [Candidate] = searchDefinedCandidates(for: allKeys)
                let textMarkCandidates: [Candidate] = AppSettings.isEmojiSuggestionsOn ? Engine.searchTextMarks(for: allKeys) : []
                let keys = allKeys.dropFirst()
                let cangjieRadicals = keys.compactMap(Converter.cangjie(of:))
                let isValidSequence: Bool = cangjieRadicals.isNotEmpty && (cangjieRadicals.count == keys.count)
                if isValidSequence {
                        mark(text: String(cangjieRadicals))
                        let text: String = keys.map(\.text).joined()
                        let standard: CharacterStandard = Options.legacyCharacterStandard.isPreset ? Options.traditionalCharacterStandard : Options.legacyCharacterStandard
                        let suggestions: [Candidate] = Engine.cangjieReverseLookup(text: text, variant: AppSettings.cangjieVariant).transformed(to: standard)
                        candidates = (definedCandidates + textMarkCandidates + suggestions).distinct()
                } else {
                        mark(text: joinedBufferTexts())
                        candidates = (definedCandidates + textMarkCandidates).distinct()
                }
        }
        private func strokeReverseLookup() {
                let allKeys = bufferEvents.map(\.key)
                let definedCandidates: [Candidate] = searchDefinedCandidates(for: allKeys)
                let textMarkCandidates: [Candidate] = AppSettings.isEmojiSuggestionsOn ? Engine.searchTextMarks(for: allKeys) : []
                let keys = allKeys.dropFirst()
                if keys.isEmpty || StrokeVirtualKey.isValidStrokes(keys).negative {
                        mark(text: joinedBufferTexts())
                        candidates = (definedCandidates + textMarkCandidates).distinct()
                } else {
                        mark(text: StrokeVirtualKey.displayText(from: keys))
                        let standard: CharacterStandard = Options.legacyCharacterStandard.isPreset ? Options.traditionalCharacterStandard : Options.legacyCharacterStandard
                        let suggestions: [Candidate] = Engine.strokeReverseLookup(keys).transformed(to: standard)
                        candidates = (definedCandidates + textMarkCandidates + suggestions).distinct()
                }
        }

        /// 拆字反查. 例如 木 + 木 = 林: mukmuk
        private func structureReverseLookup() {
                let allKeys = bufferEvents.map(\.key)
                let definedCandidates: [Candidate] = searchDefinedCandidates(for: allKeys)
                let textMarkCandidates: [Candidate] = AppSettings.isEmojiSuggestionsOn ? Engine.searchTextMarks(for: allKeys) : []
                let bufferText = joinedBufferTexts()
                guard bufferText.count > 2 else {
                        mark(text: bufferText)
                        candidates = (definedCandidates + textMarkCandidates).distinct()
                        return
                }
                let keys = allKeys.dropFirst()
                let segmentation = Segmenter.segment(keys)
                let tailMark: String = {
                        let isPeculiar: Bool = keys.contains(where: \.isLetter.negative)
                        guard isPeculiar.negative else { return bufferText.dropFirst().toneConverted() }
                        guard let bestScheme = segmentation.first else { return bufferText.dropFirst().toneConverted() }
                        let leadingLength: Int = bestScheme.length
                        guard leadingLength < keys.count else { return bestScheme.mark }
                        let tailText = keys.dropFirst(leadingLength).map(\.text).joined()
                        return bestScheme.mark + String.space + tailText
                }()
                let prefixMark: String = bufferText.prefix(1) + String.space
                let text2mark: String = prefixMark + tailMark
                mark(text: text2mark)
                let standard: CharacterStandard = Options.legacyCharacterStandard.isPreset ? Options.traditionalCharacterStandard : Options.legacyCharacterStandard
                let suggestions: [Candidate] = Engine.structureReverseLookup(keys, input: bufferText, segmentation: segmentation).transformed(to: standard)
                candidates = (definedCandidates + textMarkCandidates + suggestions).distinct()
        }


        // MARK: - Shift to switch InputMethodMode

        nonisolated(unsafe) private var previousModifiers: NSEvent.ModifierFlags = .init()
        nonisolated(unsafe) private var previousKeyCode: UInt16 = KeyCode.Function.f20
        nonisolated private func detectShift(with event: NSEvent) -> ShiftSituation {
                guard AppSettings.pressShiftOnce.isSwitchingInputMethodMode else {
                        return .transparent
                }
                let currentModifiers = event.modifierFlags
                let currentKeyCode = event.keyCode
                defer {
                        previousModifiers = currentModifiers
                        previousKeyCode = currentKeyCode
                }
                guard currentKeyCode.isShiftKeyCode else {
                        return .irrelevant
                }
                let isPressing: Bool = currentModifiers.isShift && (previousModifiers.isEmpty || (previousModifiers.isShift && previousKeyCode.isShiftKeyCode))
                let isReleased: Bool = previousModifiers.isShift && currentModifiers.isEmpty && previousKeyCode.isShiftKeyCode
                if isPressing {
                        return .buffer
                } else if isReleased {
                        return .handle
                } else {
                        return .transparent
                }
        }


        // MARK: - Handle Event

        override func recognizedEvents(_ sender: Any!) -> Int {
                let masks: NSEvent.EventTypeMask = [.keyDown, .flagsChanged]
                return Int(masks.rawValue)
        }

        override func handle(_ event: NSEvent!, client sender: Any!) -> Bool {
                guard let event = event else { return false }
                switch detectShift(with: event) {
                case .irrelevant, .transparent:
                        break
                case .buffer:
                        return true
                case .handle:
                        if inputStage.isBuffering.negative {
                                caretFrame = (sender as? InputClient)?.caretRect
                        }
                        Task { @MainActor in
                                switch inputForm {
                                case .cantonese:
                                        passBuffer()
                                        Options.updateInputMethodMode(to: .abc)
                                        updateInputForm(to: .transparent)
                                        updateWindowFrame()
                                        appContext.flashIndicatorTexts(to: .abcMode)
                                case .transparent:
                                        Options.updateInputMethodMode(to: .cantonese)
                                        updateInputForm(to: .cantonese)
                                        updateWindowFrame()
                                        appContext.flashIndicatorTexts(to: Options.legacyCharacterStandard.isMutilated ? .mutilatedCantoneseMode : .cantoneseMode)
                                case .options:
                                        break
                                }
                        }
                        return true
                }
                guard event.type == .keyDown else { return false }
                let code: UInt16 = event.keyCode
                let modifiers = event.modifierFlags
                let shouldIgnoreCurrentEvent: Bool = modifiers.contains(.command) || modifiers.contains(.option) || KeyCode.modifierSet.contains(code)
                guard shouldIgnoreCurrentEvent.negative else { return false }
                let isBuffering: Bool = inputStage.isBuffering
                lazy var hasControlShiftModifiers: Bool = false
                lazy var isEventHandled: Bool = true
                switch modifiers {
                case [.control, .shift] where (code == KeyCode.Symbol.comma) || KeyCode.numberSet.contains(code):
                        return false // NSMenu Shortcuts
                case [.control, .shift], .control:
                        switch code {
                        case KeyCode.Symbol.grave:
                                hasControlShiftModifiers = true
                                isEventHandled = true
                        case KeyCode.Special.backwardDelete, KeyCode.Special.forwardDelete:
                                guard isBuffering else { return false }
                                hasControlShiftModifiers = true
                                isEventHandled = true
                        case KeyCode.Alphabet.letterU:
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
                let isShifting: Bool = modifiers.isShift
                switch code.representative {
                case .letter:
                        switch inputForm {
                        case .cantonese:
                                isEventHandled = true
                        case .transparent:
                                return false
                        case .options:
                                isEventHandled = true
                        }
                case .number:
                        switch inputForm {
                        case .cantonese where hasControlShiftModifiers.negative && isShifting.negative && isBuffering.negative && Options.characterForm.isHalfWidth:
                                return false
                        case .cantonese:
                                isEventHandled = true
                        case .transparent where hasControlShiftModifiers:
                                isEventHandled = true
                        case .transparent:
                                return false
                        case .options:
                                isEventHandled = true
                        }
                case .keypadNumber:
                        switch inputForm {
                        case .cantonese:
                                guard isBuffering else { return false }
                                isEventHandled = true
                        case .transparent:
                                return false
                        case .options:
                                isEventHandled = true
                        }
                case .arrow:
                        switch inputForm {
                        case .cantonese:
                                guard isBuffering else { return false }
                                isEventHandled = true
                        case .transparent:
                                return false
                        case .options:
                                isEventHandled = true
                        }
                case .grave where hasControlShiftModifiers:
                        isEventHandled = true
                case .grave, .quote, .punctuation:
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
                                let shouldHandle: Bool = isShifting && AppSettings.shiftSpaceCombination.isSwitchingInputMethodMode
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
                case .pageUp:
                        switch inputForm {
                        case .cantonese:
                                guard isBuffering else { return false }
                                isEventHandled = true
                        case .transparent:
                                return false
                        case .options:
                                isEventHandled = true
                        }
                case .pageDown:
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
                        case KeyCode.Special.home where isBuffering:
                                isEventHandled = true
                        default:
                                return false
                        }
                }
                nonisolated(unsafe) let client: InputClient? = (sender as? InputClient)
                if isBuffering.negative && isEventHandled && inputForm.isOptions.negative {
                        caretFrame = client?.caretRect
                        let text: String = (VirtualInputKey.matchInputKey(for: code) ?? VirtualInputKey.letterA).text
                        let attributes: [NSAttributedString.Key: Any] = [.underlineStyle: 0]
                        let attributedText = NSAttributedString(string: text, attributes: attributes)
                        let selectionRange = NSRange(location: text.utf16.count, length: 0)
                        client?.setMarkedText(attributedText, selectionRange: selectionRange, replacementRange: replacementRange())
                }
                Task { @MainActor in
                        if isBuffering.negative || client?.bundleIdentifier() != currentClient?.bundleIdentifier() {
                                currentClient = client
                        }
                        process(keyCode: code, hasControlShiftModifiers: hasControlShiftModifiers, isShifting: isShifting)
                }
                return isEventHandled
        }

        private func process(keyCode: UInt16, hasControlShiftModifiers: Bool, isShifting: Bool) {
                let currentInputForm: InputForm = inputForm
                let isBuffering = inputStage.isBuffering
                switch keyCode.representative {
                case .letter where hasControlShiftModifiers && isBuffering && (keyCode == KeyCode.Alphabet.letterU):
                        clearBuffer()
                case .letter(let letterEvent):
                        switch currentInputForm {
                        case .cantonese:
                                let newEvent = BasicInputEvent(key: letterEvent, isCapitalized: isShifting)
                                bufferEvents.append(newEvent)
                        case .transparent:
                                return
                        case .options:
                                return
                        }
                case .number(let numberEvent):
                        guard let number = numberEvent.digit else { return }
                        let index: Int = (number == 0) ? 9 : (number - 1)
                        switch currentInputForm {
                        case .cantonese:
                                guard hasControlShiftModifiers.negative else { return } // NSMenu Shortcuts
                                if isShifting {
                                        if let highlighted = appContext.displayCandidates.fetch(appContext.highlightedIndex) {
                                                insert(highlighted.text)
                                                appendSelectedCandidate(highlighted.candidate)
                                                clearBuffer()
                                        } else {
                                                passBuffer()
                                        }
                                        switch Options.punctuationForm {
                                        case .cantonese:
                                                if let key = PunctuationKey.numberKeyPunctuation(of: number) {
                                                        punctuation(key, isShifting: isShifting)
                                                } else {
                                                        let symbol: String = PunctuationKey.numberKeyShiftingCantoneseSymbol(of: number) ?? String.empty
                                                        insert(symbol)
                                                }
                                        case .english:
                                                let symbol: String = PunctuationKey.numberKeyShiftingSymbol(of: number) ?? String.empty
                                                insert(symbol)
                                        }
                                } else if isBuffering {
                                        guard let selectedItem = appContext.displayCandidates.fetch(index) else { return }
                                        insert(selectedItem.text)
                                        aftercareSelection(selectedItem)
                                } else {
                                        let keyText: String = numberEvent.text
                                        let inputText: String = Options.characterForm.isHalfWidth ? keyText : keyText.fullWidth()
                                        insert(inputText)
                                }
                        case .transparent:
                                if hasControlShiftModifiers {
                                        return // NSMenu Shortcuts
                                } else {
                                        return // transparent
                                }
                        case .options:
                                handleOptions(index)
                        }
                case .keypadNumber(let number):
                        let isStrokeReverseLookup: Bool = currentInputForm.isCantonese && (bufferEvents.first?.key == .letterX)
                        guard isStrokeReverseLookup else { return }
                        let code: Int = number + 10
                        guard let event = VirtualInputKey.matchInputKey(for: code) else { return }
                        let newEvent = BasicInputEvent(key: event, isCapitalized: false)
                        bufferEvents.append(newEvent)
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
                case .grave where hasControlShiftModifiers:
                        switch currentInputForm {
                        case .cantonese, .transparent:
                                markOptionsViewHintText()
                                updateInputForm(to: .options)
                                updateWindowFrame()
                        case .options:
                                handleOptions(-1)
                        }
                case .grave:
                        guard currentInputForm.isCantonese else { return }
                        if let highlighted = appContext.displayCandidates.fetch(appContext.highlightedIndex) {
                                insert(highlighted.text)
                                appendSelectedCandidate(highlighted.candidate)
                                clearBuffer()
                        } else {
                                passBuffer()
                        }
                        switch Options.punctuationForm {
                        case .cantonese:
                                punctuation(.grave, isShifting: isShifting)
                        case .english:
                                let text: String = isShifting ? PunctuationKey.grave.shiftingKeyText : PunctuationKey.grave.keyText
                                insert(text)
                        }
                case .punctuation(let punctuationKey):
                        guard currentInputForm.isCantonese else { return }
                        let highlighted = appContext.displayCandidates.fetch(appContext.highlightedIndex)
                        if isBuffering && isShifting.negative {
                                let hasHighlighted: Bool = (highlighted != nil)
                                let bracketKeysMode = AppSettings.bracketKeysMode
                                let commaPeriodKeysMode = AppSettings.commaPeriodKeysMode
                                switch punctuationKey {
                                case .minus where hasHighlighted,
                                .bracketLeft where hasHighlighted && bracketKeysMode.isPaging,
                                .comma where hasHighlighted && commaPeriodKeysMode.isPaging:
                                        updateDisplayCandidates(.previousPage, highlight: .unchanged)
                                case .equal where hasHighlighted,
                                .bracketRight where hasHighlighted && bracketKeysMode.isPaging,
                                .period where hasHighlighted && commaPeriodKeysMode.isPaging:
                                        updateDisplayCandidates(.nextPage, highlight: .unchanged)
                                case .bracketLeft where hasHighlighted && bracketKeysMode.isCharacterSelection,
                                .comma where hasHighlighted && commaPeriodKeysMode.isCharacterSelection:
                                        guard let highlighted, let firstCharacter = highlighted.text.first else { return }
                                        insert(String(firstCharacter))
                                        aftercareSelection(highlighted, shouldRememberSelected: false)
                                case .bracketRight where hasHighlighted && bracketKeysMode.isCharacterSelection,
                                .period where hasHighlighted && commaPeriodKeysMode.isCharacterSelection:
                                        guard let highlighted, let lastCharacter = highlighted.text.last else { return }
                                        insert(String(lastCharacter))
                                        aftercareSelection(highlighted, shouldRememberSelected: false)
                                default:
                                        if let highlighted {
                                                insert(highlighted.text)
                                                appendSelectedCandidate(highlighted.candidate)
                                                clearBuffer()
                                        } else {
                                                passBuffer()
                                        }
                                        switch Options.punctuationForm {
                                        case .cantonese:
                                                if let instantSymbol = punctuationKey.instantSymbol {
                                                        insert(instantSymbol)
                                                } else {
                                                        punctuation(punctuationKey, isShifting: isShifting)
                                                }
                                        case .english:
                                                insert(punctuationKey.keyText)
                                        }
                                }
                        } else {
                                if let highlighted {
                                        insert(highlighted.text)
                                        appendSelectedCandidate(highlighted.candidate)
                                        clearBuffer()
                                } else {
                                        passBuffer()
                                }
                                switch Options.punctuationForm {
                                case .cantonese:
                                        let instantSymbol: String? = isShifting ? punctuationKey.instantShiftingSymbol : punctuationKey.instantSymbol
                                        if let instantSymbol {
                                                insert(instantSymbol)
                                        } else {
                                                punctuation(punctuationKey, isShifting: isShifting)
                                        }
                                case .english:
                                        let text: String = isShifting ? punctuationKey.shiftingKeyText : punctuationKey.keyText
                                        insert(text)
                                }
                        }
                case .quote:
                        switch currentInputForm {
                        case .cantonese:
                                let shouldKeepBuffer: Bool = {
                                        guard isShifting.negative else { return false }
                                        if let type = candidates.first?.type, type == .compose {
                                                return false
                                        } else {
                                                return isBuffering
                                        }
                                }()
                                if shouldKeepBuffer {
                                        let newEvent = BasicInputEvent(key: VirtualInputKey.apostrophe, isCapitalized: false)
                                        bufferEvents.append(newEvent)
                                } else {
                                        switch Options.punctuationForm {
                                        case .cantonese:
                                                passBuffer()
                                                punctuation(.quote, isShifting: isShifting)
                                        case .english:
                                                passBuffer()
                                                let text: String = isShifting ? PunctuationKey.quote.shiftingKeyText : PunctuationKey.quote.keyText
                                                insert(text)
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
                                        clearBuffer()
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
                                        bufferEvents = bufferEvents.dropLast()
                                        placeholderText = nil
                                        return
                                }
                                guard candidates.isNotEmpty else { return }
                                let index = appContext.highlightedIndex
                                guard let candidate = appContext.displayCandidates.fetch(index)?.candidate else { return }
                                guard candidate.isCantonese else { return }
                                InputMemory.remove(candidate: candidate)
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
                                InputMemory.remove(candidate: candidate)
                        case .transparent:
                                return
                        case .options:
                                handleOptions(-1)
                        }
                case .escape, .clear:
                        switch currentInputForm {
                        case .cantonese:
                                guard isBuffering else { return }
                                clearBuffer()
                        case .transparent:
                                return
                        case .options:
                                handleOptions(-1)
                        }
                case .space:
                        switch currentInputForm {
                        case .cantonese:
                                let shouldSwitchToABCMode: Bool = isShifting && AppSettings.shiftSpaceCombination.isSwitchingInputMethodMode
                                guard shouldSwitchToABCMode.negative else {
                                        passBuffer()
                                        clearMarkedText()
                                        Options.updateInputMethodMode(to: .abc)
                                        updateInputForm(to: .transparent)
                                        updateWindowFrame()
                                        appContext.flashIndicatorTexts(to: .abcMode)
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
                                let shouldSwitchToCantoneseMode: Bool = isShifting && AppSettings.shiftSpaceCombination.isSwitchingInputMethodMode
                                if shouldSwitchToCantoneseMode {
                                        clearMarkedText()
                                        Options.updateInputMethodMode(to: .cantonese)
                                        updateInputForm(to: .cantonese)
                                        updateWindowFrame()
                                        appContext.flashIndicatorTexts(to: Options.legacyCharacterStandard.isMutilated ? .mutilatedCantoneseMode : .cantoneseMode)
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
                case .pageUp:
                        switch currentInputForm {
                        case .cantonese:
                                guard isBuffering else { return }
                                updateDisplayCandidates(.previousPage, highlight: .unchanged)
                        case .transparent:
                                return
                        case .options:
                                return
                        }
                case .pageDown:
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
                        case KeyCode.Special.home:
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
                defer { clearBuffer() }
                placeholderText.flatMap(insert(_:))
                guard bufferEvents.isNotEmpty else { return }
                let joinedTexts: String = joinedBufferTexts()
                let text: String = Options.characterForm.isHalfWidth ? joinedTexts : joinedTexts.fullWidth()
                insert(text)
        }

        private func handleOptions(_ index: Int? = nil) {
                let selectedIndex: Int = index ?? appContext.optionsHighlightedIndex
                var didCharacterStandardChanged: Bool = false
                defer {
                        clearOptionsViewHintText()
                        updateInputForm()
                        if Options.inputMethodMode.isABC {
                                passBuffer()
                        }
                        if didCharacterStandardChanged {
                                bufferEvents += []
                        }
                        if let texts = IndicatorTexts.matchTexts(for: selectedIndex, isMutilated: Options.legacyCharacterStandard.isMutilated) {
                                updateWindowFrame()
                                appContext.flashIndicatorTexts(to: texts)
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
                case 0: .preset
                case 1: .hongkong
                case 2: .taiwan
                case 3: .mutilated
                default: nil
                }
                guard let newVariant, newVariant != Options.legacyCharacterStandard else { return }
                Options.updateLegacyCharacterStandard(to: newVariant)
                didCharacterStandardChanged = true
        }

        private func aftercareSelection(_ selected: DisplayCandidate, shouldRememberSelected: Bool = true) {
                let candidate = candidates.fetch(selected.candidateIndex) ?? candidates.first(where: { $0 == selected.candidate })
                guard let candidate, candidate.isCantonese else {
                        selectedCandidates = []
                        clearBuffer()
                        return
                }
                switch bufferEvents.first?.key {
                case .some(let event) where event.isLetter.negative:
                        selectedCandidates = []
                        clearBuffer()
                case .some(let event) where event.isReverseLookupTrigger:
                        selectedCandidates = []
                        var tail = bufferEvents.dropFirst(candidate.inputCount + 1)
                        while (tail.first?.key.isApostrophe ?? false) {
                                tail = tail.dropFirst()
                        }
                        let tailLength = tail.count
                        guard tailLength > 0 else {
                                clearBuffer()
                                return
                        }
                        bufferEvents = bufferEvents.prefix(1) + bufferEvents.suffix(tailLength)
                default:
                        if shouldRememberSelected {
                                appendSelectedCandidate(candidate)
                        } else {
                                selectedCandidates = []
                        }
                        var tail = bufferEvents.dropFirst(candidate.inputCount)
                        while (tail.first?.key.isApostrophe ?? false) {
                                tail = tail.dropFirst()
                        }
                        let tailLength = tail.count
                        guard tailLength > 0 else {
                                clearBuffer()
                                return
                        }
                        bufferEvents = bufferEvents.suffix(tailLength)
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
                traditional.state = (Options.legacyCharacterStandard == .preset) ? .on : .off
                menu.addItem(traditional)

                let hongkong = NSMenuItem(title: String(localized: "Menu.CharacterStandard.TraditionalHongKong"), action: #selector(toggleHongKongCharacterStandard), keyEquivalent: "2")
                hongkong.keyEquivalentModifierMask = [.control, .shift]
                hongkong.state = (Options.legacyCharacterStandard == .hongkong) ? .on : .off
                menu.addItem(hongkong)

                let taiwan = NSMenuItem(title: String(localized: "Menu.CharacterStandard.TraditionalTaiwan"), action: #selector(toggleTaiwanCharacterStandard), keyEquivalent: "3")
                taiwan.keyEquivalentModifierMask = [.control, .shift]
                taiwan.state = (Options.legacyCharacterStandard == .taiwan) ? .on : .off
                menu.addItem(taiwan)

                let simplified = NSMenuItem(title: String(localized: "Menu.CharacterStandard.Simplified"), action: #selector(toggleSimplifiedCharacterStandard), keyEquivalent: "4")
                simplified.keyEquivalentModifierMask = [.control, .shift]
                simplified.state = Options.legacyCharacterStandard.isMutilated ? .on : .off
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
                SettingsWindow.shared.contentViewController = NSHostingController(rootView: SettingsContentView())
                SettingsWindow.shared.setFrame(settingsWindowFrame(), display: true)
                SettingsWindow.shared.orderFrontRegardless()
        }
        private func settingsWindowFrame() -> CGRect {
                let mouseLocation = NSEvent.mouseLocation
                let screenFrame: CGRect = NSScreen.screens.first(where: { $0.frame.contains(mouseLocation) })?.frame ?? NSScreen.main?.frame ?? CGRect(x: 0, y: 0, width: 1280, height: 800)
                let maxWidth: CGFloat = screenFrame.width
                let maxHeight: CGFloat = screenFrame.height
                let halfWidth: CGFloat = maxWidth / 2.0
                let halfHeight: CGFloat = maxHeight / 2.0
                let idealWidth: CGFloat = 720
                let width: CGFloat = min(maxWidth - 16, max(idealWidth, halfWidth))
                let idealHeight: CGFloat = (maxHeight / 3.0) * 2.0
                let height: CGFloat = (maxWidth > maxHeight) ? idealHeight : halfHeight
                let x: CGFloat = screenFrame.minX + ((maxWidth - width) / 2.0)
                let y: CGFloat = screenFrame.minY + ((maxHeight - height) / 2.0)
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
