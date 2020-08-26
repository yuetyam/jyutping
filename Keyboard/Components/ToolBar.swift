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
        
        let settingsButton: ToolButton = ToolButton(imageName: "gear", leftInset: 15)
        let yueEngSwitch: UISegmentedControl = UISegmentedControl(items: ["粵", "EN"])
        let keyboardDownButton: ToolButton = ToolButton(imageName: "keyboard.chevron.compact.down", rightInset: 15)
        
        let inputLabel: UILabel = UILabel()
        let downArrowButton: ToolButton = ToolButton(imageName: "chevron.down", rightInset: 12)
                
        private func setupToolButtons() {
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
                NSLayoutConstraint.activate(yueEngSwitchConstraints)
                if viewController.keyboardLayout == .jyutping {
                        yueEngSwitch.selectedSegmentIndex = 0
                }
                
                addSubview(keyboardDownButton)
                keyboardDownButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate(keyboardDownButtonConstaints)
        }
        
        private func setupInputMode() {
                settingsButton.removeFromSuperview()
                yueEngSwitch.removeFromSuperview()
                keyboardDownButton.removeFromSuperview()
                NSLayoutConstraint.deactivate(settingsButtonConstraints)
                NSLayoutConstraint.deactivate(yueEngSwitchConstraints)
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
        private var isPhoneInterface: Bool { traitCollection.userInterfaceIdiom == .phone }
        
        private var settingsButtonConstraints: [NSLayoutConstraint] {
                [settingsButton.topAnchor.constraint(equalTo: topAnchor),
                 settingsButton.bottomAnchor.constraint(equalTo: bottomAnchor),
                 settingsButton.leadingAnchor.constraint(equalTo: leadingAnchor),
                 settingsButton.widthAnchor.constraint(equalToConstant: isPhoneInterface ? 55 : 60)]
        }
        private var yueEngSwitchConstraints: [NSLayoutConstraint] {
                let topBottomInset: CGFloat = isPhoneInterface ? 16 : 13
                return [yueEngSwitch.topAnchor.constraint(equalTo: topAnchor, constant: topBottomInset),
                        yueEngSwitch.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -topBottomInset),
                        yueEngSwitch.leadingAnchor.constraint(equalTo: settingsButton.trailingAnchor, constant: 16),
                        yueEngSwitch.widthAnchor.constraint(equalToConstant: isPhoneInterface ? 105 : 115)]
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
        private var keyboardDownButtonConstaints: [NSLayoutConstraint] {
                let width: CGFloat = isPhoneInterface ? 58 : 64
                return [keyboardDownButton.topAnchor.constraint(equalTo: topAnchor),
                        keyboardDownButton.bottomAnchor.constraint(equalTo: bottomAnchor),
                        keyboardDownButton.trailingAnchor.constraint(equalTo: trailingAnchor),
                        keyboardDownButton.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -width)]
        }
        
        var collectionViewConstraints: [NSLayoutConstraint] {
                [viewController.collectionView.topAnchor.constraint(equalTo: topAnchor,constant: 10),
                 viewController.collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
                 viewController.collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
                 viewController.collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -45)]
        }
}
