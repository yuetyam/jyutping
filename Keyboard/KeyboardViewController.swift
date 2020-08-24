import UIKit

final class KeyboardViewController: UIInputViewController {
        
        lazy var toolBar: ToolBar = ToolBar(viewController: self)
        lazy var settingsView: SettingsView = SettingsView()
        lazy var candidateBoard: CandidateBoard = CandidateBoard()
        lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        lazy var keyboardStackView: UIStackView = {
                let stackView = UIStackView(frame: .zero)
                stackView.axis = .vertical
                stackView.alignment = .fill
                stackView.distribution = .equalSpacing
                return stackView
        }()
        
        override func viewDidLoad() {
                super.viewDidLoad()
                
                collectionView.dataSource = self
                collectionView.delegate = self
                collectionView.register(CandidateCollectionViewCell.self, forCellWithReuseIdentifier: "CandidateCell")
                collectionView.backgroundColor = self.view.backgroundColor
                
                view.addSubview(keyboardStackView)
                keyboardStackView.translatesAutoresizingMaskIntoConstraints = false
                keyboardStackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
                keyboardStackView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
                keyboardStackView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
                keyboardStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
                
                setupToolBarActions()
        }
        
        override func viewDidAppear(_ animated: Bool) {
                super.viewDidAppear(animated)
                setupKeyboard()
        }
        
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
                super.traitCollectionDidChange(previousTraitCollection)
                setupKeyboard()
        }
        
        var isDarkAppearance: Bool {
                textDocumentProxy.keyboardAppearance == .dark ||
                traitCollection.userInterfaceStyle == .dark
        }
        
        var appearance: Appearance {
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
        
        lazy var isCapsLocked: Bool = false
        
        var keyboardLayout: KeyboardLayout = .jyutping {
                didSet {
                        setupKeyboard()
                        if keyboardLayout != .jyutping && keyboardLayout != .wordsBoard {
                                currentInputText = ""
                        }
                }
        }
        
        private(set) lazy var candidateQueue: DispatchQueue = DispatchQueue(label: "im.cantonese.cantoneseim.candidate", qos: .userInitiated)
        var currentInputText: String = "" {
                didSet {
                        DispatchQueue.main.async {
                                self.toolBar.update()
                                self.toolBar.inputLabel.text = self.currentInputText
                        }
                        if currentInputText.isEmpty {
                                candidates = []
                        } else {
                                candidateQueue.async {
                                        self.requestSuggestion()
                                }
                        }
                }
        }
        
        lazy var combinedPhrase: [Candidate] = []
        
        var candidates: [Candidate] = [] {
                didSet {
                        DispatchQueue.main.async {
                                self.collectionView.reloadData()
                                if self.collectionView.contentOffset.x > 1 {
                                        self.collectionView.setContentOffset(.zero, animated: false)
                                }
                        }
                }
        }
        
        let userPhraseManager: UserPhraseManager = UserPhraseManager()
        private lazy var engine: Engine = Engine()
        private func requestSuggestion() {
                let userdbCandidates: [Candidate] = userPhraseManager.suggest(for: currentInputText)
                let engineCandidates: [Candidate] = engine.suggest(for: currentInputText)
                candidates = (userdbCandidates + engineCandidates).deduplicated()
        }
        
        private func setupToolBarActions() {
                toolBar.settingsButton.addTarget(self, action: #selector(handleSettingsButtonEvent), for: .allTouchEvents)
                toolBar.yueEngSwitch.addTarget(self, action: #selector(handleYueEngSwitch), for: .valueChanged)
                toolBar.downArrowButton.addTarget(self, action: #selector(handleDownArrowEvent), for: .allTouchEvents)
                toolBar.keyboardDownButton.addTarget(self, action: #selector(handleDismissKeyboard), for: .allTouchEvents)
        }
        @objc private func handleDownArrowEvent() {
                candidateBoard.height = view.bounds.height
                keyboardLayout = .wordsBoard
        }
        @objc private func handleDismissKeyboard() {
                dismissKeyboard()
        }
        @objc private func handleSettingsButtonEvent() {
                settingsView.height = view.bounds.height
                keyboardLayout = .settingsView
        }
        @objc private func handleYueEngSwitch() {
                switch toolBar.yueEngSwitch.selectedSegmentIndex {
                case 0:
                        keyboardLayout = .jyutping
                case 1:
                        isCapsLocked = false
                        keyboardLayout = .alphabetLowercase
                default:
                        break
                }
        }
}

enum Appearance {
        case lightModeLightAppearance
        case lightModeDarkAppearance
        case darkModeLightAppearance
        case darkModeDarkAppearance
}
