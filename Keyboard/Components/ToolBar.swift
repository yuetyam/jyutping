import UIKit

final class ToolBar: UIView {
        
        let viewController: KeyboardViewController
        
        init(viewController: KeyboardViewController) {
                self.viewController = viewController
                super.init(frame: .zero)
                heightAnchor.constraint(equalToConstant: 65).isActive = true
                
                inputLabel.adjustsFontForContentSizeCategory = true
                inputLabel.font = .preferredFont(forTextStyle: .callout)
                inputLabel.textAlignment = .left
                
                setupToolButtons()
        }
        
        required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }
        
        private var showingToolButtons: Bool = true
        func update() {
                inputLabel.text = viewController.currentInputText
                if viewController.currentInputText.isEmpty {
                        if !showingToolButtons {
                                setupToolButtons()
                                showingToolButtons = true
                        } else {
                                refreshPasteButtonState()
                        }
                } else {
                        if showingToolButtons {
                                setupInputMode()
                                showingToolButtons = false
                        }
                }
        }
        func reinit() {
                inputLabel.text = viewController.currentInputText
                if viewController.currentInputText.isEmpty {
                        setupToolButtons()
                        showingToolButtons = true
                } else {
                        setupInputMode()
                        showingToolButtons = false
                }
        }
        private func refreshPasteButtonState() {
                if UIPasteboard.general.hasStrings {
                        pasteButton.isEnabled = true
                        pasteButton.isUserInteractionEnabled = true
                        pasteButton.alpha = 1.0
                } else {
                        pasteButton.isEnabled = false
                        pasteButton.isUserInteractionEnabled = false
                        pasteButton.alpha = 0.2
                }
        }
        
        let settingsButton: ToolButton = ToolButton(imageName: "gear", leftInset: 15)
        let yueEngSwitch: UISegmentedControl = UISegmentedControl(items: ["粵", "EN"])
        let pasteButton: ToolButton = ToolButton(imageName: "doc.on.clipboard", topInset: 18, bottomInset: 18)
        let keyboardDownButton: ToolButton = ToolButton(imageName: "keyboard.chevron.compact.down", rightInset: 15)
        
        let inputLabel: UILabel = UILabel()
        let downArrowButton: ToolButton = ToolButton(imageName: "chevron.down", rightInset: 12)
        
        private func setupToolButtons() {
                if viewController.traitCollection.userInterfaceIdiom == .phone {
                        setupToolButtonsOnPhone()
                } else {
                        setupToolButtonsOnPad()
                }
                refreshPasteButtonState()
        }
        
        private func setupToolButtonsOnPhone() {
                inputLabel.removeFromSuperview()
                viewController.collectionView.removeFromSuperview()
                downArrowButton.removeFromSuperview()
                NSLayoutConstraint.deactivate(inputLabelConstaints)
                NSLayoutConstraint.deactivate(collectionViewConstraints)
                NSLayoutConstraint.deactivate(downArrowButtonConstaints)
                
                addSubview(settingsButton)
                settingsButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate(settingsButtonConstraints)
                
                addSubview(yueEngSwitch)
                yueEngSwitch.translatesAutoresizingMaskIntoConstraints = false
                addSubview(pasteButton)
                pasteButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate(yueEngSwitchAndPasteButtonConstraintsOnPhone)
                
                addSubview(keyboardDownButton)
                keyboardDownButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate(keyboardDownButtonConstaints)
                
                pasteButton.addTarget(self, action: #selector(pasteText), for: .touchUpInside)
        }
        @objc private func pasteText() {
                guard let textToPaste: String = UIPasteboard.general.string else { return }
                viewController.textDocumentProxy.insertText(textToPaste)
        }
        
        private func setupToolButtonsOnPad() {
                inputLabel.removeFromSuperview()
                viewController.collectionView.removeFromSuperview()
                downArrowButton.removeFromSuperview()
                NSLayoutConstraint.deactivate(inputLabelConstaints)
                NSLayoutConstraint.deactivate(collectionViewConstraints)
                NSLayoutConstraint.deactivate(downArrowButtonConstaints)
                
                addSubview(settingsButton)
                settingsButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate(settingsButtonConstraints)
                
                addSubview(yueEngSwitch)
                yueEngSwitch.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate(yueEngSwitchConstraintsOnPad)
                
                addSubview(keyboardDownButton)
                keyboardDownButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate(keyboardDownButtonConstaints)
        }
        
        private func setupInputMode() {
                settingsButton.removeFromSuperview()
                yueEngSwitch.removeFromSuperview()
                pasteButton.removeFromSuperview()
                keyboardDownButton.removeFromSuperview()
                NSLayoutConstraint.deactivate(settingsButtonConstraints)
                NSLayoutConstraint.deactivate(yueEngSwitchAndPasteButtonConstraintsOnPhone)
                NSLayoutConstraint.deactivate(yueEngSwitchConstraintsOnPad)
                NSLayoutConstraint.deactivate(keyboardDownButtonConstaints)
                
                addSubview(inputLabel)
                inputLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate(inputLabelConstaints)
                
                addSubview(viewController.collectionView)
                viewController.collectionView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate(collectionViewConstraints)
                (viewController.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
                
                addSubview(downArrowButton)
                downArrowButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate(downArrowButtonConstaints)
                let splitLine: CALayer = CALayer()
                splitLine.backgroundColor = self.tintColor.withAlphaComponent(0.3).cgColor
                splitLine.frame = CGRect(x: downArrowButton.bounds.origin.x, y: downArrowButton.bounds.origin.y + 20, width: 1, height: 25)
                downArrowButton.layer.addSublayer(splitLine)
        }
        
        // FIXME: - iPad Floating Keyboard
        private var isPhoneInterface: Bool {
                switch viewController.traitCollection.userInterfaceIdiom {
                case .pad:
                        return viewController.traitCollection.horizontalSizeClass == .compact
                default:
                        return true
                }
        }
        
        private var settingsButtonConstraints: [NSLayoutConstraint] {
                let width: CGFloat = isPhoneInterface ? 55 : 60
                return [settingsButton.topAnchor.constraint(equalTo: topAnchor),
                        settingsButton.bottomAnchor.constraint(equalTo: bottomAnchor),
                        settingsButton.leadingAnchor.constraint(equalTo: leadingAnchor),
                        settingsButton.widthAnchor.constraint(equalToConstant: width)]
        }
        private var yueEngSwitchConstraintsOnPad: [NSLayoutConstraint] {
                let topBottomInset: CGFloat = isPhoneInterface ? 16 : 13
                let leading: CGFloat = 55 + 32
                let width: CGFloat = isPhoneInterface ? 105 : 120
                return [yueEngSwitch.topAnchor.constraint(equalTo: topAnchor, constant: topBottomInset),
                        yueEngSwitch.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -topBottomInset),
                        yueEngSwitch.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leading),
                        yueEngSwitch.widthAnchor.constraint(equalToConstant: width)]
        }
        private var yueEngSwitchAndPasteButtonConstraintsOnPhone: [NSLayoutConstraint] {
                let keyboardWidth: CGFloat = UIScreen.main.bounds.width - self.safeAreaInsets.left - self.safeAreaInsets.right
                let settingsWidth: CGFloat = 55
                let keyboardDownWidth: CGFloat = 58
                let midleSpace: CGFloat = keyboardWidth - settingsWidth - keyboardDownWidth
                let switchWidth: CGFloat = 105
                let pasteButtonWidth: CGFloat = 55
                let space: CGFloat = (midleSpace - switchWidth - pasteButtonWidth) / 3
                
                let switchPortaitLeading: CGFloat = settingsWidth + space
                let switchLandscapeLeading: CGFloat = settingsWidth + 32
                let switchLeading: CGFloat = traitCollection.horizontalSizeClass == .compact ? switchPortaitLeading : switchLandscapeLeading
                let pastePortaitLeading: CGFloat = settingsWidth + space + switchWidth + space
                let pasteLandscapeLeading: CGFloat = settingsWidth + 32 + switchWidth + 32
                let pasteLeading: CGFloat = traitCollection.horizontalSizeClass == .compact ? pastePortaitLeading : pasteLandscapeLeading
                return [yueEngSwitch.topAnchor.constraint(equalTo: topAnchor, constant: 16),
                        yueEngSwitch.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
                        yueEngSwitch.leadingAnchor.constraint(equalTo: leadingAnchor, constant: switchLeading),
                        yueEngSwitch.widthAnchor.constraint(equalToConstant: 105),
                        pasteButton.topAnchor.constraint(equalTo: topAnchor),
                        pasteButton.bottomAnchor.constraint(equalTo: bottomAnchor),
                        pasteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: pasteLeading),
                        pasteButton.widthAnchor.constraint(equalToConstant: 55)]
        }
        private var keyboardDownButtonConstaints: [NSLayoutConstraint] {
                let width: CGFloat = isPhoneInterface ? 58 : 64
                return [keyboardDownButton.topAnchor.constraint(equalTo: topAnchor),
                        keyboardDownButton.bottomAnchor.constraint(equalTo: bottomAnchor),
                        keyboardDownButton.trailingAnchor.constraint(equalTo: trailingAnchor),
                        keyboardDownButton.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -width)]
        }
        private var inputLabelConstaints: [NSLayoutConstraint] {
                [inputLabel.topAnchor.constraint(equalTo: topAnchor),
                 inputLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
                 inputLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
                 inputLabel.bottomAnchor.constraint(equalTo: topAnchor, constant: 18)]
        }
        private var downArrowButtonConstaints: [NSLayoutConstraint] {
                [downArrowButton.topAnchor.constraint(equalTo: topAnchor),
                 downArrowButton.bottomAnchor.constraint(equalTo: bottomAnchor),
                 downArrowButton.trailingAnchor.constraint(equalTo: trailingAnchor),
                 downArrowButton.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -45)]
        }
        var collectionViewConstraints: [NSLayoutConstraint] {
                [viewController.collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
                 viewController.collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
                 viewController.collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
                 viewController.collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -45)]
        }
}
