import UIKit

extension KeyView {
        func setupKeyShapeView() {
                let horizontalConstant: CGFloat = {
                        switch keyboardInterface {
                        case .phonePortrait, .phoneLandscape:
                                return 3
                        case .padFloating:
                                return 2
                        case .padPortraitSmall, .padPortraitMedium, .padPortraitLarge:
                                return 5
                        case .padLandscapeSmall, .padLandscapeMedium, .padLandscapeLarge:
                                return 5
                        }
                }()
                let verticalConstant: CGFloat = (keyboardInterface == .phoneLandscape) ? 3 : 5
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
                shape.layer.shadowOpacity = isDarkAppearance ? 1 : 0.3
                shape.layer.shadowOffset = CGSize(width: 0, height: 1)
                shape.layer.shadowRadius = 0.5
                shape.layer.shouldRasterize = true
                shape.layer.rasterizationScale = UIScreen.main.scale

                guard isDarkAppearance else {
                        shape.backgroundColor = backColor
                        return
                }

                /*
                let shapeColor: UIColor = {
                        if isDarkAppearance {
                                return deepDarkFantasy ? UIColor(white: 1, alpha: 0.15) : UIColor(white: 1, alpha: 0.35)
                        } else {
                                return deepDarkFantasy ? .lightEmphatic : .white
                        }
                }()
                */

                let effectView: BlurEffectView = deepDarkFantasy ? BlurEffectView(fraction: 0.48, effectStyle: .light) : BlurEffectView(fraction: 0.44, effectStyle: .extraLight)
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
                let inset: CGFloat = keyboardInterface.isCompact ? 2 : 4
                NSLayoutConstraint.activate([
                        keyHeaderLabel.topAnchor.constraint(equalTo: shape.topAnchor, constant: inset),
                        keyHeaderLabel.leadingAnchor.constraint(equalTo: shape.leadingAnchor,constant: inset),
                        keyHeaderLabel.trailingAnchor.constraint(equalTo: shape.trailingAnchor, constant: -inset)
                ])
                let fontSize: CGFloat = keyboardInterface.isCompact ? 9 : 10
                keyHeaderLabel.font = .systemFont(ofSize: fontSize)
                keyHeaderLabel.textAlignment = alignment
                keyHeaderLabel.textColor = foreColor.withAlphaComponent(0.6)
                keyHeaderLabel.text = text
        }
        func setupKeyFooterLabel(text: String?, alignment: NSTextAlignment = .right) {
                let keyFooterLabel: UILabel = UILabel()
                shape.addSubview(keyFooterLabel)
                keyFooterLabel.translatesAutoresizingMaskIntoConstraints = false
                let inset: CGFloat = keyboardInterface.isCompact ? 2 : 4
                NSLayoutConstraint.activate([
                        keyFooterLabel.bottomAnchor.constraint(equalTo: shape.bottomAnchor, constant: -inset),
                        keyFooterLabel.leadingAnchor.constraint(equalTo: shape.leadingAnchor, constant: inset),
                        keyFooterLabel.trailingAnchor.constraint(equalTo: shape.trailingAnchor, constant: -inset)
                ])
                let fontSize: CGFloat = keyboardInterface.isCompact ? 9 : 10
                keyFooterLabel.font = .systemFont(ofSize: fontSize)
                keyFooterLabel.textAlignment = alignment
                keyFooterLabel.textColor = foreColor.withAlphaComponent(0.6)
                keyFooterLabel.text = text
        }
        func setupKeyImageView(offset: CGFloat = 11) {
                let constant: CGFloat = {
                        // FIXME: Adjust offsets
                        switch keyboardInterface {
                        case .padLandscapeSmall, .padLandscapeMedium, .padLandscapeLarge:
                                return offset + 9
                        case .padPortraitSmall, .padPortraitMedium, .padPortraitLarge:
                                return offset + 6
                        case .phoneLandscape:
                                return offset - 3
                        case .phonePortrait:
                                return offset
                        case .padFloating:
                                return offset
                        }
                }()
                let keyImageView: UIImageView = UIImageView()
                shape.addSubview(keyImageView)
                keyImageView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        keyImageView.topAnchor.constraint(equalTo: shape.topAnchor, constant: constant),
                        keyImageView.bottomAnchor.constraint(equalTo: shape.bottomAnchor, constant: -constant),
                        keyImageView.leadingAnchor.constraint(equalTo: shape.leadingAnchor),
                        keyImageView.trailingAnchor.constraint(equalTo: shape.trailingAnchor)
                ])
                keyImageView.contentMode = .scaleAspectFit
                if let imageName: String = keyImageName {
                        keyImageView.image = UIImage(systemName: imageName)?.withTintColor(foreColor)
                } else {
                        keyImageView.image = UIImage(named: "EmojiSmiley")?.withTintColor(foreColor)
                }
        }
}
