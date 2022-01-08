import UIKit

final class EmojiCell: UICollectionViewCell {

        let emojiLabel: UILabel = UILabel()

        override init(frame: CGRect) {
                super.init(frame: frame)
                self.addSubview(emojiLabel)
                emojiLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        emojiLabel.topAnchor.constraint(equalTo: topAnchor),
                        emojiLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
                        emojiLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                        emojiLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])
                emojiLabel.font = .systemFont(ofSize: 34)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) { fatalError() }

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                super.touchesBegan(touches, with: event)
                displayPreview()
        }
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
                super.touchesEnded(touches, with: event)
                removePreview()
        }
        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
                super.touchesCancelled(touches, with: event)
                removePreview()
        }

        private func displayPreview() {
                layer.addSublayer(previewShapeLayer)
                addSubview(previewLabel)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.008) { [weak self] in
                        guard let self = self else { return }
                        self.previewLabel.text = self.emojiLabel.text
                }
        }
        private func removePreview() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) { [weak self] in
                        guard let self = self else { return }
                        self.previewLabel.text = nil
                        self.previewLabel.removeFromSuperview()
                        self.previewShapeLayer.removeFromSuperlayer()
                }
        }
        private lazy var previewShapeLayer: CAShapeLayer = {
                let layer = CAShapeLayer()
                layer.shadowOpacity = 0.5
                layer.shadowRadius = 1
                layer.shadowOffset = .zero
                layer.shadowColor = UIColor.black.cgColor
                layer.shouldRasterize = true
                layer.rasterizationScale = UIScreen.main.scale
                layer.path = originPath.cgPath
                layer.fillColor = traitCollection.userInterfaceStyle == .dark ? UIColor.gray.cgColor : UIColor.white.cgColor
                let animation = CABasicAnimation(keyPath: "path")
                animation.duration = 0.005
                animation.toValue = previewPath.cgPath
                animation.fillMode = .forwards
                animation.isRemovedOnCompletion = false
                animation.timingFunction = CAMediaTimingFunction(name: .default)
                layer.add(animation, forKey: animation.keyPath)
                return layer
        }()
        private lazy var previewLabel: UILabel = {
                let preview = previewPath.bounds
                let height: CGFloat = preview.height - keyHeight - 5
                let frame = CGRect(origin: preview.origin, size: CGSize(width: preview.width, height: height))
                let label = UILabel(frame: frame)
                label.textAlignment = .center
                label.font = .systemFont(ofSize: 34)
                return label
        }()
        private lazy var originPath: UIBezierPath = shapeBezierPath(origin: bottomCenter, keyWidth: keyWidth, keyHeight: keyHeight, keyCornerRadius: 5)
        private lazy var previewPath: UIBezierPath = previewBezierPath(origin: bottomCenter, previewCornerRadius: 10, keyWidth: keyWidth, keyHeight: keyHeight, keyCornerRadius: 5)
        private lazy var keyWidth: CGFloat = 35
        private lazy var keyHeight: CGFloat = 35
        private lazy var bottomCenter: CGPoint = CGPoint(x: emojiLabel.frame.midX, y: emojiLabel.frame.maxY)
}

/*
final class EmojiCollectionViewHeader: UICollectionReusableView {

        let textLabel: UILabel = UILabel()

        override init(frame: CGRect) {
                super.init(frame: frame)
                textLabel.font = .systemFont(ofSize: 17)
                addSubview(textLabel)
                textLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        textLabel.topAnchor.constraint(equalTo: topAnchor),
                        textLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
                        textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                        textLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])
        }

         @available(*, unavailable)
         required init?(coder: NSCoder) { fatalError() }
}
*/

private extension EmojiCell {
        func shapeBezierPath(origin: CGPoint, keyWidth: CGFloat, keyHeight: CGFloat, keyCornerRadius: CGFloat) -> UIBezierPath {

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

                let expansionWidth: CGFloat = keyWidth / 3.7
                let curveDistance: CGFloat = expansionWidth * 1.7
                let controlDistance: CGFloat = curveDistance / 3

                let pointA: CGPoint = CGPoint(x: origin.x - (keyWidth / 2) + keyCornerRadius, y: origin.y)
                let pointBArcCenter: CGPoint = CGPoint(x: pointA.x, y: pointA.y - keyCornerRadius)
                let pointC: CGPoint = CGPoint(x: origin.x - (keyWidth / 2), y: origin.y - keyHeight)

                let pointD: CGPoint = CGPoint(x: pointC.x - expansionWidth, y: pointC.y - curveDistance)
                let curve1Control1: CGPoint = CGPoint(x: pointC.x, y: pointC.y - controlDistance)
                let curve1Control2: CGPoint = CGPoint(x: pointD.x, y: curve1Control1.y)

                let pointE: CGPoint = CGPoint(x: pointD.x, y: pointD.y - keyHeight + previewCornerRadius - 2)
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
}
