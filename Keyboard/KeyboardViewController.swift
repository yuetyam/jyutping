import UIKit
import OpenCC

final class KeyboardViewController: UIInputViewController {
        
        lazy var toolBar: ToolBar = ToolBar(viewController: self)
        lazy var settingsView: UIView = UIView()
        lazy var candidateBoard: CandidateBoard = CandidateBoard()
        lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        lazy var settingsTableView: UITableView = UITableView(frame: .zero, style: .grouped)
        
        lazy var keyboardStackView: UIStackView = {
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
                keyboardStackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
                keyboardStackView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
                keyboardStackView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
                keyboardStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
                
                setupToolBarActions()
                
                collectionView.dataSource = self
                collectionView.delegate = self
                collectionView.register(CandidateCollectionViewCell.self, forCellWithReuseIdentifier: "CandidateCell")
                collectionView.backgroundColor = self.view.backgroundColor
                
                settingsTableView.dataSource = self
                settingsTableView.delegate = self
                settingsTableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: "SwitchTableViewCell")                
                settingsTableView.register(NormalTableViewCell.self, forCellReuseIdentifier: "CharactersTableViewCell")
                settingsTableView.register(NormalTableViewCell.self, forCellReuseIdentifier: "JyutpingTableViewCell")
                settingsTableView.register(NormalTableViewCell.self, forCellReuseIdentifier: "ToneStyleTableViewCell")
                settingsTableView.register(NormalTableViewCell.self, forCellReuseIdentifier: "ClearLexiconTableViewCell")
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
                if lightImpactFeedback == nil && isHapticFeedbackOn {
                        lightImpactFeedback = UIImpactFeedbackGenerator(style: .light)
                }
                if selectionFeedback == nil && isHapticFeedbackOn {
                        selectionFeedback = UISelectionFeedbackGenerator()
                }
        }
        
        var lightImpactFeedback: UIImpactFeedbackGenerator?
        var selectionFeedback: UISelectionFeedbackGenerator?
        
        override func viewWillDisappear(_ animated: Bool) {
                super.viewWillDisappear(animated)
                lightImpactFeedback = nil
                selectionFeedback = nil
        }
        
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
                super.traitCollectionDidChange(previousTraitCollection)
                isDarkAppearance = textDocumentProxy.keyboardAppearance == .dark || traitCollection.userInterfaceStyle == .dark
                appearance = detectAppearance()
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
        
        private lazy var answeredKeyboardLayout: KeyboardLayout = .jyutping
        
        var askedKeyboardLayout: KeyboardLayout {
                switch textDocumentProxy.keyboardType {
                case .numberPad, .asciiCapableNumberPad:
                        return traitCollection.userInterfaceIdiom == .pad ? .numeric : .numberPad
                case .decimalPad:
                        return traitCollection.userInterfaceIdiom == .pad ? .numeric : .decimalPad
                case .asciiCapable, .emailAddress, .twitter, .URL:
                        return .alphabetic
                case .numbersAndPunctuation:
                        return .numeric
                default:
                        return .jyutping
                }
        }
        
        lazy var isCapsLocked: Bool = false
        
        var keyboardLayout: KeyboardLayout = .jyutping {
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
                        if currentInputText.isEmpty {
                                candidates = []
                        } else {
                                imeQueue.async {
                                        self.suggestCandidates()
                                }
                        }
                        let range: NSRange = NSRange(location: currentInputText.count, length: 0)
                        textDocumentProxy.setMarkedText(currentInputText, selectedRange: range)
                }
        }
        
        lazy var candidateSequence: [Candidate] = []
        
        var candidates: [Candidate] = [] {
                didSet {
                        DispatchQueue.main.async {
                                self.collectionView.reloadData()
                                self.collectionView.setContentOffset(.zero, animated: true)
                        }
                }
        }
        
        let lexiconManager: LexiconManager = LexiconManager()
        private let engine: Engine = Engine()
        private func suggestCandidates() {
                let userdbCandidates: [Candidate] = lexiconManager.suggest(for: currentInputText)
                let engineCandidates: [Candidate] = engine.suggest(for: currentInputText)
                let combined: [Candidate] = userdbCandidates + engineCandidates
                if logogram < 2 {
                        candidates = combined.deduplicated()
                } else if converter == nil {
                        candidates = combined.deduplicated()
                        updateConverter()
                } else {
                        let converted: [Candidate] = combined.map { Candidate(text: converter!.convert($0.text), footnote: $0.footnote, input: $0.input, lexiconText: $0.lexiconText) }
                        candidates = converted.deduplicated()
                }
        }
        
        private func setupToolBarActions() {
                toolBar.settingsButton.addTarget(self, action: #selector(handleSettingsButtonEvent), for: .touchUpInside)
                toolBar.yueEngSwitch.addTarget(self, action: #selector(handleYueEngSwitch), for: .valueChanged)
                toolBar.pasteButton.addTarget(self, action: #selector(handlePaste), for: .touchUpInside)
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
                selectionFeedback?.selectionChanged()
                isCapsLocked = false
                switch toolBar.yueEngSwitch.selectedSegmentIndex {
                case 0:
                        keyboardLayout = .jyutping
                case 1:
                        keyboardLayout = .alphabetic
                default:
                        break
                }
        }
        @objc private func handlePaste() {
                guard UIPasteboard.general.hasStrings else { return }
                guard let copied: String = UIPasteboard.general.string else { return }
                lightImpactFeedback?.impactOccurred()
                AudioFeedback.perform(audioFeedback: .modify)
                textDocumentProxy.insertText(copied)
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
        private var converter: ChineseConverter? = {
                let options: ChineseConverter.Options = {
                        let logogram: Int = UserDefaults.standard.integer(forKey: "logogram")
                        switch logogram {
                        case 2:
                                return [.hkStandard]
                        case 3:
                                return [.twStandard]
                        case 4:
                                return [.simplify]
                        default:
                                return [.traditionalize]
                        }
                }()
                guard let openccBundle: Bundle = Bundle(url: Bundle.main.bundleURL.appendingPathComponent("OpenCC.bundle")) else { return nil }
                let converter: ChineseConverter? = try? ChineseConverter(bundle: openccBundle, options: options)
                return converter
        }()
        func updateConverter() {
                logogram = UserDefaults.standard.integer(forKey: "logogram")
                let options: ChineseConverter.Options = {
                        switch logogram {
                        case 2:
                                return [.hkStandard]
                        case 3:
                                return [.twStandard]
                        case 4:
                                return [.simplify]
                        default:
                                return [.traditionalize]
                        }
                }()
                guard let openccBundle: Bundle = Bundle(url: Bundle.main.bundleURL.appendingPathComponent("OpenCC.bundle")) else { return }
                let converter: ChineseConverter? = try? ChineseConverter(bundle: openccBundle, options: options)
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
        ///
        private(set) lazy var jyutpingDisplay: Int = UserDefaults.standard.integer(forKey: "jyutping_display")
        func updateJyutpingDisplay() {
                jyutpingDisplay = UserDefaults.standard.integer(forKey: "jyutping_display")
        }
        
        /// 粵拼聲調樣式
        ///
        /// 0: The key "tone_style" doesn‘t exist.
        ///
        /// 1: 普通
        ///
        /// 2: 無聲調
        ///
        /// 3: 上標
        ///
        /// 4: 下標
        ///
        /// 4: 陰上陽下
        private(set) lazy var toneStyle: Int = UserDefaults.standard.integer(forKey: "tone_style")
        func updateToneStyle() {
                toneStyle = UserDefaults.standard.integer(forKey: "tone_style")
        }
        
        private(set) lazy var isDarkAppearance: Bool = textDocumentProxy.keyboardAppearance == .dark || traitCollection.userInterfaceStyle == .dark
        
        private(set) lazy var appearance: Appearance = detectAppearance()
        
        private func detectAppearance() -> Appearance {
                switch traitCollection.userInterfaceStyle {
                case .light:
                        switch textDocumentProxy.keyboardAppearance {
                        case .light, .default:
                                return .lightModeLightAppearance
                        case .dark:
                                return .lightModeDarkAppearance
                        default:
                                return .lightModeDarkAppearance
                        }
                case .dark:
                        switch textDocumentProxy.keyboardAppearance {
                        case .light, .default:
                                return .darkModeLightAppearance
                        case .dark:
                                return .darkModeDarkAppearance
                        default:
                                return .darkModeLightAppearance
                        }
                case .unspecified:
                        switch textDocumentProxy.keyboardAppearance {
                        case .light, .default:
                                return .lightModeLightAppearance
                        case .dark:
                                return .darkModeDarkAppearance
                        default:
                                return .lightModeDarkAppearance
                        }
                @unknown default:
                        return .lightModeDarkAppearance
                }
        }
}

enum Appearance {
        case lightModeLightAppearance
        case lightModeDarkAppearance
        case darkModeLightAppearance
        case darkModeDarkAppearance
}
