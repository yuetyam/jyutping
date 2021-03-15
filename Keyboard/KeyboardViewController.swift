import UIKit
import OpenCCLite

final class KeyboardViewController: UIInputViewController {
        
        private(set) lazy var toolBar: ToolBar = ToolBar(viewController: self)
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

                candidateCollectionView.delegate = self
                candidateCollectionView.dataSource = self
                candidateCollectionView.register(CandidateCell.self, forCellWithReuseIdentifier: "CandidateCell")
                candidateCollectionView.backgroundColor = view.backgroundColor
                
                emojiCollectionView.delegate = self
                emojiCollectionView.dataSource = self
                emojiCollectionView.register(EmojiCell.self, forCellWithReuseIdentifier: "EmojiCell")
                emojiCollectionView.backgroundColor = view.backgroundColor

                settingsTableView.delegate = self
                settingsTableView.dataSource = self
                settingsTableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: "SwitchTableViewCell")                
                settingsTableView.register(NormalTableViewCell.self, forCellReuseIdentifier: "CharactersTableViewCell")
                settingsTableView.register(NormalTableViewCell.self, forCellReuseIdentifier: "JyutpingTableViewCell")
                settingsTableView.register(NormalTableViewCell.self, forCellReuseIdentifier: "ToneStyleTableViewCell")
                settingsTableView.register(NormalTableViewCell.self, forCellReuseIdentifier: "ClearLexiconTableViewCell")
        }

        override func didReceiveMemoryWarning() {
                debugPrint("didReceiveMemoryWarning()")
                super.didReceiveMemoryWarning()
        }

        override func viewDidAppear(_ animated: Bool) {
                super.viewDidAppear(animated)
                if askingDifferentKeyboardLayout {
                        keyboardLayout = answeredKeyboardLayout
                } else {
                        setupKeyboard()
                        didKeyboardEstablished = true
                }
                let isHapticFeedbackOn: Bool = UserDefaults.standard.bool(forKey: "haptic_feedback")
                if isHapticFeedbackOn && hapticFeedback == nil {
                        hapticFeedback = UIImpactFeedbackGenerator(style: .light)
                }
                if logogram > 1 && converter == nil {
                        updateConverter()
                }
                if engine == nil {
                        engine = Engine()
                }
                if lexiconManager == nil {
                        lexiconManager = LexiconManager()
                }
        }
        
        var hapticFeedback: UIImpactFeedbackGenerator?

        override func viewWillDisappear(_ animated: Bool) {
                super.viewWillDisappear(animated)
                hapticFeedback = nil
                converter?.destroy()
                converter = nil
                engine?.close()
                engine = nil
                lexiconManager?.close()
                lexiconManager = nil
        }

        private(set) lazy var isDarkAppearance: Bool = textDocumentProxy.keyboardAppearance == .dark || traitCollection.userInterfaceStyle == .dark
        
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
                super.traitCollectionDidChange(previousTraitCollection)
                isDarkAppearance = textDocumentProxy.keyboardAppearance == .dark || traitCollection.userInterfaceStyle == .dark
                if didKeyboardEstablished {
                        setupKeyboard()
                }
        }
        
        private lazy var didKeyboardEstablished: Bool = false
        private lazy var askingDifferentKeyboardLayout: Bool = false
        
        override func textDidChange(_ textInput: UITextInput?) {
                super.textDidChange(textInput)
                let asked: KeyboardLayout = askedKeyboardLayout
                if answeredKeyboardLayout != asked {
                        answeredKeyboardLayout = asked
                        askingDifferentKeyboardLayout = true
                        if didKeyboardEstablished {
                                keyboardLayout = answeredKeyboardLayout
                        }
                }
                if !textDocumentProxy.hasText && !currentInputText.isEmpty {
                        // User just tapped Clear Button in TextField
                        currentInputText = ""
                }
        }
        
        private lazy var answeredKeyboardLayout: KeyboardLayout = .jyutping(.lowercased)
        
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
                        return .jyutping(.lowercased)
                }
        }

        var keyboardLayout: KeyboardLayout = .jyutping(.lowercased) {
                didSet {
                        setupKeyboard()
                        guard didKeyboardEstablished else {
                                didKeyboardEstablished = true
                                return
                        }
                        if !keyboardLayout.isJyutpingMode {
                                if !currentInputText.isEmpty {
                                        textDocumentProxy.insertText(currentInputText)
                                }
                                currentInputText = ""
                        }
                }
        }
        
        let imeQueue: DispatchQueue = DispatchQueue(label: "im.cantonese.ime", qos: .userInitiated)
        var currentInputText: String = "" {
                didSet {
                        DispatchQueue.main.async {
                                self.toolBar.update()
                        }
                        let range: NSRange = NSRange(location: currentInputText.count, length: 0)
                        textDocumentProxy.setMarkedText(currentInputText, selectedRange: range)
                        if currentInputText.isEmpty {
                                textDocumentProxy.unmarkText()
                                candidates = []
                        } else {
                                imeQueue.async {
                                        self.suggestCandidates()
                                }
                        }
                }
        }
        
        lazy var candidateSequence: [Candidate] = []
        
        var candidates: [Candidate] = [] {
                didSet {
                        DispatchQueue.main.async {
                                self.candidateCollectionView.reloadData()
                                self.candidateCollectionView.setContentOffset(.zero, animated: true)
                        }
                }
        }
        
        private(set) var lexiconManager: LexiconManager? = LexiconManager()
        private var engine: Engine? = Engine()
        private func suggestCandidates() {
                let userdbCandidates: [Candidate] = lexiconManager?.suggest(for: currentInputText) ?? []
                let engineCandidates: [Candidate] = engine?.suggest(for: currentInputText) ?? []
                let combined: [Candidate] = userdbCandidates + engineCandidates
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
        
        private func setupToolBarActions() {
                toolBar.settingsButton.addTarget(self, action: #selector(handleSettingsButtonEvent), for: .touchUpInside)
                toolBar.yueEngSwitch.addTarget(self, action: #selector(handleYueEngSwitch), for: .valueChanged)
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
                switch toolBar.yueEngSwitch.selectedSegmentIndex {
                case 0:
                        switch keyboardLayout {
                        case .alphabetic(.lowercased):
                                keyboardLayout = .jyutping(.lowercased)
                        case .alphabetic(.uppercased):
                                keyboardLayout = .jyutping(.uppercased)
                        case .alphabetic(.capsLocked):
                                keyboardLayout = .jyutping(.capsLocked)
                        case .numeric:
                                keyboardLayout = .cantoneseNumeric
                        case .symbolic:
                                keyboardLayout = .cantoneseSymbolic
                        default:
                                break
                        }
                case 1:
                        switch keyboardLayout {
                        case .jyutping(.lowercased):
                                keyboardLayout = .alphabetic(.lowercased)
                        case .jyutping(.uppercased):
                                keyboardLayout = .alphabetic(.uppercased)
                        case .jyutping(.capsLocked):
                                keyboardLayout = .alphabetic(.capsLocked)
                        case .cantoneseNumeric:
                                keyboardLayout = .numeric
                        case .cantoneseSymbolic:
                                keyboardLayout = .symbolic
                        default:
                                break
                        }
                default:
                        break
                }
        }
        @objc private func handlePaste() {
                guard UIPasteboard.general.hasStrings else { return }
                guard let copied: String = UIPasteboard.general.string else { return }
                hapticFeedback?.impactOccurred()
                AudioFeedback.perform(.input)
                textDocumentProxy.insertText(copied)
        }
        @objc private func handleEmojiSwitch() {
                hapticFeedback?.impactOccurred()
                AudioFeedback.perform(.modify)
                keyboardLayout = .emoji
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
        private var converter: Converter? = {
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
}
