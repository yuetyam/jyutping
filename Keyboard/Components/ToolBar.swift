import UIKit

final class ToolBar: UIView {
        
        let viewController: KeyboardViewController
        
        init(viewController: KeyboardViewController) {
                self.viewController = viewController
                super.init(frame: .zero)
                heightAnchor.constraint(equalToConstant: 65).isActive = true
                setupSettingButton()
                setupKeyboardDownButton()
        }
        
        required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }
        
        func update() {
                if !viewController.currentInputText.isEmpty  {
                        if !subviews.contains(viewController.collectionView) {
                                setupCandidatesCollectionView()
                        }
                        if !isDownArrowSetup {
                                setupDownArrow()
                                isDownArrowSetup = true
                        }
                } else {
                        if !isKeyboardDownSetup {
                                setupSettingButton()
                                setupKeyboardDownButton()
                                isDownArrowSetup = false
                        }
                }
        }
        
        let inputLabel: UILabel = UILabel()
        
        let settingsButton: ToolButton = ToolButton(imageName: "gear", leftInset: 15)
        let yueEngSwitch: UISegmentedControl = UISegmentedControl(items: ["粵", "EN"])
        
        let keyboardDownButton: ToolButton = ToolButton(imageName: "keyboard.chevron.compact.down", rightInset: 15)
        let downArrowButton: ToolButton = ToolButton(imageName: "chevron.down", rightInset: 12)
        private var isDownArrowSetup: Bool = false
        private var isKeyboardDownSetup: Bool { !isDownArrowSetup }
        
        func setupSettingButton() {
                inputLabel.removeFromSuperview()
                viewController.collectionView.removeFromSuperview()
                
                // FIXME: - iPad Floating Keyboard
                let isPhoneInterface: Bool = traitCollection.userInterfaceIdiom == .phone
                
                addSubview(settingsButton)
                settingsButton.translatesAutoresizingMaskIntoConstraints = false
                settingsButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
                settingsButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
                settingsButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
                settingsButton.widthAnchor.constraint(equalToConstant: isPhoneInterface ? 55 : 60).isActive = true
                
                addSubview(yueEngSwitch)
                yueEngSwitch.translatesAutoresizingMaskIntoConstraints = false
                let topBottomInset: CGFloat = isPhoneInterface ? 16 : 13
                yueEngSwitch.topAnchor.constraint(equalTo: topAnchor, constant: topBottomInset).isActive = true
                yueEngSwitch.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -topBottomInset).isActive = true
                yueEngSwitch.leadingAnchor.constraint(equalTo: settingsButton.trailingAnchor, constant: 16).isActive = true
                yueEngSwitch.widthAnchor.constraint(equalToConstant: isPhoneInterface ? 105 : 115).isActive = true
                if viewController.keyboardLayout == .jyutping {
                        yueEngSwitch.selectedSegmentIndex = 0
                }
        }
        
        func setupCandidatesCollectionView() {
                settingsButton.removeFromSuperview()
                yueEngSwitch.removeFromSuperview()
                
                addSubview(inputLabel)
                inputLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        inputLabel.topAnchor.constraint(equalTo: topAnchor),
                        inputLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
                        inputLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
                        inputLabel.bottomAnchor.constraint(equalTo: topAnchor, constant: 18)
                ])
                inputLabel.adjustsFontForContentSizeCategory = true
                inputLabel.font = .preferredFont(forTextStyle: .callout)
                inputLabel.textAlignment = .left
                inputLabel.text = viewController.currentInputText
                
                addSubview(viewController.collectionView)
                viewController.collectionView.translatesAutoresizingMaskIntoConstraints = false
                
                viewController.collectionView.topAnchor.constraint(equalTo: topAnchor,constant: 10).isActive = true
                viewController.collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
                viewController.collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
                viewController.collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -45).isActive = true
                
                let collectionViewFlowLayout = UICollectionViewFlowLayout()
                collectionViewFlowLayout.scrollDirection = .horizontal
                viewController.collectionView.collectionViewLayout = collectionViewFlowLayout
        }
        
        func setupDownArrow() {
                keyboardDownButton.removeFromSuperview()
                addSubview(downArrowButton)
                downArrowButton.translatesAutoresizingMaskIntoConstraints = false
                downArrowButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
                downArrowButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
                downArrowButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
                downArrowButton.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -45).isActive = true
                
                let splitLine: CALayer = CALayer()
                splitLine.backgroundColor = self.tintColor.withAlphaComponent(0.3).cgColor
                splitLine.frame = CGRect(x: downArrowButton.bounds.origin.x, y: downArrowButton.bounds.origin.y + 20, width: 1, height: 25)
                downArrowButton.layer.addSublayer(splitLine)
        }
        
        func setupKeyboardDownButton() {
                downArrowButton.removeFromSuperview()
                addSubview(keyboardDownButton)
                keyboardDownButton.translatesAutoresizingMaskIntoConstraints = false
                keyboardDownButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
                keyboardDownButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
                keyboardDownButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
                let width: CGFloat = traitCollection.userInterfaceIdiom == .phone ? 58 : 64
                keyboardDownButton.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -width).isActive = true
        }
}
