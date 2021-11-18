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
                candidateCollectionView.register(CandidateCell.self, forCellWithReuseIdentifier: "CandidateCell")
                emojiCollectionView.delegate = self
                emojiCollectionView.dataSource = self
                emojiCollectionView.backgroundColor = view.backgroundColor
                emojiCollectionView.register(EmojiCell.self, forCellWithReuseIdentifier: "EmojiCell")
                settingsTableView.delegate = self
                settingsTableView.dataSource = self
                settingsTableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: "SwitchTableViewCell")
                settingsTableView.register(NormalTableViewCell.self, forCellReuseIdentifier: "CharactersTableViewCell")
                settingsTableView.register(NormalTableViewCell.self, forCellReuseIdentifier: "KeyboardLayoutTableViewCell")
                settingsTableView.register(NormalTableViewCell.self, forCellReuseIdentifier: "JyutpingTableViewCell")
                settingsTableView.register(NormalTableViewCell.self, forCellReuseIdentifier: "ToneStyleTableViewCell")
                settingsTableView.register(NormalTableViewCell.self, forCellReuseIdentifier: "SpaceShortcutTableViewCell")
                settingsTableView.register(NormalTableViewCell.self, forCellReuseIdentifier: "ClearLexiconTableViewCell")
                setupToolBarActions()
        }

        override func viewDidLoad() {
                super.viewDidLoad()
                initialize()
        }
        private lazy var shouldKeepInputTextWhileTextDidChange: Bool = false
        override func textDidChange(_ textInput: UITextInput?) {
                super.textDidChange(textInput)
                let asked: KeyboardLayout = askedKeyboardLayout
                if respondingKeyboardLayout != asked {
                        respondingKeyboardLayout = asked
                        needsDifferentKeyboard = true
                        if didKeyboardEstablished {
                                keyboardLayout = asked
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
                        keyboardLayout = respondingKeyboardLayout
                } else if !didKeyboardEstablished {
                        setupKeyboard()
                        didKeyboardEstablished = true
                }
        }
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
                super.traitCollectionDidChange(previousTraitCollection)
                updateProperties()
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
                DispatchQueue.main.async { [unowned self] in
                        self.keyboardStackView.removeFromSuperview()
                }
        }

        private lazy var didKeyboardEstablished: Bool = false
        private lazy var needsDifferentKeyboard: Bool = false
        private lazy var respondingKeyboardLayout: KeyboardLayout = .cantonese(.lowercased)
        private var askedKeyboardLayout: KeyboardLayout {
                switch textDocumentProxy.keyboardType {
                case .numberPad, .asciiCapableNumberPad:
                        return isPad ? .numeric : .numberPad
                case .decimalPad:
                        return isPad ? .numeric : .decimalPad
                case .numbersAndPunctuation:
                        return .numeric
                case .emailAddress, .URL:
                        return .alphabetic(.lowercased)
                default:
                        return .cantonese(.lowercased)
                }
        }
        var keyboardLayout: KeyboardLayout = .cantonese(.lowercased) {
                didSet {
                        setupKeyboard()
                        guard didKeyboardEstablished else {
                                didKeyboardEstablished = true
                                return
                        }
                        if (!keyboardLayout.isCantoneseMode) && (!inputText.isEmpty) {
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
                        if keyboardLayout.isCantoneseMode {
                                if arrangement == 2 && text == "gw" {
                                        let newInputText: String = inputText + text
                                        inputText = newInputText.replacingOccurrences(of: "gwgw", with: "kw")
                                } else {
                                        inputText += text
                                }
                        } else {
                                textDocumentProxy.insertText(text)
                        }
                        AudioFeedback.perform(.input)
                        adjustKeyboardLayout()
                case .separator:
                        inputText += "'"
                        AudioFeedback.perform(.input)
                        adjustKeyboardLayout()
                case .punctuation(let text):
                        textDocumentProxy.insertText(text)
                        AudioFeedback.perform(.input)
                        adjustKeyboardLayout()
                case .space:
                        switch keyboardLayout {
                        case .cantonese:
                                defer {
                                        AudioFeedback.perform(.input)
                                }
                                guard !inputText.isEmpty else {
                                        textDocumentProxy.insertText(.space)
                                        return
                                }
                                guard let firstCandidate: Candidate = candidates.first else {
                                        output(inputText)
                                        inputText = .empty
                                        return
                                }
                                output(firstCandidate.text)
                                switch inputText.first {
                                case .none:
                                        break
                                case .some("r"), .some("v"), .some("x"):
                                        if inputText.count == (firstCandidate.input.count + 1) {
                                                inputText = .empty
                                        } else {
                                                let first: String = String(inputText.first!)
                                                let tail = inputText.dropFirst(firstCandidate.input.count + 1)
                                                inputText = first + tail
                                        }
                                default:
                                        candidateSequence.append(firstCandidate)
                                        let inputCount: Int = {
                                                if arrangement > 1 {
                                                        return firstCandidate.input.count
                                                } else {
                                                        let converted: String = firstCandidate.input.replacingOccurrences(of: "4", with: "vv").replacingOccurrences(of: "5", with: "xx").replacingOccurrences(of: "6", with: "qq")
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
                        default:
                                textDocumentProxy.insertText(.space)
                                AudioFeedback.perform(.input)
                        }
                        adjustKeyboardLayout()
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
                                switch (doubleSpaceShortcut, keyboardLayout.isEnglishMode) {
                                case (0, false), (1, false):
                                        return "。"
                                case (3, false):
                                        return "，"
                                case (0, true), (1, true):
                                        return ". "
                                case (3, true):
                                        return ", "
                                default:
                                        return "。"
                                }
                        }()
                        textDocumentProxy.insertText(text)
                case .backspace:
                        if inputText.isEmpty {
                                textDocumentProxy.deleteBackward()
                        } else {
                                lazy var hasLightToneSuffix: Bool = inputText.hasSuffix("vv") || inputText.hasSuffix("xx") || inputText.hasSuffix("qq")
                                if arrangement < 2 && hasLightToneSuffix {
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
                        output(inputText)
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
                        switch keyboardLayout {
                        case .cantonese(.lowercased):
                                keyboardLayout = .cantonese(.uppercased)
                        case .cantonese(.uppercased),
                             .cantonese(.capsLocked):
                                keyboardLayout = .cantonese(.lowercased)
                        case .alphabetic(.lowercased):
                                keyboardLayout = .alphabetic(.uppercased)
                        case .alphabetic(.uppercased),
                             .alphabetic(.capsLocked):
                                keyboardLayout = .alphabetic(.lowercased)
                        default:
                                break
                        }
                case .doubleShift:
                        AudioFeedback.perform(.modify)
                        keyboardLayout = keyboardLayout.isEnglishMode ? .alphabetic(.capsLocked) : .cantonese(.capsLocked)
                case .switchTo(let newLayout):
                        AudioFeedback.perform(.modify)
                        keyboardLayout = newLayout
                }
        }
        private func adjustKeyboardLayout() {
                switch keyboardLayout {
                case .alphabetic(.uppercased):
                        keyboardLayout = .alphabetic(.lowercased)
                case .cantonese(.uppercased):
                        keyboardLayout = .cantonese(.lowercased)
                default:
                        break
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
                                if arrangement > 1 {
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

                        if inputText.isEmpty && !oldValue.isEmpty {
                                DispatchQueue.main.async { [unowned self] in
                                        self.updateBottomStackView(with: .key(.cantoneseComma))
                                }
                        } else if !inputText.isEmpty && oldValue.isEmpty {
                                DispatchQueue.main.async { [unowned self] in
                                        self.updateBottomStackView(with: .key(.separator))
                                }
                        }
                }
        }
        private lazy var processingText: String = .empty {
                didSet {
                        DispatchQueue.main.async { [unowned self] in
                                self.toolBar.update()
                        }

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

                // REASON: Chrome
                willSet {
                        guard markedText.isEmpty && !newValue.isEmpty else { return }
                        guard (textDocumentProxy.keyboardType ?? .default) == .webSearch else { return }
                        shouldKeepInputTextWhileTextDidChange = true
                        textDocumentProxy.insertText("")
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

        /// some dumb apps just can't be compatible with `textDocumentProxy.setMarkedText() & textDocumentProxy.insertText()`
        /// - Parameter text: text to output
        func output(_ text: String) {
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
                        let candidates: [Candidate] = romanizations.map({ Candidate(text: lexicon.text, jyutping: $0, input: lexicon.input, lexiconText: lexicon.text) })
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
                        let candidates: [Candidate] = romanizations.map({ Candidate(text: lexicon.text, jyutping: $0, input: lexicon.input, lexiconText: lexicon.text) })
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
                        let candidates: [Candidate] = romanizations.map({ Candidate(text: lexicon.text, jyutping: $0, input: lexicon.input, lexiconText: lexicon.text) })
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
                        let converted: [Candidate] = origin.map { Candidate(text: converter!.convert($0.text), jyutping: $0.jyutping, input: $0.input, lexiconText: $0.lexiconText) }
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
                keyboardLayout = .settingsView
        }
        @objc private func handleYueEngSwitch() {
                hapticFeedback?.impactOccurred()
                AudioFeedback.perform(.modify)
                let switched: Bool = toolBar.yueEngSwitch.switched
                if switched {
                        switch keyboardLayout {
                        case .alphabetic(.lowercased):
                                keyboardLayout = .cantonese(.lowercased)
                        case .alphabetic(.uppercased):
                                keyboardLayout = .cantonese(.uppercased)
                        case .alphabetic(.capsLocked):
                                keyboardLayout = .cantonese(.capsLocked)
                        case .numeric:
                                keyboardLayout = .cantoneseNumeric
                        case .symbolic:
                                keyboardLayout = .cantoneseSymbolic
                        default:
                                keyboardLayout = .cantonese(.lowercased)
                        }
                } else {
                        switch keyboardLayout {
                        case .cantonese(.lowercased):
                                keyboardLayout = .alphabetic(.lowercased)
                        case .cantonese(.uppercased):
                                keyboardLayout = .alphabetic(.uppercased)
                        case .cantonese(.capsLocked):
                                keyboardLayout = .alphabetic(.capsLocked)
                        case .cantoneseNumeric:
                                keyboardLayout = .numeric
                        case .cantoneseSymbolic:
                                keyboardLayout = .symbolic
                        default:
                                keyboardLayout = .alphabetic(.lowercased)
                        }
                }
        }
        @objc private func handlePaste() {
                guard UIPasteboard.general.hasStrings else { return }
                guard let copied: String = UIPasteboard.general.string else { return }
                hapticFeedback?.impactOccurred()
                AudioFeedback.perform(.input)
                insert(copied)
        }
        @objc private func handleEmojiSwitch() {
                hapticFeedback?.impactOccurred()
                AudioFeedback.perform(.modify)
                keyboardLayout = .emoji
        }
        @objc private func dismissInputMethod() {
                dismissKeyboard()
        }
        @objc private func handleDownArrow() {
                keyboardLayout = .candidateBoard
        }


        // MARK: - Properties

        private lazy var isPhone: Bool = traitCollection.userInterfaceIdiom == .phone
        private lazy var isPad: Bool = traitCollection.userInterfaceIdiom == .pad
        private(set) lazy var isDarkAppearance: Bool = textDocumentProxy.keyboardAppearance == .dark || traitCollection.userInterfaceStyle == .dark
        private(set) lazy var screenSize: CGSize = UIScreen.main.bounds.size
        private(set) lazy var isCompactInterface: Bool = isPhone || traitCollection.horizontalSizeClass == .compact
        private(set) lazy var isPhonePortrait: Bool = isPhone && traitCollection.verticalSizeClass == .regular
        private(set) lazy var isPhoneLandscape: Bool = isPhone && traitCollection.verticalSizeClass == .compact
        private(set) lazy var isPadFloating: Bool = isPad && traitCollection.horizontalSizeClass == .compact
        private(set) lazy var isPadPortrait: Bool = !isCompactInterface && screenSize.width < screenSize.height
        private(set) lazy var isPadLandscape: Bool = !isCompactInterface && screenSize.width > screenSize.height
        private func updateProperties() {
                isDarkAppearance = textDocumentProxy.keyboardAppearance == .dark || traitCollection.userInterfaceStyle == .dark
                screenSize = UIScreen.main.bounds.size
                isCompactInterface = isPhone || traitCollection.horizontalSizeClass == .compact
                isPhonePortrait = isPhone && traitCollection.verticalSizeClass == .regular
                isPhoneLandscape = isPhone && traitCollection.verticalSizeClass == .compact
                isPadFloating = isPad && traitCollection.horizontalSizeClass == .compact
                isPadPortrait = !isCompactInterface && screenSize.width < screenSize.height
                isPadLandscape = !isCompactInterface && screenSize.width > screenSize.height
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
        private(set) lazy var arrangement: Int = UserDefaults.standard.integer(forKey: "keyboard_layout")
        func updateArrangement() {
                arrangement = UserDefaults.standard.integer(forKey: "keyboard_layout")
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
        /// 1: 輸入句號「。」（英文鍵盤輸入一個句號「.」加一個空格）
        ///
        /// 2: 無（輸入兩個空格）
        ///
        /// 3: 輸入逗號「，」（英文鍵盤輸入一個逗號「,」加一個空格）
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
