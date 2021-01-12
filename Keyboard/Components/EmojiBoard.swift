import UIKit

final class EmojiBoard: UIView {

        let bottomStackView: UIStackView = UIStackView()
        let indicatorsStackView: UIStackView = UIStackView()

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
                bottomStackView.distribution = .fillProportionally
                bottomStackView.addMultipleArrangedSubviews(buttons)
                addSubview(bottomStackView)
                bottomStackView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        bottomStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
                        bottomStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                        bottomStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])

                let indicator_0: Indicator = Indicator(0)
                let indicator_1: Indicator = Indicator(1)
                let indicator_2: Indicator = Indicator(2)
                let indicator_3: Indicator = Indicator(3)
                let indicator_4: Indicator = Indicator(4)
                let indicator_5: Indicator = Indicator(5)
                let indicator_6: Indicator = Indicator(6)
                let indicator_7: Indicator = Indicator(7)
                let indicator_8: Indicator = Indicator(8)
                // mostLeftIndicator.indicatorImageView.image = UIImage(systemName: "clock")
                indicator_0.indicatorImageView.image = UIImage(systemName: "face.smiling")
                indicator_1.indicatorImageView.image = UIImage(systemName: "hand.thumbsup")
                indicator_2.indicatorImageView.image = UIImage(systemName: "tortoise")
                indicator_3.indicatorImageView.image = UIImage(systemName: "leaf")
                indicator_4.indicatorImageView.image = UIImage(systemName: "car")
                indicator_5.indicatorImageView.image = UIImage(systemName: "ticket")
                indicator_6.indicatorImageView.image = UIImage(systemName: "lightbulb")
                indicator_7.indicatorImageView.image = UIImage(systemName: "number.circle")
                indicator_8.indicatorImageView.image = UIImage(systemName: "flag")
                
                indicatorsStackView.distribution = .fillProportionally
                indicatorsStackView.addMultipleArrangedSubviews([indicator_0, indicator_1, indicator_2, indicator_3, indicator_4, indicator_5, indicator_6, indicator_7, indicator_8])
                addSubview(indicatorsStackView)
                indicatorsStackView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        indicatorsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                        indicatorsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                        indicatorsStackView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor)
                ])
        }
}

final class Indicator: UIButton {

        let indicatorImageView: UIImageView = UIImageView()
        let index: Int

        init(_ index: Int, topInset: CGFloat = 10, bottomInset: CGFloat = 10, leftInset: CGFloat = 2, rightInset: CGFloat = 2) {
                self.index = index
                super.init(frame: .zero)
                self.backgroundColor = .clearTappable
                tintColor = .systemGray
                addSubview(indicatorImageView)
                indicatorImageView.contentMode = .scaleAspectFit
                indicatorImageView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        indicatorImageView.topAnchor.constraint(equalTo: topAnchor, constant: topInset),
                        indicatorImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomInset),
                        indicatorImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftInset),
                        indicatorImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -rightInset)
                ])
        }

        required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }

        override var intrinsicContentSize: CGSize {
                return CGSize(width: 40, height: 40)
        }
}
