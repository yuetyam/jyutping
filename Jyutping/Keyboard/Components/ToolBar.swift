import UIKit

final class ToolBar: UIView {

        private let controller: KeyboardViewController
        private let stackView: UIStackView =  UIStackView()
        private let toolBarHeight: CGFloat = 60

        init(controller: KeyboardViewController) {
                self.controller = controller
                super.init(frame: .zero)
                heightAnchor.constraint(equalToConstant: toolBarHeight).isActive = true
                setupToolMode()
                setupStackView()
                downArrow.layer.addSublayer(splitLine)
                improveAccessibility()
        }
        required init?(coder: NSCoder) { fatalError("ToolBar.init(coder:) error") }
        override var intrinsicContentSize: CGSize { CGSize(width: 320, height: 60)}

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

        let settingsButton: ToolButton = ToolButton(imageName: "gear", topInset: 17, bottomInset: 17)
        let yueEngSwitch: YueEngSwitch = YueEngSwitch(width: 80, height: 60, isDarkAppearance: false, switched: false)
        let pasteButton: ToolButton = ToolButton(imageName: "doc.on.clipboard", topInset: 19, bottomInset: 18)
        let emojiSwitch: ToolButton = ToolButton(imageName: "EmojiSmiley", topInset: 18, bottomInset: 18)
        let keyboardDown: ToolButton = ToolButton(imageName: "keyboard.chevron.compact.down", topInset: 18, bottomInset: 19)
        let downArrow: ToolButton = .chevron(.down, topInset: 18, bottomInset: 18)
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
                return [settingsButton.widthAnchor.constraint(equalToConstant: width),
                        settingsButton.heightAnchor.constraint(equalToConstant: toolBarHeight),
                        yueEngSwitch.widthAnchor.constraint(equalToConstant: 80),
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

        private func improveAccessibility() {
                settingsButton.accessibilityLabel = NSLocalizedString("Keyboard Settings", comment: .empty)
                yueEngSwitch.accessibilityLabel = NSLocalizedString("Keyboard Mode Switch", comment: .empty)
                pasteButton.accessibilityLabel = NSLocalizedString("Paste Clipboard content", comment: .empty)
                emojiSwitch.accessibilityLabel = NSLocalizedString("Switch to Emoji layout", comment: .empty)
                keyboardDown.accessibilityLabel = NSLocalizedString("Dismiss keyboard", comment: .empty)
                downArrow.accessibilityLabel = NSLocalizedString("Expand Candidates board", comment: .empty)
        }
}
