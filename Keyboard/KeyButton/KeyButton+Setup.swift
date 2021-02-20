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
                        case .text, .space:
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
                keyButtonView.addSubview(keyTextLabel)
                keyTextLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        keyTextLabel.topAnchor.constraint(equalTo: keyButtonView.topAnchor),
                        keyTextLabel.bottomAnchor.constraint(equalTo: keyButtonView.bottomAnchor),
                        keyTextLabel.leadingAnchor.constraint(equalTo: keyButtonView.leadingAnchor),
                        keyTextLabel.trailingAnchor.constraint(equalTo: keyButtonView.trailingAnchor)
                ])
                keyTextLabel.textAlignment = .center
                keyTextLabel.adjustsFontForContentSizeCategory = true
                keyTextLabel.font = styledFont
                keyTextLabel.text = keyText
                keyTextLabel.textColor = buttonTintColor
        }
        
        func setupKeyImageView(constant: CGFloat = 10) {
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
        
        func previewBezierPath(origin: CGPoint, previewCornerRadius: CGFloat, keyWidth: CGFloat, keyHeight: CGFloat, keyCornerRadius: CGFloat) -> UIBezierPath {
                
                //    +-------------------G---+
                //    +   |               |   +
                //    E...F               H...+
                //    +                       +
                //    +                       +
                //    D                       J
                //     .                     .
                //       .                 .
                //        C               K
                //        +               +
                //        +               +
                //        +...B       M...L
                //        +   |       |   +
                //        +---A---o-------+
                
                
                // TODO: - More details
                let expansionWidth: CGFloat = keyWidth / 2.5
                let curveDistance: CGFloat = expansionWidth * 1.5
                let controlDistance: CGFloat = curveDistance / 3
                
                let pointA: CGPoint = CGPoint(x: origin.x - (keyWidth / 2) + keyCornerRadius, y: origin.y)
                let pointBArcCenter: CGPoint = CGPoint(x: pointA.x, y: pointA.y - keyCornerRadius)
                let pointC: CGPoint = CGPoint(x: origin.x - (keyWidth / 2), y: origin.y - keyHeight)
                
                let pointD: CGPoint = CGPoint(x: pointC.x - expansionWidth, y: pointC.y - curveDistance)
                let curve1Control1: CGPoint = CGPoint(x: pointC.x, y: pointC.y - controlDistance)
                let curve1Control2: CGPoint = CGPoint(x: pointD.x, y: curve1Control1.y)
                
                let pointE: CGPoint = CGPoint(x: pointD.x, y: pointD.y - keyHeight + previewCornerRadius + 5)
                let pointFArcCenter: CGPoint = CGPoint(x: pointE.x + previewCornerRadius, y: pointE.y)
                
                let maxWidth: CGFloat = keyWidth + (expansionWidth * 2)
                let pointG: CGPoint = CGPoint(x: pointFArcCenter.x + (maxWidth - previewCornerRadius * 2), y: pointFArcCenter.y - previewCornerRadius)
                let pointHArcCenter: CGPoint = CGPoint(x: pointG.x, y: pointFArcCenter.y)
                
                let pointJ: CGPoint = CGPoint(x: pointHArcCenter.x + previewCornerRadius, y: pointD.y)
                let pointK: CGPoint = CGPoint(x: pointC.x + keyWidth, y: pointC.y)
                let curve2Control1: CGPoint = CGPoint(x: pointJ.x, y: curve1Control1.y)
                let curve2Control2: CGPoint = CGPoint(x: pointK.x, y: curve2Control1.y)
                
                let pointL: CGPoint = CGPoint(x: origin.x + (keyWidth / 2), y: pointBArcCenter.y)
                let pointMArcCenter: CGPoint = CGPoint(x: pointL.x - keyCornerRadius, y: pointL.y)
                
                let path: UIBezierPath = UIBezierPath()
                path.move(to: origin)
                
                path.addLine(to: pointA)
                path.addArc(withCenter: pointBArcCenter, radius: keyCornerRadius, startAngle: (3 * CGFloat.pi / 2), endAngle: CGFloat.pi, clockwise: true)
                
                path.addLine(to: pointC)
                path.addCurve(to: pointD, controlPoint1: curve1Control1, controlPoint2: curve1Control2)
                
                path.addLine(to: pointE)
                path.addArc(withCenter: pointFArcCenter, radius: previewCornerRadius, startAngle: CGFloat.pi, endAngle: (3 * CGFloat.pi / 2), clockwise: true)
                
                path.addLine(to: pointG)
                path.addArc(withCenter: pointHArcCenter, radius: previewCornerRadius, startAngle: (CGFloat.pi / 2), endAngle: 0, clockwise: true)
                
                path.addLine(to: pointJ)
                path.addCurve(to: pointK, controlPoint1: curve2Control1, controlPoint2: curve2Control2)
                
                path.addLine(to: pointL)
                path.addArc(withCenter: pointMArcCenter, radius: keyCornerRadius, startAngle: 0, endAngle: (CGFloat.pi / 2), clockwise: true)
                
                path.close()
                return path
        }
        
        func startBezierPath(origin: CGPoint, keyWidth: CGFloat, keyHeight: CGFloat, keyCornerRadius: CGFloat) -> UIBezierPath {
                
                //    +-----------E---+
                //    +   |       |   +
                //    C...D       F...+
                //    +               +
                //    +               +
                //    +...B       H...G
                //    +   |       |   +
                //    +---A---o-------+
                
                let pointA: CGPoint = CGPoint(x: origin.x - (keyWidth / 2) + keyCornerRadius, y: origin.y)
                let pointBArcCenter: CGPoint = CGPoint(x: pointA.x, y: pointA.y - keyCornerRadius)
                let pointC: CGPoint = CGPoint(x: pointA.x - keyCornerRadius, y: origin.y - keyHeight + keyCornerRadius)
                let pointDArcCenter: CGPoint = CGPoint(x: pointA.x, y: pointC.y)
                let pointFArcCenter: CGPoint = CGPoint(x: origin.x + (keyWidth / 2) - keyCornerRadius, y: pointDArcCenter.y)
                let pointE: CGPoint = CGPoint(x: pointFArcCenter.x, y: pointFArcCenter.y - keyCornerRadius)
                let pointG: CGPoint = CGPoint(x: pointFArcCenter.x + keyCornerRadius, y: pointBArcCenter.y)
                let pointHArcCenter: CGPoint = CGPoint(x: pointFArcCenter.x, y: pointG.y)
                
                let stepHeight: CGFloat = (pointBArcCenter.y - pointC.y) / 3
                let pointB1C: CGPoint = CGPoint(x: pointC.x, y: pointBArcCenter.y - stepHeight)
                let pointB2C: CGPoint = CGPoint(x: pointC.x, y: pointB1C.y - stepHeight)
                let pointF1G: CGPoint = CGPoint(x: pointG.x, y: pointFArcCenter.y + stepHeight)
                let pointF2G: CGPoint = CGPoint(x: pointG.x, y: pointF1G.y + stepHeight)
                let stepWidth: CGFloat = (pointE.x - pointDArcCenter.x) / 3
                let pointD1E: CGPoint = CGPoint(x: pointDArcCenter.x + stepWidth, y: pointE.y)
                let pointD2E: CGPoint = CGPoint(x: pointD1E.x + stepWidth, y: pointE.y)
                
                let path: UIBezierPath = UIBezierPath()
                path.move(to: origin)
                path.addLine(to: pointA)
                path.addArc(withCenter: pointBArcCenter, radius: keyCornerRadius, startAngle: (3 * CGFloat.pi / 2), endAngle: CGFloat.pi, clockwise: true)
                path.addLine(to: pointB1C)
                path.addLine(to: pointB2C)
                path.addLine(to: pointC)
                path.addArc(withCenter: pointDArcCenter, radius: keyCornerRadius, startAngle: CGFloat.pi, endAngle: (3 * CGFloat.pi / 2), clockwise: true)
                path.addLine(to: pointD1E)
                path.addLine(to: pointD2E)
                path.addLine(to: pointE)
                path.addArc(withCenter: pointFArcCenter, radius: keyCornerRadius, startAngle: (3 * CGFloat.pi / 2), endAngle: 0, clockwise: true)
                path.addLine(to: pointF1G)
                path.addLine(to: pointF2G)
                path.addLine(to: pointG)
                path.addArc(withCenter: pointHArcCenter, radius: keyCornerRadius, startAngle: 0, endAngle: (CGFloat.pi / 2), clockwise: true)
                path.close()
                
                return path
        }
}
