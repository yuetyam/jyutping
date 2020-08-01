import UIKit

extension KeyButton {
        func setupKeyButtonView() {
                var horizontalConstant: CGFloat {
                        switch traitCollection.userInterfaceIdiom {
                        case .phone:
                                return 3
                        case .pad:
                                // Keyboard is floating if width ≈ iPhone screen
                                return viewController.view.bounds.width < 500 ? 2 : 5
                        default:
                                return 3
                        }
                }
                var verticalConstant: CGFloat {
                        if traitCollection.userInterfaceIdiom == .phone && UIScreen.main.bounds.width > UIScreen.main.bounds.height {
                                return 3
                        } else {
                                return 5
                        }
                }
                keyButtonView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(keyButtonView)
                keyButtonView.topAnchor.constraint(equalTo: topAnchor, constant: verticalConstant).isActive = true
                keyButtonView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalConstant).isActive = true
                keyButtonView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalConstant).isActive = true
                keyButtonView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalConstant).isActive = true
                keyButtonView.isUserInteractionEnabled = false
                keyButtonView.backgroundColor = buttonColor
                keyButtonView.tintColor = buttonTintColor
                
                keyButtonView.layer.cornerRadius = 5
                keyButtonView.layer.cornerCurve = .continuous
                keyButtonView.layer.shadowColor = UIColor.black.cgColor
                keyButtonView.layer.shadowOpacity = 0.3
                keyButtonView.layer.shadowOffset = CGSize(width: 0, height: 1)
                keyButtonView.layer.shadowRadius = 0.5
                keyButtonView.layer.shouldRasterize = true
                keyButtonView.layer.rasterizationScale = UIScreen.main.scale
                keyButtonView.layer.shadowPath = nil
        }
        
        func setupKeyTextLabel() {
                keyTextLabel.translatesAutoresizingMaskIntoConstraints = false
                keyButtonView.addSubview(keyTextLabel)
                keyTextLabel.topAnchor.constraint(equalTo: keyButtonView.topAnchor).isActive = true
                keyTextLabel.bottomAnchor.constraint(equalTo: keyButtonView.bottomAnchor).isActive = true
                keyTextLabel.leadingAnchor.constraint(equalTo: keyButtonView.leadingAnchor).isActive = true
                keyTextLabel.trailingAnchor.constraint(equalTo: keyButtonView.trailingAnchor).isActive = true
                keyTextLabel.textAlignment = .center
                keyTextLabel.adjustsFontForContentSizeCategory = true
                keyTextLabel.font = styledFont
                keyTextLabel.text = keyText
                keyTextLabel.textColor = buttonTintColor
        }
        
        func setupKeyImageView(constant: CGFloat = 10) {
                var constant: CGFloat = constant
                if traitCollection.userInterfaceIdiom == .pad {
                        if viewController.view.bounds.width < 500 {
                                // floating, same as iPhone
                                
                        } else if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
                                // landscape
                                constant = constant * 2
                        } else {
                                constant += 5
                        }
                } else {
                        if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
                                // iPhone landscape
                                constant -= 3
                        }
                }
                
                keyImageView.translatesAutoresizingMaskIntoConstraints = false
                keyButtonView.addSubview(keyImageView)
                keyImageView.topAnchor.constraint(equalTo: keyButtonView.topAnchor, constant: constant).isActive = true
                keyImageView.bottomAnchor.constraint(equalTo: keyButtonView.bottomAnchor, constant: -constant).isActive = true
                keyImageView.leadingAnchor.constraint(equalTo: keyButtonView.leadingAnchor).isActive = true
                keyImageView.trailingAnchor.constraint(equalTo: keyButtonView.trailingAnchor).isActive = true
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
        
        /*
        func previewPath(minWidth: CGFloat, height: CGFloat, cornerRadius: CGFloat) -> UIBezierPath {
                
                let distance: CGFloat = (height - minWidth) / 2
                let curveDistance: CGFloat = distance * 3 / 2
                let squareHeight: CGFloat = height - curveDistance
                let controlDistance: CGFloat = curveDistance / 3
                
                let path: UIBezierPath = UIBezierPath()
                path.move(to: CGPoint(x: distance, y: height))
                path.addCurve(to: CGPoint(x: 0, y: squareHeight), controlPoint1: CGPoint(x: distance, y: height - controlDistance), controlPoint2: CGPoint(x: 0, y: height - controlDistance))
                
                path.addLine(to: CGPoint(x: 0, y: cornerRadius))
                path.addArc(withCenter: CGPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: CGFloat.pi, endAngle: (3 * CGFloat.pi / 2), clockwise: true)
                
                path.addLine(to: CGPoint(x: height - cornerRadius, y: 0))
                path.addArc(withCenter: CGPoint(x: height - cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: (3 * CGFloat.pi / 2), endAngle: 0, clockwise: true)
                
                path.addLine(to: CGPoint(x: height, y: squareHeight))
                path.addCurve(to: CGPoint(x: minWidth + distance, y: height), controlPoint1: CGPoint(x: height, y: height - controlDistance), controlPoint2: CGPoint(x: minWidth + distance, y: height - controlDistance))
                
                path.close()
                return path
        }
        */
        
        func previewBezierPath(origin: CGPoint, end: CGPoint, height: CGFloat, cornerRadius: CGFloat) -> UIBezierPath {
                let minWidth = end.x - origin.x
                let distance: CGFloat = (height - minWidth) / 2
                let curveDistance: CGFloat = distance * 3 / 2
                let controlDistance: CGFloat = curveDistance / 3
                
                let path: UIBezierPath = UIBezierPath()
                path.move(to: origin)
                path.addCurve(to: CGPoint(x: origin.x - distance, y: origin.y - curveDistance),
                              controlPoint1: CGPoint(x: origin.x, y: origin.y - controlDistance),
                              controlPoint2: CGPoint(x: origin.x - distance, y: origin.y - controlDistance))
                
                path.addLine(to: CGPoint(x: origin.x - distance, y: origin.y - height + cornerRadius))
                path.addArc(withCenter: CGPoint(x: origin.x - distance + cornerRadius, y: origin.y - height + cornerRadius),
                            radius: cornerRadius,
                            startAngle: CGFloat.pi,
                            endAngle: (3 * CGFloat.pi / 2),
                            clockwise: true)
                
                path.addLine(to: CGPoint(x: origin.x - distance + height - cornerRadius, y: origin.y - height))
                path.addArc(withCenter: CGPoint(x: origin.x - distance + height - cornerRadius, y: origin.y - height + cornerRadius),
                            radius: cornerRadius,
                            startAngle: (3 * CGFloat.pi / 2),
                            endAngle: 0,
                            clockwise: true)
                
                path.addLine(to: CGPoint(x: end.x + distance, y: end.y - curveDistance))
                path.addCurve(to: end,
                              controlPoint1: CGPoint(x: end.x + distance, y: end.y - controlDistance),
                              controlPoint2: CGPoint(x: end.x, y: end.y - controlDistance))
                
                path.close()
                return path
        }
        func previewStartPath(rect: CGRect) -> UIBezierPath {
                let path: UIBezierPath = UIBezierPath()
                path.move(to: rect.origin)
                path.addLine(to: CGPoint(x: rect.origin.x + rect.width, y: rect.origin.y))
                path.addLine(to: CGPoint(x: rect.origin.x + rect.width, y: rect.origin.y + rect.height))
                path.addLine(to: CGPoint(x: rect.origin.x, y: rect.origin.y + rect.height))
                path.close()
                return path
        }
}
