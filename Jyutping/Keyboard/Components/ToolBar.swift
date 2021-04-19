import UIKit

final class ToolBar: UIView {
        
        private let controller: KeyboardViewController
        private let stackView: UIStackView =  UIStackView()
        private let toolBarHeight: CGFloat = 60

        init(controller: KeyboardViewController) {
                self.controller = controller
                super.init(frame: .zero)
                heightAnchor.constraint(equalToConstant: toolBarHeight).isActive = true
                setupStackView()
                setupToolMode()
                downArrowButton.layer.addSublayer(splitLine)
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
                stackView.addArrangedSubview(keyboardDownButton)

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
        let yueEngSwitch: UISegmentedControl = UISegmentedControl(items: ["粵", "EN"])
        let pasteButton: ToolButton = ToolButton(imageName: "doc.on.clipboard", topInset: 19, bottomInset: 18)
        let emojiSwitch: ToolButton = {
                let smilingEmojiName: String = {
                        if #available(iOSApplicationExtension 14, *) {
                                return "face.smiling"
                        } else {
                                return "smiley"
                        }
                }()
                return ToolButton(imageName: smilingEmojiName, topInset: 17, bottomInset: 17)
        }()
        let keyboardDownButton: ToolButton = ToolButton(imageName: "keyboard.chevron.compact.down", topInset: 18, bottomInset: 19)
        let downArrowButton: ToolButton = ToolButton(imageName: "chevron.down", topInset: 18, bottomInset: 18)
        private let splitLine: CALayer = CALayer()

        private func setupToolMode() {
                controller.candidateCollectionView.removeFromSuperview()
                downArrowButton.removeFromSuperview()
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

                addSubview(downArrowButton)
                downArrowButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate(downArrowButtonConstraints)
                splitLine.backgroundColor = tintColor.withAlphaComponent(0.3).cgColor
                splitLine.frame = CGRect(x: downArrowButton.bounds.origin.x, y: downArrowButton.bounds.origin.y + 20, width: 1, height: 25)
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
                        yueEngSwitch.widthAnchor.constraint(equalToConstant: 100),
                        yueEngSwitch.heightAnchor.constraint(equalToConstant: 32),
                        pasteButton.widthAnchor.constraint(equalToConstant: width),
                        pasteButton.heightAnchor.constraint(equalToConstant: toolBarHeight),
                        emojiSwitch.widthAnchor.constraint(equalToConstant: width),
                        emojiSwitch.heightAnchor.constraint(equalToConstant: toolBarHeight),
                        keyboardDownButton.widthAnchor.constraint(equalToConstant: width),
                        keyboardDownButton.heightAnchor.constraint(equalToConstant: toolBarHeight)]
        }
        var collectionViewConstraints: [NSLayoutConstraint] {
                [controller.candidateCollectionView.topAnchor.constraint(equalTo: topAnchor),
                 controller.candidateCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
                 controller.candidateCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
                 controller.candidateCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -45)]
        }
        private var downArrowButtonConstraints: [NSLayoutConstraint] {
                [downArrowButton.topAnchor.constraint(equalTo: topAnchor),
                 downArrowButton.bottomAnchor.constraint(equalTo: bottomAnchor),
                 downArrowButton.trailingAnchor.constraint(equalTo: trailingAnchor),
                 downArrowButton.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -45)]
        }
}
