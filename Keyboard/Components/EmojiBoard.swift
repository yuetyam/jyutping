import UIKit

final class EmojiBoard: UIView {

        let bottomStackView: UIStackView = UIStackView()

        private let viewController: KeyboardViewController

        init(viewController: KeyboardViewController) {
                self.viewController = viewController
                super.init(frame: .zero)
                setupSubViews()
        }

        required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }

        private func setupSubViews() {
                let switchBackButton: KeyButton = KeyButton(keyboardEvent: .switchTo(.jyutping), viewController: viewController)
                let spaceButton: KeyButton = KeyButton(keyboardEvent: .space, viewController: viewController)
                let backspaceButton: KeyButton = KeyButton(keyboardEvent: .backspace, viewController: viewController)
                let returnButton: KeyButton = KeyButton(keyboardEvent: .newLine, viewController: viewController)
                let buttons: [KeyButton] = {
                        if viewController.needsInputModeSwitchKey {
                                let switchInputMethodButton: KeyButton = KeyButton(keyboardEvent: .switchInputMethod, viewController: viewController)
                                switchInputMethodButton.addTarget(viewController, action: #selector(viewController.handleInputModeList(from:with:)), for: .allTouchEvents)
                                return [switchBackButton, switchInputMethodButton, spaceButton, backspaceButton, returnButton]
                        } else {
                                return [switchBackButton, spaceButton, backspaceButton, returnButton]
                        }
                }()
                bottomStackView.axis = .horizontal
                bottomStackView.distribution = .fillProportionally
                bottomStackView.addMultipleArrangedSubviews(buttons)
                addSubview(bottomStackView)
                bottomStackView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        bottomStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
                        bottomStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                        bottomStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])
        }
}
