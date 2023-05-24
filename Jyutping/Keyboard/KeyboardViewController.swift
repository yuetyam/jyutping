import SwiftUI
import CommonExtensions
import CoreIME

final class KeyboardViewController: UIInputViewController, ObservableObject {

        override func updateViewConstraints() {
                super.updateViewConstraints()
        }

        override func viewDidLoad() {
                super.viewDidLoad()
                _ = view.subviews.map({ $0.removeFromSuperview() })
                _ = self.children.map({ $0.removeFromParent() })
                updateKeyboardSize()
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
                Engine.prepare()
                instantiateHapticFeedbacks()
        }
        override func viewDidAppear(_ animated: Bool) {
                super.viewDidAppear(animated)
        }
        override func viewWillDisappear(_ animated: Bool) {
                super.viewWillDisappear(animated)
                releaseHapticFeedbacks()
                candidates = []
                markedText = .empty
                bufferText = .empty
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
                        clearBufferText()
                }
        }

        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
                updateKeyboardSize()
                let newKeyboardAppearance: Appearance = (traitCollection.userInterfaceStyle == .dark || textDocumentProxy.keyboardAppearance == .dark) ? .dark : .light
                if appearance != newKeyboardAppearance {
                        appearance = newKeyboardAppearance
                }
                let newKeyboardInterface: KeyboardInterface = adoptKeyboardInterface()
                if keyboardInterface != newKeyboardInterface {
                        keyboardInterface = newKeyboardInterface
                }
        }


        // MARK: - Mark & Insert

        private lazy var markedText: String = .empty {
                willSet {
                        // REASON: Chrome address bar
                        guard textDocumentProxy.keyboardType == .webSearch else { return }
                        guard markedText.isEmpty && !newValue.isEmpty else { return }
                        textDocumentProxy.insertText(String.empty)
                }
                didSet {
                        if markedText.isEmpty {
                                textDocumentProxy.setMarkedText(String.empty, selectedRange: NSRange(location: 0, length: 0))
                                textDocumentProxy.unmarkText()
                        } else {
                                let location: Int = (markedText as NSString).length
                                let range: NSRange = NSRange(location: location, length: 0)
                                textDocumentProxy.setMarkedText(markedText, selectedRange: range)
                        }
                }
        }

        private func insert(_ text: String) {
                let location: Int = (text as NSString).length
                let range: NSRange = NSRange(location: location, length: 0)
                textDocumentProxy.setMarkedText(text, selectedRange: range)
                textDocumentProxy.unmarkText()
        }


        // MARK: - Input & Buffer

        @Published private(set) var inputStage: InputStage = .standby

        func clearBufferText() {
                bufferText = .empty
        }
        func dropLastBufferCharacter() {
                bufferText = String(bufferText.dropLast())
        }
        func appendBufferText(_ text: String) {
                bufferText += text
        }
        private(set) lazy var bufferText: String = .empty {
                didSet {
                        switch (oldValue.isEmpty, bufferText.isEmpty) {
                        case (true, true):
                                inputStage = .standby
                        case (true, false):
                                inputStage = .starting
                                updateReturnKeyText()
                        case (false, true):
                                inputStage = .ending
                                updateReturnKeyText()
                        case (false, false):
                                inputStage = .ongoing
                        }
                        switch bufferText.first {
                        case .none:
                                markedText = .empty
                                candidates = []
                        case .some("r"):
                                pinyinReverseLookup()
                        case .some("v"):
                                cangjieReverseLookup()
                        case .some("x"):
                                strokeReverseLookup()
                        case .some("q"):
                                composeReverseLookup()
                        default:
                                suggest()
                        }
                }
        }


        // MARK: - Operations

        func operate(_ operation: Operation) {
                switch operation {
                case .input(let text):
                        if inputMethodMode.isABC {
                                textDocumentProxy.insertText(text)
                        } else {
                                appendBufferText(text)
                        }
                case .separator:
                        appendBufferText("'")
                case .punctuation(let text):
                        textDocumentProxy.insertText(text)
                case .space:
                        guard inputStage.isBuffering else {
                                // TODO: Full-width space?
                                let spaceValue: String = " "
                                textDocumentProxy.insertText(spaceValue)
                                return
                        }
                        guard let candidate = candidates.first else {
                                let text: String = bufferText
                                clearBufferText()
                                textDocumentProxy.insertText(text)
                                return
                        }
                        insert(candidate.text)
                        textDocumentProxy.insertText(candidate.text)
                        adjustKeyboard()
                        aftercareSelected(candidate)
                case .doubleSpace:
                        textDocumentProxy.deleteBackward()
                        textDocumentProxy.insertText("。")
                case .backspace:
                        if inputStage.isBuffering {
                                dropLastBufferCharacter()
                        } else {
                                textDocumentProxy.deleteBackward()
                        }
                case .clearBuffer:
                        clearBufferText()
                case .return:
                        if inputStage.isBuffering {
                                let text: String = bufferText
                                clearBufferText()
                                textDocumentProxy.insertText(text)
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
                        insert(candidate.text)
                        adjustKeyboard()
                        aftercareSelected(candidate)
                case .paste:
                        guard UIPasteboard.general.hasStrings else { return }
                        guard let text = UIPasteboard.general.string else { return }
                        insert(text)
                case .clearClipboard:
                        UIPasteboard.general.items.removeAll()
                case .clearText:
                        if textDocumentProxy.selectedText != nil {
                                textDocumentProxy.deleteBackward()
                        }
                        if let textBeforeCursor = textDocumentProxy.documentContextBeforeInput {
                                _ = (0..<textBeforeCursor.count).map({ _ in
                                        textDocumentProxy.deleteBackward()
                                })
                        }
                        if let textAfterCursor = textDocumentProxy.documentContextAfterInput {
                                let characterCount: Int = textAfterCursor.count
                                textDocumentProxy.adjustTextPosition(byCharacterOffset: characterCount)
                                _ = (0..<characterCount).map({ _ in
                                        textDocumentProxy.deleteBackward()
                                })
                        }
                case .moveCursorBackward:
                        textDocumentProxy.adjustTextPosition(byCharacterOffset: -1)
                case .moveCursorForward:
                        textDocumentProxy.adjustTextPosition(byCharacterOffset: 1)
                case .jumpToHead:
                        guard let text = textDocumentProxy.documentContextBeforeInput else { return }
                        textDocumentProxy.adjustTextPosition(byCharacterOffset: -(text.count))
                case .jumpToTail:
                        guard let text = textDocumentProxy.documentContextAfterInput else { return }
                        textDocumentProxy.adjustTextPosition(byCharacterOffset: text.count)
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
                        guard !(inputStage.isBuffering) else { return }
                        updateKeyboardForm(to: .alphabet)
                default:
                        break
                }
        }
        private func aftercareSelected(_ candidate: Candidate) {
                switch bufferText.first {
                case .none:
                        return
                case .some(let character) where character.isReverseLookupTrigger:
                        let leadingCount: Int = candidate.input.count + 1
                        if bufferText.count > leadingCount {
                                let tail = bufferText.dropFirst(leadingCount)
                                bufferText = String(character) + tail
                        } else {
                                clearBufferText()
                        }
                default:
                        guard candidate.isCantonese else {
                                clearBufferText()
                                return
                        }
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


        // MARK: - Candidate Suggestions

        private func suggest() {
                let processingText: String = bufferText.toneConverted()
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
                markedText = text2mark
                let engineCandidates: [Candidate] = {
                        var suggestion: [Candidate] = Engine.suggest(text: processingText, segmentation: segmentation)
                        let shouldContinue: Bool = Options.isEmojiSuggestionsOn && !suggestion.isEmpty //  && candidateSequence.isEmpty
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
                let userCandidates: [Candidate] = [] // UserLexicon.suggest(text: processingText, segmentation: segmentation)
                let combined: [Candidate] = userCandidates + engineCandidates
                candidates = combined.map({ $0.transformed(to: Options.characterStandard) }).uniqued()
        }
        private func pinyinReverseLookup() {
                let text: String = String(bufferText.dropFirst())
                guard !(text.isEmpty) else {
                        markedText = bufferText
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
                markedText = text2mark
                let lookup: [Candidate] = Engine.pinyinReverseLookup(text: text, schemes: schemes)
                candidates = lookup.map({ $0.transformed(to: Options.characterStandard) }).uniqued()
        }
        private func cangjieReverseLookup() {
                let text: String = String(bufferText.dropFirst())
                let converted = text.map({ Logogram.cangjie(of: $0) }).compactMap({ $0 })
                let isValidSequence: Bool = !converted.isEmpty && converted.count == text.count
                if isValidSequence {
                        markedText = String(converted)
                        let lookup: [Candidate] = Engine.cangjieReverseLookup(text: text)
                        candidates = lookup.map({ $0.transformed(to: Options.characterStandard) }).uniqued()
                } else {
                        markedText = bufferText
                        candidates = []
                }
        }
        private func strokeReverseLookup() {
                let text: String = String(bufferText.dropFirst())
                let transformed: String = Logogram.strokeTransform(text)
                let converted = transformed.map({ Logogram.stroke(of: $0) }).compactMap({ $0 })
                let isValidSequence: Bool = !converted.isEmpty && converted.count == text.count
                if isValidSequence {
                        markedText = String(converted)
                        let lookup: [Candidate] = Engine.strokeReverseLookup(text: transformed)
                        candidates = lookup.map({ $0.transformed(to: Options.characterStandard) }).uniqued()
                } else {
                        markedText = bufferText
                        candidates = []
                }
        }
        private func composeReverseLookup() {
                guard bufferText.count > 2 else {
                        markedText = bufferText
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
                markedText = text2mark
                let lookup: [Candidate] = Engine.composeReverseLookup(text: text, input: bufferText, segmentation: segmentation)
                candidates = lookup.map({ $0.transformed(to: Options.characterStandard) }).uniqued()
        }

        @Published private(set) var candidates: [Candidate] = []


        // MARK: - Properties

        @Published private(set) var inputMethodMode: InputMethodMode = .cantonese
        func toggleInputMethodMode() {
                inputMethodMode = inputMethodMode.isABC ? .cantonese : .abc
                updateReturnKeyText()
                updateSpaceText()
        }

        @Published private(set) var previousKeyboardForm: KeyboardForm = .alphabet
        @Published private(set) var keyboardForm: KeyboardForm = .alphabet
        func updateKeyboardForm(to form: KeyboardForm) {
                previousKeyboardForm = keyboardForm
                keyboardForm = form
                updateReturnKeyText()
                updateSpaceText()
        }

        @Published private(set) var keyboardCase: KeyboardCase = .lowercased
        func updateKeyboardCase(to newCase: KeyboardCase) {
                keyboardCase = newCase
                updateSpaceText()
        }

        @Published private(set) var returnKeyText: String = "換行"
        private func updateReturnKeyText() {
                let newText: String = textDocumentProxy.returnKeyType.returnKeyText(isABC: inputMethodMode.isABC, isSimplified: Options.characterStandard.isSimplified, isBuffering: inputStage.isBuffering)
                if returnKeyText != newText {
                        returnKeyText = newText
                }
        }
        @Published private(set) var spaceText: String = "粵拼"
        private func updateSpaceText() {
                let newText: String = {
                        guard inputMethodMode.isCantonese else { return "ABC" }
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
                if spaceText != newText {
                        spaceText = newText
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
                let screenWidth: CGFloat = view.window?.windowScene?.screen.bounds.size.width ?? UIScreen.main.bounds.size.width
                let isPhoneLandscape: Bool = traitCollection.verticalSizeClass == .compact
                let horizontalInset: CGFloat = isPhoneLandscape ? 150 : 0
                keyboardWidth = screenWidth - horizontalInset
                widthUnit = keyboardWidth / 10.0
                heightUnit = isPhoneLandscape ? 40 : 53
        }

        private(set) lazy var appearance: Appearance = (traitCollection.userInterfaceStyle == .dark || textDocumentProxy.keyboardAppearance == .dark) ? .dark : .light
        private(set) lazy var keyboardInterface: KeyboardInterface = adoptKeyboardInterface()
        private func adoptKeyboardInterface() -> KeyboardInterface {
                switch traitCollection.userInterfaceIdiom {
                case .pad:
                        guard traitCollection.horizontalSizeClass != .compact else { return .padFloating }
                        let width: CGFloat = view.window?.windowScene?.screen.bounds.size.width ?? UIScreen.main.bounds.size.width
                        let height: CGFloat = view.window?.windowScene?.screen.bounds.size.width ?? UIScreen.main.bounds.size.height
                        let isPortrait: Bool = width < height
                        let minSide: CGFloat = min(width, height)
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
