import UIKit

final class ToolBar: UIView {
        
        private let controller: KeyboardViewController
        private let isPhoneInterface: Bool
        private let stackView: UIStackView =  UIStackView()
        private let toolBarHeight: CGFloat = 60

        init(controller: KeyboardViewController) {
                self.controller = controller
                self.isPhoneInterface = controller.isPhoneInterface
                super.init(frame: .zero)
                heightAnchor.constraint(equalToConstant: toolBarHeight).isActive = true
                setupToolMode()
                setupStackView()
                downArrow.layer.addSublayer(splitLine)
                setupAccessibility()
        }
        required init?(coder: NSCoder) { fatalError("ToolBar.init(coder:) error") }

        private func setupStackView() {
                stackView.alignment = .center
                stackView.distribution = .equalSpacing
                stackView.addArrangedSubview(settingsButton)
                stackView.addArrangedSubview(yueEngSwitch)
                if controller.hasFullAccess {
                        stackView.addArrangedSubview(pasteButton)
                }
                stackView.addArrangedSubview(emojiSwitch)
                stackView.addArrangedSubview(keyboardDown)

                NSLayoutConstraint.activate(toolBarItemsConstraints)
        }

        private lazy var showingToolButtons: Bool = true
        func update() {
                if controller.inputText.isEmpty {
                        if !showingToolButtons {
                                setupToolMode()
                                showingToolButtons = true
                        }
                } else {
                        if showingToolButtons {
                                setupInputMode()
                                showingToolButtons = false
                        }
                }
        }
        func reset() {
                if controller.inputText.isEmpty {
                        setupToolMode()
                        showingToolButtons = true
                } else {
                        setupInputMode()
                        showingToolButtons = false
                }
        }

        private(set) lazy var settingsButton: ToolButton = {
                let inset: CGFloat = isPhoneInterface ? 17 : 15
                return ToolButton(imageName: "gear", topInset: inset, bottomInset: inset)
        }()
        private(set) lazy var yueEngSwitch: YueEngSwitch = {
                let width: CGFloat = isPhoneInterface ? 88 : 108
                return YueEngSwitch(width: width, height: toolBarHeight, isPhoneInterface: isPhoneInterface, isDarkAppearance: false, switched: false)
        }()
        private(set) lazy var pasteButton: ToolButton = {
                if isPhoneInterface {
                        return ToolButton(imageName: "doc.on.clipboard", topInset: 19, bottomInset: 18)
                } else {
                        return ToolButton(imageName: "doc.on.clipboard", topInset: 17, bottomInset: 16)
                }
        }()
        private(set) lazy var emojiSwitch: ToolButton = {
                let name: String = {
                        if #available(iOSApplicationExtension 14, *) {
                                return "face.smiling"
                        } else {
                                return "smiley"
                        }
                }()
                let inset: CGFloat = isPhoneInterface ? 17 : 15
                return ToolButton(imageName: name, topInset: inset, bottomInset: inset)
        }()
        private(set) lazy var keyboardDown: ToolButton = {
                if isPhoneInterface {
                        return ToolButton(imageName: "keyboard.chevron.compact.down", topInset: 18, bottomInset: 19)
                } else {
                        return ToolButton(imageName: "keyboard.chevron.compact.down", topInset: 16, bottomInset: 17)
                }
        }()
        let downArrow: ToolButton = ToolButton(imageName: "chevron.down", topInset: 18, bottomInset: 18)
        private let splitLine: CALayer = CALayer()

        private func setupToolMode() {
                controller.candidateCollectionView.removeFromSuperview()
                downArrow.removeFromSuperview()
                NSLayoutConstraint.deactivate(collectionViewConstraints)
                NSLayoutConstraint.deactivate(downArrowButtonConstraints)

                addSubview(stackView)
                stackView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate(stackViewConstraints)
        }
        private func setupInputMode() {
                stackView.removeFromSuperview()
                NSLayoutConstraint.deactivate(stackViewConstraints)

                addSubview(controller.candidateCollectionView)
                controller.candidateCollectionView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate(collectionViewConstraints)
                (controller.candidateCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal

                addSubview(downArrow)
                downArrow.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate(downArrowButtonConstraints)
                splitLine.backgroundColor = tintColor.withAlphaComponent(0.3).cgColor
                splitLine.frame = CGRect(x: downArrow.bounds.origin.x, y: downArrow.bounds.origin.y + 20, width: 1, height: 25)
        }

        private var stackViewConstraints: [NSLayoutConstraint] {
                [stackView.topAnchor.constraint(equalTo: topAnchor),
                 stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
                 stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                 stackView.trailingAnchor.constraint(equalTo: trailingAnchor)]
        }
        private var toolBarItemsConstraints: [NSLayoutConstraint] {
                let width: CGFloat = 50
                let yueEngWidth: CGFloat = isPhoneInterface ? 88 : 108
                return [settingsButton.widthAnchor.constraint(equalToConstant: width),
                        settingsButton.heightAnchor.constraint(equalToConstant: toolBarHeight),
                        yueEngSwitch.widthAnchor.constraint(equalToConstant: yueEngWidth),
                        yueEngSwitch.heightAnchor.constraint(equalToConstant: toolBarHeight),
                        pasteButton.widthAnchor.constraint(equalToConstant: width),
                        pasteButton.heightAnchor.constraint(equalToConstant: toolBarHeight),
                        emojiSwitch.widthAnchor.constraint(equalToConstant: width),
                        emojiSwitch.heightAnchor.constraint(equalToConstant: toolBarHeight),
                        keyboardDown.widthAnchor.constraint(equalToConstant: width),
                        keyboardDown.heightAnchor.constraint(equalToConstant: toolBarHeight)]
        }
        var collectionViewConstraints: [NSLayoutConstraint] {
                [controller.candidateCollectionView.topAnchor.constraint(equalTo: topAnchor),
                 controller.candidateCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
                 controller.candidateCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
                 controller.candidateCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -45)]
        }
        private var downArrowButtonConstraints: [NSLayoutConstraint] {
                [downArrow.topAnchor.constraint(equalTo: topAnchor),
                 downArrow.bottomAnchor.constraint(equalTo: bottomAnchor),
                 downArrow.trailingAnchor.constraint(equalTo: trailingAnchor),
                 downArrow.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -45)]
        }

        private func setupAccessibility() {
                settingsButton.accessibilityLabel = NSLocalizedString("Keyboard Settings", comment: "")
                yueEngSwitch.accessibilityLabel = NSLocalizedString("Keyboard Mode Switch", comment: "")
                pasteButton.accessibilityLabel = NSLocalizedString("Paste Clipboard content", comment: "")
                emojiSwitch.accessibilityLabel = NSLocalizedString("Switch to Emoji layout", comment: "")
                keyboardDown.accessibilityLabel = NSLocalizedString("Dismiss keyboard", comment: "")
                downArrow.accessibilityLabel = NSLocalizedString("Expand Candidates board", comment: "")
        }
}
