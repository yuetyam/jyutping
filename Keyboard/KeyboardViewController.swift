import SwiftUI
import CommonExtensions
import CoreIME

final class KeyboardViewController: UIInputViewController, ObservableObject {

        private lazy var isKeyboardPrepared: Bool = false
        private func prepareKeyboard() {
                _ = view.subviews.map({ $0.removeFromSuperview() })
                _ = children.map({ $0.removeFromParent() })
                InputMemory.prepare()
                Engine.prepare()
                instantiateHapticFeedbacks()
                keyboardInterface = adoptKeyboardInterface()
                updateKeyboardSize()
                updateSpaceKeyForm()
                updateReturnKey()
                let motherBoard = UIHostingController(rootView: MotherBoard().environmentObject(self))
                addChild(motherBoard)
                view.addSubview(motherBoard.view)
                motherBoard.view.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        motherBoard.view.topAnchor.constraint(equalTo: view.topAnchor),
                        motherBoard.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                        motherBoard.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                        motherBoard.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                ])
                motherBoard.view.backgroundColor = view.backgroundColor
                isKeyboardPrepared = true
        }
        override func viewDidLoad() {
                super.viewDidLoad()
                if isKeyboardPrepared {
                        // do something
                } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [unowned self] in
                                prepareKeyboard()
                        }
                }
        }
        override func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)
                if isKeyboardPrepared {
                        updateSpaceKeyForm()
                        updateReturnKey()
                } else {
                        prepareKeyboard()
                }
        }
        override func viewWillDisappear(_ animated: Bool) {
                super.viewWillDisappear(animated)
                _ = view.subviews.map({ $0.removeFromSuperview() })
                _ = children.map({ $0.removeFromParent() })
                isKeyboardPrepared = false
                releaseHapticFeedbacks()
                selectedCandidates = []
                candidates = []
                text2mark = String.empty
                clearBuffer()
        }

        private lazy var keyboardType: UIKeyboardType = .default
        override func textWillChange(_ textInput: (any UITextInput)?) {
                super.textWillChange(textInput)
                guard let newKeyboardType = (textInput?.keyboardType ?? textDocumentProxy.keyboardType) else { return }
                guard keyboardType != newKeyboardType else { return }
                keyboardType = newKeyboardType
                let newInputMethodMode = newKeyboardType.inputMethodMode
                if inputMethodMode != newInputMethodMode {
                        inputMethodMode = newInputMethodMode
                }
                let newKeyboardForm = newKeyboardType.keyboardForm
                if keyboardForm != newKeyboardForm {
                        updateKeyboardForm(to: newKeyboardForm)
                }
        }

        private lazy var hasText: Bool? = nil {
                didSet {
                        guard oldValue != nil else { return }
                        guard hasText != oldValue else { return }
                        updateReturnKey()
                }
        }
        override func textDidChange(_ textInput: UITextInput?) {
                super.textDidChange(textInput)
                let hasText: Bool = textInput?.hasText ?? textDocumentProxy.hasText
                self.hasText = hasText
                let didUserClearTextField: Bool = hasText.negative && inputStage.isBuffering
                if didUserClearTextField {
                        clearBuffer()
                }
        }

        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
                super.traitCollectionDidChange(previousTraitCollection)
                keyboardInterface = adoptKeyboardInterface()
                updateKeyboardSize()
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
        private lazy var capitals: [Bool] = []
        private lazy var inputLengthSequence: [Int] = []

        private func joinedBufferTexts() -> String {
                guard capitals.contains(true) else { return bufferEvents.map(\.text).joined() }
                guard bufferEvents.count == capitals.count else { return bufferEvents.map(\.text).joined() }
                return zip(capitals, bufferEvents).map({ $0 ? $1.text.uppercased() : $1.text }).joined()
        }

        func process(_ event: InputEvent, isCapitalized: Bool) {
                defer {
                        adjustKeyboard()
                }
                lazy var text: String = isCapitalized ? event.text.uppercased() : event.text
                let isCantoneseComposeMode: Bool = inputMethodMode.isCantonese && keyboardForm.isBufferrable
                guard isCantoneseComposeMode else {
                        textDocumentProxy.insertText(text)
                        return
                }
                let shouldAppendEvent: Bool = event.isLetter || (inputStage.isBuffering && (event.isToneNumber || event.isQuote))
                guard shouldAppendEvent else {
                        if inputStage.isBuffering {
                                inputBufferText(followedBy: text)
                        } else {
                                textDocumentProxy.insertText(text)
                        }
                        return
                }
                bufferEvents.append(event)
                capitals.append(isCapitalized)
                inputLengthSequence.append(1)
        }
        func process(events: [InputEvent], isCapitalized: Bool) {
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
                let shouldAppendEvent: Bool = firstEvent.isLetter || (inputStage.isBuffering && (firstEvent.isToneNumber || firstEvent.isQuote))
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
                        bufferEvents = bufferEvents.dropLast(2)
                        bufferEvents += InputEvent.KWEvents
                } else {
                        bufferEvents += events
                        capitals.append(isCapitalized)
                        inputLengthSequence.append(events.count)
                }
        }
        private func appendBufferText(_ text: String) {
                switch text.count {
                case 0: return
                case 1:
                        guard let event = InputEvent.matchInputEvent(for: text.lowercased().first!) else { return }
                        process(event, isCapitalized: text.first!.isUppercase)
                default:
                        let events = text.lowercased().compactMap(InputEvent.matchInputEvent(for:))
                        guard events.isNotEmpty else { return }
                        process(events: events, isCapitalized: text.first!.isUppercase)
                }
        }

        private func clearBuffer() {
                bufferCombos = []
                capitals = []
                bufferEvents = []
                inputLengthSequence = []
        }

        /// Cantonese TenKey layout
        private lazy var bufferCombos: [Combo] = [] {
                didSet {
                        clearSidebarSyllables()
                        switch (oldValue.isEmpty, bufferCombos.isEmpty) {
                        case (true, true):
                                inputStage = .standby
                        case (true, false):
                                inputStage = .starting
                                updateReturnKey()
                                tenKeySuggest()
                        case (false, false):
                                inputStage = .ongoing
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
                defer { hasText = textDocumentProxy.hasText }
                switch operation {
                case .input(let text):
                        textDocumentProxy.insertText(text)
                        adjustKeyboard()
                case .separate:
                        process(.quote, isCapitalized: false)
                        adjustKeyboard()
                case .process(let text):
                        let isCantoneseComposeMode: Bool = inputMethodMode.isCantonese && keyboardForm.isBufferrable
                        guard isCantoneseComposeMode else {
                                textDocumentProxy.insertText(text)
                                adjustKeyboard()
                                return
                        }
                        let shouldAppendText: Bool = text.isLetters || (inputStage.isBuffering && (text.first?.isCantoneseToneDigit ?? false))
                        if shouldAppendText {
                                appendBufferText(text)
                        } else if inputStage.isBuffering {
                                inputBufferText(followedBy: text)
                                adjustKeyboard()
                        } else {
                                textDocumentProxy.insertText(text)
                                adjustKeyboard()
                        }
                case .combine(let combo):
                        bufferCombos.append(combo)
                case .space:
                        guard inputMethodMode.isCantonese else {
                                textDocumentProxy.insertText(String.space)
                                adjustKeyboard()
                                return
                        }
                        guard inputStage.isBuffering else {
                                let text: String = (keyboardCase == .uppercased) ? String.fullWidthSpace : String.space
                                textDocumentProxy.insertText(text)
                                adjustKeyboard()
                                return
                        }
                        if let candidate = candidates.first {
                                input(candidate.text)
                                aftercareSelected(candidate)
                        } else {
                                inputBufferText()
                                updateReturnKey()
                                adjustKeyboard()
                        }
                case .doubleSpace:
                        if inputStage.isBuffering {
                                if let candidate = candidates.first {
                                        input(candidate.text)
                                        aftercareSelected(candidate)
                                } else {
                                        inputBufferText()
                                        updateReturnKey()
                                        adjustKeyboard()
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
                                adjustKeyboard()
                        }
                case .backspace:
                        if inputStage.isBuffering {
                                switch keyboardLayout {
                                case .qwerty:
                                        bufferEvents = bufferEvents.dropLast()
                                        capitals = capitals.dropLast()
                                        inputLengthSequence = inputLengthSequence.dropLast()
                                        adjustKeyboard()
                                case .tripleStroke:
                                        guard let lastInputLength = inputLengthSequence.last else { return }
                                        bufferEvents = bufferEvents.dropLast(lastInputLength)
                                        capitals = capitals.dropLast(lastInputLength)
                                        inputLengthSequence = inputLengthSequence.dropLast()
                                        adjustKeyboard()
                                case .tenKey:
                                        bufferCombos = bufferCombos.dropLast()
                                }
                        } else {
                                textDocumentProxy.deleteBackward()
                                adjustKeyboard()
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
                                adjustKeyboard()
                        } else {
                                textDocumentProxy.insertText(String.newLine)
                                adjustKeyboard()
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
                case .tab:
                        if inputStage.isBuffering {
                                inputBufferText(followedBy: String.tab)
                        } else {
                                textDocumentProxy.insertText(String.tab)
                        }
                        adjustKeyboard()
                case .dismiss:
                        dismissKeyboard()
                case .select(let candidate):
                        input(candidate.text)
                        aftercareSelected(candidate)
                case .copyAllText:
                        let didCopyText: Bool = textDocumentProxy.copyAllText()
                        guard didCopyText else { return }
                        isClipboardEmpty = false
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
                defer {
                        adjustKeyboard()
                }
                switch keyboardLayout {
                case .qwerty, .tripleStroke:
                        switch bufferEvents.first {
                        case .none: return
                        case .some(let event) where event.isReverseLookupTrigger:
                                selectedCandidates = []
                                let leadingCount: Int = candidate.inputCount + 1
                                guard bufferEvents.count > leadingCount else {
                                        clearBuffer()
                                        return
                                }
                                let tail = bufferEvents.dropFirst(leadingCount)
                                bufferEvents = [event] + tail
                                let altTail = inputLengthSequence.dropFirst(leadingCount)
                                inputLengthSequence = [1] + altTail
                                guard let firstCapital = capitals.first else { return }
                                capitals = [firstCapital] + capitals.suffix(tail.count)
                        default:
                                if candidate.isCantonese {
                                        selectedCandidates.append(candidate)
                                } else {
                                        selectedCandidates = []
                                }
                                guard candidate.inputCount < bufferEvents.count else {
                                        clearBuffer()
                                        return
                                }
                                var tail = bufferEvents.dropFirst(candidate.inputCount)
                                while (tail.first?.isQuote ?? false) {
                                        tail = tail.dropFirst()
                                }
                                let tailLength = tail.count
                                bufferEvents = bufferEvents.suffix(tailLength)
                                capitals = capitals.suffix(tailLength)
                                inputLengthSequence = inputLengthSequence.suffix(tailLength)
                        }
                case .tenKey:
                        if candidate.isCantonese {
                                selectedCandidates.append(candidate)
                        } else {
                                selectedCandidates = []
                        }
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
                        guard candidates.isEmpty else { return }
                        updateKeyboardForm(to: previousKeyboardForm)
                default:
                        break
                }
        }


        // MARK: - Candidate Suggestions

        private lazy var suggestionTask: Task<Void, Never>? = nil
        private func tenKeySuggest() {
                suggestionTask?.cancel()
                let isEmojiSuggestionsOn: Bool = Options.isEmojiSuggestionsOn
                let isInputMemoryOn: Bool = Options.isInputMemoryOn
                suggestionTask = Task.detached(priority: .high) { [weak self] in
                        guard let self else { return }
                        let combos = await bufferCombos
                        async let memoryCandidates: [Candidate] = isInputMemoryOn ? InputMemory.tenKeySuggest(combos: combos) : []
                        async let engineCandidates: [Candidate] = Engine.tenKeySuggest(combos: combos)
                        let suggestions = await (memoryCandidates + engineCandidates).transformed(with: Options.characterStandard, isEmojiSuggestionsOn: isEmojiSuggestionsOn)
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
                                        self.tenKeyCachedCandidates = suggestions
                                        self.updateSidebarSyllables()
                                }
                        }
                }
        }
        private func suggest() {
                suggestionTask?.cancel()
                let isEmojiSuggestionsOn: Bool = Options.isEmojiSuggestionsOn
                let isInputMemoryOn: Bool = Options.isInputMemoryOn
                suggestionTask = Task.detached(priority: .high) { [weak self] in
                        guard let self else { return }
                        let segmentation = await Segmenter.segment(events: bufferEvents)
                        async let memoryCandidates: [Candidate] = isInputMemoryOn ? InputMemory.suggest(events: bufferEvents, segmentation: segmentation) : []
                        async let engineCandidates: [Candidate] = Engine.suggest(events: bufferEvents, segmentation: segmentation)
                        let suggestions = await (memoryCandidates + engineCandidates).transformed(with: Options.characterStandard, isEmojiSuggestionsOn: isEmojiSuggestionsOn)
                        if Task.isCancelled.negative {
                                await MainActor.run { [weak self] in
                                        guard let self else { return }
                                        self.text2mark = {
                                                lazy var text: String = joinedBufferTexts()
                                                let isPeculiar: Bool = capitals.contains(true) || bufferEvents.contains(where: \.isSyllableLetter.negative)
                                                guard isPeculiar.negative else { return text.toneConverted().formattedForMark() }
                                                guard let firstCandidate = suggestions.first else { return text }
                                                guard firstCandidate.inputCount != bufferEvents.count else { return firstCandidate.mark }
                                                guard let bestScheme = segmentation.first else { return text }
                                                let leadingLength: Int = bestScheme.length
                                                guard leadingLength < bufferEvents.count else { return bestScheme.mark }
                                                return bestScheme.mark + String.space + text.dropFirst(leadingLength)
                                        }()
                                        self.candidates = suggestions
                                }
                        }
                }
        }
        private func pinyinReverseLookup() {
                let bufferText = joinedBufferTexts()
                let text: String = String(bufferText.dropFirst())
                guard text.isNotEmpty else {
                        text2mark = bufferText
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
                text2mark = "r " + tailText2Mark
                candidates = suggestions.transformed(to: Options.characterStandard).uniqued()
        }
        private func cangjieReverseLookup() {
                let bufferText = joinedBufferTexts()
                let text: String = String(bufferText.dropFirst())
                let converted = text.compactMap({ CharacterStandard.cangjie(of: $0) })
                let isValidSequence: Bool = converted.isNotEmpty && (converted.count == text.count)
                if isValidSequence {
                        text2mark = String(converted)
                        let lookup: [Candidate] = Engine.cangjieReverseLookup(text: text, variant: Options.cangjieVariant)
                        candidates = lookup.transformed(to: Options.characterStandard).uniqued()
                } else {
                        text2mark = bufferText
                        candidates = []
                }
        }
        private func strokeReverseLookup() {
                let bufferText = joinedBufferTexts()
                let text: String = String(bufferText.dropFirst())
                let transformed: String = CharacterStandard.strokeTransform(text)
                let converted = transformed.compactMap({ CharacterStandard.stroke(of: $0) })
                let isValidSequence: Bool = converted.isNotEmpty && (converted.count == text.count)
                if isValidSequence {
                        text2mark = String(converted)
                        let lookup: [Candidate] = Engine.strokeReverseLookup(text: transformed)
                        candidates = lookup.transformed(to: Options.characterStandard).uniqued()
                } else {
                        text2mark = bufferText
                        candidates = []
                }
        }

        /// 拆字、兩分反查. 例如 木 + 木 = 林: mukmuk
        private func structureReverseLookup() {
                let bufferText = joinedBufferTexts()
                guard bufferText.count > 2 else {
                        text2mark = bufferText
                        candidates = []
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
                text2mark = "q " + tailMark
                let lookup: [Candidate] = Engine.structureReverseLookup(events: bufferEvents, input: bufferText, segmentation: segmentation)
                candidates = lookup.transformed(to: Options.characterStandard).uniqued()
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

        @Published private(set) var previousKeyboardForm: KeyboardForm = .alphabetic
        @Published private(set) var keyboardForm: KeyboardForm = .alphabetic
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
                let newText: AttributedString = newType.attributedText(of: newState)
                if returnKeyType != newType {
                        returnKeyType = newType
                }
                if returnKeyState != newState {
                        returnKeyState = newState
                }
                if returnKeyText != newText {
                        returnKeyText = newText
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
        private func updateKeyboardSize() {
                let screenSize: CGSize = view.window?.windowScene?.screen.bounds.size ?? UIScreen.main.bounds.size
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
                keyboardWidth = newKeyboardWidth
                widthUnit = newKeyboardWidth / keyboardInterface.widthUnitTimes
                tenKeyWidthUnit = newKeyboardWidth / 5.0
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
                _ = view.subviews.map({ $0.removeFromSuperview() })
                _ = children.map({ $0.removeFromParent() })
                let motherBoard = UIHostingController(rootView: MotherBoard().environmentObject(self))
                addChild(motherBoard)
                view.addSubview(motherBoard.view)
                motherBoard.view.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        motherBoard.view.topAnchor.constraint(equalTo: view.topAnchor),
                        motherBoard.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                        motherBoard.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                        motherBoard.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                ])
                motherBoard.view.backgroundColor = view.backgroundColor
        }

        @Published private(set) var keyboardInterface: KeyboardInterface = .phonePortrait
        private func adoptKeyboardInterface() -> KeyboardInterface {
                let isRunningOnPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
                let isPadInterface: Bool = traitCollection.userInterfaceIdiom == .pad
                let isCompactHorizontal: Bool = traitCollection.horizontalSizeClass == .compact
                let isFloatingOnPad: Bool = isRunningOnPad && isPadInterface && isCompactHorizontal
                guard isFloatingOnPad.negative else { return .padFloating }
                switch (isRunningOnPad, isPadInterface) {
                case (true, true):
                        // iPad
                        let screenSize: CGSize = view.window?.windowScene?.screen.bounds.size ?? UIScreen.main.bounds.size
                        let minDimension: CGFloat = min(screenSize.width, screenSize.height)
                        let windowSize: CGSize = view.superview?.window?.bounds.size ?? screenSize
                        let isPortrait: Bool = windowSize.width < (minDimension + 2)
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
