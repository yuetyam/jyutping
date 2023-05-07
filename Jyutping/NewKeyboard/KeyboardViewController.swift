import SwiftUI
import CommonExtensions
import CoreIME

final class KeyboardViewController: UIInputViewController, ObservableObject {

        override func updateViewConstraints() {
                super.updateViewConstraints()
        }

        override func viewDidLoad() {
                super.viewDidLoad()
                updateScreenSize()
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
        }
        override func viewDidAppear(_ animated: Bool) {
                super.viewDidAppear(animated)
        }
        override func viewWillDisappear(_ animated: Bool) {
                super.viewWillDisappear(animated)
                candidates = []
                markedText = .empty
                bufferText = .empty
                _ = view.subviews.map({ $0.removeFromSuperview() })
                _ = self.children.map({ $0.removeFromParent() })
        }

        override func viewWillLayoutSubviews() {
                super.viewWillLayoutSubviews()
        }

        override func textWillChange(_ textInput: UITextInput?) {
                // The app is about to change the document's contents. Perform any preparation here.
        }
        override func textDidChange(_ textInput: UITextInput?) {
                // The app has just changed the document's contents, the document context has been updated.
        }

        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
                updateScreenSize()
                let newKeyboardAppearance: Appearance = (traitCollection.userInterfaceStyle == .dark || textDocumentProxy.keyboardAppearance == .dark) ? .dark : .light
                if keyboardAppearance != newKeyboardAppearance {
                        keyboardAppearance = newKeyboardAppearance
                }
                let newKeyboardInterface: KeyboardInterface = adoptKeyboardInterface()
                if keyboardInterface != newKeyboardInterface {
                        keyboardInterface = newKeyboardInterface
                }
        }

        func operate(_ operation: Operation) {
                switch operation {
                case .input(let text):
                        appendBufferText(text)
                case .separator:
                        appendBufferText("'")
                case .punctuation:
                        break
                case .space:
                        guard inputStage.isBuffering else {
                                textDocumentProxy.insertText(" ")
                                return
                        }
                        guard let candidate = candidates.first else {
                                textDocumentProxy.insertText(bufferText)
                                clearBufferText()
                                return
                        }
                        textDocumentProxy.insertText(candidate.text)
                        let newBufferText = bufferText.dropFirst(candidate.input.count)
                        bufferText = String(newBufferText)
                case .doubleSpace:
                        break
                case .backspace:
                        if inputStage.isBuffering {
                                dropLastBufferCharacter()
                        } else {
                                textDocumentProxy.deleteBackward()
                        }
                case .clear:
                        clearBufferText()
                case .return:
                        if inputStage.isBuffering {
                                textDocumentProxy.insertText(bufferText)
                                clearBufferText()
                        } else {
                                textDocumentProxy.insertText("\n")
                        }
                case .shift:
                        break
                case .doubleShift:
                        break
                case .tab:
                        textDocumentProxy.insertText("\t")
                case .transform(let keyboardType):
                        updateKeyboardType(to: keyboardType)
                case .dismiss:
                        dismissKeyboard()
                case .select(let candidate):
                        textDocumentProxy.insertText(candidate.text)
                        let newBufferText = bufferText.dropFirst(candidate.input.count)
                        bufferText = String(newBufferText)
                }
        }


        // MARK: - Input

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
                        case (false, true):
                                inputStage = .ending
                        case (false, false):
                                inputStage = .ongoing
                        }
                        switch bufferText.first {
                        case .none:
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

        private lazy var markedText: String = .empty


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

        private(set) lazy var isPhone: Bool = UITraitCollection.current.userInterfaceIdiom == .phone
        private(set) lazy var isPad: Bool = UITraitCollection.current.userInterfaceIdiom == .pad

        @Published private(set) var screenSize: CGSize = CGSize(width: 375, height: 667)
        @Published private(set) var widthUnit: CGFloat = 37.5
        @Published private(set) var heightUnit: CGFloat = 53
        private func updateScreenSize() {
                screenSize = view.window?.windowScene?.screen.bounds.size ?? UIScreen.main.bounds.size
                widthUnit = screenSize.width / 10.0
                // TODO: Responsible height
                heightUnit = 53
        }

        @Published private(set) var keyboardType: KeyboardType = .cantonese(.lowercased)
        func updateKeyboardType(to type: KeyboardType) {
                keyboardType = type
        }

        private(set) lazy var keyboardAppearance: Appearance = (traitCollection.userInterfaceStyle == .dark || textDocumentProxy.keyboardAppearance == .dark) ? .dark : .light
        private(set) lazy var keyboardInterface: KeyboardInterface = adoptKeyboardInterface()
        private func adoptKeyboardInterface() -> KeyboardInterface {
                switch traitCollection.userInterfaceIdiom {
                case .pad:
                        guard traitCollection.horizontalSizeClass != .compact else { return .padFloating }
                        let width: CGFloat = UIScreen.main.bounds.size.width
                        let height: CGFloat = UIScreen.main.bounds.size.height
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

        private lazy var hapticFeedback: UIImpactFeedbackGenerator? = nil
        private func instantiateHapticFeedback() {
                switch hapticFeedbackMode {
                case .disabled:
                        hapticFeedback = nil
                case .light:
                        hapticFeedback = UIImpactFeedbackGenerator(style: .light)
                case .medium:
                        hapticFeedback = UIImpactFeedbackGenerator(style: .medium)
                case .heavy:
                        hapticFeedback = UIImpactFeedbackGenerator(style: .heavy)
                }
        }
        func prepareHapticFeedback() {
                hapticFeedback?.prepare()
        }
        func triggerHapticFeedback() {
                hapticFeedback?.impactOccurred()
        }
        private func releaseHapticFeedback() {
                hapticFeedback = nil
        }

        private(set) lazy var hapticFeedbackMode: HapticFeedback = {
                guard hasFullAccess else { return .disabled }
                let savedValue: Int = UserDefaults.standard.integer(forKey: OptionsKey.HapticFeedback)
                switch savedValue {
                case HapticFeedback.disabled.rawValue:
                        return .disabled
                case HapticFeedback.light.rawValue:
                        return .light
                case HapticFeedback.medium.rawValue:
                        return .medium
                case HapticFeedback.heavy.rawValue:
                        return .heavy
                default:
                        return .disabled
                }
        }()
        func updateHapticFeedbackMode(to mode: HapticFeedback) {
                hapticFeedbackMode = mode
                let value: Int = mode.rawValue
                UserDefaults.standard.set(value, forKey: OptionsKey.HapticFeedback)
                instantiateHapticFeedback()
        }
}
