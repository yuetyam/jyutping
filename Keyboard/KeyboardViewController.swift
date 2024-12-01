import SwiftUI
import CommonExtensions
import CoreIME

final class KeyboardViewController: UIInputViewController, ObservableObject {

        private lazy var isKeyboardPrepared: Bool = false
        private func prepareKeyboard() {
                _ = view.subviews.map({ $0.removeFromSuperview() })
                _ = children.map({ $0.removeFromParent() })
                UserLexicon.prepare()
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
                        prepareKeyboard()
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
                        let location: Int = text2mark.utf16.count
                        let range: NSRange = NSRange(location: location, length: 0)
                        textDocumentProxy.setMarkedText(text2mark, selectedRange: range)
                }
        }
        private lazy var canMarkText: Bool = true {
                didSet {
                        guard canMarkText else { return }
                        markText()
                }
        }

        /// Compose text
        /// - Parameter text: Text to insert
        ///
        /// Some Flutter apps can't be compatible with `setMarkedText() & insertText()`
        ///
        /// So we use `setMarkedText() & unmarkText()`
        ///
        /// In iOS 17, we may still need to use `insertText()` and do some hacks.
        private func input(_ text: String) {
                guard text.isNotEmpty else { return }
                canMarkText = false
                let previousContext: String = textDocumentProxy.documentContextBeforeInput ?? String.empty
                let previousLength: Int = previousContext.count
                let location: Int = text.utf16.count
                let range: NSRange = NSRange(location: location, length: 0)
                textDocumentProxy.setMarkedText(text, selectedRange: range)
                textDocumentProxy.unmarkText()
                defer {
                        Task {
                                try await Task.sleep(nanoseconds: 40_000_000) // 0.04s
                                canMarkText = true
                        }
                }
                let currentContext: String = textDocumentProxy.documentContextBeforeInput ?? String.empty
                let currentLength: Int = currentContext.count
                guard currentLength == previousLength else { return }
                guard currentContext == previousContext else { return }
                textDocumentProxy.insertText(text)
        }
        private func inputBufferText(followedBy text2insert: String? = nil) {
                guard bufferText.isNotEmpty else {
                        guard let text2insert, text2insert.isNotEmpty else { return }
                        textDocumentProxy.insertText(text2insert)
                        clearBuffer()
                        return
                }
                canMarkText = false
                let text: String = {
                        guard let text2insert, text2insert.isNotEmpty else { return bufferText }
                        return bufferText + text2insert
                }()
                clearBuffer()
                let previousContext: String = textDocumentProxy.documentContextBeforeInput ?? String.empty
                let previousLength: Int = previousContext.count
                let location: Int = text.utf16.count
                let range: NSRange = NSRange(location: location, length: 0)
                textDocumentProxy.setMarkedText(text, selectedRange: range)
                textDocumentProxy.unmarkText()
                defer {
                        Task {
                                try await Task.sleep(nanoseconds: 80_000_000) // 0.08s
                                canMarkText = true
                        }
                }
                defer {
                        Task {
                                try await Task.sleep(nanoseconds: 40_000_000) // 0.04s
                                let location: Int = String.zeroWidthSpace.utf16.count
                                let range: NSRange = NSRange(location: location, length: 0)
                                textDocumentProxy.setMarkedText(String.zeroWidthSpace, selectedRange: range)
                        }
                }
                let currentContext: String = textDocumentProxy.documentContextBeforeInput ?? String.empty
                let currentLength: Int = currentContext.count
                guard currentLength == previousLength else { return }
                guard currentContext == previousContext else { return }
                textDocumentProxy.insertText(text)
        }


        // MARK: - Buffer

        @Published private(set) var inputStage: InputStage = .standby

        func clearBuffer() {
                bufferCombos = []
                tripleStrokeBuffer = []
                bufferText = String.empty
        }
        private func appendBufferText(_ text: String) {
                tripleStrokeBuffer.append(text)
                bufferText += text
        }

        /// Cantonese Qwerty and TripleStroke layouts
        private lazy var bufferText: String = String.empty {
                didSet {
                        switch (oldValue.isEmpty, bufferText.isEmpty) {
                        case (true, true):
                                inputStage = .standby
                        case (true, false):
                                inputStage = .starting
                                updateReturnKey()
                        case (false, true):
                                inputStage = .ending
                                if Options.isInputMemoryOn && selectedCandidates.isNotEmpty {
                                        let concatenated = selectedCandidates.joined()
                                        UserLexicon.handle(concatenated)
                                }
                                selectedCandidates = []
                                updateReturnKey()
                        case (false, false):
                                inputStage = .ongoing
                        }
                        switch bufferText.first {
                        case .none:
                                suggestionTask?.cancel()
                                ensureQwertyForm(to: .jyutping)
                                candidates = []
                                text2mark = String.empty
                        case .some("r"):
                                pinyinReverseLookup()
                        case .some("v"):
                                ensureQwertyForm(to: .cangjie)
                                cangjieReverseLookup()
                        case .some("x"):
                                ensureQwertyForm(to: .stroke)
                                strokeReverseLookup()
                        case .some("q"):
                                structureReverseLookup()
                        default:
                                suggest()
                        }
                }
        }

        /// Cantonese TripleStroke layout
        private lazy var tripleStrokeBuffer: [String] = []

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
                        case (false, true):
                                inputStage = .ending
                                suggestionTask?.cancel()
                                if Options.isInputMemoryOn && selectedCandidates.isNotEmpty {
                                        let concatenated = selectedCandidates.filter(\.isCantonese).joined()
                                        UserLexicon.handle(concatenated)
                                }
                                selectedCandidates = []
                                candidates = []
                                text2mark = String.empty
                                updateReturnKey()
                        case (false, false):
                                inputStage = .ongoing
                                tenKeySuggest()
                        }
                }
        }

        // TenKey layout
        @Published private(set) var sidebarTexts: [String] = PresetConstant.defaultSidebarTexts
        private func resetSidebarTexts() {
                sidebarTexts = PresetConstant.defaultSidebarTexts
        }


        // MARK: - Operations

        func operate(_ operation: Operation) {
                defer { hasText = textDocumentProxy.hasText }
                switch operation {
                case .input(let text):
                        textDocumentProxy.insertText(text)
                        adjustKeyboard()
                case .separate:
                        appendBufferText("'")
                        adjustKeyboard()
                case .process(let text):
                        defer {
                                adjustKeyboard()
                        }
                        let isCantoneseComposeMode: Bool = inputMethodMode.isCantonese && (keyboardForm == .alphabetic)
                        guard isCantoneseComposeMode else {
                                textDocumentProxy.insertText(text)
                                return
                        }
                        switch text {
                        case PresetConstant.kGW where Options.keyboardLayout.isTripleStroke:
                                if tripleStrokeBuffer.last == PresetConstant.kGW {
                                        tripleStrokeBuffer = tripleStrokeBuffer.dropLast()
                                        tripleStrokeBuffer.append(PresetConstant.kKW)
                                } else {
                                        tripleStrokeBuffer.append(text)
                                }
                                let fullText: String = bufferText + text
                                bufferText = fullText.replacingOccurrences(of: PresetConstant.kDoubleGW, with: PresetConstant.kKW, options: [.anchored, .backwards])
                        case _ where text.isLetters:
                                appendBufferText(text)
                        case _ where Options.keyboardLayout.isTripleStroke && (text.first?.isCantoneseToneDigit ?? false):
                                appendBufferText(text)
                        case _ where inputStage.isBuffering.negative:
                                textDocumentProxy.insertText(text)
                        default:
                                inputBufferText(followedBy: text)
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
                        guard inputStage.isBuffering.negative else {
                                if let candidate = candidates.first {
                                        input(candidate.text)
                                        aftercareSelected(candidate)
                                } else {
                                        inputBufferText()
                                        updateReturnKey()
                                        adjustKeyboard()
                                }
                                return
                        }
                        defer {
                                adjustKeyboard()
                        }
                        let hasSpaceAhead: Bool = textDocumentProxy.documentContextBeforeInput?.hasSuffix(String.space) ?? false
                        guard hasSpaceAhead else {
                                textDocumentProxy.insertText(String.space)
                                return
                        }
                        let shortcutText: String? = {
                                switch (Options.doubleSpaceShortcut, inputMethodMode) {
                                case (.insertPeriod, .abc):
                                        return ". "
                                case (.insertPeriod, .cantonese):
                                        return "。"
                                case (.doNothing, _):
                                        return nil
                                case (.insertIdeographicComma, .abc):
                                        return nil
                                case (.insertIdeographicComma, .cantonese):
                                        return "、"
                                case (.insertFullWidthSpace, .abc):
                                        return nil
                                case (.insertFullWidthSpace, .cantonese):
                                        return String.fullWidthSpace
                                }
                        }()
                        guard let shortcutText else {
                                textDocumentProxy.insertText(String.space)
                                return
                        }
                        textDocumentProxy.deleteBackward()
                        textDocumentProxy.insertText(shortcutText)
                case .backspace:
                        if inputStage.isBuffering {
                                switch Options.keyboardLayout {
                                case .qwerty:
                                        bufferText = String(bufferText.dropLast())
                                        adjustKeyboard()
                                case .tripleStroke:
                                        tripleStrokeBuffer = tripleStrokeBuffer.dropLast()
                                        bufferText = tripleStrokeBuffer.joined()
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
                        if inputStage.isBuffering {
                                inputBufferText()
                                updateReturnKey()
                        } else {
                                textDocumentProxy.insertText(String.newLine)
                        }
                        adjustKeyboard()
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
                        textDocumentProxy.insertText(String.tab)
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
                switch Options.keyboardLayout {
                case .qwerty:
                        switch bufferText.first {
                        case .none:
                                return
                        case .some(let character) where character.isReverseLookupTrigger:
                                selectedCandidates = []
                                let inputCount: Int = candidate.input.count
                                let leadingCount: Int = inputCount + 1
                                if bufferText.count > leadingCount {
                                        let tail = bufferText.dropFirst(leadingCount)
                                        bufferText = String(character) + tail
                                } else {
                                        clearBuffer()
                                }
                        default:
                                guard candidate.isCantonese else {
                                        selectedCandidates = []
                                        clearBuffer()
                                        return
                                }
                                selectedCandidates.append(candidate)
                                let inputCount: Int = candidate.input.replacingOccurrences(of: "[456]", with: "RR", options: .regularExpression).count
                                var tail = bufferText.dropFirst(inputCount)
                                while tail.hasPrefix("'") {
                                        tail = tail.dropFirst()
                                }
                                bufferText = String(tail)
                        }
                case .tripleStroke:
                        // TODO: where keyboardInterface.isCompact ?
                        switch bufferText.first {
                        case .none:
                                return
                        case .some(let character) where character.isReverseLookupTrigger:
                                selectedCandidates = []
                                let inputCount: Int = candidate.input.count
                                let leadingCount: Int = inputCount + 1
                                if bufferText.count > leadingCount {
                                        let tripleStrokeTail = tripleStrokeBuffer.dropFirst(leadingCount)
                                        let tail = bufferText.dropFirst(leadingCount)
                                        tripleStrokeBuffer = [String(character)] + tripleStrokeTail
                                        bufferText = String(character) + tail
                                } else {
                                        clearBuffer()
                                }
                        default:
                                guard candidate.isCantonese else {
                                        selectedCandidates = []
                                        clearBuffer()
                                        return
                                }
                                selectedCandidates.append(candidate)
                                let inputCount: Int = candidate.input.count
                                var tail = bufferText.dropFirst(inputCount)
                                while tail.hasPrefix("'") {
                                        tail = tail.dropFirst()
                                }
                                tripleStrokeBuffer = tripleStrokeBuffer.suffix(tail.count)
                                bufferText = String(tail)
                        }
                case .tenKey:
                        selectedCandidates.append(candidate)
                        let inputCount = candidate.input.count
                        let tailCount: Int = bufferCombos.count - inputCount
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
                let combos = bufferCombos
                let isInputMemoryOn: Bool = Options.isInputMemoryOn
                suggestionTask = Task.detached(priority: .high) {
                        let segmentation = Segmentor.segment(combos: combos)
                        async let userLexiconCandidates: [Candidate] = isInputMemoryOn ? UserLexicon.tenKeySuggest(combos: combos, segmentation: segmentation) : []
                        async let engineCandidates: [Candidate] = Engine.tenKeySuggest(combos: combos, segmentation: segmentation)
                        let suggestions = await (userLexiconCandidates + engineCandidates).transformed(with: Options.characterStandard)
                        if Task.isCancelled.negative {
                                await MainActor.run { [weak self] in
                                        self?.text2mark = {
                                                guard let firstCandidate = suggestions.first else { return String(combos.compactMap(\.letters.first)) }
                                                let userInputCount = combos.count
                                                let firstInputCount = firstCandidate.input.count
                                                guard firstInputCount < userInputCount else { return firstCandidate.mark }
                                                let tailCombos = combos.suffix(userInputCount - firstInputCount)
                                                let tailText = tailCombos.compactMap(\.letters.first)
                                                return firstCandidate.mark + String.space + tailText
                                        }()
                                        self?.candidates = suggestions
                                }
                        }
                }
        }
        private func suggest() {
                suggestionTask?.cancel()
                let originalText = bufferText
                let processingText: String = Options.keyboardLayout.isTripleStroke ? bufferText : bufferText.toneConverted()
                let needsSymbols: Bool = Options.isEmojiSuggestionsOn && selectedCandidates.isEmpty
                let isInputMemoryOn: Bool = Options.isInputMemoryOn
                suggestionTask = Task.detached(priority: .high) {
                        let segmentation = Segmentor.segment(text: processingText)
                        let bestScheme = segmentation.first
                        async let userLexiconCandidates: [Candidate] = isInputMemoryOn ? UserLexicon.suggest(text: processingText, segmentation: segmentation) : []
                        async let engineCandidates: [Candidate] = Engine.suggest(origin: originalText, text: processingText, segmentation: segmentation, needsSymbols: needsSymbols)
                        let suggestions = await (userLexiconCandidates + engineCandidates).transformed(with: Options.characterStandard)
                        if Task.isCancelled.negative {
                                await MainActor.run { [weak self] in
                                        self?.text2mark = {
                                                let hasSeparatorsOrTones: Bool = processingText.contains(where: \.isSeparatorOrTone)
                                                guard hasSeparatorsOrTones.negative else { return processingText.formattedForMark() }
                                                let userInputTextCount: Int = processingText.count
                                                if let firstCandidate = suggestions.first, firstCandidate.input.count == userInputTextCount { return firstCandidate.mark }
                                                guard let bestScheme else { return processingText.formattedForMark() }
                                                let leadingLength: Int = bestScheme.length
                                                let leadingText: String = bestScheme.map(\.text).joined(separator: String.space)
                                                guard leadingLength != userInputTextCount else { return leadingText }
                                                let tailText = processingText.dropFirst(leadingLength)
                                                return leadingText + String.space + tailText
                                        }()
                                        self?.candidates = suggestions
                                }
                        }
                }
        }
        private func pinyinReverseLookup() {
                let text: String = String(bufferText.dropFirst())
                guard text.isNotEmpty else {
                        text2mark = bufferText
                        candidates = []
                        return
                }
                let schemes: [[String]] = PinyinSegmentor.segment(text: text)
                let suggestions: [Candidate] = Engine.pinyinReverseLookup(text: text, schemes: schemes)
                let tailText2Mark: String = {
                        if let firstCandidate = suggestions.first, firstCandidate.input.count == text.count { return firstCandidate.mark }
                        guard let bestScheme = schemes.first else { return text }
                        let leadingLength: Int = bestScheme.summedLength
                        let leadingText: String = bestScheme.joined(separator: String.space)
                        guard leadingLength != text.count else { return leadingText }
                        let tailText = text.dropFirst(leadingLength)
                        return leadingText + String.space + tailText
                }()
                text2mark = "r " + tailText2Mark
                candidates = suggestions.map({ $0.transformed(to: Options.characterStandard) }).uniqued()
        }
        private func cangjieReverseLookup() {
                let text: String = String(bufferText.dropFirst())
                let converted = text.compactMap({ Logogram.cangjie(of: $0) })
                let isValidSequence: Bool = converted.isNotEmpty && (converted.count == text.count)
                if isValidSequence {
                        text2mark = String(converted)
                        let lookup: [Candidate] = Engine.cangjieReverseLookup(text: text, variant: Options.cangjieVariant)
                        candidates = lookup.map({ $0.transformed(to: Options.characterStandard) }).uniqued()
                } else {
                        text2mark = bufferText
                        candidates = []
                }
        }
        private func strokeReverseLookup() {
                let text: String = String(bufferText.dropFirst())
                let transformed: String = Logogram.strokeTransform(text)
                let converted = transformed.compactMap({ Logogram.stroke(of: $0) })
                let isValidSequence: Bool = converted.isNotEmpty && (converted.count == text.count)
                if isValidSequence {
                        text2mark = String(converted)
                        let lookup: [Candidate] = Engine.strokeReverseLookup(text: transformed)
                        candidates = lookup.map({ $0.transformed(to: Options.characterStandard) }).uniqued()
                } else {
                        text2mark = bufferText
                        candidates = []
                }
        }

        /// LoengFan Reverse Lookup. 拆字、兩分反查. 例如 木 + 旦 = 查: mukdaan
        private func structureReverseLookup() {
                guard bufferText.count > 2 else {
                        text2mark = bufferText
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
                        let leadingText: String = bestScheme.map(\.text).joined(separator: String.space)
                        guard leadingLength != text.count else { return leadingText }
                        let tailText = text.dropFirst(leadingLength)
                        return leadingText + String.space + tailText
                }()
                text2mark = "q " + tailMarkedText
                let lookup: [Candidate] = Engine.structureReverseLookup(text: text, input: bufferText, segmentation: segmentation)
                candidates = lookup.map({ $0.transformed(to: Options.characterStandard) }).uniqued()
        }

        /// Cached Candidate sequence for UserLexicon
        private lazy var selectedCandidates: [Candidate] = []

        @Published private(set) var candidatesState: Int = 0
        @Published private(set) var candidates: [Candidate] = [] {
                didSet {
                        candidatesState += 1
                        updateSpaceKeyForm()
                }
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

        @Published private(set) var previousKeyboardForm: KeyboardForm = .alphabetic
        @Published private(set) var keyboardForm: KeyboardForm = .alphabetic
        func updateKeyboardForm(to form: KeyboardForm) {
                let shouldStayBuffering: Bool = inputMethodMode.isCantonese && (form == .alphabetic || form == .candidateBoard)
                if inputStage.isBuffering && shouldStayBuffering.negative {
                        inputBufferText()
                }
                let currentHeight = view.frame.size.height
                if currentHeight > 200 {
                        keyboardHeight = currentHeight
                        expandedKeyboardHeight = currentHeight + 150
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

        private(set) lazy var isPhone: Bool = UITraitCollection.current.userInterfaceIdiom == .phone
        private(set) lazy var isPad: Bool = UITraitCollection.current.userInterfaceIdiom == .pad

        @Published private(set) var keyboardWidth: CGFloat = 375
        @Published private(set) var keyboardHeight: CGFloat = 272
        @Published private(set) var widthUnit: CGFloat = 37.5
        @Published private(set) var tenKeyWidthUnit: CGFloat = 75
        @Published private(set) var heightUnit: CGFloat = 53
        private func updateKeyboardSize() {
                let screen: CGSize = view.window?.windowScene?.screen.bounds.size ?? UIScreen.main.bounds.size
                let newKeyboardWidth: CGFloat = {
                        guard keyboardInterface != .padFloating else { return 320 }
                        let horizontalInset: CGFloat = {
                                let isPhoneLandscape: Bool = traitCollection.verticalSizeClass == .compact
                                guard isPhoneLandscape else { return 0 }
                                let hasHomeButton: Bool = needsInputModeSwitchKey // FIXME: Not a good way
                                return hasHomeButton ? 0 : 236
                        }()
                        return screen.width - horizontalInset
                }()
                keyboardWidth = newKeyboardWidth
                widthUnit = newKeyboardWidth / keyboardInterface.widthUnitTimes
                tenKeyWidthUnit = newKeyboardWidth / 5.0
                heightUnit = keyboardInterface.keyHeightUnit(of: screen)
        }

        @Published private(set) var expandedKeyboardHeight: CGFloat = 272 + 150
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
                switch traitCollection.userInterfaceIdiom {
                case .pad:
                        guard traitCollection.horizontalSizeClass != .compact else { return .padFloating }
                        let screen: CGSize = view.window?.windowScene?.screen.bounds.size ?? UIScreen.main.bounds.size
                        let isPortrait: Bool = screen.width < screen.height
                        let minSide: CGFloat = min(screen.width, screen.height)
                        if minSide > 840 {
                                return isPortrait ? .padPortraitLarge : .padLandscapeLarge
                        } else if minSide > 815 {
                                return isPortrait ? .padPortraitMedium : .padLandscapeMedium
                        } else {
                                return isPortrait ? .padPortraitSmall : .padLandscapeSmall
                        }
                default:
                        switch traitCollection.verticalSizeClass {
                        case .compact:
                                return .phoneLandscape
                        default:
                                return .phonePortrait
                        }
                }
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
