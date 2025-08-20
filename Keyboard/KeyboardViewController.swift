import SwiftUI
import CommonExtensions
import CoreIME

final class KeyboardViewController: UIInputViewController, ObservableObject {

        private lazy var isKeyboardPrepared: Bool = false
        private func prepareMotherBoard() {
                let screenSize: CGSize = UIScreen.main.bounds.size
                adoptKeyboardInterface(screenSize: screenSize)
                let rowHeight: CGFloat = keyboardInterface.keyHeightUnit(of: screenSize)
                let rowCount: CGFloat = (keyboardInterface.isLargePad || Options.needsNumberRow) ? 5 : 4
                keyboardHeight = (rowHeight * rowCount) + PresetConstant.toolBarHeight
                let board = UIHostingController(rootView: MotherBoard().environmentObject(self))
                board.view.translatesAutoresizingMaskIntoConstraints = false
                addChild(board)
                view.addSubview(board.view)
                NSLayoutConstraint.activate([
                        board.view.topAnchor.constraint(equalTo: view.topAnchor),
                        board.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                        board.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                        board.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                ])
                board.view.backgroundColor = view.backgroundColor
                board.didMove(toParent: self)
        }
        private func prepareKeyboard() {
                let screenSize: CGSize = UIScreen.main.bounds.size
                adoptKeyboardInterface(screenSize: screenSize)
                updateKeyboardSize(screenSize: screenSize)
                responsiveKeyboard()
                InputMemory.prepare()
                Engine.prepare()
                instantiateHapticFeedbacks()
                hasText = textDocumentProxy.hasText
                isKeyboardPrepared = true
                Task {
                        await obtainSupplementaryLexicon()
                }
        }
        override func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)
                if isKeyboardPrepared.negative {
                        prepareMotherBoard()
                }
        }
        override func viewDidAppear(_ animated: Bool) {
                super.viewDidAppear(animated)
                if isKeyboardPrepared.negative {
                        prepareKeyboard()
                }
        }
        private func responsiveKeyboard(for keyboardType: UIKeyboardType? = nil) {
                let keyboardType: UIKeyboardType = keyboardType ?? textDocumentProxy.keyboardType ?? .default
                let newInputMethodMode = keyboardType.inputMethodMode
                let newKeyboardForm = keyboardType.keyboardForm
                if inputMethodMode != newInputMethodMode {
                        inputMethodMode = newInputMethodMode
                }
                if keyboardForm != newKeyboardForm {
                        updateKeyboardForm(to: newKeyboardForm)
                }
        }

        override func textDidChange(_ textInput: UITextInput?) {
                super.textDidChange(textInput)
                guard isKeyboardPrepared else { return }
                let containsText: Bool = textInput?.hasText ?? textDocumentProxy.hasText
                let didUserClearTextField: Bool = containsText.negative && inputStage.isBuffering
                if didUserClearTextField {
                        clearBuffer()
                }
        }
        private lazy var hasText: Bool? = nil {
                didSet {
                        guard oldValue != nil else { return }
                        // guard hasText != oldValue else { return }
                        updateReturnKey()
                }
        }

        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
                super.traitCollectionDidChange(previousTraitCollection)
                guard isKeyboardPrepared else { return }
                adoptKeyboardInterface()
                updateKeyboardSize()
        }

        override func viewWillDisappear(_ animated: Bool) {
                super.viewWillDisappear(animated)
                releaseHapticFeedbacks()
        }


        // MARK: - Mark & Input

        private lazy var text2mark: String = String.empty {
                didSet {
                        guard canMarkText else { return }
                        markText()
                }
        }
        private func markText() {
                if text2mark.isEmpty {
                        textDocumentProxy.setMarkedText(String.empty, selectedRange: NSRange(location: 0, length: 0))
                        textDocumentProxy.unmarkText()
                } else {
                        textDocumentProxy.setMarkedText(text2mark, selectedRange: NSRange(location: text2mark.utf16.count, length: 0))
                }
        }
        private lazy var canMarkText: Bool = true {
                didSet {
                        guard canMarkText else { return }
                        markText()
                }
        }

        private func input(_ text: String) {
                guard text.isNotEmpty else { return }
                canMarkText = false
                performInput(text)
        }
        private func inputBufferText(followedBy text2insert: String? = nil) {
                bufferCombos = []
                let text: String = {
                        guard let text2insert, text2insert.isNotEmpty else { return joinedBufferTexts() }
                        return joinedBufferTexts() + text2insert
                }()
                guard text.isNotEmpty else { return }
                canMarkText = false
                clearBuffer()
                performInput(text)
        }
        private func performInput(_ text: String) {
                defer {
                        Task {
                                try await Task.sleep(nanoseconds: 10_000_000) // 0.01s
                                textDocumentProxy.setMarkedText(String.zeroWidthSpace, selectedRange: NSRange(location: String.zeroWidthSpace.utf16.count, length: 0))
                                try await Task.sleep(nanoseconds: 10_000_000) // 0.01s
                                canMarkText = true
                        }
                }
                let previousContext: String = textDocumentProxy.documentContextBeforeInput ?? String.empty
                let previousLength: Int = previousContext.count
                textDocumentProxy.setMarkedText(text, selectedRange: NSRange(location: text.utf16.count, length: 0))
                textDocumentProxy.unmarkText()
                let currentContext: String = textDocumentProxy.documentContextBeforeInput ?? String.empty
                guard currentContext.count == previousLength else { return }
                guard currentContext == previousContext else { return }
                textDocumentProxy.insertText(text)
        }


        // MARK: - Buffer

        @Published private(set) var inputStage: InputStage = .standby

        private lazy var capitals: [Bool] = []
        private lazy var inputLengthSequence: [Int] = []
        private lazy var bufferEvents: [InputEvent] = [] {
                didSet {
                        switch (oldValue.isEmpty, bufferEvents.isEmpty) {
                        case (true, true):
                                inputStage = .standby
                        case (true, false):
                                inputStage = .starting
                                updateReturnKey()
                        case (false, false):
                                inputStage = .ongoing
                        case (false, true):
                                inputStage = .ending
                                if Options.isInputMemoryOn && selectedCandidates.isNotEmpty {
                                        let concatenated = selectedCandidates.filter(\.isCantonese).joined()
                                        concatenated.flatMap(InputMemory.handle(_:))
                                }
                                selectedCandidates = []
                                updateReturnKey()
                        }
                        switch bufferEvents.first {
                        case .none:
                                suggestionTask?.cancel()
                                ensureQwertyForm(to: .jyutping)
                                if keyboardForm == .tenKeyStroke {
                                        updateKeyboardForm(to: .alphabetic)
                                }
                                candidates = []
                                text2mark = String.empty
                        case InputEvent.letterR:
                                ensureQwertyForm(to: .pinyin)
                                pinyinReverseLookup()
                        case InputEvent.letterV:
                                ensureQwertyForm(to: .cangjie)
                                cangjieReverseLookup()
                        case InputEvent.letterX:
                                if strokeLayout.isTenKey && keyboardForm != .tenKeyStroke {
                                        updateKeyboardForm(to: .tenKeyStroke)
                                } else {
                                        ensureQwertyForm(to: .stroke)
                                }
                                strokeReverseLookup()
                        case InputEvent.letterQ:
                                structureReverseLookup()
                        default:
                                suggest()
                        }
                }
        }
        private func joinedBufferTexts() -> String {
                guard capitals.contains(true) else { return bufferEvents.map(\.text).joined() }
                return zip(capitals, bufferEvents).map({ $0 ? $1.text.uppercased() : $1.text }).joined()
        }

        func handle(_ event: InputEvent, isCapitalized: Bool? = nil) {
                let isCapitalized: Bool = isCapitalized ?? keyboardCase.isCapitalized
                defer {
                        adjustKeyboard()
                }
                lazy var text: String = isCapitalized ? event.text.uppercased() : event.text
                let isCantoneseComposeMode: Bool = inputMethodMode.isCantonese && keyboardForm.isBufferrable
                guard isCantoneseComposeMode else {
                        textDocumentProxy.insertText(text)
                        return
                }
                let shouldAppendEvent: Bool = event.isLetter || (inputStage.isBuffering && (event.isToneNumber || event.isApostrophe))
                guard shouldAppendEvent else {
                        if inputStage.isBuffering {
                                inputBufferText(followedBy: text)
                        } else {
                                textDocumentProxy.insertText(text)
                        }
                        return
                }
                capitals.append(isCapitalized)
                inputLengthSequence.append(1)
                bufferEvents.append(event)
        }
        private func process(events: [InputEvent], isCapitalized: Bool) {
                guard let firstEvent = events.first else { return }
                defer {
                        adjustKeyboard()
                }
                lazy var text: String = isCapitalized ? events.map(\.text).joined().uppercased() : events.map(\.text).joined()
                let isCantoneseComposeMode: Bool = inputMethodMode.isCantonese && keyboardForm.isBufferrable
                guard isCantoneseComposeMode else {
                        textDocumentProxy.insertText(text)
                        return
                }
                let shouldAppendEvent: Bool = firstEvent.isLetter || (inputStage.isBuffering && (firstEvent.isToneNumber || firstEvent.isApostrophe))
                guard shouldAppendEvent else {
                        if inputStage.isBuffering {
                                inputBufferText(followedBy: text)
                        } else {
                                textDocumentProxy.insertText(text)
                        }
                        return
                }
                let shouldConvertEvents: Bool = keyboardLayout.isTripleStroke && (events == InputEvent.GWEvents) && (inputLengthSequence.last == 2) && (bufferEvents.last == .letterW)
                if shouldConvertEvents {
                        bufferEvents = bufferEvents.dropLast(2) + InputEvent.KWEvents
                } else {
                        capitals += Array(repeating: isCapitalized, count: events.count)
                        inputLengthSequence.append(events.count)
                        bufferEvents += events
                }
        }
        private func appendBufferText(_ text: String) {
                guard let isCapitalized = text.first?.isUppercase else { return }
                let events = text.lowercased().compactMap(InputEvent.matchInputEvent(for:))
                switch events.count {
                case 0: return
                case 1: events.first.flatMap({ handle($0, isCapitalized: isCapitalized) })
                default: process(events: events, isCapitalized: isCapitalized)
                }
        }

        private func clearBuffer() {
                bufferCombos = []
                capitals = []
                inputLengthSequence = []
                bufferEvents = []
        }

        /// Cantonese TenKey layout
        private lazy var bufferCombos: [Combo] = [] {
                didSet {
                        switch (oldValue.isEmpty, bufferCombos.isEmpty) {
                        case (true, true):
                                inputStage = .standby
                        case (true, false):
                                inputStage = .starting
                                updateReturnKey()
                                tenKeySuggest()
                        case (false, false):
                                inputStage = .ongoing
                                if bufferCombos.count == (oldValue.count - 1) {
                                        selectedSyllables = []
                                }
                                tenKeySuggest()
                        case (false, true):
                                inputStage = .ending
                                suggestionTask?.cancel()
                                if Options.isInputMemoryOn && selectedCandidates.isNotEmpty {
                                        let concatenated = selectedCandidates.filter(\.isCantonese).joined()
                                        concatenated.flatMap(InputMemory.handle(_:))
                                }
                                selectedCandidates = []
                                candidates = []
                                text2mark = String.empty
                                clearSidebarSyllables()
                                updateReturnKey()
                        }
                }
        }

        @Published private(set) var sidebarSyllables: [SidebarSyllable] = []
        private lazy var selectedSyllables: [SidebarSyllable] = []
        func handleSidebarTapping(at index: Int) {
                guard let item = sidebarSyllables.fetch(index) else { return }
                sidebarSyllables.remove(at: index)
                let newSyllable = SidebarSyllable(text: item.text, isSelected: item.isSelected.negative)
                sidebarSyllables.insert(newSyllable, at: index)
                sidebarSyllables.sort(by: { $0.isSelected && $1.isSelected.negative })
                selectedSyllables = sidebarSyllables.filter(\.isSelected)
                updateSidebarSyllables()
        }
        private func updateSidebarSyllables() {
                let selected = selectedSyllables.map(\.text)
                candidates = selected.isEmpty ? tenKeyCachedCandidates : tenKeyCachedCandidates.filter({ item -> Bool in
                        let syllables = item.romanization.removedTones().split(separator: Character.space).map({ String($0) })
                        return syllables.starts(with: selected)
                })
                let leadingLength = selected.isEmpty ? 0 : selected.reduce(0, { $0 + $1.count + 2 })
                guard leadingLength < bufferCombos.count else {
                        sidebarSyllables = selectedSyllables
                        return
                }
                let newSyllables = candidates.compactMap({ $0.romanization.dropFirst(leadingLength).split(separator: Character.space).first?.dropLast() })
                        .uniqued()
                        .map({ SidebarSyllable(text: String($0), isSelected: false) })
                sidebarSyllables = selectedSyllables + newSyllables
        }
        private func clearSidebarSyllables() {
                sidebarSyllables = []
                selectedSyllables = []
        }


        // MARK: - Operations

        func operate(_ operation: Operation) {
                lazy var shouldAdjustKeyboard: Bool = true
                defer {
                        if shouldAdjustKeyboard {
                                adjustKeyboard()
                        }
                }
                switch operation {
                case .input(let text):
                        textDocumentProxy.insertText(text)
                case .process(let text):
                        let isCantoneseComposeMode: Bool = inputMethodMode.isCantonese && keyboardForm.isBufferrable
                        guard isCantoneseComposeMode else {
                                textDocumentProxy.insertText(text)
                                return
                        }
                        let shouldAppendText: Bool = text.isLetters || (inputStage.isBuffering && (text.first?.isCantoneseToneDigit ?? false))
                        if shouldAppendText {
                                appendBufferText(text)
                        } else if inputStage.isBuffering {
                                inputBufferText(followedBy: text)
                        } else {
                                textDocumentProxy.insertText(text)
                        }
                case .combine(let combo):
                        bufferCombos.append(combo)
                case .space:
                        guard inputMethodMode.isCantonese else {
                                textDocumentProxy.insertText(String.space)
                                return
                        }
                        guard inputStage.isBuffering else {
                                let text: String = (keyboardCase == .uppercased) ? String.fullWidthSpace : String.space
                                textDocumentProxy.insertText(text)
                                return
                        }
                        if let candidate = candidates.first {
                                input(candidate.text)
                                aftercareSelected(candidate)
                        } else {
                                inputBufferText()
                                updateReturnKey()
                        }
                case .doubleSpace:
                        if inputStage.isBuffering {
                                if let candidate = candidates.first {
                                        input(candidate.text)
                                        aftercareSelected(candidate)
                                } else {
                                        inputBufferText()
                                        updateReturnKey()
                                }
                        } else {
                                // TODO: Double-space shortcut
                                /*
                                let hasSpaceAhead: Bool = textDocumentProxy.documentContextBeforeInput?.hasSuffix(String.space) ?? false
                                if hasSpaceAhead {
                                        textDocumentProxy.deleteBackward()
                                        let shortcutText: String = inputMethodMode.isABC ? ". " : "。"
                                        textDocumentProxy.insertText(shortcutText)
                                } else {
                                        textDocumentProxy.insertText(String.space)
                                }
                                */
                                textDocumentProxy.insertText(String.space)
                        }
                case .backspace:
                        if inputStage.isBuffering {
                                switch keyboardLayout {
                                case .qwerty:
                                        capitals = capitals.dropLast()
                                        inputLengthSequence = inputLengthSequence.dropLast()
                                        bufferEvents = bufferEvents.dropLast()
                                case .tripleStroke:
                                        guard let lastInputLength = inputLengthSequence.last else { return }
                                        capitals = capitals.dropLast(lastInputLength)
                                        inputLengthSequence = inputLengthSequence.dropLast()
                                        bufferEvents = bufferEvents.dropLast(lastInputLength)
                                case .tenKey:
                                        bufferCombos = bufferCombos.dropLast()
                                }
                        } else {
                                textDocumentProxy.deleteBackward()
                        }
                case .clearBuffer:
                        clearBuffer()
                case .return:
                        if keyboardForm == .tenKeyStroke, let candidate = candidates.first {
                                input(candidate.text)
                                aftercareSelected(candidate)
                        } else if inputStage.isBuffering {
                                inputBufferText()
                                updateReturnKey()
                        } else {
                                textDocumentProxy.insertText(String.newLine)
                        }
                case .shift:
                        let newCase: KeyboardCase = {
                                switch keyboardCase {
                                case .lowercased:
                                        return .uppercased
                                case .uppercased:
                                        return .lowercased
                                case .capsLocked:
                                        return .lowercased
                                }
                        }()
                        updateKeyboardCase(to: newCase)
                        shouldAdjustKeyboard = false
                case .doubleShift:
                        let newCase: KeyboardCase = {
                                switch keyboardCase {
                                case .lowercased:
                                        return .capsLocked
                                case .uppercased:
                                        return .capsLocked
                                case .capsLocked:
                                        return .lowercased
                                }
                        }()
                        updateKeyboardCase(to: newCase)
                        shouldAdjustKeyboard = false
                case .tab:
                        if inputStage.isBuffering {
                                inputBufferText(followedBy: String.tab)
                        } else {
                                textDocumentProxy.insertText(String.tab)
                        }
                case .dismiss:
                        dismissKeyboard()
                        shouldAdjustKeyboard = false
                case .select(let candidate):
                        input(candidate.text)
                        aftercareSelected(candidate)
                case .copyAllText:
                        let didCopyText: Bool = textDocumentProxy.copyAllText()
                        guard didCopyText else { return }
                        isClipboardEmpty = false
                        shouldAdjustKeyboard = false
                case .cutAllText:
                        let didCopyText: Bool = textDocumentProxy.cutAllText()
                        guard didCopyText else { return }
                        isClipboardEmpty = false
                case .clearAllText:
                        textDocumentProxy.clearAllText()
                case .convertAllText:
                        textDocumentProxy.convertAllText()
                case .clearClipboard:
                        UIPasteboard.general.items.removeAll()
                        isClipboardEmpty = true
                        shouldAdjustKeyboard = false
                case .paste:
                        guard UIPasteboard.general.hasStrings else { return }
                        guard let text = UIPasteboard.general.string else { return }
                        guard text.isNotEmpty else { return }
                        textDocumentProxy.insertText(text)
                case .moveCursorBackward:
                        textDocumentProxy.moveBackward()
                case .moveCursorForward:
                        textDocumentProxy.moveForward()
                case .jumpToHead:
                        textDocumentProxy.jumpToHead()
                case .jumpToTail:
                        textDocumentProxy.jumpToTail()
                case .forwardDelete:
                        guard let offset = textDocumentProxy.documentContextAfterInput?.first?.utf16.count else { return }
                        textDocumentProxy.adjustTextPosition(byCharacterOffset: offset)
                        textDocumentProxy.deleteBackward()
                }
        }
        private func aftercareSelected(_ candidate: Candidate) {
                switch keyboardLayout {
                case .qwerty, .tripleStroke:
                        switch bufferEvents.first {
                        case .some(let event) where event.isReverseLookupTrigger:
                                selectedCandidates = []
                                var tail = bufferEvents.dropFirst(candidate.inputCount + 1)
                                while (tail.first?.isApostrophe ?? false) {
                                        tail = tail.dropFirst()
                                }
                                let tailLength = tail.count
                                guard tailLength > 0 else {
                                        clearBuffer()
                                        return
                                }
                                capitals = capitals.prefix(1) + capitals.suffix(tailLength)
                                inputLengthSequence = inputLengthSequence.prefix(1) + inputLengthSequence.suffix(tailLength)
                                bufferEvents = bufferEvents.prefix(1) + bufferEvents.suffix(tailLength)
                        default:
                                if candidate.isCantonese {
                                        selectedCandidates.append(candidate)
                                } else {
                                        selectedCandidates = []
                                }
                                var tail = bufferEvents.dropFirst(candidate.inputCount)
                                while (tail.first?.isApostrophe ?? false) {
                                        tail = tail.dropFirst()
                                }
                                let tailLength = tail.count
                                guard tailLength > 0 else {
                                        clearBuffer()
                                        return
                                }
                                capitals = capitals.suffix(tailLength)
                                inputLengthSequence = inputLengthSequence.suffix(tailLength)
                                bufferEvents = bufferEvents.suffix(tailLength)
                        }
                case .tenKey:
                        if candidate.isCantonese {
                                selectedCandidates.append(candidate)
                        } else {
                                selectedCandidates = []
                        }
                        selectedSyllables = []
                        let tailCount: Int = bufferCombos.count - candidate.inputCount
                        let suffixLength: Int = max(0, tailCount)
                        bufferCombos = bufferCombos.suffix(suffixLength)
                }
        }
        private func adjustKeyboard() {
                switch keyboardCase {
                case .lowercased:
                        break
                case .uppercased:
                        updateKeyboardCase(to: .lowercased)
                case .capsLocked:
                        break
                }
                switch keyboardForm {
                case .candidateBoard:
                        if candidates.isEmpty {
                                updateKeyboardForm(to: previousKeyboardForm)
                        }
                default:
                        break
                }
                hasText = textDocumentProxy.hasText
        }


        // MARK: - Candidate Suggestions

        private lazy var suggestionTask: Task<Void, Never>? = nil
        private func tenKeySuggest() {
                suggestionTask?.cancel()
                let combos = bufferCombos
                let isEmojiSuggestionsOn: Bool = Options.isEmojiSuggestionsOn
                let isInputMemoryOn: Bool = Options.isInputMemoryOn
                suggestionTask = Task.detached(priority: .high) { [weak self] in
                        guard let self else { return }
                        let definedCandidates: [Candidate] = await queryDefinedCandidates(for: combos)
                        async let textMarkCandidates: [Candidate] = Engine.queryTextMarks(for: combos)
                        async let memoryCandidates: [Candidate] = isInputMemoryOn ? InputMemory.tenKeySuggest(combos: combos) : []
                        async let engineCandidates: [Candidate] = Engine.tenKeySuggest(combos: combos)
                        let suggestions: [Candidate] = await (memoryCandidates + textMarkCandidates + engineCandidates).transformed(with: Options.characterStandard, isEmojiSuggestionsOn: isEmojiSuggestionsOn)
                        if Task.isCancelled.negative {
                                await MainActor.run { [weak self] in
                                        guard let self else { return }
                                        self.text2mark = {
                                                guard let firstCandidate = suggestions.first else { return combos.compactMap(\.letters.first).joined() }
                                                let userInputCount = combos.count
                                                let firstInputCount = firstCandidate.inputCount
                                                guard firstInputCount < userInputCount else { return firstCandidate.mark }
                                                let tailCombos = combos.suffix(userInputCount - firstInputCount)
                                                let tailText = tailCombos.compactMap(\.letters.first).joined()
                                                return firstCandidate.mark + String.space + tailText
                                        }()
                                        self.tenKeyCachedCandidates = definedCandidates.isEmpty ? suggestions : (definedCandidates + suggestions)
                                        self.updateSidebarSyllables()
                                }
                        }
                }
        }
        private func suggest() {
                suggestionTask?.cancel()
                let events = bufferEvents
                let isEmojiSuggestionsOn: Bool = Options.isEmojiSuggestionsOn
                let isInputMemoryOn: Bool = Options.isInputMemoryOn
                suggestionTask = Task.detached(priority: .high) { [weak self] in
                        guard let self else { return }
                        let definedCandidates: [Candidate] = await searchDefinedCandidates(for: events)
                        async let textMarkCandidates: [Candidate] = Engine.searchTextMarks(for: events)
                        let segmentation = Segmenter.segment(events: events)
                        async let memoryCandidates: [Candidate] = isInputMemoryOn ? InputMemory.suggest(events: events, segmentation: segmentation) : []
                        async let engineCandidates: [Candidate] = Engine.suggest(events: events, segmentation: segmentation)
                        let suggestions: [Candidate] = await (memoryCandidates + textMarkCandidates + engineCandidates).transformed(with: Options.characterStandard, isEmojiSuggestionsOn: isEmojiSuggestionsOn)
                        if Task.isCancelled.negative {
                                await MainActor.run { [weak self] in
                                        guard let self else { return }
                                        self.text2mark = {
                                                lazy var text: String = joinedBufferTexts()
                                                let isPeculiar: Bool = capitals.contains(true) || events.contains(where: \.isSyllableLetter.negative)
                                                guard isPeculiar.negative else { return text.toneConverted().formattedForMark() }
                                                guard let firstCandidate = suggestions.first else { return text }
                                                guard firstCandidate.inputCount != events.count else { return firstCandidate.mark }
                                                guard let bestScheme = segmentation.first else { return text }
                                                let leadingLength: Int = bestScheme.length
                                                guard leadingLength < events.count else { return bestScheme.mark }
                                                return bestScheme.mark + String.space + text.dropFirst(leadingLength)
                                        }()
                                        self.candidates = definedCandidates.isEmpty ? suggestions : (definedCandidates + suggestions)
                                }
                        }
                }
        }
        private func pinyinReverseLookup() {
                suggestionTask?.cancel()
                let definedCandidates: [Candidate] = searchDefinedCandidates(for: bufferEvents)
                let textMarkCandidates: [Candidate] = Engine.searchTextMarks(for: bufferEvents)
                let events = bufferEvents.dropFirst()
                guard events.isNotEmpty else {
                        text2mark = joinedBufferTexts()
                        candidates = definedCandidates + textMarkCandidates
                        return
                }
                suggestionTask = Task.detached(priority: .high) { [weak self] in
                        guard let self else { return }
                        let segmentation = PinyinSegmenter.segment(events: events)
                        let suggestions: [Candidate] = await Engine.pinyinReverseLookup(events: events, segmentation: segmentation).transformed(to: Options.characterStandard).uniqued()
                        if Task.isCancelled.negative {
                                await MainActor.run { [weak self] in
                                        guard let self else { return }
                                        let bufferText = joinedBufferTexts()
                                        let headMark: String = bufferText.prefix(1) + String.space
                                        let tailMark: String = {
                                                // TODO: Handle separators
                                                guard let firstCandidate = suggestions.first else { return String(bufferText.dropFirst()) }
                                                guard firstCandidate.inputCount != events.count else { return firstCandidate.mark }
                                                guard let bestScheme = segmentation.first else { return String(bufferText.dropFirst()) }
                                                let leadingLength: Int = bestScheme.length
                                                guard leadingLength < events.count else { return bestScheme.mark }
                                                return bestScheme.mark + String.space + bufferText.dropFirst(leadingLength + 1)
                                        }()
                                        self.text2mark = headMark + tailMark
                                        self.candidates = definedCandidates + textMarkCandidates + suggestions
                                }
                        }
                }
        }
        private func cangjieReverseLookup() {
                let definedCandidates: [Candidate] = searchDefinedCandidates(for: bufferEvents)
                let textMarkCandidates: [Candidate] = Engine.searchTextMarks(for: bufferEvents)
                let bufferText = joinedBufferTexts()
                let text: String = String(bufferText.dropFirst())
                let converted = text.compactMap({ CharacterStandard.cangjie(of: $0) })
                let isValidSequence: Bool = converted.isNotEmpty && (converted.count == text.count)
                if isValidSequence {
                        text2mark = String(converted)
                        let suggestions: [Candidate] = Engine.cangjieReverseLookup(text: text, variant: Options.cangjieVariant).transformed(to: Options.characterStandard).uniqued()
                        candidates = definedCandidates + textMarkCandidates + suggestions
                } else {
                        text2mark = bufferText
                        candidates = definedCandidates + textMarkCandidates
                }
        }
        private func strokeReverseLookup() {
                let definedCandidates: [Candidate] = searchDefinedCandidates(for: bufferEvents)
                let textMarkCandidates: [Candidate] = Engine.searchTextMarks(for: bufferEvents)
                let bufferText = joinedBufferTexts()
                let text: String = String(bufferText.dropFirst())
                let transformed: String = CharacterStandard.strokeTransform(text)
                let converted = transformed.compactMap({ CharacterStandard.stroke(of: $0) })
                let isValidSequence: Bool = converted.isNotEmpty && (converted.count == text.count)
                if isValidSequence {
                        text2mark = String(converted)
                        let suggestions: [Candidate] = Engine.strokeReverseLookup(text: transformed).transformed(to: Options.characterStandard).uniqued()
                        candidates = definedCandidates + textMarkCandidates + suggestions
                } else {
                        text2mark = bufferText
                        candidates = definedCandidates + textMarkCandidates
                }
        }

        /// 拆字、兩分反查. 例如 木 + 木 = 林: mukmuk
        private func structureReverseLookup() {
                let definedCandidates: [Candidate] = searchDefinedCandidates(for: bufferEvents)
                let textMarkCandidates: [Candidate] = Engine.searchTextMarks(for: bufferEvents)
                let bufferText = joinedBufferTexts()
                guard bufferText.count > 2 else {
                        text2mark = bufferText
                        candidates = definedCandidates + textMarkCandidates
                        return
                }
                let segmentation = Segmenter.segment(events: bufferEvents)
                let tailMark: String = {
                        let isPeculiar: Bool = bufferEvents.contains(where: \.isLetter.negative)
                        guard isPeculiar.negative else { return bufferText.dropFirst().toneConverted() }
                        guard let bestScheme = segmentation.first else { return bufferText.dropFirst().toneConverted() }
                        let leadingLength: Int = bestScheme.length
                        guard leadingLength < (bufferEvents.count - 1) else { return bestScheme.mark }
                        let tailText = bufferEvents.dropFirst(leadingLength + 1).map(\.text).joined()
                        return bestScheme.mark + String.space + tailText
                }()
                let prefixMark: String = bufferText.prefix(1) + String.space
                text2mark = prefixMark + tailMark
                let suggestions: [Candidate] = Engine.structureReverseLookup(events: bufferEvents, input: bufferText, segmentation: segmentation).transformed(to: Options.characterStandard).uniqued()
                candidates = definedCandidates + textMarkCandidates + suggestions
        }

        /// Cached Candidate sequence for InputMemory
        private lazy var selectedCandidates: [Candidate] = []

        @Published private(set) var candidateState: Int = 0
        @Published private(set) var candidates: [Candidate] = [] {
                didSet {
                        candidateState += 1
                        updateSpaceKeyForm()
                }
        }
        private lazy var tenKeyCachedCandidates: [Candidate] = []

        /// System Text Replacements
        private lazy var definedLexicons: [DefinedLexicon] = []
        private func obtainSupplementaryLexicon() async {
                let lexicon = await requestSupplementaryLexicon()
                definedLexicons = lexicon.entries.compactMap({ entry -> DefinedLexicon? in
                        let input = entry.userInput
                        guard input.isNotEmpty else { return nil }
                        let events = input.lowercased().compactMap(InputEvent.matchInputEvent(for:))
                        guard events.count == input.count else { return nil }
                        let text = entry.documentText
                        guard text.isNotEmpty else { return nil }
                        return DefinedLexicon(input: input, text: text, events: events)
                })
        }
        private func searchDefinedCandidates(for events: [InputEvent]) -> [Candidate] {
                guard Options.isTextReplacementsOn else { return [] }
                if events.count < 10 {
                        let charCode: Int = events.map(\.code).radix100Combined()
                        return definedLexicons.filter({ $0.charCode == charCode }).map(\.candidate)
                } else {
                        return definedLexicons.filter({ $0.events == events }).map(\.candidate)
                }
        }
        private func queryDefinedCandidates(for combos: [Combo]) -> [Candidate] {
                guard Options.isTextReplacementsOn else { return [] }
                let tenKeyCharCode: Int = combos.map(\.rawValue).decimalCombined()
                guard tenKeyCharCode > 0 else { return [] }
                return definedLexicons.filter({ $0.tenKeyCharCode == tenKeyCharCode }).map(\.candidate)
        }


        // MARK: - Properties

        @Published private(set) var isClipboardEmpty: Bool = false

        @Published private(set) var inputMethodMode: InputMethodMode = .cantonese
        func toggleInputMethodMode() {
                if inputMethodMode.isCantonese && inputStage.isBuffering {
                        inputBufferText()
                }
                inputMethodMode = inputMethodMode.isABC ? .cantonese : .abc
                updateSpaceKeyForm()
                updateReturnKey()
        }

        @Published private(set) var previousKeyboardForm: KeyboardForm = .placeholder
        @Published private(set) var keyboardForm: KeyboardForm = .placeholder
        func updateKeyboardForm(to form: KeyboardForm) {
                let shouldStayBuffering: Bool = inputMethodMode.isCantonese && form.isBufferrable
                if inputStage.isBuffering && shouldStayBuffering.negative {
                        inputBufferText()
                }
                let shouldAdjustKeyboardCase: Bool = (keyboardForm == .alphabetic) && (keyboardCase != .lowercased)
                if shouldAdjustKeyboardCase {
                        keyboardCase = .lowercased
                }
                if form == .editingPanel {
                        isClipboardEmpty = UIPasteboard.general.hasStrings.negative
                }
                previousKeyboardForm = keyboardForm
                keyboardForm = form
                updateReturnKey()
                updateSpaceKeyForm()
                if isKeyboardHeightExpanded {
                        toggleKeyboardHeight()
                }
        }

        @Published private(set) var qwertyForm: QwertyForm = .jyutping
        private func ensureQwertyForm(to form: QwertyForm) {
                guard qwertyForm != form else { return }
                qwertyForm = form
        }

        @Published private(set) var keyboardCase: KeyboardCase = .lowercased
        func updateKeyboardCase(to newCase: KeyboardCase) {
                keyboardCase = newCase
                updateSpaceKeyForm()
        }

        @Published private(set) var returnKeyType: EnhancedReturnKeyType = .default
        @Published private(set) var returnKeyState: ReturnKeyState = .standbyTraditional
        @Published private(set) var returnKeyText: AttributedString = EnhancedReturnKeyType.default.attributedText(of: .standbyTraditional)
        private func updateReturnKey() {
                let newType: EnhancedReturnKeyType = textDocumentProxy.returnKeyType.enhancedReturnKeyType
                let enablesReturnKeyAutomatically: Bool = textDocumentProxy.enablesReturnKeyAutomatically ?? false
                let isAvailable: Bool = enablesReturnKeyAutomatically.negative || textDocumentProxy.hasText
                let newState: ReturnKeyState = ReturnKeyState.state(isAvailable: isAvailable, isABC: inputMethodMode.isABC, isSimplified: Options.characterStandard.isSimplified, isBuffering: inputStage.isBuffering)
                let shouldUpdateKey: Bool = (returnKeyType != newType) || (returnKeyState != newState)
                guard shouldUpdateKey else { return }
                returnKeyText = newType.attributedText(of: newState)
                if returnKeyType != newType {
                        returnKeyType = newType
                }
                if returnKeyState != newState {
                        returnKeyState = newState
                }
        }
        @Published private(set) var spaceKeyForm: SpaceKeyForm = .fallback
        private func updateSpaceKeyForm() {
                let newForm: SpaceKeyForm = {
                        guard inputMethodMode.isCantonese else { return .english }
                        guard keyboardForm != .tenKeyNumeric else { return .fallback }
                        let isSimplified: Bool = Options.characterStandard.isSimplified
                        if inputStage.isBuffering {
                                if candidates.isEmpty {
                                        return isSimplified ? .confirmSimplified : .confirm
                                } else {
                                        return isSimplified ? .selectSimplified : .select
                                }
                        } else {
                                switch keyboardCase {
                                case .lowercased:
                                        return isSimplified ? .lowercasedSimplified : .lowercased
                                case .uppercased:
                                        return isSimplified ? .uppercasedSimplified : .uppercased
                                case .capsLocked:
                                        return isSimplified ? .capsLockedSimplified : .capsLocked
                                }
                        }
                }()
                if spaceKeyForm != newForm {
                        spaceKeyForm = newForm
                }
        }

        private(set) lazy var isRunningOnPhone: Bool = UIDevice.current.userInterfaceIdiom == .phone

        @Published private(set) var keyboardWidth: CGFloat = 440
        @Published private(set) var keyboardHeight: CGFloat = 284
        @Published private(set) var widthUnit: CGFloat = 44
        @Published private(set) var tenKeyWidthUnit: CGFloat = 88
        @Published private(set) var heightUnit: CGFloat = 56
        private func updateKeyboardSize(screenSize: CGSize? = nil) {
                let screenSize: CGSize = screenSize ?? UIScreen.main.bounds.size
                /*
                let newKeyboardWidth: CGFloat = {
                        switch keyboardInterface {
                        case .phoneLandscape:
                                // Screen Aspect Ratio
                                // iPhone with Face ID would be 19.5:9
                                // iPhone with Touch ID would be 16:9
                                let aspectRatio: CGFloat = UIScreen.main.nativeBounds.height / UIScreen.main.nativeBounds.width
                                let horizontalInset: CGFloat = (aspectRatio > 2) ? (117 * 2) : 0
                                return screenSize.width - horizontalInset
                        case .phoneOnPadPortrait:
                                let small: CGFloat = 375 // Same as iPhone SE3
                                let large: CGFloat = 390 // Same as iPhone 14
                                let isLargeScreenPad: Bool = min(screenSize.width, screenSize.height) > 840
                                return isLargeScreenPad ? large : small
                        case .phoneOnPadLandscape:
                                let small: CGFloat = 667 // Same as iPhone SE3
                                let large: CGFloat = 844 // Same as iPhone 14
                                let horizontalInset: CGFloat = 75 * 2
                                let isLargeScreenPad: Bool = min(screenSize.width, screenSize.height) > 840
                                return isLargeScreenPad ? (large - horizontalInset) : small
                        case .padFloating:
                                return 320 // Same as iPhone SE1
                        default:
                                return screenSize.width
                        }
                }()
                */
                keyboardWidth = view.frame.width
                widthUnit = keyboardWidth / keyboardInterface.widthUnitTimes
                tenKeyWidthUnit = keyboardWidth / 5.0
                heightUnit = keyboardInterface.keyHeightUnit(of: screenSize)
                let rowCount: CGFloat = (keyboardInterface.isLargePad || Options.needsNumberRow) ? 5 : 4
                keyboardHeight = (heightUnit * rowCount) + PresetConstant.toolBarHeight
                expandedKeyboardHeight = keyboardHeight + 150
        }

        @Published private(set) var expandedKeyboardHeight: CGFloat = 284 + 150
        @Published private(set) var isKeyboardHeightExpanded: Bool = false
        func toggleKeyboardHeight() {
                isKeyboardHeightExpanded.toggle()
                reloadKeyboard()
        }
        private func reloadKeyboard() {
                // TODO: Needs a more appropriate way
                _ = view.subviews.map({ $0.removeFromSuperview() })
                _ = children.map({ $0.removeFromParent() })
                let board = UIHostingController(rootView: MotherBoard().environmentObject(self))
                board.view.translatesAutoresizingMaskIntoConstraints = false
                addChild(board)
                view.addSubview(board.view)
                NSLayoutConstraint.activate([
                        board.view.topAnchor.constraint(equalTo: view.topAnchor),
                        board.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                        board.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                        board.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                ])
                board.view.backgroundColor = view.backgroundColor
                board.didMove(toParent: self)
                view.layoutIfNeeded()
        }

        @Published private(set) var keyboardInterface: KeyboardInterface = .phonePortrait
        private func adoptKeyboardInterface(screenSize: CGSize? = nil) {
                let newInterface = detectKeyboardInterface(screenSize: screenSize)
                if keyboardInterface != newInterface {
                        keyboardInterface = newInterface
                }
        }
        private func detectKeyboardInterface(screenSize: CGSize? = nil) -> KeyboardInterface {
                let isRunningOnPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
                let isPadInterface: Bool = traitCollection.userInterfaceIdiom == .pad
                let isCompactHorizontal: Bool = traitCollection.horizontalSizeClass == .compact
                let isFloatingOnPad: Bool = {
                        guard isRunningOnPad && isPadInterface else { return false }
                        guard isCompactHorizontal.negative else { return true }
                        let viewWidth = view.frame.width
                        guard viewWidth > 100 else { return false }
                        let screenSize: CGSize = screenSize ?? UIScreen.main.bounds.size
                        return viewWidth < (screenSize.width * 0.75)
                }()
                guard isFloatingOnPad.negative else { return .padFloating }
                switch (isRunningOnPad, isPadInterface) {
                case (true, true):
                        // iPad
                        let screenSize: CGSize = screenSize ?? UIScreen.main.bounds.size
                        let minDimension: CGFloat = min(screenSize.width, screenSize.height)
                        let isPortrait: Bool = screenSize.width < (minDimension + 2)
                        if minDimension > 840 {
                                return isPortrait ? .padPortraitLarge : .padLandscapeLarge
                        } else if minDimension > 815 {
                                return isPortrait ? .padPortraitMedium : .padLandscapeMedium
                        } else {
                                return isPortrait ? .padPortraitSmall : .padLandscapeSmall
                        }
                case (true, false):
                        // iPhone app running on iPad
                        let isCompactVertical: Bool = traitCollection.verticalSizeClass == .compact
                        return isCompactVertical ? .phoneOnPadLandscape : .phoneOnPadPortrait
                case (false, _):
                        // iPhone
                        let isCompactVertical: Bool = traitCollection.verticalSizeClass == .compact
                        return isCompactVertical ? .phoneLandscape : .phonePortrait
                }
        }

        /// Cantonese Keyboard Layout. Qwerty / TripleStroke / TenKey
        @Published private(set) var keyboardLayout: KeyboardLayout = KeyboardLayout.fetchSavedLayout()
        func updateKeyboardLayout(to layout: KeyboardLayout) {
                keyboardLayout = layout
                let value: Int = layout.rawValue
                UserDefaults.standard.set(value, forKey: OptionsKey.KeyboardLayout)
        }

        /// Numeric keyboard for the Qwerty KeyboardLayout
        @Published private(set) var numericLayout: NumericLayout = NumericLayout.fetchSavedLayout()
        func updateNumericLayout(to layout: NumericLayout) {
                numericLayout = layout
                preferredNumericForm = layout.isNumberKeyPad ? .tenKeyNumeric : .numeric
                let value: Int = layout.rawValue
                UserDefaults.standard.set(value, forKey: OptionsKey.NumericLayout)
        }
        @Published private(set) var preferredNumericForm: KeyboardForm = NumericLayout.fetchSavedLayout().isNumberKeyPad ? .tenKeyNumeric : .numeric

        /// Keyboard Layout for Stroke Reverse Lookup
        @Published private(set) var strokeLayout: StrokeLayout = StrokeLayout.fetchSavedLayout()
        func updateStrokeLayout(to layout: StrokeLayout) {
                strokeLayout = layout
                let value: Int = layout.rawValue
                UserDefaults.standard.set(value, forKey: OptionsKey.StrokeLayout)
        }

        func updateNumberRowState(to isOn: Bool) {
                Options.updateNumberRowState(to: isOn)
                updateKeyboardSize()
                reloadKeyboard()
        }


        // MARK: - Haptic Feedback

        private lazy var selectionHapticFeedback: UISelectionFeedbackGenerator? = nil
        private lazy var hapticFeedback: UIImpactFeedbackGenerator? = nil
        private func instantiateHapticFeedbacks() {
                switch hapticFeedbackMode {
                case .disabled:
                        selectionHapticFeedback = nil
                        hapticFeedback = nil
                case .light:
                        selectionHapticFeedback = UISelectionFeedbackGenerator()
                        hapticFeedback = UIImpactFeedbackGenerator(style: .light)
                case .medium:
                        selectionHapticFeedback = UISelectionFeedbackGenerator()
                        hapticFeedback = UIImpactFeedbackGenerator(style: .medium)
                case .heavy:
                        selectionHapticFeedback = UISelectionFeedbackGenerator()
                        hapticFeedback = UIImpactFeedbackGenerator(style: .heavy)
                }
                selectionHapticFeedback?.prepare()
                hapticFeedback?.prepare()
        }
        func prepareSelectionHapticFeedback() {
                selectionHapticFeedback?.prepare()
        }
        func prepareHapticFeedback() {
                hapticFeedback?.prepare()
        }
        func triggerSelectionHapticFeedback() {
                selectionHapticFeedback?.selectionChanged()
                selectionHapticFeedback?.prepare()
        }
        func triggerHapticFeedback() {
                hapticFeedback?.impactOccurred()
                hapticFeedback?.prepare()
        }
        private func releaseHapticFeedbacks() {
                selectionHapticFeedback = nil
                hapticFeedback = nil
        }

        private(set) lazy var hapticFeedbackMode: HapticFeedback = {
                guard hasFullAccess else { return .disabled }
                return HapticFeedback.fetchSavedMode()
        }()
        func updateHapticFeedbackMode(to mode: HapticFeedback) {
                hapticFeedbackMode = mode
                let value: Int = mode.rawValue
                UserDefaults.standard.set(value, forKey: OptionsKey.HapticFeedback)
                instantiateHapticFeedbacks()
        }

        @objc func globeKeyFeedback() {
                AudioFeedback.modified()
                triggerHapticFeedback()
        }
}
