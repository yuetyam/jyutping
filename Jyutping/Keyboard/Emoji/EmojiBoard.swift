import UIKit

final class EmojiBoard: UIView {

        let backButton: UIButton
        let backspaceKey: UIButton
        let indicatorsStackView: UIStackView = UIStackView()

        init() {
                backButton = Indicator(index: -1, imageName: "abc")
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
                let footballImageName: String = {
                        if #available(iOSApplicationExtension 16.0, *) {
                                return "soccerball"
                        } else {
                                return "EmojiCategoryActivity"
                        }
                }()
                let indicator_0: Indicator = Indicator(index: 0, imageName: "clock")
                let indicator_1: Indicator = Indicator(index: 1, imageName: "EmojiSmiley")
                let indicator_2: Indicator = Indicator(index: 2, imageName: "hare")
                let indicator_3: Indicator = Indicator(index: 3, imageName: "EmojiCategoryFoodAndDrink")
                let indicator_4: Indicator = Indicator(index: 4, imageName: footballImageName)
                let indicator_5: Indicator = Indicator(index: 5, imageName: "EmojiCategoryTravelAndPlaces")
                let indicator_6: Indicator = Indicator(index: 6, imageName: "lightbulb")
                let indicator_7: Indicator = Indicator(index: 7, imageName: "EmojiCategorySymbols")
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
                let baseInset: CGFloat = 10
                let topInset: CGFloat = {
                        switch index {
                        case 2:
                                return baseInset + 2
                        case 3:
                                return baseInset + 2
                        case 4:
                                if #available(iOSApplicationExtension 16.0, *) {
                                        return baseInset
                                } else {
                                        return baseInset + 3
                                }
                        case 5:
                                return baseInset + 2
                        case 6:
                                return baseInset + 1
                        case 7:
                                return baseInset + 4
                        case 9:
                                return baseInset - 2
                        default:
                                return baseInset
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
