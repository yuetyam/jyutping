import UIKit

extension KeyButton {
        func setupKeyButtonView() {
                var horizontalConstant: CGFloat {
                        switch viewController.traitCollection.userInterfaceIdiom {
                        case .phone:
                                return 3
                        case .pad:
                                // Keyboard is floating if width ≈ iPhone screen
                                // .compact <==> floating
                                if viewController.traitCollection.horizontalSizeClass == .compact || viewController.view.frame.width < 500 {
                                        return 2
                                } else {
                                        return 5
                                }
                        default:
                                return 3
                        }
                }
                var verticalConstant: CGFloat {
                        if viewController.traitCollection.userInterfaceIdiom == .phone && viewController.traitCollection.verticalSizeClass == .compact {
                                return 3
                        } else {
                                return 5
                        }
                }
                addSubview(keyButtonView)
                keyButtonView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        keyButtonView.topAnchor.constraint(equalTo: topAnchor, constant: verticalConstant),
                        keyButtonView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalConstant),
                        keyButtonView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalConstant),
                        keyButtonView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalConstant)
                ])
                keyButtonView.isUserInteractionEnabled = false
                keyButtonView.tintColor = buttonTintColor
                keyButtonView.layer.cornerRadius = 5
                keyButtonView.layer.cornerCurve = .continuous
                keyButtonView.layer.shadowColor = UIColor.black.cgColor
                keyButtonView.layer.shadowOpacity = 0.3
                keyButtonView.layer.shadowOffset = CGSize(width: 0, height: 1)
                keyButtonView.layer.shadowRadius = 0.5
                keyButtonView.layer.shouldRasterize = true
                keyButtonView.layer.rasterizationScale = UIScreen.main.scale
                // keyButtonView.layer.shadowPath = nil

                guard viewController.isDarkAppearance else {
                        keyButtonView.backgroundColor = buttonColor
                        return
                }
                let effectView: BlurEffectView = {
                        switch keyboardEvent {
                        case .key, .space:
                                return BlurEffectView(fraction: 0.44, effectStyle: .extraLight)
                        default:
                                return BlurEffectView(fraction: 0.48, effectStyle: .light)
                        }
                }()
                let blurEffectView: UIVisualEffectView = effectView
                blurEffectView.frame = keyButtonView.bounds
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                blurEffectView.layer.cornerRadius = 5
                blurEffectView.layer.cornerCurve = .continuous
                blurEffectView.clipsToBounds = true
                keyButtonView.addSubview(blurEffectView)
        }
        
        func setupKeyTextLabel() {
                let keyTextLabel: UILabel = UILabel()
                keyButtonView.addSubview(keyTextLabel)
                keyTextLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        keyTextLabel.topAnchor.constraint(equalTo: keyButtonView.topAnchor),
                        keyTextLabel.bottomAnchor.constraint(equalTo: keyButtonView.bottomAnchor),
                        keyTextLabel.leadingAnchor.constraint(equalTo: keyButtonView.leadingAnchor),
                        keyTextLabel.trailingAnchor.constraint(equalTo: keyButtonView.trailingAnchor)
                ])
                keyTextLabel.textAlignment = .center
                keyTextLabel.font = styledFont
                keyTextLabel.text = keyText
                keyTextLabel.textColor = buttonTintColor
        }
        func setupKeyHeaderLabel(text: String?) {
                let keyHeaderLabel: UILabel = UILabel()
                keyButtonView.addSubview(keyHeaderLabel)
                keyHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        keyHeaderLabel.topAnchor.constraint(equalTo: keyButtonView.topAnchor, constant: 2),
                        keyHeaderLabel.leadingAnchor.constraint(equalTo: keyButtonView.leadingAnchor,constant: 2),
                        keyHeaderLabel.trailingAnchor.constraint(equalTo: keyButtonView.trailingAnchor, constant: -2)
                ])
                keyHeaderLabel.font = .systemFont(ofSize: 10)
                keyHeaderLabel.textAlignment = .right
                keyHeaderLabel.text = text
                keyHeaderLabel.textColor = buttonTintColor.withAlphaComponent(0.7)
        }
        func setupKeyFooterLabel(text: String?) {
                let keyFooterLabel: UILabel = UILabel()
                keyButtonView.addSubview(keyFooterLabel)
                keyFooterLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        keyFooterLabel.bottomAnchor.constraint(equalTo: keyButtonView.bottomAnchor, constant: -2),
                        keyFooterLabel.leadingAnchor.constraint(equalTo: keyButtonView.leadingAnchor, constant: 2),
                        keyFooterLabel.trailingAnchor.constraint(equalTo: keyButtonView.trailingAnchor, constant: -2)
                ])
                keyFooterLabel.font = .systemFont(ofSize: 10)
                keyFooterLabel.textAlignment = .right
                keyFooterLabel.text = text
                keyFooterLabel.textColor = buttonTintColor.withAlphaComponent(0.7)
        }
        func setupKeyImageView(constant: CGFloat = 10) {
                let keyImageView: UIImageView = UIImageView()
                var constant: CGFloat = constant
                if viewController.traitCollection.userInterfaceIdiom == .pad {
                        if viewController.traitCollection.horizontalSizeClass == .compact || viewController.view.frame.width < 500 {
                                // Floating on iPad, same as iPhone
                                
                        } else if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
                                // iPad landscape
                                constant = constant * 2
                        } else {
                                constant += 5
                        }
                } else {
                        if viewController.traitCollection.verticalSizeClass == .compact {
                                // iPhone landscape
                                constant -= 3
                        }
                }
                keyButtonView.addSubview(keyImageView)
                keyImageView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        keyImageView.topAnchor.constraint(equalTo: keyButtonView.topAnchor, constant: constant),
                        keyImageView.bottomAnchor.constraint(equalTo: keyButtonView.bottomAnchor, constant: -constant),
                        keyImageView.leadingAnchor.constraint(equalTo: keyButtonView.leadingAnchor),
                        keyImageView.trailingAnchor.constraint(equalTo: keyButtonView.trailingAnchor)
                ])
                keyImageView.contentMode = .scaleAspectFit
                keyImageView.image = keyImage?.withTintColor(buttonTintColor)
        }
        
        /*
        func makeShadow(color: UIColor = .black, opacity: Float = 0.3, x: CGFloat = 0, y: CGFloat = 1, blur: CGFloat = 1, spread: CGFloat = 0) {
                layer.shadowColor = color.cgColor
                layer.shadowOpacity = opacity
                layer.shadowOffset = CGSize(width: x, height: y)
                layer.shadowRadius = blur / 2.0
                layer.shouldRasterize = true
                layer.rasterizationScale = UIScreen.main.scale
                if spread == 0 {
                        layer.shadowPath = nil
                } else {
                        let dx = -spread
                        let rect = bounds.insetBy(dx: dx, dy: dx)
                        layer.shadowPath = UIBezierPath(rect: rect).cgPath
                }
        }
        */
}
