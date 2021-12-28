import UIKit

final class ToolButton: UIButton {
        init(image: UIImage?, topInset: CGFloat = 0, bottomInset: CGFloat = 0, leftInset: CGFloat = 0, rightInset: CGFloat = 0) {
                super.init(frame: .zero)
                backgroundColor = .interactiveClear
                let buttonImageView: UIImageView = UIImageView()
                addSubview(buttonImageView)
                buttonImageView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        buttonImageView.topAnchor.constraint(equalTo: topAnchor, constant: topInset),
                        buttonImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomInset),
                        buttonImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftInset),
                        buttonImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -rightInset)
                ])
                buttonImageView.contentMode = .scaleAspectFit
                buttonImageView.image = image
        }
        required init?(coder: NSCoder) { fatalError("ToolButton.init(coder:) error") }

        convenience init(imageName: String, topInset: CGFloat = 0, bottomInset: CGFloat = 0, leftInset: CGFloat = 0, rightInset: CGFloat = 0) {
                let image: UIImage? = {
                        if imageName == "EmojiSmiley" {
                                return UIImage.emojiSmiley
                        } else {
                                return UIImage(systemName: imageName)
                        }
                }()
                self.init(image: image, topInset: topInset, bottomInset: bottomInset, leftInset: leftInset, rightInset: rightInset)
        }

        static func chevron(_ direction: Direction, topInset: CGFloat = 0, bottomInset: CGFloat = 0, leftInset: CGFloat = 0, rightInset: CGFloat = 0) -> ToolButton {
                let image: UIImage? = UIImage.chevron(direction)
                return ToolButton(image: image, topInset: topInset, bottomInset: bottomInset, leftInset: leftInset, rightInset: rightInset)
        }
}

final class YueEngSwitch: UIButton {

        private let backView: UIView = UIView()
        private let leftForeView: UIView = UIView()
        private let rightForeView: UIView = UIView()
        private let yueLabel: UILabel = UILabel()
        private let engLabel: UILabel = UILabel()

        private let width: CGFloat
        private let height: CGFloat
        private var isDarkAppearance: Bool
        private(set) var switched: Bool

        init(width: CGFloat, height: CGFloat, isDarkAppearance: Bool, switched: Bool) {
                self.width = width
                self.height = height
                self.isDarkAppearance = isDarkAppearance
                self.switched = switched
                super.init(frame: .zero)
                backgroundColor = .interactiveClear
                setupBackView()
                setupLeftForeView()
                setupRightForeView()
                setupText()
        }
        required init?(coder: NSCoder) { fatalError("YueEngSwitch.init(coder:) error") }

        func update(isDarkAppearance: Bool, switched: Bool) {
                yueLabel.text = Logogram.current == .simplified ? "粤" : "粵"
                let isSameState: Bool = self.isDarkAppearance == isDarkAppearance && self.switched == switched
                guard !isSameState else { return }
                self.isDarkAppearance = isDarkAppearance
                self.switched = switched

                backView.backgroundColor = isDarkAppearance ? .darkThick : .lightEmphatic
                yueLabel.textColor = isDarkAppearance ? .white : .black
                engLabel.textColor = isDarkAppearance ? .white : .black
                if switched {
                        leftForeView.backgroundColor = .clear
                        rightForeView.backgroundColor = isDarkAppearance ? .darkThin : .white
                        yueLabel.font = smallFont
                        engLabel.font = largeFont
                } else {
                        leftForeView.backgroundColor = isDarkAppearance ? .darkThin : .white
                        rightForeView.backgroundColor = .clear
                        yueLabel.font = largeFont
                        engLabel.font = smallFont
                }
        }
        private func setupBackView() {
                addSubview(backView)
                backView.translatesAutoresizingMaskIntoConstraints = false
                let topBottomInset: CGFloat = 16
                NSLayoutConstraint.activate([
                        backView.leadingAnchor.constraint(equalTo: leadingAnchor),
                        backView.trailingAnchor.constraint(equalTo: trailingAnchor),
                        backView.topAnchor.constraint(equalTo: topAnchor, constant: topBottomInset),
                        backView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -topBottomInset)
                ])
                backView.layer.cornerRadius = 5
                backView.layer.cornerCurve = .continuous
                backView.backgroundColor = isDarkAppearance ? .darkThick : .lightEmphatic
                backView.isUserInteractionEnabled = false
        }
        private func setupLeftForeView() {
                backView.addSubview(leftForeView)
                leftForeView.translatesAutoresizingMaskIntoConstraints = false
                let halfWidth: CGFloat = width / 2.0
                let topBottomInset: CGFloat = 16
                NSLayoutConstraint.activate([
                        leftForeView.topAnchor.constraint(equalTo: topAnchor, constant: topBottomInset),
                        leftForeView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -topBottomInset),
                        leftForeView.leadingAnchor.constraint(equalTo: leadingAnchor),
                        leftForeView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -halfWidth)
                ])
                leftForeView.layer.cornerRadius = 5
                leftForeView.layer.cornerCurve = .continuous
                leftForeView.backgroundColor = switched ? .clear : (isDarkAppearance ? .darkThin : .white)
        }
        private func setupRightForeView() {
                backView.addSubview(rightForeView)
                rightForeView.translatesAutoresizingMaskIntoConstraints = false
                let halfWidth: CGFloat = width / 2.0
                let topBottomInset: CGFloat = 16
                NSLayoutConstraint.activate([
                        rightForeView.topAnchor.constraint(equalTo: topAnchor, constant: topBottomInset),
                        rightForeView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -topBottomInset),
                        rightForeView.trailingAnchor.constraint(equalTo: trailingAnchor),
                        rightForeView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: halfWidth)
                ])
                rightForeView.layer.cornerRadius = 5
                rightForeView.layer.cornerCurve = .continuous
                rightForeView.backgroundColor = switched ? (isDarkAppearance ? .darkThin : .white) : .clear
        }
        private func setupText() {
                backView.addSubview(yueLabel)
                backView.addSubview(engLabel)
                yueLabel.translatesAutoresizingMaskIntoConstraints = false
                engLabel.translatesAutoresizingMaskIntoConstraints = false
                yueLabel.textAlignment = .center
                engLabel.textAlignment = .center
                yueLabel.textColor = isDarkAppearance ? .white : .black
                engLabel.textColor = isDarkAppearance ? .white : .black
                yueLabel.text = Logogram.current == .simplified ? "粤" : "粵"
                engLabel.text = "A"
                if switched {
                        yueLabel.font = smallFont
                        engLabel.font = largeFont
                } else {
                        yueLabel.font = largeFont
                        engLabel.font = smallFont
                }
                NSLayoutConstraint.activate([
                        yueLabel.topAnchor.constraint(equalTo: topAnchor),
                        yueLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
                        yueLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                        yueLabel.trailingAnchor.constraint(equalTo: leadingAnchor, constant: width / 2.0),
                        engLabel.topAnchor.constraint(equalTo: topAnchor),
                        engLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
                        engLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
                        engLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: width / 2.0)
                ])
        }

        private let largeFont: UIFont = .systemFont(ofSize: 15)
        private let smallFont: UIFont = .systemFont(ofSize: 12)

        override var accessibilityValue: String? {
                get {
                        return switched ? NSLocalizedString("Current mode: English", comment: .empty) : NSLocalizedString("Current mode: Cantonese", comment: .empty)
                }
                set {}
        }
}
