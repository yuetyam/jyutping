import UIKit

final class ToolButton: UIButton {
        init(imageName: String, topInset: CGFloat = 0, bottomInset: CGFloat = 0, leftInset: CGFloat = 0, rightInset: CGFloat = 0) {
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
                buttonImageView.image = UIImage(systemName: imageName)
        }
        required init?(coder: NSCoder) { fatalError("ToolButton.init(coder:) error") }
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
                let same: Bool = self.isDarkAppearance == isDarkAppearance && self.switched == switched
                guard !same else { return }
                self.isDarkAppearance = isDarkAppearance
                self.switched = switched

                backView.backgroundColor = isDarkAppearance ? darkBack : lightBack
                yueLabel.textColor = isDarkAppearance ? .white : .black
                engLabel.textColor = isDarkAppearance ? .white : .black
                if switched {
                        leftForeView.backgroundColor = .clear
                        rightForeView.backgroundColor = isDarkAppearance ? darkFore : .white
                        yueLabel.font = .systemFont(ofSize: 12)
                        engLabel.font = .systemFont(ofSize: 13)
                } else {
                        leftForeView.backgroundColor = isDarkAppearance ? darkFore : .white
                        rightForeView.backgroundColor = .clear
                        yueLabel.font = .systemFont(ofSize: 15)
                        engLabel.font = .systemFont(ofSize: 10)
                }
        }
        private func setupBackView() {
                addSubview(backView)
                backView.translatesAutoresizingMaskIntoConstraints = false
                let topBottomInset: CGFloat = height / 4.0
                NSLayoutConstraint.activate([
                        backView.leadingAnchor.constraint(equalTo: leadingAnchor),
                        backView.trailingAnchor.constraint(equalTo: trailingAnchor),
                        backView.topAnchor.constraint(equalTo: topAnchor, constant: topBottomInset),
                        backView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -topBottomInset)
                ])
                backView.layer.cornerRadius = 5
                backView.layer.cornerCurve = .continuous
                backView.backgroundColor = isDarkAppearance ? darkBack : lightBack
                backView.isUserInteractionEnabled = false
        }
        private func setupLeftForeView() {
                backView.addSubview(leftForeView)
                leftForeView.translatesAutoresizingMaskIntoConstraints = false
                let halfWidth: CGFloat = width / 2.0
                let topBottomInset: CGFloat = height / 4.0
                NSLayoutConstraint.activate([
                        leftForeView.topAnchor.constraint(equalTo: topAnchor, constant: topBottomInset),
                        leftForeView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -topBottomInset),
                        leftForeView.leadingAnchor.constraint(equalTo: leadingAnchor),
                        leftForeView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -halfWidth)
                ])
                leftForeView.layer.cornerRadius = 5
                leftForeView.layer.cornerCurve = .continuous
                leftForeView.backgroundColor = switched ? .clear : (isDarkAppearance ? darkFore : .white)
        }
        private func setupRightForeView() {
                backView.addSubview(rightForeView)
                rightForeView.translatesAutoresizingMaskIntoConstraints = false
                let halfWidth: CGFloat = width / 2.0
                let topBottomInset: CGFloat = height / 4.0
                NSLayoutConstraint.activate([
                        rightForeView.topAnchor.constraint(equalTo: topAnchor, constant: topBottomInset),
                        rightForeView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -topBottomInset),
                        rightForeView.trailingAnchor.constraint(equalTo: trailingAnchor),
                        rightForeView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: halfWidth)
                ])
                rightForeView.layer.cornerRadius = 5
                rightForeView.layer.cornerCurve = .continuous
                rightForeView.backgroundColor = switched ? (isDarkAppearance ? darkFore : .white) : .clear
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
                yueLabel.text = "粵"
                engLabel.text = "EN"
                if switched {
                        yueLabel.font = .systemFont(ofSize: 12)
                        engLabel.font = .systemFont(ofSize: 13)
                } else {
                        yueLabel.font = .systemFont(ofSize: 15)
                        engLabel.font = .systemFont(ofSize: 10)
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
        private let lightBack: UIColor = UIColor(displayP3Red: 201.0 / 255, green: 203.0 / 255, blue: 209.0 / 255, alpha: 1)
        private let darkBack: UIColor = UIColor(displayP3Red: 62.0 / 255, green: 62.0 / 255, blue: 66.0 / 255, alpha: 1)
        private let darkFore: UIColor = UIColor(displayP3Red: 115.0 / 255, green: 115.0 / 255, blue: 120.0 / 255, alpha: 1)

        override var accessibilityValue: String? {
                get {
                        return switched ? NSLocalizedString("Current mode: English", comment: "") : NSLocalizedString("Current mode: Cantonese", comment: "")
                }
                set {}
        }
}
