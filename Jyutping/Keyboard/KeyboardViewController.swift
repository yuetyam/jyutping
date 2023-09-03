import SwiftUI
import CommonExtensions
import CoreIME

final class KeyboardViewController: UIInputViewController, ObservableObject {

        override func updateViewConstraints() {
                super.updateViewConstraints()
        }

        override func didReceiveMemoryWarning() {
                super.didReceiveMemoryWarning()
                _ = view.subviews.map({ $0.removeFromSuperview() })
                _ = self.children.map({ $0.removeFromParent() })
                keyboardInterface = adoptKeyboardInterface()
                updateKeyboardSize()
                updateSpaceKeyText()
                updateReturnKeyText()
                let motherBoard = UIHostingController(rootView: MotherBoard().environmentObject(self))
                view.addSubview(motherBoard.view)
                motherBoard.view.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        motherBoard.view.topAnchor.constraint(equalTo: view.topAnchor),
                        motherBoard.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                        motherBoard.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                        motherBoard.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                ])
                motherBoard.view.backgroundColor = view.backgroundColor
                self.addChild(motherBoard)
        }

        override func viewDidLoad() {
                super.viewDidLoad()
                _ = view.subviews.map({ $0.removeFromSuperview() })
                _ = self.children.map({ $0.removeFromParent() })
                keyboardInterface = adoptKeyboardInterface()
                updateKeyboardSize()
                updateSpaceKeyText()
                updateReturnKeyText()
                let motherBoard = UIHostingController(rootView: MotherBoard().environmentObject(self))
                view.addSubview(motherBoard.view)
                motherBoard.view.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        motherBoard.view.topAnchor.constraint(equalTo: view.topAnchor),
                        motherBoard.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                        motherBoard.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                        motherBoard.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                ])
                motherBoard.view.backgroundColor = view.backgroundColor
                self.addChild(motherBoard)
        }
        override func viewWillAppear(_ animated: Bool) {
                UserLexicon.prepare()
                Engine.prepare()
                instantiateHapticFeedbacks()
                updateSpaceKeyText()
                updateReturnKeyText()
        }
        override func viewDidAppear(_ animated: Bool) {
                super.viewDidAppear(animated)
        }
        override func viewWillDisappear(_ animated: Bool) {
                super.viewWillDisappear(animated)
                releaseHapticFeedbacks()
                selectedCandidates = []
                candidates = []
                text2mark = String.empty
                clearBuffer()
        }

        override func viewWillLayoutSubviews() {
                super.viewWillLayoutSubviews()
        }

        override func textWillChange(_ textInput: UITextInput?) {
                // The app is about to change the document's contents. Perform any preparation here.
        }

        override func textDidChange(_ textInput: UITextInput?) {
                let didUserClearTextFiled: Bool = inputStage.isBuffering && !textDocumentProxy.hasText
                if didUserClearTextFiled {
                        clearBuffer()
                }
        }

        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
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
                        let location: Int = (text2mark as NSString).length
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
        /// In iOS 17 betas, we may still need to use `insertText()`
        private func input(_ text: String) {
                canMarkText = false
                defer {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) { [unowned self] in
                                canMarkText = true
                        }
                }
                let previousLength: Int = textDocumentProxy.documentContextBeforeInput?.count ?? 0
                let location: Int = (text as NSString).length
                let range: NSRange = NSRange(location: location, length: 0)
                textDocumentProxy.setMarkedText(text, selectedRange: range)
                textDocumentProxy.unmarkText()
                guard !(text.isEmpty) else { return }
                let currentLength: Int = textDocumentProxy.documentContextBeforeInput?.count ?? 0
                let isFailed: Bool = currentLength == previousLength
                guard isFailed else { return }
                textDocumentProxy.insertText(text)
        }
        private func inputBufferText() {
                // Yes, this's some kind of hack
                defer {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [unowned self] in
                                clearBuffer()
                        }
                }
                defer {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.04) { [unowned self] in
                                textDocumentProxy.deleteBackward()
                        }
                }
                defer {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) { [unowned self] in
                                textDocumentProxy.insertText(String.zeroWidthSpace)
                        }
                }
                let previousLength: Int = textDocumentProxy.documentContextBeforeInput?.count ?? 0
                let location: Int = (bufferText as NSString).length
                let range: NSRange = NSRange(location: location, length: 0)
                textDocumentProxy.setMarkedText(bufferText, selectedRange: range)
                textDocumentProxy.unmarkText()
                guard !(bufferText.isEmpty) else { return }
                let currentLength: Int = textDocumentProxy.documentContextBeforeInput?.count ?? 0
                let isFailed: Bool = currentLength == previousLength
                guard isFailed else { return }
                textDocumentProxy.insertText(bufferText)
        }


        // MARK: - Buffer

        @Published private(set) var inputStage: InputStage = .standby

        func clearBuffer() {
                bufferCombos = []
                bufferText = String.empty
        }
        private func appendBufferText(_ text: String) {
                bufferText += text
        }
        private lazy var bufferText: String = String.empty {
                didSet {
                        switch (oldValue.isEmpty, bufferText.isEmpty) {
                        case (true, true):
                                inputStage = .standby
                        case (true, false):
                                inputStage = .starting
                                if textDocumentProxy.keyboardType == .webSearch {
                                        // REASON: Chrome address bar
                                        textDocumentProxy.insertText(String.empty)
                                }
                                UserLexicon.prepare()
                                Engine.prepare()
                                updateReturnKeyText()
                        case (false, true):
                                inputStage = .ending
                                if !(selectedCandidates.isEmpty) {
                                        let concatenated: Candidate = selectedCandidates.joined()
                                        selectedCandidates = []
                                        UserLexicon.handle(concatenated)
                                }
                                updateReturnKeyText()
                        case (false, false):
                                inputStage = .ongoing
                        }
                        switch bufferText.first {
                        case .none:
                                ensureQwertyForm(to: .jyutping)
                                text2mark = String.empty
                                candidates = []
                        case .some("r"):
                                pinyinReverseLookup()
                        case .some("v"):
                                ensureQwertyForm(to: .cangjie)
                                cangjieReverseLookup()
                        case .some("x"):
                                ensureQwertyForm(to: .stroke)
                                strokeReverseLookup()
                        case .some("q"):
                                composeReverseLookup()
                        default:
                                suggest()
                        }
                }
        }

        private lazy var bufferCombos: [Combo] = [] {
                didSet {
                        switch (oldValue.isEmpty, bufferCombos.isEmpty) {
                        case (true, true):
                                inputStage = .standby
                        case (true, false):
                                inputStage = .starting
                                if textDocumentProxy.keyboardType == .webSearch {
                                        // REASON: Chrome address bar
                                        textDocumentProxy.insertText(String.empty)
                                }
                                UserLexicon.prepare()
                                Engine.prepare()
                                if let combo = bufferCombos.first {
                                        sidebarTexts = combo.keys
                                }
                                updateReturnKeyText()
                        case (false, true):
                                inputStage = .ending
                                if !(selectedCandidates.isEmpty) {
                                        // TODO: Uncomment this
                                        // let concatenated: Candidate = selectedCandidates.joined()
                                        selectedCandidates = []
                                        // UserLexicon.handle(concatenated)
                                }
                                resetSidebarTexts()
                                updateReturnKeyText()
                        case (false, false):
                                inputStage = .ongoing
                                if let combo = bufferCombos.last {
                                        sidebarTexts = combo.keys
                                }
                        }
                        tenKeySuggest()
                }
        }

        @Published private(set) var sidebarTexts: [String] = Constant.defaultSidebarTexts
        private func resetSidebarTexts() {
                sidebarTexts = Constant.defaultSidebarTexts
        }


        // MARK: - Operations

        func operate(_ operation: Operation) {
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
                        case "gw" where Options.keyboardLayout == .saamPing:
                                let fullText: String = bufferText + text
                                bufferText = fullText.replacingOccurrences(of: "gwgw", with: "kw", options: [.anchored, .backwards])
                        case _ where text.isLetters:
                                appendBufferText(text)
                        case _ where (Options.keyboardLayout == .saamPing) && (text.first?.isCantoneseToneDigit ?? false):
                                appendBufferText(text)
                        case _ where !(inputStage.isBuffering):
                                textDocumentProxy.insertText(text)
                        default:
                                inputBufferText()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) { [unowned self] in
                                        textDocumentProxy.insertText(text)
                                }
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
                                updateReturnKeyText()
                                adjustKeyboard()
                        }
                case .doubleSpace:
                        guard !(inputStage.isBuffering) else { return }
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
                                let isTenKeyKeyboard: Bool = (Options.keyboardLayout == .tenKey) && keyboardInterface.isCompact
                                if isTenKeyKeyboard {
                                        bufferCombos = bufferCombos.dropLast()
                                } else {
                                        bufferText = String(bufferText.dropLast())
                                }
                        } else {
                                textDocumentProxy.deleteBackward()
                        }
                case .clearBuffer:
                        clearBuffer()
                case .return:
                        if inputStage.isBuffering {
                                inputBufferText()
                                updateReturnKeyText()
                        } else {
                                textDocumentProxy.insertText("\n")
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
                        textDocumentProxy.insertText("\t")
                case .dismiss:
                        dismissKeyboard()
                case .select(let candidate):
                        input(candidate.text)
                        aftercareSelected(candidate)
                case .paste:
                        guard UIPasteboard.general.hasStrings else { return }
                        guard let text = UIPasteboard.general.string else { return }
                        guard !(text.isEmpty) else { return }
                        textDocumentProxy.insertText(text)
                case .clearClipboard:
                        UIPasteboard.general.items.removeAll()
                case .clearLeadingText:
                        textDocumentProxy.deleteBackward() // Delete selectedText
                        for _ in 0..<5 {
                                guard let textBeforeCursor = textDocumentProxy.documentContextBeforeInput else { break }
                                _ = (0..<textBeforeCursor.count).map({ _ in
                                        textDocumentProxy.deleteBackward()
                                })
                        }
                case .moveCursorBackward:
                        textDocumentProxy.adjustTextPosition(byCharacterOffset: -1)
                case .moveCursorForward:
                        textDocumentProxy.adjustTextPosition(byCharacterOffset: 1)
                case .jumpToHead:
                        for _ in 0..<5 {
                                guard let text = textDocumentProxy.documentContextBeforeInput else { break }
                                textDocumentProxy.adjustTextPosition(byCharacterOffset: -(text.count))
                        }
                case .jumpToTail:
                        for _ in 0..<5 {
                                guard let text = textDocumentProxy.documentContextAfterInput else { break }
                                textDocumentProxy.adjustTextPosition(byCharacterOffset: text.count)
                        }
                }
        }
        private func aftercareSelected(_ candidate: Candidate) {
                defer {
                        adjustKeyboard()
                }
                let isTenKeyKeyboard: Bool = (Options.keyboardLayout == .tenKey) && keyboardInterface.isCompact
                guard !isTenKeyKeyboard else {
                        // TODO: selectedCandidates.append(candidate)
                        let length: Int = bufferCombos.count - candidate.input.count
                        bufferCombos = bufferCombos.suffix(length)
                        return
                }
                switch bufferText.first {
                case .none:
                        return
                case .some(let character) where character.isReverseLookupTrigger:
                        selectedCandidates = []
                        let leadingCount: Int = candidate.input.count + 1
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
                        let inputCount: Int = {
                                switch Options.keyboardLayout {
                                case .saamPing:
                                        return candidate.input.count
                                default:
                                        return candidate.input.replacingOccurrences(of: "(4|5|6)", with: "RR", options: .regularExpression).count
                                }
                        }()
                        var tail = bufferText.dropFirst(inputCount)
                        while tail.hasPrefix("'") {
                                tail = tail.dropFirst()
                        }
                        bufferText = String(tail)
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

        private func tenKeySuggest() {
                guard var possibleTexts = bufferCombos.first?.keys else {
                        text2mark = String.empty
                        if !(candidates.isEmpty) {
                                candidates = []
                        }
                        return
                }
                for combo in bufferCombos.dropFirst() {
                        let possibilities = combo.keys.map { key -> [String] in
                                return possibleTexts.map({ $0 + key })
                        }
                        possibleTexts = possibilities.flatMap({ $0 })
                }
                let suggestions = Engine.tenKeySuggest(sequences: possibleTexts).map({ $0.transformed(to: Options.characterStandard) }).uniqued()
                text2mark = suggestions.first?.input ?? String.empty
                candidates = suggestions
        }

        private func suggest() {
                let processingText: String = bufferText.toneConverted()
                let segmentation = Segmentor.segment(text: processingText)
                let text2mark: String = {
                        let isMarkFree: Bool = processingText.first(where: { $0.isSeparatorOrTone }) == nil
                        guard isMarkFree else { return processingText.formattedForMark() }
                        guard let bestScheme = segmentation.first else { return processingText.formattedForMark() }
                        let leadingLength: Int = bestScheme.length
                        let leadingText: String = bestScheme.map(\.text).joined(separator: String.space)
                        guard leadingLength != processingText.count else { return leadingText }
                        let tailText = processingText.dropFirst(leadingLength)
                        return leadingText + String.space + tailText
                }()
                self.text2mark = text2mark
                let engineCandidates: [Candidate] = {
                        var suggestion: [Candidate] = Engine.suggest(text: processingText, segmentation: segmentation)
                        let shouldContinue: Bool = Options.isEmojiSuggestionsOn && !(suggestion.isEmpty) && selectedCandidates.isEmpty
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
                let userCandidates: [Candidate] = UserLexicon.suggest(text: processingText, segmentation: segmentation)
                let combined: [Candidate] = userCandidates + engineCandidates
                candidates = combined.map({ $0.transformed(to: Options.characterStandard) }).uniqued()
        }
        private func pinyinReverseLookup() {
                let text: String = String(bufferText.dropFirst())
                guard !(text.isEmpty) else {
                        text2mark = bufferText
                        candidates = []
                        return
                }
                let schemes: [[String]] = PinyinSegmentor.segment(text: text)
                let tailMarkedText: String = {
                        guard let bestScheme = schemes.first else { return text }
                        let leadingLength: Int = bestScheme.summedLength
                        let leadingText: String = bestScheme.joined(separator: String.space)
                        guard leadingLength != text.count else { return leadingText }
                        let tailText = text.dropFirst(leadingLength)
                        return leadingText + String.space + tailText
                }()
                text2mark = "r " + tailMarkedText
                let lookup: [Candidate] = Engine.pinyinReverseLookup(text: text, schemes: schemes)
                candidates = lookup.map({ $0.transformed(to: Options.characterStandard) }).uniqued()
        }
        private func cangjieReverseLookup() {
                let text: String = String(bufferText.dropFirst())
                let converted = text.map({ Logogram.cangjie(of: $0) }).compactMap({ $0 })
                let isValidSequence: Bool = !converted.isEmpty && converted.count == text.count
                if isValidSequence {
                        text2mark = String(converted)
                        let lookup: [Candidate] = Engine.cangjieReverseLookup(text: text)
                        candidates = lookup.map({ $0.transformed(to: Options.characterStandard) }).uniqued()
                } else {
                        text2mark = bufferText
                        candidates = []
                }
        }
        private func strokeReverseLookup() {
                let text: String = String(bufferText.dropFirst())
                let transformed: String = Logogram.strokeTransform(text)
                let converted = transformed.map({ Logogram.stroke(of: $0) }).compactMap({ $0 })
                let isValidSequence: Bool = !converted.isEmpty && converted.count == text.count
                if isValidSequence {
                        text2mark = String(converted)
                        let lookup: [Candidate] = Engine.strokeReverseLookup(text: transformed)
                        candidates = lookup.map({ $0.transformed(to: Options.characterStandard) }).uniqued()
                } else {
                        text2mark = bufferText
                        candidates = []
                }
        }
        private func composeReverseLookup() {
                guard bufferText.count > 2 else {
                        text2mark = bufferText
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
                        let leadingText: String = bestScheme.map(\.text).joined(separator: String.space)
                        guard leadingLength != text.count else { return leadingText }
                        let tailText = text.dropFirst(leadingLength)
                        return leadingText + String.space + tailText
                }()
                text2mark = "q " + tailMarkedText
                let lookup: [Candidate] = Engine.composeReverseLookup(text: text, input: bufferText, segmentation: segmentation)
                candidates = lookup.map({ $0.transformed(to: Options.characterStandard) }).uniqued()
        }

        /// Cached Candidate sequence for UserLexicon
        private lazy var selectedCandidates: [Candidate] = []

        @Published private(set) var candidates: [Candidate] = []


        // MARK: - Properties

        @Published private(set) var inputMethodMode: InputMethodMode = .cantonese
        func toggleInputMethodMode() {
                if inputMethodMode.isCantonese && inputStage.isBuffering {
                        inputBufferText()
                }
                inputMethodMode = inputMethodMode.isABC ? .cantonese : .abc
                updateSpaceKeyText()
                updateReturnKeyText()
        }

        @Published private(set) var previousKeyboardForm: KeyboardForm = .alphabetic
        @Published private(set) var keyboardForm: KeyboardForm = .alphabetic
        func updateKeyboardForm(to form: KeyboardForm) {
                if inputStage.isBuffering {
                        inputBufferText()
                }
                previousKeyboardForm = keyboardForm
                keyboardForm = form
                updateReturnKeyText()
                updateSpaceKeyText()
        }

        @Published private(set) var qwertyForm: QwertyForm = .jyutping
        private func ensureQwertyForm(to form: QwertyForm) {
                guard qwertyForm != form else { return }
                qwertyForm = form
        }

        @Published private(set) var keyboardCase: KeyboardCase = .lowercased
        func updateKeyboardCase(to newCase: KeyboardCase) {
                keyboardCase = newCase
                updateSpaceKeyText()
        }

        @Published private(set) var returnKeyText: String = "換行"
        private func updateReturnKeyText() {
                let newText: String = textDocumentProxy.returnKeyType.returnKeyText(isABC: inputMethodMode.isABC, isSimplified: Options.characterStandard.isSimplified, isBuffering: inputStage.isBuffering)
                if returnKeyText != newText {
                        returnKeyText = newText
                }
        }
        @Published private(set) var spaceKeyText: String = "粵拼"
        private func updateSpaceKeyText() {
                let newText: String = {
                        guard inputMethodMode.isCantonese else { return "space" }
                        guard keyboardForm != .tenKeyNumeric else { return "空格" }
                        let isSimplified: Bool = Options.characterStandard.isSimplified
                        switch keyboardCase {
                        case .lowercased:
                                return isSimplified ? "粤拼·简化字" : "粵拼"
                        case .uppercased:
                                return "全形空格"
                        case .capsLocked:
                                return isSimplified ? "大写锁定" : "大寫鎖定"
                        }
                }()
                if spaceKeyText != newText {
                        spaceKeyText = newText
                }
        }
        @Published private(set) var touchedLocation: CGPoint = .zero
        func updateTouchedLocation(to point: CGPoint) {
                touchedLocation = point
        }

        private(set) lazy var isPhone: Bool = UITraitCollection.current.userInterfaceIdiom == .phone
        private(set) lazy var isPad: Bool = UITraitCollection.current.userInterfaceIdiom == .pad

        @Published private(set) var keyboardWidth: CGFloat = 375
        @Published private(set) var widthUnit: CGFloat = 37.5
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
                widthUnit = keyboardWidth / keyboardInterface.widthUnitTimes
                heightUnit = keyboardInterface.keyHeightUnit(of: screen)
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
                prepareSelectionHapticFeedback()
        }
        func triggerHapticFeedback() {
                hapticFeedback?.impactOccurred()
                prepareHapticFeedback()
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
}
