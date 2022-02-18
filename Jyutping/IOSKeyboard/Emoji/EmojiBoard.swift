import UIKit

final class EmojiBoard: UIView {

        let backButton: UIButton
        let backspaceKey: UIButton
        let indicatorsStackView: UIStackView = UIStackView()

        init() {
                let imageName: String = {
                        if #available(iOSApplicationExtension 14.0, *) {
                                return "abc"
                        } else {
                                return "textformat.abc"
                        }
                }()
                backButton = Indicator(index: -1, imageName: imageName)
                backspaceKey = Indicator(index: 9, imageName: "delete.left")
                super.init(frame: .zero)
                setupBackButton()
                setupBackspaceKey()
                setupSubViews()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) { fatalError() }

        private func setupBackButton() {
                addSubview(backButton)
                backButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        backButton.leadingAnchor.constraint(equalTo: leadingAnchor),
                        backButton.bottomAnchor.constraint(equalTo: bottomAnchor),
                        backButton.topAnchor.constraint(equalTo: bottomAnchor, constant: -40),
                        backButton.trailingAnchor.constraint(equalTo: leadingAnchor, constant: 44)
                ])
        }
        private func setupBackspaceKey() {
                addSubview(backspaceKey)
                backspaceKey.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        backspaceKey.trailingAnchor.constraint(equalTo: trailingAnchor),
                        backspaceKey.bottomAnchor.constraint(equalTo: bottomAnchor),
                        backspaceKey.topAnchor.constraint(equalTo: bottomAnchor, constant: -40),
                        backspaceKey.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -44)
                ])
        }
        private func setupSubViews() {
                let indicator_0: Indicator = Indicator(index: 0, imageName: "clock")
                let indicator_1: Indicator = Indicator(index: 1, imageName: "EmojiSmiley")
                let indicator_2: Indicator = Indicator(index: 2, imageName: "tortoise")
                let indicator_3: Indicator = Indicator(index: 3, imageName: "EmojiICategoryFoodAndDrink")
                let indicator_4: Indicator = Indicator(index: 4, imageName: "EmojiICategoryActivity")
                let indicator_5: Indicator = Indicator(index: 5, imageName: "EmojiICategoryTravelAndPlaces")
                let indicator_6: Indicator = Indicator(index: 6, imageName: "lightbulb")
                let indicator_7: Indicator = Indicator(index: 7, imageName: "EmojiICategorySymbols")
                let indicator_8: Indicator = Indicator(index: 8, imageName: "flag")
                indicatorsStackView.distribution = .fillProportionally
                indicatorsStackView.addArrangedSubviews([indicator_0, indicator_1, indicator_2, indicator_3, indicator_4, indicator_5, indicator_6, indicator_7, indicator_8])
                addSubview(indicatorsStackView)
                indicatorsStackView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        indicatorsStackView.leadingAnchor.constraint(equalTo: backButton.trailingAnchor),
                        indicatorsStackView.trailingAnchor.constraint(equalTo: backspaceKey.leadingAnchor),
                        indicatorsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
                        indicatorsStackView.topAnchor.constraint(equalTo: bottomAnchor, constant: -40)
                ])
        }
}

final class Indicator: UIButton {

        let index: Int

        init(index: Int, imageName: String) {
                self.index = index
                super.init(frame: .zero)
                backgroundColor = .interactiveClear
                tintColor = .systemGray
                let indicatorImageView: UIImageView = UIImageView()
                addSubview(indicatorImageView)
                indicatorImageView.translatesAutoresizingMaskIntoConstraints = false
                let topInset: CGFloat = {
                        switch index {
                        case 4:
                                return 13
                        case 5:
                                return 12
                        case 7:
                                return 14
                        case 9:
                                return 10
                        default:
                                return 11
                        }
                }()
                NSLayoutConstraint.activate([
                        indicatorImageView.topAnchor.constraint(equalTo: topAnchor, constant: topInset),
                        indicatorImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
                        indicatorImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                        indicatorImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])
                indicatorImageView.contentMode = .scaleAspectFit
                if imageName.hasPrefix("Emoji") {
                        indicatorImageView.image = UIImage(named: imageName)?.cropped()?.withRenderingMode(.alwaysTemplate)
                } else {
                        indicatorImageView.image = UIImage(systemName: imageName)
                }
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) { fatalError() }

        override var intrinsicContentSize: CGSize {
                return CGSize(width: 40, height: 40)
        }
}
