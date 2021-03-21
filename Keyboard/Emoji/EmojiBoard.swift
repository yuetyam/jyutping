import UIKit

final class EmojiBoard: UIView {

        private let bottomStackView: UIStackView = UIStackView()
        let indicatorsStackView: UIStackView = UIStackView()

        init(viewController: KeyboardViewController) {
                super.init(frame: .zero)
                setupSubViews(viewController: viewController)
        }

        required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }

        private func setupSubViews(viewController: KeyboardViewController) {
                let switchBackButton: KeyButton = KeyButton(keyboardEvent: .switchTo(.cantonese(.lowercased)), viewController: viewController)
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

                let imageName_0: String = {
                        if #available(iOSApplicationExtension 14, *) {
                                return "face.smiling"
                        } else {
                                return "smiley"
                        }
                }()
                let imageName_3: String = {
                        if #available(iOSApplicationExtension 14, *) {
                                return "leaf"
                        } else {
                                return "flame"
                        }
                }()
                let indicator_0: Indicator = Indicator(index: 0, imageName: "clock")
                let indicator_1: Indicator = Indicator(index: 1, imageName: imageName_0)
                let indicator_2: Indicator = Indicator(index: 2, imageName: "tortoise")
                let indicator_3: Indicator = Indicator(index: 3, imageName: imageName_3) // fix: hamburger
                let indicator_4: Indicator = Indicator(index: 4, imageName: "circle") // fix: football
                let indicator_5: Indicator = Indicator(index: 5, imageName: "car")
                let indicator_6: Indicator = Indicator(index: 6, imageName: "lightbulb")
                let indicator_7: Indicator = Indicator(index: 7, imageName: "number.circle")
                let indicator_8: Indicator = Indicator(index: 8, imageName: "flag")
                
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

        let index: Int

        init(index: Int, imageName: String, topInset: CGFloat = 10, bottomInset: CGFloat = 10) {
                self.index = index
                super.init(frame: .zero)
                backgroundColor = .interactableClear
                tintColor = .systemGray
                let indicatorImageView: UIImageView = UIImageView()
                addSubview(indicatorImageView)
                indicatorImageView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        indicatorImageView.topAnchor.constraint(equalTo: topAnchor, constant: topInset),
                        indicatorImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomInset),
                        indicatorImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                        indicatorImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])
                indicatorImageView.contentMode = .scaleAspectFit
                indicatorImageView.image = UIImage(systemName: imageName)
        }

        required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }

        override var intrinsicContentSize: CGSize {
                return CGSize(width: 40, height: 40)
        }
}
