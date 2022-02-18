import UIKit
import KeyboardData
import LookupData
import Simplifier

final class KeyboardViewController: UIInputViewController {

        // MARK: - Subviews

        private(set) lazy var toolBar: ToolBar = ToolBar(controller: self)
        private(set) lazy var settingsView: UIView = UIView()
        private(set) lazy var candidateBoard: CandidateBoard = CandidateBoard()
        private(set) lazy var emojiBoard: EmojiBoard = EmojiBoard()

        private(set) lazy var candidateCollectionView: UICollectionView = {
                let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
                collectionView.delegate = self
                collectionView.dataSource = self
                collectionView.backgroundColor = .interactiveClear
                collectionView.register(CandidateCell.self, forCellWithReuseIdentifier: Identifiers.CandidateCell)
                return collectionView
        }()
        private(set) lazy var emojiCollectionView: UICollectionView = {
                let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
                collectionView.delegate = self
                collectionView.dataSource = self
                collectionView.backgroundColor = .interactiveClear
                collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: Identifiers.EmojiCell)
                return collectionView
        }()
        private(set) lazy var sidebarCollectionView: UICollectionView = {
                let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
                collectionView.delegate = self
                collectionView.dataSource = self
                collectionView.backgroundColor = .interactiveClear
                collectionView.register(SidebarCell.self, forCellWithReuseIdentifier: Identifiers.SidebarCell)
                return collectionView
        }()
        private(set) lazy var settingsTableView: UITableView = {
                let tableView = UITableView(frame: .zero, style: .insetGrouped)
                tableView.delegate = self
                tableView.dataSource = self
                tableView.register(UITableViewCell.self, forCellReuseIdentifier: Identifiers.switchSettingsCell)
                tableView.register(UITableViewCell.self, forCellReuseIdentifier: Identifiers.selectionSettingsCell)
                tableView.register(UITableViewCell.self, forCellReuseIdentifier: Identifiers.clearLexiconSettingsCell)
                return tableView
        }()

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

        override func viewDidLoad() {
                super.viewDidLoad()
                view.addSubview(keyboardStackView)
                keyboardStackView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        keyboardStackView.topAnchor.constraint(equalTo: view.topAnchor),
                        keyboardStackView.leftAnchor.constraint(equalTo: view.leftAnchor),
                        keyboardStackView.rightAnchor.constraint(equalTo: view.rightAnchor),
                        keyboardStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ])
                setupToolBarActions()
        }
        private lazy var shouldKeepBufferTextWhileTextDidChange: Bool = false
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
                if shouldKeepBufferTextWhileTextDidChange {
                        shouldKeepBufferTextWhileTextDidChange = false
                } else {
                        if !bufferText.isEmpty && !textDocumentProxy.hasText {
                                // User just tapped the Clear button in the text field
                                bufferText = .empty
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
                simplifier?.close()
                simplifier = nil
        }
        override func viewDidDisappear(_ animated: Bool) {
                super.viewDidDisappear(animated)
                keyboardStackView.removeFromSuperview()
        }

        private lazy var didKeyboardEstablished: Bool = false
        private lazy var needsDifferentKeyboard: Bool = false
        private lazy var respondingKeyboardIdiom: KeyboardIdiom = fallbackKeyboardIdiom
        private var askedKeyboardIdiom: KeyboardIdiom {
                switch textDocumentProxy.keyboardType {
                case .numberPad, .asciiCapableNumberPad:
                        return keyboardInterface.isCompact ? .numberPad : .numeric
                case .decimalPad:
                        return keyboardInterface.isCompact ? .decimalPad : .numeric
                case .numbersAndPunctuation:
                        return .numeric
                case .emailAddress, .URL:
                        return .alphabetic(.lowercased)
                default:
                        return fallbackKeyboardIdiom
                }
        }
        lazy var keyboardIdiom: KeyboardIdiom = fallbackKeyboardIdiom {
                didSet {
                        setupKeyboard()
                        guard didKeyboardEstablished else {
                                didKeyboardEstablished = true
                                return
                        }
                        if (!keyboardIdiom.isPingMode) && (!bufferText.isEmpty) {
                                let text: String = bufferText
                                bufferText = .empty
                                textDocumentProxy.insertText(text)
                        }
                }
        }
        var fallbackKeyboardIdiom: KeyboardIdiom {
                switch keyboardLayout {
                case .qwerty:
                        return .cantonese(.lowercased)
                case .saamPing:
                        return .cantonese(.lowercased)
                case .grid:
                        return .gridKeyboard
                }
        }


        // MARK: - Operations

        func operate(_ operation: Operation) {
                switch operation {
                case .input(let text):
                        if keyboardIdiom.isPingMode {
                                if keyboardLayout == .saamPing && text == "gw" {
                                        let newText: String = bufferText + text
                                        bufferText = newText.replacingOccurrences(of: "gwgw", with: "kw")
                                } else {
                                        bufferText += text
                                }
                        } else {
                                textDocumentProxy.insertText(text)
                        }
                        AudioFeedback.perform(.input)
                        adjustKeyboardIdiom()
                case .separator:
                        bufferText += "'"
                        AudioFeedback.perform(.input)
                        adjustKeyboardIdiom()
                case .punctuation(let text):
                        textDocumentProxy.insertText(text)
                        AudioFeedback.perform(.input)
                        adjustKeyboardIdiom()
                case .space:
                        switch keyboardIdiom {
                        case .cantonese where !bufferText.isEmpty:
                                if let firstCandidate: Candidate = candidates.first {
                                        compose(firstCandidate.text)
                                        AudioFeedback.perform(.modify)
                                        aftercareSelected(firstCandidate)
                                } else {
                                        compose(bufferText)
                                        AudioFeedback.perform(.input)
                                        bufferText = .empty
                                }
                        default:
                                textDocumentProxy.insertText(.space)
                                AudioFeedback.perform(.input)
                        }
                        adjustKeyboardIdiom()
                case .doubleSpace:
                        guard bufferText.isEmpty else { return }
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
                                case (0, true), (1, true):
                                        return ". "
                                case (3, false):
                                        return "、"
                                case (3, true):
                                        return ", "
                                case (4, _):
                                        return .fullwidthSpace
                                default:
                                        return .fullwidthSpace
                                }
                        }()
                        textDocumentProxy.insertText(text)
                case .backspace:
                        if bufferText.isEmpty {
                                textDocumentProxy.deleteBackward()
                        } else {
                                lazy var hasLightToneSuffix: Bool = bufferText.hasSuffix("vv") || bufferText.hasSuffix("xx") || bufferText.hasSuffix("qq")
                                if keyboardLayout == .qwerty && hasLightToneSuffix {
                                        bufferText = String(bufferText.dropLast(2))
                                } else {
                                        bufferText = String(bufferText.dropLast())
                                }
                                candidateSequence = []
                        }
                        AudioFeedback.perform(.delete)
                case .clear:
                        guard !bufferText.isEmpty else { return }
                        bufferText = .empty
                        AudioFeedback.perform(.delete)
                case .return:
                        guard !bufferText.isEmpty else {
                                textDocumentProxy.insertText("\n")
                                AudioFeedback.perform(.modify)
                                return
                        }
                        compose(bufferText)
                        bufferText = .empty
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
                case .transform(let newIdiom):
                        AudioFeedback.perform(.modify)
                        let shouldBeGridKeyboard: Bool = keyboardLayout == .grid && newIdiom == .cantonese(.lowercased)
                        keyboardIdiom = shouldBeGridKeyboard ? .gridKeyboard : newIdiom
                case .select(let candidate):
                        compose(candidate.text)
                        AudioFeedback.perform(.modify)
                        triggerHapticFeedback()
                        aftercareSelected(candidate)
                        adjustKeyboardIdiom()
                }
        }
        private func adjustKeyboardIdiom() {
                switch keyboardIdiom {
                case .alphabetic(.uppercased):
                        keyboardIdiom = .alphabetic(.lowercased)
                case .cantonese(.uppercased):
                        keyboardIdiom = .cantonese(.lowercased)
                case .candidates where bufferText.isEmpty:
                        candidateCollectionView.removeFromSuperview()
                        NSLayoutConstraint.deactivate(candidateBoardCollectionViewConstraints)
                        toolBar.reset()
                        keyboardIdiom = fallbackKeyboardIdiom
                default:
                        break
                }
        }
        private func aftercareSelected(_ candidate: Candidate) {
                switch bufferText.first {
                case .none:
                        break
                case .some("r"), .some("v"), .some("x"):
                        if bufferText.count == candidate.input.count + 1 {
                                bufferText = .empty
                        } else {
                                let first: String = String(bufferText.first!)
                                let tail = bufferText.dropFirst(candidate.input.count + 1)
                                bufferText = first + tail
                        }
                default:
                        candidateSequence.append(candidate)
                        let inputTextLength: Int = bufferText.count
                        let candidateInputText: String = {
                                if keyboardLayout == .saamPing {
                                        return candidate.input
                                } else {
                                        let converted: String = candidate.input.replacingOccurrences(of: "(4|5|6)", with: "xx", options: .regularExpression)
                                        return converted
                                }
                        }()
                        let inputCount: Int = {
                                let candidateInputCount: Int = candidateInputText.count
                                guard inputTextLength != 2 else { return candidateInputCount }
                                guard candidateInputText.contains("jyu") else { return candidateInputCount }
                                let suffixCount: Int = max(0, inputTextLength - candidateInputCount)
                                let leading = bufferText.dropLast(suffixCount)
                                let modifiedLeading = leading.replacingOccurrences(of: "jyu", with: "xxx").replacingOccurrences(of: "yu", with: "jyu")
                                return candidateInputCount - (modifiedLeading.count - leading.count)
                        }()
                        let leading = bufferText.dropLast(inputTextLength - inputCount)
                        let filtered = leading.replacingOccurrences(of: "'", with: "")
                        var tail: String.SubSequence = {
                                if filtered.count == leading.count {
                                        return bufferText.dropFirst(inputCount)
                                } else {
                                        let separatorsCount: Int = leading.count - filtered.count
                                        return bufferText.dropFirst(inputCount + separatorsCount)
                                }
                        }()
                        while tail.hasPrefix("'") {
                                tail = tail.dropFirst()
                        }
                        bufferText = String(tail)
                }
                if bufferText.isEmpty && !candidateSequence.isEmpty {
                        let concatenatedCandidate: Candidate = candidateSequence.joined()
                        candidateSequence = []
                        handleLexicon(concatenatedCandidate)
                }
        }


        // MARK: - Input Texts

        private(set) lazy var bufferText: String = .empty {
                didSet {
                        switch bufferText.first {
                        case .none:
                                processingText = .empty
                        case .some("r"), .some("v"), .some("x"):
                                processingText = bufferText
                        default:
                                if keyboardLayout == .saamPing {
                                        processingText = bufferText
                                } else {
                                        processingText = bufferText.replacingOccurrences(of: "vv", with: "4")
                                                .replacingOccurrences(of: "xx", with: "5")
                                                .replacingOccurrences(of: "qq", with: "6")
                                                .replacingOccurrences(of: "v", with: "1")
                                                .replacingOccurrences(of: "x", with: "2")
                                                .replacingOccurrences(of: "q", with: "3")
                                }
                        }
                        switch (bufferText.isEmpty, oldValue.isEmpty) {
                        case (true, false):
                                updateBottomStackView(with: .input(.cantoneseComma))
                        case (false, true):
                                updateBottomStackView(with: .input(.separator))
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
                                suggest()
                        }
                }
        }
        private lazy var markedText: String = .empty {
                willSet {
                        // REASON: Chrome address bar
                        guard markedText.isEmpty && !newValue.isEmpty else { return }
                        guard textDocumentProxy.keyboardType == .webSearch else { return }
                        shouldKeepBufferTextWhileTextDidChange = true
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
                                                .replacingOccurrences(of: "(eoy|oey)$", with: "eoi", options: .regularExpression)
                                                .replacingOccurrences(of: "^([b-z]|ng)(u|o)m$", with: "$1am", options: .regularExpression)
                                                .replacingOccurrences(of: "^y(u|un|ut)$", with: "jy$1", options: .regularExpression)
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) { [unowned self] in
                                shouldMarkInput = true
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
        private lazy var simplifier: Simplifier? = nil
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
                switch Logogram.current {
                case .traditional:
                        candidates = origin.uniqued()
                case .hongkong, .taiwan:
                        let converted: [Candidate] = origin.map({ Candidate(text: VariantConverter.convert(text: $0.text, to: .current), romanization: $0.romanization, input: $0.input, lexiconText: $0.lexiconText) })
                        candidates = converted.uniqued()
                case .simplified:
                        if simplifier == nil {
                                simplifier = Simplifier()
                        }
                        let converted: [Candidate] = origin.map({ Candidate(text: simplifier?.convert($0.text) ?? $0.text, romanization: $0.romanization, input: $0.input, lexiconText: $0.lexiconText)})
                        candidates = converted.uniqued()
                }
        }
        private(set) lazy var candidates: [Candidate] = [] {
                didSet {
                        DispatchQueue.main.async { [unowned self] in
                                candidateCollectionView.reloadData()
                                candidateCollectionView.setContentOffset(.zero, animated: true)
                        }
                }
        }
        private lazy var candidateSequence: [Candidate] = []
        func handleLexicon(_ candidate: Candidate) {
                imeQueue.async { [unowned self] in
                        userLexicon?.handle(candidate)
                }
        }
        func clearUserLexicon() {
                imeQueue.async { [unowned self] in
                        userLexicon?.deleteAll()
                }
                Emoji.clearFrequentEmojis()
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
                keyboardIdiom = .settings
        }
        @objc private func handleYueEngSwitch() {
                hapticFeedback?.impactOccurred()
                AudioFeedback.perform(.modify)
                let switched: Bool = toolBar.yueEngSwitch.switched
                if switched {
                        let newIdiom: KeyboardIdiom = {
                                let shouldBeGridLayout: Bool = keyboardLayout == .grid
                                switch keyboardIdiom {
                                case .alphabetic(.lowercased):
                                        return fallbackKeyboardIdiom
                                case .alphabetic(.uppercased):
                                        return shouldBeGridLayout ? .gridKeyboard : .cantonese(.uppercased)
                                case .alphabetic(.capsLocked):
                                        return shouldBeGridLayout ? .gridKeyboard : .cantonese(.capsLocked)
                                case .numeric:
                                        return shouldBeGridLayout ? .gridKeyboard : .cantoneseNumeric
                                case .symbolic:
                                        return shouldBeGridLayout ? .gridKeyboard : .cantoneseSymbolic
                                default:
                                        return fallbackKeyboardIdiom
                                }
                        }()
                        keyboardIdiom = newIdiom
                } else {
                        let newIdiom: KeyboardIdiom = {
                                switch keyboardIdiom {
                                case .cantonese(.lowercased):
                                        return .alphabetic(.lowercased)
                                case .cantonese(.uppercased):
                                        return .alphabetic(.uppercased)
                                case .cantonese(.capsLocked):
                                        return .alphabetic(.capsLocked)
                                case .cantoneseNumeric:
                                        return .numeric
                                case .cantoneseSymbolic:
                                        return .symbolic
                                default:
                                        return .alphabetic(.lowercased)
                                }
                        }()
                        keyboardIdiom = newIdiom
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
                keyboardIdiom = .candidates
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

        /// 鍵盤佈局。全鍵盤 或三拼 或九宮格。
        private(set) lazy var keyboardLayout: KeyboardLayout = {

                /// 鍵盤佈局
                ///
                /// 0: The key "keyboard_layout" doesn‘t exist.
                ///
                /// 1: 全鍵盤 QWERTY
                ///
                /// 2: 三拼
                ///
                /// 3: 九宮格（未實現）
                let value: Int = UserDefaults.standard.integer(forKey: "keyboard_layout")
                switch value {
                case 0, 1:
                        return .qwerty
                case 2:
                        return .saamPing
                case 3:
                        return .grid
                default:
                        return .qwerty
                }
        }()
        func updateKeyboardLayout(to newLayout: KeyboardLayout) {
                let value: Int = {
                        switch newLayout {
                        case .qwerty:
                                return 1
                        case .saamPing:
                                return 2
                        case .grid:
                                return 3
                        }
                }()
                UserDefaults.standard.set(value, forKey: "keyboard_layout")
                keyboardLayout = newLayout
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
        /// 3: 輸入一個頓號「、」（英文鍵盤輸入一個逗號「,」加一個空格）
        ///
        /// 4: 輸入一個全形空格（U+3000）
        private(set) lazy var doubleSpaceShortcut: Int = UserDefaults.standard.integer(forKey: "double_space_shortcut")
        func updateDoubleSpaceShortcut() {
                doubleSpaceShortcut = UserDefaults.standard.integer(forKey: "double_space_shortcut")
        }
}
