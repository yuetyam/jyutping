import UIKit

final class EmojiBoard: UIView {

        private let bottomStackView: UIStackView = UIStackView()
        let indicatorsStackView: UIStackView = UIStackView()
        let globeKey: UIButton = UIButton()

        init(viewController: KeyboardViewController) {
                super.init(frame: .zero)
                setupSubViews(controller: viewController)
        }

        required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }

        private func setupSubViews(controller: KeyboardViewController) {
                let switchBack: KeyView = KeyView(event: .switchTo(.cantonese(.lowercased)), controller: controller)
                let space: KeyView = KeyView(event: .space, controller: controller)
                let backspace: KeyView = KeyView(event: .backspace, controller: controller)
                let newLine: KeyView = KeyView(event: .newLine, controller: controller)
                let keys: [KeyView] = {
                        if controller.needsInputModeSwitchKey {
                                let switchIME: KeyView = KeyView(event: .switchInputMethod, controller: controller)
                                switchIME.addSubview(globeKey)
                                globeKey.translatesAutoresizingMaskIntoConstraints = false
                                NSLayoutConstraint.activate([
                                        globeKey.topAnchor.constraint(equalTo: switchIME.topAnchor),
                                        globeKey.bottomAnchor.constraint(equalTo: switchIME.bottomAnchor),
                                        globeKey.leadingAnchor.constraint(equalTo: switchIME.leadingAnchor),
                                        globeKey.trailingAnchor.constraint(equalTo: switchIME.trailingAnchor)
                                ])
                                return [switchBack, switchIME, space, backspace, newLine]
                        } else {
                                return [switchBack, space, backspace, newLine]
                        }
                }()
                bottomStackView.distribution = .fillProportionally
                bottomStackView.addMultipleArrangedSubviews(keys)
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
                backgroundColor = .interactiveClear
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
