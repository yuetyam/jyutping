import UIKit
import OpenCCLite

final class KeyboardViewController: UIInputViewController {

        // MARK: - SubViews

        private(set) lazy var toolBar: ToolBar = ToolBar(controller: self)
        private(set) lazy var settingsView: UIView = UIView()
        private(set) lazy var candidateBoard: CandidateBoard = CandidateBoard()
        private(set) lazy var candidateCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        private(set) lazy var emojiBoard: EmojiBoard = EmojiBoard(viewController: self)
        private(set) lazy var emojiCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        private(set) lazy var settingsTableView: UITableView = UITableView(frame: .zero, style: .grouped)

        private(set) lazy var keyboardStackView: UIStackView = {
                let stackView = UIStackView(frame: .zero)
                stackView.axis = .vertical
                stackView.alignment = .fill
                stackView.distribution = .equalSpacing
                return stackView
        }()


        // MARK: - Keyboard Life Cycle

        private lazy var didLoad: Bool = false
        private func initialize() {
                guard !didLoad else { return }
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
                settingsTableView.register(NormalTableViewCell.self, forCellReuseIdentifier: "ClearLexiconTableViewCell")
                setupToolBarActions()
                didLoad = true
        }
        override func viewDidLoad() {
                super.viewDidLoad()
                initialize()
        }
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
                if !textDocumentProxy.hasText && !inputText.isEmpty {
                        inputText = ""
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
                if isHapticFeedbackOn && hapticFeedback == nil {
                        hapticFeedback = UIImpactFeedbackGenerator(style: .light)
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
        }
        private lazy var didKeyboardEstablished: Bool = false
        private lazy var needsDifferentKeyboard: Bool = false
        private lazy var respondingKeyboardLayout: KeyboardLayout = .cantonese(.lowercased)
        var askedKeyboardLayout: KeyboardLayout {
                switch textDocumentProxy.keyboardType {
                case .numberPad, .asciiCapableNumberPad:
                        return traitCollection.userInterfaceIdiom == .pad ? .numeric : .numberPad
                case .decimalPad:
                        return traitCollection.userInterfaceIdiom == .pad ? .numeric : .decimalPad
                case .asciiCapable, .emailAddress, .twitter, .URL:
                        return .alphabetic(.lowercased)
                case .numbersAndPunctuation:
                        return .numeric
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
                                output(processingText)
                                DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) { [unowned self] in
                                        self.inputText = ""
                                }
                        }
                }
        }


        // MARK: - Input

        lazy var inputText: String = "" {
                didSet {
                        if inputText.isEmpty || inputText.hasPrefix("v") || inputText.hasPrefix("r") {
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
        }
        private(set) lazy var processingText: String = "" {
                didSet {
                        DispatchQueue.main.async { [unowned self] in
                                self.toolBar.update()
                        }
                        syllablesSchemes = Splitter.split(processingText)
                        if let syllables: [String] = syllablesSchemes.first {
                                let splittable: String = syllables.joined()
                                if splittable.count == processingText.count {
                                        markedText = syllables.joined(separator: " ")
                                } else if processingText.contains("'") {
                                        markedText = processingText.replacingOccurrences(of: "'", with: "' ")
                                } else {
                                        let tail = processingText.dropFirst(splittable.count)
                                        markedText = syllables.joined(separator: " ") + " " + tail
                                }
                        } else {
                                markedText = processingText
                        }
                        if processingText.isEmpty {
                                candidates = []
                        } else {
                                imeQueue.async { [unowned self] in
                                        self.suggest()
                                }
                        }
                }
        }
        private lazy var markedText: String = "" {
                didSet {
                        guard shouldMarkInput else { return }
                        handleMarkedText()
                }
        }
        private lazy var syllablesSchemes: [[String]] = []

        /// some dumb apps just can't be compatible with `setMarkedText() & insertText()`
        /// - Parameter text: text to output
        func output(_ text: String) {
                shouldMarkInput = false
                defer {
                        DispatchQueue.global().asyncAfter(deadline: .now() + 0.02) { [unowned self] in
                                self.shouldMarkInput = true
                        }
                }
                let range: NSRange = NSRange(location: text.count, length: 0)
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
                let range: NSRange = NSRange(location: markedText.count, length: 0)
                textDocumentProxy.setMarkedText(markedText, selectedRange: range)
        }

        /// Calling `textDocumentProxy.insertText(_)`
        /// - Parameter text: text to insert
        func insert(_ text: String) {
                textDocumentProxy.insertText(text)
        }


        // MARK: - Engine

        private let imeQueue: DispatchQueue = DispatchQueue(label: "im.cantonese.ime", qos: .userInteractive)
        private lazy var lexiconManager: LexiconManager = LexiconManager()
        private lazy var engine: Engine = Engine()
        private func suggest() {
                let userLexicon: [Candidate] = lexiconManager.suggest(for: processingText)
                let engineCandidates: [Candidate] = engine.suggest(for: processingText, schemes: syllablesSchemes)
                let combined: [Candidate] = userLexicon + engineCandidates
                if logogram < 2 {
                        candidates = combined.deduplicated()
                } else if converter == nil {
                        candidates = combined.deduplicated()
                        updateConverter()
                } else {
                        let converted: [Candidate] = combined.map { Candidate(text: converter!.convert($0.text), jyutping: $0.jyutping, input: $0.input, lexiconText: $0.lexiconText) }
                        candidates = converted.deduplicated()
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
                        self.lexiconManager.handle(candidate: candidate)
                }
        }
        func clearUserLexicon() {
                imeQueue.async { [unowned self] in
                        self.lexiconManager.deleteAll()
                }
        }


        // MARK: - ToolBar Actions

        private func setupToolBarActions() {
                toolBar.settingsButton.addTarget(self, action: #selector(handleSettingsButtonEvent), for: .touchUpInside)
                toolBar.yueEngSwitch.addTarget(self, action: #selector(handleYueEngSwitch), for: .touchDown)
                toolBar.pasteButton.addTarget(self, action: #selector(handlePaste), for: .touchUpInside)
                toolBar.emojiSwitch.addTarget(self, action: #selector(handleEmojiSwitch), for: .touchUpInside)
                toolBar.downArrowButton.addTarget(self, action: #selector(handleDownArrowEvent), for: .touchUpInside)
                toolBar.keyboardDownButton.addTarget(self, action: #selector(dismissInputMethod), for: .touchUpInside)
        }
        @objc private func handleDownArrowEvent() {
                keyboardLayout = .candidateBoard
        }
        @objc private func dismissInputMethod() {
                dismissKeyboard()
        }
        @objc private func handleSettingsButtonEvent() {
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


        // MARK: - Properties

        private(set) lazy var isDarkAppearance: Bool = textDocumentProxy.keyboardAppearance == .dark || traitCollection.userInterfaceStyle == .dark
        private(set) lazy var isPhonePortrait: Bool = (traitCollection.userInterfaceIdiom == .phone) && (traitCollection.verticalSizeClass == .regular)
        private(set) lazy var isPhoneInterface: Bool = (traitCollection.userInterfaceIdiom == .phone) || (traitCollection.horizontalSizeClass == .compact) || (view.frame.width < 500)
        private(set) lazy var isPadLandscape: Bool = UIScreen.main.bounds.width > UIScreen.main.bounds.height
        private func updateProperties() {
                isDarkAppearance = textDocumentProxy.keyboardAppearance == .dark || traitCollection.userInterfaceStyle == .dark
                isPhonePortrait = (traitCollection.userInterfaceIdiom == .phone) && (traitCollection.verticalSizeClass == .regular)
                isPhoneInterface = (traitCollection.userInterfaceIdiom == .phone) || (traitCollection.horizontalSizeClass == .compact) || (view.frame.width < 500)
                isPadLandscape = UIScreen.main.bounds.width > UIScreen.main.bounds.height
        }

        // MARK: - Settings

        var hapticFeedback: UIImpactFeedbackGenerator?
        private(set) lazy var isHapticFeedbackOn: Bool = UserDefaults.standard.bool(forKey: "haptic_feedback")
        func updateHapticFeedbackStatus() {
                isHapticFeedbackOn = UserDefaults.standard.bool(forKey: "haptic_feedback")
        }

        /// 鍵盤佈局
        ///
        /// 0: The key "keyboard_layout" doesn‘t exist.
        ///
        /// 1: 粵拼 全鍵盤 QWERTY
        ///
        /// 2: 粵拼 三拼
        ///
        /// 3: 粵拼 九宮格十鍵（未實現）
        private(set) lazy var arrangement: Int = UserDefaults.standard.integer(forKey: "keyboard_layout")
        func updateArrangement() {
                arrangement = UserDefaults.standard.integer(forKey: "keyboard_layout")
        }

        /// 候選詞字形
        ///
        /// 0: The key "logogram" doesn‘t exist.
        ///
        /// 1: 傳統漢字
        ///
        /// 2: 傳統漢字（香港）
        ///
        /// 3: 傳統漢字（臺灣）
        ///
        /// 4: 簡化字
        private(set) lazy var logogram: Int = UserDefaults.standard.integer(forKey: "logogram")
        private lazy var converter: Converter? = {
                let conversion: Converter.Conversion? = {
                        let logogram: Int = UserDefaults.standard.integer(forKey: "logogram")
                        switch logogram {
                        case 2:
                                return .hkStandard
                        case 3:
                                return .twStandard
                        case 4:
                                return .simplify
                        default:
                                return nil
                        }
                }()
                guard conversion != nil else { return nil }
                let converter: Converter? = try? Converter(conversion!)
                return converter
        }()
        func updateConverter() {
                logogram = UserDefaults.standard.integer(forKey: "logogram")
                let conversion: Converter.Conversion? = {
                        switch logogram {
                        case 2:
                                return .hkStandard
                        case 3:
                                return .twStandard
                        case 4:
                                return .simplify
                        default:
                                return nil
                        }
                }()
                guard conversion != nil else { converter = nil; return }
                let converter: Converter? = try? Converter(conversion!)
                self.converter = converter
        }

        /// 粵拼顯示
        ///
        /// 0: The key "jyutping_display" doesn‘t exist.
        ///
        /// 1: 喺候選詞上邊
        ///
        /// 2: 喺候選詞下邊
        ///
        /// 3: 唔顯示
        private(set) lazy var jyutpingDisplay: Int = UserDefaults.standard.integer(forKey: "jyutping_display")
        func updateJyutpingDisplay() {
                jyutpingDisplay = UserDefaults.standard.integer(forKey: "jyutping_display")
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

        private(set) lazy var frequentEmojis: String = UserDefaults.standard.string(forKey: "emoji_frequent") ?? ""
        func updateFrequentEmojis(latest emoji: String) {
                let combined: String = emoji + frequentEmojis
                let uniqued: [String] = combined.map({ String($0)} ).deduplicated()
                let updated: [String] = uniqued.count < 31 ? uniqued : uniqued.dropLast(uniqued.count - 30)
                frequentEmojis = updated.joined()
                UserDefaults.standard.set(frequentEmojis, forKey: "emoji_frequent")
        }
}
