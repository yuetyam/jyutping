import UIKit
import OpenCCLite

final class KeyboardViewController: UIInputViewController {

        // MARK: - Subviews

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
                stackView.distribution = .equalSpacing
                return stackView
        }()
        private(set) lazy var bottomStackView: UIStackView = {
                let stackView = UIStackView(frame: .zero)
                stackView.distribution = .fillProportionally
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
                                inputText = ""
                        }
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
        private var askedKeyboardLayout: KeyboardLayout {
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
                                let text: String = inputText
                                inputText = ""
                                insert(text)
                        }
                }
        }


        // MARK: - Input

        lazy var inputText: String = "" {
                didSet {
                        if inputText.isEmpty || (arrangement > 1) || inputText.hasPrefix("v") || inputText.hasPrefix("r") {
                                processingText = inputText
                        } else {
                                processingText = inputText.replacingOccurrences(of: "vv", with: "4")
                                        .replacingOccurrences(of: "xx", with: "5")
                                        .replacingOccurrences(of: "qq", with: "6")
                                        .replacingOccurrences(of: "v", with: "1")
                                        .replacingOccurrences(of: "x", with: "2")
                                        .replacingOccurrences(of: "q", with: "3")
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
        private lazy var processingText: String = "" {
                didSet {
                        DispatchQueue.main.async { [unowned self] in
                                self.toolBar.update()
                        }
                        guard !processingText.isEmpty else {
                                syllablesSchemes = []
                                markedText = ""
                                candidates = []
                                return
                        }
                        if processingText.hasPrefix("v") || processingText.hasPrefix("r") {
                                syllablesSchemes = []
                                markedText = processingText
                        } else {
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
                        }
                        imeQueue.async { [unowned self] in
                                self.suggest()
                        }
                }
        }
        private lazy var markedText: String = "" {

                // REASON: Chrome
                willSet {
                        guard markedText.isEmpty && !newValue.isEmpty else { return }
                        guard let type = textDocumentProxy.keyboardType, type == .webSearch else { return }
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
                        guard !syllablesSchemes.isEmpty else { schemes = syllablesSchemes; return }
                        schemes = syllablesSchemes.map({ block -> [String] in
                                let sequence: [String] = block.map { syllable -> String in
                                        let converted: String = syllable.replacingOccurrences(of: "eo(ng|k)$", with: "oe$1", options: .regularExpression)
                                                .replacingOccurrences(of: "oe(i|n|t)$", with: "eo$1", options: .regularExpression)
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

        private let imeQueue: DispatchQueue = DispatchQueue(label: "im.cantonese.ime", qos: .userInteractive)
        private lazy var userLexicon: UserLexicon = UserLexicon()
        private lazy var engine: Engine = Engine()
        private func suggest() {
                let lexiconCandidates: [Candidate] = userLexicon.suggest(for: processingText)
                let engineCandidates: [Candidate] = engine.suggest(for: processingText, schemes: schemes.deduplicated())
                let combined: [Candidate] = lexiconCandidates + engineCandidates
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
                        self.userLexicon.handle(candidate)
                }
        }
        func clearUserLexicon() {
                imeQueue.async { [unowned self] in
                        self.userLexicon.deleteAll()
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

        private(set) lazy var isDarkAppearance: Bool = textDocumentProxy.keyboardAppearance == .dark || traitCollection.userInterfaceStyle == .dark
        private(set) lazy var isPhonePortrait: Bool = traitCollection.userInterfaceIdiom == .phone && traitCollection.verticalSizeClass == .regular
        private(set) lazy var isPhoneInterface: Bool = traitCollection.userInterfaceIdiom == .phone || traitCollection.horizontalSizeClass == .compact
        private(set) lazy var isPadLandscape: Bool = UIScreen.main.bounds.width > UIScreen.main.bounds.height
        private func updateProperties() {
                let isPhone: Bool = traitCollection.userInterfaceIdiom == .phone
                isDarkAppearance = textDocumentProxy.keyboardAppearance == .dark || traitCollection.userInterfaceStyle == .dark
                isPhonePortrait = isPhone && traitCollection.verticalSizeClass == .regular
                isPhoneInterface = isPhone || traitCollection.horizontalSizeClass == .compact
                isPadLandscape = UIScreen.main.bounds.width > UIScreen.main.bounds.height
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

        /// 候選詞字符標準
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
                guard let conversion = conversion else { return nil }
                let converter: Converter? = try? Converter(conversion)
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

        /*
        /// 雙擊空格鍵快捷動作
        ///
        /// 0: The key "double_space_shortcut" doesn‘t exist.
        ///
        /// 1: 無（輸入兩個空格）
        ///
        /// 2: 輸入句號「。」（英文鍵盤輸入一個句號「.」加一個空格）
        private(set) lazy var doubleSpaceShortcut: Int = UserDefaults.standard.integer(forKey: "double_space_shortcut")
        func updateDoubleSpaceShortcut() {
                doubleSpaceShortcut = UserDefaults.standard.integer(forKey: "double_space_shortcut")
        }
        */

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

        private(set) lazy var frequentEmojis: String = UserDefaults.standard.string(forKey: "emoji_frequent") ?? ""
        func updateFrequentEmojis(latest emoji: String) {
                let combined: String = emoji + frequentEmojis
                let uniqued: [String] = combined.map({ String($0) }).deduplicated()
                let updated: [String] = uniqued.count < 31 ? uniqued : uniqued.dropLast(uniqued.count - 30)
                frequentEmojis = updated.joined()
                UserDefaults.standard.set(frequentEmojis, forKey: "emoji_frequent")
        }
}


// MARK: - NOTES

// Up to v0.7.3
// User Lexicon was in Library/userdb.sqlite3

// v0.7.4 - v0.7.6
// transfer it to Library/userlexicon.sqlite3
// add UserDefaults.standard.bool(forKey: "is_user_lexicon_ready_v0.7")

// v0.7.7
// abandon Library/userdb.sqlite3 and "is_user_lexicon_ready_v0.7"
// commit: 41dc8dfeb175a26fb83b2f0972253f736d9c342d
