import UIKit
import OpenCCLite
import KeyboardData
import LookupData

final class KeyboardViewController: UIInputViewController {

        // MARK: - Subviews

        private(set) lazy var toolBar: ToolBar = ToolBar(controller: self)
        private(set) lazy var settingsView: UIView = UIView()
        private(set) lazy var candidateBoard: CandidateBoard = CandidateBoard()
        private(set) lazy var candidateCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        private(set) lazy var emojiBoard: EmojiBoard = EmojiBoard()
        private(set) lazy var emojiCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        private(set) lazy var settingsTableView: UITableView = UITableView(frame: .zero, style: .insetGrouped)

        private(set) lazy var keyboardStackView: UIStackView = {
                let stackView = UIStackView(frame: .zero)
                stackView.axis = .vertical
                stackView.distribution = .equalSpacing
                return stackView
        }()
        private(set) lazy var bottomStackView: UIStackView = {
                let stackView = UIStackView(frame: .zero)
                stackView.distribution = .fillProportionally
                return stackView
        }()


        // MARK: - Keyboard Life Cycle

        private func initialize() {
                view.addSubview(keyboardStackView)
                keyboardStackView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        keyboardStackView.topAnchor.constraint(equalTo: view.topAnchor),
                        keyboardStackView.leftAnchor.constraint(equalTo: view.leftAnchor),
                        keyboardStackView.rightAnchor.constraint(equalTo: view.rightAnchor),
                        keyboardStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ])
                candidateCollectionView.delegate = self
                candidateCollectionView.dataSource = self
                candidateCollectionView.backgroundColor = view.backgroundColor
                candidateCollectionView.register(CandidateCell.self, forCellWithReuseIdentifier: Identifiers.CandidateCell)
                emojiCollectionView.delegate = self
                emojiCollectionView.dataSource = self
                emojiCollectionView.backgroundColor = view.backgroundColor
                emojiCollectionView.register(EmojiCell.self, forCellWithReuseIdentifier: Identifiers.EmojiCell)
                settingsTableView.delegate = self
                settingsTableView.dataSource = self
                settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: Identifiers.feedbacksSettingsCell)
                settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: Identifiers.charactersSettingsCell)
                settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: Identifiers.keyboardLayoutSettingsCell)
                settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: Identifiers.candidateFootnoteSettingsCell)
                settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: Identifiers.candidateToneStyleSettingsCell)
                settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: Identifiers.spaceShortcutSettingsCell)
                settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: Identifiers.clearLexiconSettingsCell)
                setupToolBarActions()
        }

        override func viewDidLoad() {
                super.viewDidLoad()
                initialize()
        }
        private lazy var shouldKeepInputTextWhileTextDidChange: Bool = false
        override func textDidChange(_ textInput: UITextInput?) {
                super.textDidChange(textInput)
                let asked: KeyboardIdiom = askedKeyboardIdiom
                if respondingKeyboardIdiom != asked {
                        respondingKeyboardIdiom = asked
                        needsDifferentKeyboard = true
                        if didKeyboardEstablished {
                                keyboardIdiom = asked
                        }
                }
                if shouldKeepInputTextWhileTextDidChange {
                        shouldKeepInputTextWhileTextDidChange = false
                } else {
                        if !inputText.isEmpty && !textDocumentProxy.hasText {
                                // User just tapped the Clear button in the text field
                                inputText = .empty
                        }
                }
        }

        override func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)
                if userLexicon == nil {
                        userLexicon = UserLexicon()
                }
                if engine == nil {
                        engine = Engine()
                }
                if isHapticFeedbackOn && hapticFeedback == nil {
                        hapticFeedback = UIImpactFeedbackGenerator(style: .light)
                }
        }
        override func viewDidAppear(_ animated: Bool) {
                super.viewDidAppear(animated)
                if needsDifferentKeyboard {
                        keyboardIdiom = respondingKeyboardIdiom
                } else if !didKeyboardEstablished {
                        setupKeyboard()
                        didKeyboardEstablished = true
                }
        }
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
                super.traitCollectionDidChange(previousTraitCollection)
                isDarkAppearance = traitCollection.userInterfaceStyle == .dark || textDocumentProxy.keyboardAppearance == .dark
                keyboardInterface = matchInterface()
                if didKeyboardEstablished {
                        setupKeyboard()
                }
        }
        override func viewWillDisappear(_ animated: Bool) {
                super.viewWillDisappear(animated)
                hapticFeedback = nil
                engine?.close()
                engine = nil
                userLexicon?.close()
                userLexicon = nil
                pinyinProvider?.close()
                pinyinProvider = nil
                shapeData?.close()
                shapeData = nil
        }
        override func viewDidDisappear(_ animated: Bool) {
                super.viewDidDisappear(animated)
                keyboardStackView.removeFromSuperview()
        }

        private lazy var didKeyboardEstablished: Bool = false
        private lazy var needsDifferentKeyboard: Bool = false
        private lazy var respondingKeyboardIdiom: KeyboardIdiom = .cantonese(.lowercased)
        private var askedKeyboardIdiom: KeyboardIdiom {
                switch textDocumentProxy.keyboardType {
                case .numberPad, .asciiCapableNumberPad:
                        // TODO: - Test on .padFloating
                        return keyboardInterface.isCompact ? .numberPad : .numeric
                case .decimalPad:
                        return keyboardInterface.isCompact ? .decimalPad : .numeric
                case .numbersAndPunctuation:
                        return .numeric
                case .emailAddress, .URL:
                        return .alphabetic(.lowercased)
                default:
                        return .cantonese(.lowercased)
                }
        }
        lazy var keyboardIdiom: KeyboardIdiom = .cantonese(.lowercased) {
                didSet {
                        setupKeyboard()
                        guard didKeyboardEstablished else {
                                didKeyboardEstablished = true
                                return
                        }
                        if (!keyboardIdiom.isCantoneseMode) && (!inputText.isEmpty) {
                                let text: String = inputText
                                inputText = .empty
                                textDocumentProxy.insertText(text)
                        }
                }
        }


        // MARK: - Operations

        func operate(_ operation: Operation) {
                switch operation {
                case .input(let text):
                        if keyboardIdiom.isCantoneseMode {
                                if keyboardLayout == 2 && text == "gw" {
                                        let newInputText: String = inputText + text
                                        inputText = newInputText.replacingOccurrences(of: "gwgw", with: "kw")
                                } else {
                                        inputText += text
                                }
                        } else {
                                textDocumentProxy.insertText(text)
                        }
                        AudioFeedback.perform(.input)
                        adjustKeyboardIdiom()
                case .separator:
                        inputText += "'"
                        AudioFeedback.perform(.input)
                        adjustKeyboardIdiom()
                case .punctuation(let text):
                        textDocumentProxy.insertText(text)
                        AudioFeedback.perform(.input)
                        adjustKeyboardIdiom()
                case .space:
                        switch keyboardIdiom {
                        case .cantonese where !inputText.isEmpty:
                                if let firstCandidate: Candidate = candidates.first {
                                        compose(firstCandidate.text)
                                        AudioFeedback.perform(.modify)
                                        handleSelected(firstCandidate)
                                } else {
                                        compose(inputText)
                                        AudioFeedback.perform(.input)
                                        inputText = .empty
                                }
                        default:
                                textDocumentProxy.insertText(.space)
                                AudioFeedback.perform(.input)
                        }
                        adjustKeyboardIdiom()
                case .doubleSpace:
                        guard inputText.isEmpty else { return }
                        defer {
                                AudioFeedback.perform(.input)
                        }
                        let hasSpaceAhead: Bool = textDocumentProxy.documentContextBeforeInput?.hasSuffix(.space) ?? false
                        guard doubleSpaceShortcut != 2 && hasSpaceAhead else {
                                textDocumentProxy.insertText(.space)
                                return
                        }
                        textDocumentProxy.deleteBackward()
                        let text: String = {
                                switch (doubleSpaceShortcut, keyboardIdiom.isEnglishMode) {
                                case (0, false), (1, false):
                                        return "。"
                                case (3, false):
                                        return "，"
                                case (0, true), (1, true):
                                        return ". "
                                case (3, true):
                                        return ", "
                                default:
                                        return .fullwidthSpace
                                }
                        }()
                        textDocumentProxy.insertText(text)
                case .backspace:
                        if inputText.isEmpty {
                                textDocumentProxy.deleteBackward()
                        } else {
                                lazy var hasLightToneSuffix: Bool = inputText.hasSuffix("vv") || inputText.hasSuffix("xx") || inputText.hasSuffix("qq")
                                if keyboardLayout < 2 && hasLightToneSuffix {
                                        inputText = String(inputText.dropLast(2))
                                } else {
                                        inputText = String(inputText.dropLast())
                                }
                                candidateSequence = []
                        }
                        AudioFeedback.perform(.delete)
                case .clear:
                        guard !inputText.isEmpty else { return }
                        inputText = .empty
                        AudioFeedback.perform(.delete)
                case .return:
                        guard !inputText.isEmpty else {
                                textDocumentProxy.insertText("\n")
                                AudioFeedback.perform(.modify)
                                return
                        }
                        compose(inputText)
                        inputText = .empty
                        DispatchQueue.global().asyncAfter(deadline: .now() + 0.04) { [unowned self] in
                                DispatchQueue(label: "im.cantonese.fix.return").sync { [unowned self] in
                                        self.textDocumentProxy.insertText(.zeroWidthSpace)
                                        self.textDocumentProxy.deleteBackward()
                                }
                        }
                        AudioFeedback.perform(.input)
                case .shift:
                        AudioFeedback.perform(.modify)
                        switch keyboardIdiom {
                        case .cantonese(.lowercased):
                                keyboardIdiom = .cantonese(.uppercased)
                        case .cantonese(.uppercased),
                             .cantonese(.capsLocked):
                                keyboardIdiom = .cantonese(.lowercased)
                        case .alphabetic(.lowercased):
                                keyboardIdiom = .alphabetic(.uppercased)
                        case .alphabetic(.uppercased),
                             .alphabetic(.capsLocked):
                                keyboardIdiom = .alphabetic(.lowercased)
                        default:
                                break
                        }
                case .doubleShift:
                        AudioFeedback.perform(.modify)
                        keyboardIdiom = keyboardIdiom.isEnglishMode ? .alphabetic(.capsLocked) : .cantonese(.capsLocked)
                case .switchTo(let newLayout):
                        AudioFeedback.perform(.modify)
                        keyboardIdiom = newLayout
                case .select(let candidate):
                        compose(candidate.text)
                        AudioFeedback.perform(.modify)
                        triggerHapticFeedback()
                        handleSelected(candidate)
                        adjustKeyboardIdiom()
                }
        }
        private func adjustKeyboardIdiom() {
                switch keyboardIdiom {
                case .alphabetic(.uppercased):
                        keyboardIdiom = .alphabetic(.lowercased)
                case .cantonese(.uppercased):
                        keyboardIdiom = .cantonese(.lowercased)
                case .candidateBoard where inputText.isEmpty:
                        candidateCollectionView.removeFromSuperview()
                        NSLayoutConstraint.deactivate(candidateBoardCollectionViewConstraints)
                        toolBar.reset()
                        keyboardIdiom = .cantonese(.lowercased)
                default:
                        break
                }
        }
        private func handleSelected(_ candidate: Candidate) {
                switch inputText.first {
                case .none:
                        break
                case .some("r"), .some("v"), .some("x"):
                        if inputText.count == candidate.input.count + 1 {
                                inputText = .empty
                        } else {
                                let first: String = String(inputText.first!)
                                let tail = inputText.dropFirst(candidate.input.count + 1)
                                inputText = first + tail
                        }
                default:
                        candidateSequence.append(candidate)
                        let inputCount: Int = {
                                if keyboardLayout > 1 {
                                        return candidate.input.count
                                } else {
                                        let converted: String = candidate.input.replacingOccurrences(of: "(4|5|6)", with: "xx", options: .regularExpression)
                                        return converted.count
                                }
                        }()
                        let leading = inputText.dropLast(inputText.count - inputCount)
                        let filtered = leading.replacingOccurrences(of: "'", with: "")
                        var tail: String.SubSequence = {
                                if filtered.count == leading.count {
                                        return inputText.dropFirst(inputCount)
                                } else {
                                        let separatorsCount: Int = leading.count - filtered.count
                                        return inputText.dropFirst(inputCount + separatorsCount)
                                }
                        }()
                        while tail.hasPrefix("'") {
                                tail = tail.dropFirst()
                        }
                        inputText = String(tail)
                }
                if inputText.isEmpty && !candidateSequence.isEmpty {
                        let concatenatedCandidate: Candidate = candidateSequence.joined()
                        candidateSequence = []
                        handleLexicon(concatenatedCandidate)
                }
        }


        // MARK: - Input Texts

        lazy var inputText: String = .empty {
                didSet {
                        switch inputText.first {
                        case .none:
                                processingText = .empty
                        case .some("r"), .some("v"), .some("x"):
                                processingText = inputText
                        default:
                                if keyboardLayout > 1 {
                                        processingText = inputText
                                } else {
                                        processingText = inputText.replacingOccurrences(of: "vv", with: "4")
                                                .replacingOccurrences(of: "xx", with: "5")
                                                .replacingOccurrences(of: "qq", with: "6")
                                                .replacingOccurrences(of: "v", with: "1")
                                                .replacingOccurrences(of: "x", with: "2")
                                                .replacingOccurrences(of: "q", with: "3")
                                }
                        }
                        switch (inputText.isEmpty, oldValue.isEmpty) {
                        case (true, false):
                                updateBottomStackView(with: .key(.cantoneseComma))
                        case (false, true):
                                updateBottomStackView(with: .key(.separator))
                        default:
                                break
                        }
                }
        }
        private lazy var processingText: String = .empty {
                didSet {
                        toolBar.update()
                        switch processingText.first {
                        case .none:
                                syllablesSchemes = []
                                markedText = .empty
                                candidates = []
                        case .some("r"), .some("v"), .some("x"):
                                syllablesSchemes = []
                                markedText = processingText
                        default:
                                syllablesSchemes = Splitter.split(processingText)
                                if let syllables: [String] = syllablesSchemes.first {
                                        let splittable: String = syllables.joined()
                                        if splittable.count == processingText.count {
                                                markedText = syllables.joined(separator: .space)
                                        } else if processingText.contains("'") {
                                                markedText = processingText.replacingOccurrences(of: "'", with: "' ")
                                        } else {
                                                let tail = processingText.dropFirst(splittable.count)
                                                markedText = syllables.joined(separator: .space) + .space + tail
                                        }
                                } else {
                                        markedText = processingText
                                }
                        }
                        guard !processingText.isEmpty else { return }
                        imeQueue.async { [unowned self] in
                                self.suggest()
                        }
                }
        }
        private lazy var markedText: String = .empty {
                willSet {
                        // REASON: Chrome address bar
                        guard markedText.isEmpty && !newValue.isEmpty else { return }
                        guard textDocumentProxy.keyboardType == .webSearch else { return }
                        shouldKeepInputTextWhileTextDidChange = true
                        textDocumentProxy.insertText(.empty)
                }
                didSet {
                        guard shouldMarkInput else { return }
                        handleMarkedText()
                }
        }
        private lazy var syllablesSchemes: [[String]] = [] {
                didSet {
                        guard !syllablesSchemes.isEmpty else { schemes = []; return }
                        schemes = syllablesSchemes.map({ block -> [String] in
                                let sequence: [String] = block.map { syllable -> String in
                                        let converted: String = syllable.replacingOccurrences(of: "eo(ng|k)$", with: "oe$1", options: .regularExpression)
                                                .replacingOccurrences(of: "oe(i|n|t)$", with: "eo$1", options: .regularExpression)
                                                .replacingOccurrences(of: "eoy", with: "eoi")
                                                .replacingOccurrences(of: "oey", with: "eoi")
                                                .replacingOccurrences(of: "^([b-z]|ng)(u|o)m$", with: "$1am", options: .regularExpression)
                                                .replacingOccurrences(of: "y", with: "j", options: .anchored)
                                        return converted
                                }
                                return sequence
                        })
                }
        }
        private lazy var schemes: [[String]] = []

        /// some apps can't be compatible with `textDocumentProxy.setMarkedText() & textDocumentProxy.insertText()`
        /// - Parameter text: text to insert
        private func compose(_ text: String) {
                shouldMarkInput = false
                defer {
                        DispatchQueue.global().asyncAfter(deadline: .now() + 0.02) { [unowned self] in
                                self.shouldMarkInput = true
                        }
                }
                let location: Int = (text as NSString).length
                let range: NSRange = NSRange(location: location, length: 0)
                textDocumentProxy.setMarkedText(text, selectedRange: range)
                textDocumentProxy.unmarkText()
        }
        private lazy var shouldMarkInput: Bool = true {
                didSet {
                        guard shouldMarkInput else { return }
                        handleMarkedText()
                }
        }
        private func handleMarkedText() {
                guard !(markedText.isEmpty) else {
                        textDocumentProxy.setMarkedText("", selectedRange: NSRange(location: 0, length: 0))
                        textDocumentProxy.unmarkText()
                        return
                }
                let location: Int = (markedText as NSString).length
                let range: NSRange = NSRange(location: location, length: 0)
                textDocumentProxy.setMarkedText(markedText, selectedRange: range)
        }

        /// Calling `textDocumentProxy.insertText(_:)`
        /// - Parameter text: text to insert
        func insert(_ text: String) {
                textDocumentProxy.insertText(text)
        }


        // MARK: - Engine

        private let imeQueue: DispatchQueue = DispatchQueue(label: "im.cantonese.CantoneseIM.Keyboard.ime", qos: .userInteractive)
        private lazy var userLexicon: UserLexicon? = UserLexicon()
        private lazy var engine: Engine? = Engine()
        private lazy var pinyinProvider: PinyinProvider? = nil
        private lazy var shapeData: ShapeData? = nil
        private func suggest() {
                switch processingText.first {
                case .none:
                        break
                case .some("r"):
                        pinyinReverseLookup()
                case .some("v"):
                        cangjieReverseLookup()
                case .some("x"):
                        strokeReverseLookup()
                default:
                        imeSuggest()
                }
        }
        private func pinyinReverseLookup() {
                let text: String = String(processingText.dropFirst())
                guard !text.isEmpty else {
                        candidates = []
                        return
                }
                if pinyinProvider == nil {
                        pinyinProvider = PinyinProvider()
                }
                guard let searches = pinyinProvider?.search(for: text), !searches.isEmpty else { return }
                let lookup: [[Candidate]] = searches.map { lexicon -> [Candidate] in
                        let romanizations: [String] = LookupData.search(for: lexicon.text)
                        let candidates: [Candidate] = romanizations.map({ Candidate(text: lexicon.text, romanization: $0, input: lexicon.input, lexiconText: lexicon.text) })
                        return candidates
                }
                let joined: [Candidate] = Array<Candidate>(lookup.joined())
                push(joined)
        }
        private func cangjieReverseLookup() {
                let text: String = String(processingText.dropFirst())
                guard !text.isEmpty else {
                        candidates = []
                        return
                }
                if shapeData == nil {
                        shapeData = ShapeData()
                }
                guard let searches = shapeData?.search(cangjie: text), !searches.isEmpty else { return }
                let lookup: [[Candidate]] = searches.map { lexicon -> [Candidate] in
                        let romanizations: [String] = LookupData.search(for: lexicon.text)
                        let candidates: [Candidate] = romanizations.map({ Candidate(text: lexicon.text, romanization: $0, input: lexicon.input, lexiconText: lexicon.text) })
                        return candidates
                }
                let joined: [Candidate] = Array<Candidate>(lookup.joined())
                push(joined)
        }
        private func strokeReverseLookup() {
                let text: String = String(processingText.dropFirst())
                guard !text.isEmpty else {
                        candidates = []
                        return
                }
                if shapeData == nil {
                        shapeData = ShapeData()
                }
                guard let searches = shapeData?.search(stroke: text), !searches.isEmpty else { return }
                let lookup: [[Candidate]] = searches.map { lexicon -> [Candidate] in
                        let romanizations: [String] = LookupData.search(for: lexicon.text)
                        let candidates: [Candidate] = romanizations.map({ Candidate(text: lexicon.text, romanization: $0, input: lexicon.input, lexiconText: lexicon.text) })
                        return candidates
                }
                let joined: [Candidate] = Array<Candidate>(lookup.joined())
                push(joined)
        }
        private func imeSuggest() {
                let lexiconCandidates: [Candidate] = userLexicon?.suggest(for: processingText) ?? []
                let engineCandidates: [Candidate] = {
                        let normal: [Candidate] = engine?.suggest(for: processingText, schemes: schemes.uniqued()) ?? []
                        if normal.isEmpty && processingText.hasSuffix("'") && !processingText.dropLast().contains("'") {
                                let droppedSeparator: String = String(processingText.dropLast())
                                let newSchemes: [[String]] = Splitter.split(droppedSeparator).uniqued().filter({ $0.joined() == droppedSeparator || $0.count == 1 })
                                return engine?.suggest(for: droppedSeparator, schemes: newSchemes) ?? []
                        } else {
                                return normal
                        }
                }()
                let combined: [Candidate] = lexiconCandidates + engineCandidates
                push(combined)
        }
        private func push(_ origin: [Candidate]) {
                if Logogram.current == .traditional {
                        candidates = origin.uniqued()
                } else if converter == nil {
                        candidates = origin.uniqued()
                        updateConverter()
                } else {
                        let converted: [Candidate] = origin.map { Candidate(text: converter!.convert($0.text), romanization: $0.romanization, input: $0.input, lexiconText: $0.lexiconText) }
                        candidates = converted.uniqued()
                }
        }
        private(set) lazy var candidates: [Candidate] = [] {
                didSet {
                        DispatchQueue.main.async { [unowned self] in
                                self.candidateCollectionView.reloadData()
                                self.candidateCollectionView.setContentOffset(.zero, animated: true)
                        }
                }
        }
        lazy var candidateSequence: [Candidate] = []
        func handleLexicon(_ candidate: Candidate) {
                imeQueue.async { [unowned self] in
                        self.userLexicon?.handle(candidate)
                }
        }
        func clearUserLexicon() {
                imeQueue.async { [unowned self] in
                        self.userLexicon?.deleteAll()
                }
        }


        // MARK: - ToolBar Actions

        private func setupToolBarActions() {
                toolBar.settingsButton.addTarget(self, action: #selector(handleSettingsButton), for: .touchUpInside)
                toolBar.yueEngSwitch.addTarget(self, action: #selector(handleYueEngSwitch), for: .touchDown)
                toolBar.pasteButton.addTarget(self, action: #selector(handlePaste), for: .touchUpInside)
                toolBar.emojiSwitch.addTarget(self, action: #selector(handleEmojiSwitch), for: .touchUpInside)
                toolBar.keyboardDown.addTarget(self, action: #selector(dismissInputMethod), for: .touchUpInside)
                toolBar.downArrow.addTarget(self, action: #selector(handleDownArrow), for: .touchUpInside)
        }
        @objc private func handleSettingsButton() {
                keyboardIdiom = .settingsView
        }
        @objc private func handleYueEngSwitch() {
                hapticFeedback?.impactOccurred()
                AudioFeedback.perform(.modify)
                let switched: Bool = toolBar.yueEngSwitch.switched
                if switched {
                        switch keyboardIdiom {
                        case .alphabetic(.lowercased):
                                keyboardIdiom = .cantonese(.lowercased)
                        case .alphabetic(.uppercased):
                                keyboardIdiom = .cantonese(.uppercased)
                        case .alphabetic(.capsLocked):
                                keyboardIdiom = .cantonese(.capsLocked)
                        case .numeric:
                                keyboardIdiom = .cantoneseNumeric
                        case .symbolic:
                                keyboardIdiom = .cantoneseSymbolic
                        default:
                                keyboardIdiom = .cantonese(.lowercased)
                        }
                } else {
                        switch keyboardIdiom {
                        case .cantonese(.lowercased):
                                keyboardIdiom = .alphabetic(.lowercased)
                        case .cantonese(.uppercased):
                                keyboardIdiom = .alphabetic(.uppercased)
                        case .cantonese(.capsLocked):
                                keyboardIdiom = .alphabetic(.capsLocked)
                        case .cantoneseNumeric:
                                keyboardIdiom = .numeric
                        case .cantoneseSymbolic:
                                keyboardIdiom = .symbolic
                        default:
                                keyboardIdiom = .alphabetic(.lowercased)
                        }
                }
        }
        @objc private func handlePaste() {
                guard UIPasteboard.general.hasStrings else { return }
                guard let copied: String = UIPasteboard.general.string else { return }
                textDocumentProxy.insertText(copied)
                hapticFeedback?.impactOccurred()
                AudioFeedback.perform(.input)
        }
        @objc private func handleEmojiSwitch() {
                hapticFeedback?.impactOccurred()
                AudioFeedback.perform(.modify)
                keyboardIdiom = .emoji
        }
        @objc private func dismissInputMethod() {
                dismissKeyboard()
        }
        @objc private func handleDownArrow() {
                keyboardIdiom = .candidateBoard
        }


        // MARK: - Properties

        private(set) lazy var isDarkAppearance: Bool = traitCollection.userInterfaceStyle == .dark || textDocumentProxy.keyboardAppearance == .dark
        private(set) lazy var keyboardInterface: KeyboardInterface = matchInterface()
        private func matchInterface() -> KeyboardInterface {
                switch traitCollection.userInterfaceIdiom {
                case .pad:
                        guard traitCollection.horizontalSizeClass != .compact else { return .padFloating }
                        let isPortrait: Bool = UIScreen.main.bounds.width < UIScreen.main.bounds.height
                        return isPortrait ? .padPortrait : .padLandscape
                default:
                        switch traitCollection.verticalSizeClass {
                        case .compact:
                                return .phoneLandscape
                        default:
                                return .phonePortrait
                        }
                }
        }


        // MARK: - Settings

        private var hapticFeedback: UIImpactFeedbackGenerator?
        func triggerHapticFeedback() {
                hapticFeedback?.impactOccurred()
        }
        func prepareHapticFeedback() {
                hapticFeedback?.prepare()
        }
        private(set) lazy var isHapticFeedbackOn: Bool = hasFullAccess && UserDefaults.standard.bool(forKey: "haptic_feedback") {
                didSet {
                        if isHapticFeedbackOn {
                                if hapticFeedback == nil {
                                        hapticFeedback = UIImpactFeedbackGenerator(style: .light)
                                }
                        } else {
                                if hapticFeedback != nil {
                                        hapticFeedback = nil
                                }
                        }
                }
        }
        func updateHapticFeedbackStatus() {
                isHapticFeedbackOn = hasFullAccess && UserDefaults.standard.bool(forKey: "haptic_feedback")
        }

        private lazy var converter: Converter? = {
                let conversion: Converter.Conversion? = {
                        switch Logogram.current {
                        case .hongkong:
                                return .hkStandard
                        case .taiwan:
                                return .twStandard
                        case .simplified:
                                return .simplify
                        default:
                                return nil
                        }
                }()
                guard let conversion = conversion else { return nil }
                let converter: Converter? = try? Converter(conversion)
                return converter
        }()
        func updateConverter() {
                let conversion: Converter.Conversion? = {
                        switch Logogram.current {
                        case .hongkong:
                                return .hkStandard
                        case .taiwan:
                                return .twStandard
                        case .simplified:
                                return .simplify
                        default:
                                return nil
                        }
                }()
                guard let conversion = conversion else { converter = nil; return }
                converter = try? Converter(conversion)
        }

        /// 鍵盤佈局
        ///
        /// 0: The key "keyboard_layout" doesn‘t exist.
        ///
        /// 1: 全鍵盤 QWERTY
        ///
        /// 2: 三拼
        ///
        /// 3: 九宮格（未實現）
        private(set) lazy var keyboardLayout: Int = UserDefaults.standard.integer(forKey: "keyboard_layout")
        func updateKeyboardLayout() {
                keyboardLayout = UserDefaults.standard.integer(forKey: "keyboard_layout")
        }

        /// 粵拼顯示
        ///
        /// 0: The key "jyutping_display" doesn‘t exist.
        ///
        /// 1: 候選詞之上
        ///
        /// 2: 候選詞之下
        ///
        /// 3: 無
        private(set) lazy var footnoteStyle: Int = UserDefaults.standard.integer(forKey: "jyutping_display")
        func updateFootnoteStyle() {
                footnoteStyle = UserDefaults.standard.integer(forKey: "jyutping_display")
        }

        /// 粵拼聲調樣式
        ///
        /// 0: The key "tone_style" doesn‘t exist.
        ///
        /// 1: 正常
        ///
        /// 2: 無聲調
        ///
        /// 3: 上標
        ///
        /// 4: 下標
        private(set) lazy var toneStyle: Int = UserDefaults.standard.integer(forKey: "tone_style")
        func updateToneStyle() {
                toneStyle = UserDefaults.standard.integer(forKey: "tone_style")
        }

        /// 雙擊空格鍵快捷動作
        ///
        /// 0: The key "double_space_shortcut" doesn‘t exist.
        ///
        /// 1: 輸入一個句號「。」（英文鍵盤輸入一個句號「.」加一個空格）
        ///
        /// 2: 無（輸入兩個空格）
        ///
        /// 3: 輸入一個逗號「，」（英文鍵盤輸入一個逗號「,」加一個空格）
        ///
        /// 4: 輸入一個全形空格（U+3000）
        private(set) lazy var doubleSpaceShortcut: Int = UserDefaults.standard.integer(forKey: "double_space_shortcut")
        func updateDoubleSpaceShortcut() {
                doubleSpaceShortcut = UserDefaults.standard.integer(forKey: "double_space_shortcut")
        }

        private(set) lazy var frequentEmojis: String = UserDefaults.standard.string(forKey: "emoji_frequent") ?? .empty
        func updateFrequentEmojis(latest emoji: String) {
                let combined: String = emoji + frequentEmojis
                let uniqued: [String] = combined.map({ String($0) }).uniqued()
                let updated: [String] = uniqued.count < 31 ? uniqued : uniqued.dropLast(uniqued.count - 30)
                frequentEmojis = updated.joined()
                UserDefaults.standard.set(frequentEmojis, forKey: "emoji_frequent")
        }
}
