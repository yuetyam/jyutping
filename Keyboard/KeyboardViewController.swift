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
                settingsTableView.register(NormalTableViewCell.self, forCellReuseIdentifier: "NormalTableViewCell")
        }
        
        override func viewDidAppear(_ animated: Bool) {
                super.viewDidAppear(animated)
                setupKeyboard()
        }
        
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
                super.traitCollectionDidChange(previousTraitCollection)
                isDarkAppearance = textDocumentProxy.keyboardAppearance == .dark || traitCollection.userInterfaceStyle == .dark
                appearance = detectAppearance()
                setupKeyboard()
        }
        
        override func textDidChange(_ textInput: UITextInput?) {
                super.textDidChange(textInput)
                if answeredKeyboardLayout != askedKeyboardLayout {
                        answeredKeyboardLayout = askedKeyboardLayout
                        keyboardLayout = answeredKeyboardLayout
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
                        if keyboardLayout != .jyutping &&
                                keyboardLayout != .jyutpingUppercase &&
                                keyboardLayout != .candidateBoard {
                                currentInputText = ""
                        }
                        setupKeyboard()
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
                let converted: [Candidate] = combined.map {
                        Candidate(text: converter.convert($0.text), footnote: $0.footnote, input: $0.input)
                }
                candidates = converted.deduplicated()
        }
        
        private func setupToolBarActions() {
                toolBar.settingsButton.addTarget(self, action: #selector(handleSettingsButtonEvent), for: .allTouchEvents)
                toolBar.yueEngSwitch.addTarget(self, action: #selector(handleYueEngSwitch), for: .valueChanged)
                toolBar.downArrowButton.addTarget(self, action: #selector(handleDownArrowEvent), for: .allTouchEvents)
                toolBar.keyboardDownButton.addTarget(self, action: #selector(dismissInputMethod), for: .allTouchEvents)
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
        
        private var converter: ChineseConverter = {
                let options: ChineseConverter.Options = {
                        let logogram: Int = UserDefaults.standard.integer(forKey: "logogram")
                        // 0: The key "logogram" doesn‘t exist.
                        // 1: 傳統漢字
                        // 2: 傳統漢字香港字形
                        // 3: 傳統漢字臺灣字形
                        // 4: 大陸簡化字
                        switch logogram {
                        case 2:
                                return [.traditionalize, .hkStandard]
                        case 3:
                                return [.traditionalize, .twStandard]
                        case 4:
                                return [.simplify]
                        default:
                                return [.traditionalize]
                        }
                }()
                let openccBundle: Bundle = Bundle(url: Bundle.main.bundleURL.appendingPathComponent("OpenCC.bundle"))!
                let converter: ChineseConverter = try! ChineseConverter(bundle: openccBundle, options: options)
                return converter
        }()
        func updateConverter() {
                let options: ChineseConverter.Options = {
                        let logogram: Int = UserDefaults.standard.integer(forKey: "logogram")
                        switch logogram {
                        case 2:
                                return [.traditionalize, .hkStandard]
                        case 3:
                                return [.traditionalize, .twStandard]
                        case 4:
                                return [.simplify]
                        default:
                                return [.traditionalize]
                        }
                }()
                let openccBundle: Bundle = Bundle(url: Bundle.main.bundleURL.appendingPathComponent("OpenCC.bundle"))!
                let converter: ChineseConverter = try! ChineseConverter(bundle: openccBundle, options: options)
                self.converter = converter
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
