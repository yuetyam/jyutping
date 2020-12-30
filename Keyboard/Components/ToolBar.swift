import UIKit

final class ToolBar: UIView {
        
        let viewController: KeyboardViewController
        
        init(viewController: KeyboardViewController) {
                self.viewController = viewController
                super.init(frame: .zero)
                heightAnchor.constraint(equalToConstant: 60).isActive = true
                loadToolButtons()
        }
        
        required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }
        
        private var showingToolButtons: Bool = true
        func update() {
                if viewController.currentInputText.isEmpty {
                        if !showingToolButtons {
                                loadToolButtons()
                                showingToolButtons = true
                        }
                } else {
                        if showingToolButtons {
                                setupInputMode()
                                showingToolButtons = false
                        }
                }
        }
        func reinit() {
                if viewController.currentInputText.isEmpty {
                        loadToolButtons()
                        showingToolButtons = true
                } else {
                        setupInputMode()
                        showingToolButtons = false
                }
        }
        
        let settingsButton: ToolButton = ToolButton(imageName: "gear", leftInset: 14, rightInset: 14)
        let yueEngSwitch: UISegmentedControl = UISegmentedControl(items: ["粵", "EN"])
        let pasteButton: ToolButton = ToolButton(imageName: "doc.on.clipboard", topInset: 18, bottomInset: 17)
        let keyboardDownButton: ToolButton = ToolButton(imageName: "keyboard.chevron.compact.down", bottomInset: 4, leftInset: 16, rightInset: 14)
        let downArrowButton: ToolButton = ToolButton(imageName: "chevron.down", rightInset: 12)
        
        private func loadToolButtons() {
                viewController.collectionView.removeFromSuperview()
                downArrowButton.removeFromSuperview()
                NSLayoutConstraint.deactivate(collectionViewConstraints)
                NSLayoutConstraint.deactivate(downArrowButtonConstaints)
                
                addSubview(settingsButton)
                settingsButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate(settingsButtonConstraints)
                
                addSubview(yueEngSwitch)
                yueEngSwitch.translatesAutoresizingMaskIntoConstraints = false
                
                if traitCollection.userInterfaceIdiom == .phone && viewController.hasFullAccess {
                        addSubview(pasteButton)
                        pasteButton.translatesAutoresizingMaskIntoConstraints = false
                        NSLayoutConstraint.activate(yueEngSwitchPasteButtonConstraints)
                } else {
                        NSLayoutConstraint.activate(yueEngSwitchConstraints)
                }
                
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
                NSLayoutConstraint.deactivate(yueEngSwitchConstraints)
                NSLayoutConstraint.deactivate(yueEngSwitchPasteButtonConstraints)
                NSLayoutConstraint.deactivate(keyboardDownButtonConstaints)
                
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
        private var yueEngSwitchConstraints: [NSLayoutConstraint] {
                let topBottomInset: CGFloat = isPhoneInterface ? 14 : 11
                let width: CGFloat = isPhoneInterface ? 110 : 120
                return [yueEngSwitch.topAnchor.constraint(equalTo: topAnchor, constant: topBottomInset),
                        yueEngSwitch.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -topBottomInset),
                        yueEngSwitch.leadingAnchor.constraint(equalTo: settingsButton.trailingAnchor, constant: 20),
                        yueEngSwitch.widthAnchor.constraint(equalToConstant: width)]
        }
        private var yueEngSwitchPasteButtonConstraints: [NSLayoutConstraint] {
                let space: CGFloat = {
                        guard traitCollection.verticalSizeClass == .regular else { return 20 }
                        let toolBarWidth: CGFloat = UIScreen.main.bounds.size.width
                        let settingsWidth: CGFloat = isPhoneInterface ? 55 : 60
                        let yueEngSwitchWidth: CGFloat = isPhoneInterface ? 110 : 120
                        let pasteWidth: CGFloat = 60
                        let keyboardDownWidth: CGFloat = isPhoneInterface ? 58 : 64
                        let totalSpace: CGFloat = toolBarWidth - settingsWidth - yueEngSwitchWidth - pasteWidth - keyboardDownWidth
                        return totalSpace / 3
                }()
                let topBottomInset: CGFloat = isPhoneInterface ? 14 : 11
                let width: CGFloat = isPhoneInterface ? 110 : 120
                return [yueEngSwitch.topAnchor.constraint(equalTo: topAnchor, constant: topBottomInset),
                        yueEngSwitch.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -topBottomInset),
                        yueEngSwitch.leadingAnchor.constraint(equalTo: settingsButton.trailingAnchor, constant: space),
                        yueEngSwitch.widthAnchor.constraint(equalToConstant: width),
                        pasteButton.topAnchor.constraint(equalTo: topAnchor),
                        pasteButton.bottomAnchor.constraint(equalTo: bottomAnchor),
                        pasteButton.leadingAnchor.constraint(equalTo: yueEngSwitch.trailingAnchor, constant: space),
                        pasteButton.widthAnchor.constraint(equalToConstant: 60)]
                
        }
        private var keyboardDownButtonConstaints: [NSLayoutConstraint] {
                let width: CGFloat = isPhoneInterface ? 58 : 64
                return [keyboardDownButton.topAnchor.constraint(equalTo: topAnchor),
                        keyboardDownButton.bottomAnchor.constraint(equalTo: bottomAnchor),
                        keyboardDownButton.trailingAnchor.constraint(equalTo: trailingAnchor),
                        keyboardDownButton.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -width)]
        }
        private var downArrowButtonConstaints: [NSLayoutConstraint] {
                [downArrowButton.topAnchor.constraint(equalTo: topAnchor),
                 downArrowButton.bottomAnchor.constraint(equalTo: bottomAnchor),
                 downArrowButton.trailingAnchor.constraint(equalTo: trailingAnchor),
                 downArrowButton.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -45)]
        }
        var collectionViewConstraints: [NSLayoutConstraint] {
                [viewController.collectionView.topAnchor.constraint(equalTo: topAnchor),
                 viewController.collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
                 viewController.collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
                 viewController.collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -45)]
        }
}
