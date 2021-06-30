import UIKit

extension KeyView {
        func setupKeyShapeView() {
                let horizontalConstant: CGFloat = {
                        switch traitCollection.userInterfaceIdiom {
                        case .pad:
                                return isPhoneInterface ? 2 : 5
                        default:
                                return 3
                        }
                }()
                let verticalConstant: CGFloat = {
                        if traitCollection.userInterfaceIdiom == .phone && traitCollection.verticalSizeClass == .compact {
                                return 3
                        } else {
                                return 5
                        }
                }()
                addSubview(shape)
                shape.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        shape.topAnchor.constraint(equalTo: topAnchor, constant: verticalConstant),
                        shape.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalConstant),
                        shape.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalConstant),
                        shape.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalConstant)
                ])
                shape.isUserInteractionEnabled = false
                shape.tintColor = foreColor
                shape.layer.cornerRadius = 5
                shape.layer.cornerCurve = .continuous
                shape.layer.shadowColor = UIColor.black.cgColor
                shape.layer.shadowOpacity = 0.3
                shape.layer.shadowOffset = CGSize(width: 0, height: 1)
                shape.layer.shadowRadius = 0.5
                shape.layer.shouldRasterize = true
                shape.layer.rasterizationScale = UIScreen.main.scale

                guard isDarkAppearance else {
                        shape.backgroundColor = backColor
                        return
                }
                let effectView: BlurEffectView = {
                        switch event {
                        case .key, .space:
                                return BlurEffectView(fraction: 0.44, effectStyle: .extraLight)
                        default:
                                return BlurEffectView(fraction: 0.48, effectStyle: .light)
                        }
                }()
                let blurEffectView: UIVisualEffectView = effectView
                blurEffectView.frame = shape.bounds
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                blurEffectView.layer.cornerRadius = 5
                blurEffectView.layer.cornerCurve = .continuous
                blurEffectView.clipsToBounds = true
                shape.addSubview(blurEffectView)
        }
        func setupKeyTextLabel() {
                let keyTextLabel: UILabel = UILabel()
                shape.addSubview(keyTextLabel)
                keyTextLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        keyTextLabel.topAnchor.constraint(equalTo: shape.topAnchor),
                        keyTextLabel.bottomAnchor.constraint(equalTo: shape.bottomAnchor),
                        keyTextLabel.leadingAnchor.constraint(equalTo: shape.leadingAnchor),
                        keyTextLabel.trailingAnchor.constraint(equalTo: shape.trailingAnchor)
                ])
                keyTextLabel.font = keyFont
                keyTextLabel.textAlignment = .center
                keyTextLabel.textColor = foreColor
                keyTextLabel.text = keyText
        }
        func setupKeyHeaderLabel(text: String?, alignment: NSTextAlignment = .right) {
                let keyHeaderLabel: UILabel = UILabel()
                shape.addSubview(keyHeaderLabel)
                keyHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
                let inset: CGFloat = isPhoneInterface ? 2 : 4
                NSLayoutConstraint.activate([
                        keyHeaderLabel.topAnchor.constraint(equalTo: shape.topAnchor, constant: inset),
                        keyHeaderLabel.leadingAnchor.constraint(equalTo: shape.leadingAnchor,constant: inset),
                        keyHeaderLabel.trailingAnchor.constraint(equalTo: shape.trailingAnchor, constant: -inset)
                ])
                let fontSize: CGFloat = isPhoneInterface ? 9 : 10
                keyHeaderLabel.font = .systemFont(ofSize: fontSize)
                keyHeaderLabel.textAlignment = alignment
                keyHeaderLabel.textColor = foreColor.withAlphaComponent(0.6)
                keyHeaderLabel.text = text
        }
        func setupKeyFooterLabel(text: String?, alignment: NSTextAlignment = .right) {
                let keyFooterLabel: UILabel = UILabel()
                shape.addSubview(keyFooterLabel)
                keyFooterLabel.translatesAutoresizingMaskIntoConstraints = false
                let inset: CGFloat = isPhoneInterface ? 2 : 4
                NSLayoutConstraint.activate([
                        keyFooterLabel.bottomAnchor.constraint(equalTo: shape.bottomAnchor, constant: -inset),
                        keyFooterLabel.leadingAnchor.constraint(equalTo: shape.leadingAnchor, constant: inset),
                        keyFooterLabel.trailingAnchor.constraint(equalTo: shape.trailingAnchor, constant: -inset)
                ])
                let fontSize: CGFloat = isPhoneInterface ? 9 : 10
                keyFooterLabel.font = .systemFont(ofSize: fontSize)
                keyFooterLabel.textAlignment = alignment
                keyFooterLabel.textColor = foreColor.withAlphaComponent(0.6)
                keyFooterLabel.text = text
        }
        func setupKeyImageView(constant: CGFloat = 10) {
                let keyImageView: UIImageView = UIImageView()
                let constantValue: CGFloat = {
                        if !isPhoneInterface {
                                return isPadLandscape ? (constant * 2) : (constant + 5)
                        }
                        if !isPhonePortrait { return constant - 3 }
                        return constant
                }()
                shape.addSubview(keyImageView)
                keyImageView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        keyImageView.topAnchor.constraint(equalTo: shape.topAnchor, constant: constantValue),
                        keyImageView.bottomAnchor.constraint(equalTo: shape.bottomAnchor, constant: -constantValue),
                        keyImageView.leadingAnchor.constraint(equalTo: shape.leadingAnchor),
                        keyImageView.trailingAnchor.constraint(equalTo: shape.trailingAnchor)
                ])
                keyImageView.contentMode = .scaleAspectFit
                if let imageName: String = keyImageName {
                        keyImageView.image = UIImage(systemName: imageName)?.withTintColor(foreColor)
                }
        }
}
