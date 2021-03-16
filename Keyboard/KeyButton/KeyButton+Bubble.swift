import UIKit

extension KeyButton {

        func keyShapeBezierPath(origin: CGPoint, keyWidth: CGFloat, keyHeight: CGFloat, keyCornerRadius: CGFloat) -> UIBezierPath {

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

        func rightBubblePath(origin: CGPoint, previewCornerRadius: CGFloat, keyWidth: CGFloat, keyHeight: CGFloat, keyCornerRadius: CGFloat, count: CGFloat = 1) -> UIBezierPath {

                //    +-----------------------e------------+------------a---+
                //    +   |                   +            +            |   +
                //    E...F                   +            +            b...+
                //    +                       +            +                +
                //    +                       +            +                +
                //    +                       +            +            d...c
                //    D                       +            +            |   +
                //     .                      J------------+----------------+
                //       .                   .
                //        C               K
                //        +               +
                //        +               +
                //        +...B       M...L
                //        +   |       |   +
                //        +---A---o-------+

                let expansionWidth: CGFloat = keyWidth / 2.5
                let curveDistance: CGFloat = expansionWidth * 1.5
                let controlDistance: CGFloat = curveDistance / 3
                let maxWidth: CGFloat = keyWidth + (expansionWidth * 2)

                let pointA: CGPoint = CGPoint(x: origin.x - (keyWidth / 2) + keyCornerRadius, y: origin.y)
                let pointBArcCenter: CGPoint = CGPoint(x: pointA.x, y: pointA.y - keyCornerRadius)
                let pointC: CGPoint = CGPoint(x: origin.x - (keyWidth / 2), y: origin.y - keyHeight)

                let pointD: CGPoint = CGPoint(x: pointC.x - expansionWidth, y: pointC.y - curveDistance)
                let curve1Control1: CGPoint = CGPoint(x: pointC.x, y: pointC.y - controlDistance)
                let curve1Control2: CGPoint = CGPoint(x: pointD.x, y: curve1Control1.y)

                let pointE: CGPoint = CGPoint(x: pointD.x, y: pointD.y - keyHeight + previewCornerRadius + 5)
                let pointFArcCenter: CGPoint = CGPoint(x: pointE.x + previewCornerRadius, y: pointE.y)

                let pointExtE: CGPoint = CGPoint(x: pointE.x + maxWidth, y: pointE.y - previewCornerRadius)
                let extendWith: CGFloat = (keyWidth + 4) * count + previewCornerRadius
                let pointExtA: CGPoint = CGPoint(x: pointExtE.x + extendWith - previewCornerRadius, y: pointExtE.y)
                let pointExtBArcCenter: CGPoint = CGPoint(x: pointExtA.x, y: pointE.y)
                let pointExtC: CGPoint = CGPoint(x: pointExtA.x + previewCornerRadius, y: pointD.y)
                let pointExtDArcCenter: CGPoint = CGPoint(x: pointExtA.x, y: pointExtC.y)

                let pointJ: CGPoint = CGPoint(x: pointExtE.x, y: pointD.y + previewCornerRadius)
                let pointK: CGPoint = CGPoint(x: pointC.x + keyWidth, y: pointC.y)
                let control: CGFloat = (pointJ.x - pointK.x) / 3
                let curve2Control1: CGPoint = CGPoint(x: pointJ.x, y: pointK.y - control * 2)
                let curve2Control2: CGPoint = CGPoint(x: pointK.x, y: curve2Control1.y)

                let pointL: CGPoint = CGPoint(x: origin.x + (keyWidth / 2), y: pointBArcCenter.y)
                let pointMArcCenter: CGPoint = CGPoint(x: pointL.x - keyCornerRadius, y: pointL.y)

                let path: UIBezierPath = UIBezierPath()
                path.move(to: origin)

                path.addLine(to: pointA)
                path.addArc(withCenter: pointBArcCenter, radius: keyCornerRadius, startAngle: (CGFloat.pi * 3 / 2), endAngle: CGFloat.pi, clockwise: true)

                path.addLine(to: pointC)
                path.addCurve(to: pointD, controlPoint1: curve1Control1, controlPoint2: curve1Control2)

                path.addLine(to: pointE)
                path.addArc(withCenter: pointFArcCenter, radius: previewCornerRadius, startAngle: CGFloat.pi, endAngle: (CGFloat.pi * 3 / 2), clockwise: true)

                path.addLine(to: pointExtA)
                path.addArc(withCenter: pointExtBArcCenter, radius: previewCornerRadius, startAngle: (CGFloat.pi / 2), endAngle: 0, clockwise: true)
                path.addLine(to: pointExtC)
                path.addArc(withCenter: pointExtDArcCenter, radius: previewCornerRadius, startAngle: 0, endAngle: (CGFloat.pi / 2), clockwise: true)

                path.addLine(to: pointJ)
                path.addCurve(to: pointK, controlPoint1: curve2Control1, controlPoint2: curve2Control2)

                path.addLine(to: pointL)
                path.addArc(withCenter: pointMArcCenter, radius: keyCornerRadius, startAngle: 0, endAngle: (CGFloat.pi / 2), clockwise: true)

                path.close()
                return path
        }

        func leftBubblePath(origin: CGPoint, previewCornerRadius: CGFloat, keyWidth: CGFloat, keyHeight: CGFloat, keyCornerRadius: CGFloat, count: CGFloat = 1) -> UIBezierPath {

                //    +-----------+-----------+-------------------G---+
                //    +   |       +           +                   |   +
                //    c...d       +           +                   H...+
                //    +           +           +                       +
                //    +           +           +                       +
                //    +...b       +           +                       +
                //    +   |       +           +                       J
                //    +---a-------+-----------D                      .
                //                                .                 .
                //                                  C               K
                //                                  +               +
                //                                  +               +
                //                                  +...B       M...L
                //                                  +   |       |   +
                //                                  +---A---o-------+

                let expansionWidth: CGFloat = keyWidth / 2.5
                let curveDistance: CGFloat = expansionWidth * 1.5
                let controlDistance: CGFloat = curveDistance / 3
                let maxWidth: CGFloat = keyWidth + (expansionWidth * 2)

                let pointA: CGPoint = CGPoint(x: origin.x - (keyWidth / 2) + keyCornerRadius, y: origin.y)
                let pointBArcCenter: CGPoint = CGPoint(x: pointA.x, y: pointA.y - keyCornerRadius)
                let pointC: CGPoint = CGPoint(x: origin.x - (keyWidth / 2), y: origin.y - keyHeight)

                let pointK: CGPoint = CGPoint(x: pointC.x + keyWidth, y: pointC.y)
                let pointJ: CGPoint = CGPoint(x: pointK.x + expansionWidth, y: pointK.y - curveDistance)
                let curve2Control1: CGPoint = CGPoint(x: pointJ.x, y: pointK.y - controlDistance)
                let curve2Control2: CGPoint = CGPoint(x: pointK.x, y: curve2Control1.y)

                let pointHArcCenter: CGPoint = CGPoint(x: pointJ.x - previewCornerRadius, y: pointJ.y - keyHeight + previewCornerRadius + 5)
                let pointG: CGPoint = CGPoint(x: pointHArcCenter.x, y: pointHArcCenter.y - previewCornerRadius)

                let pointD: CGPoint = CGPoint(x: pointJ.x - maxWidth, y: pointJ.y + previewCornerRadius)
                let extendWith: CGFloat = (keyWidth + 4) * count + previewCornerRadius
                let pointExtA: CGPoint = CGPoint(x: pointD.x - extendWith + previewCornerRadius, y: pointD.y)
                let pointExtBArcCenter: CGPoint = CGPoint(x: pointExtA.x, y: pointExtA.y - previewCornerRadius)
                let pointExtC: CGPoint = CGPoint(x: pointExtA.x - previewCornerRadius, y: pointHArcCenter.y)
                let pointExtDArcCenter: CGPoint = CGPoint(x: pointExtBArcCenter.x, y: pointExtC.y)
                let control: CGFloat = (pointC.x - pointD.x) / 3
                let curve1Control1: CGPoint = CGPoint(x: pointC.x, y: pointC.y - control * 2)
                let curve1Control2: CGPoint = CGPoint(x: pointD.x, y: curve1Control1.y)

                let pointL: CGPoint = CGPoint(x: origin.x + (keyWidth / 2), y: pointBArcCenter.y)
                let pointMArcCenter: CGPoint = CGPoint(x: pointL.x - keyCornerRadius, y: pointL.y)

                let path: UIBezierPath = UIBezierPath()
                path.move(to: origin)

                path.addLine(to: pointA)
                path.addArc(withCenter: pointBArcCenter, radius: keyCornerRadius, startAngle: (CGFloat.pi * 3 / 2), endAngle: CGFloat.pi, clockwise: true)

                path.addLine(to: pointC)
                path.addCurve(to: pointD, controlPoint1: curve1Control1, controlPoint2: curve1Control2)

                path.addLine(to: pointExtA)
                path.addArc(withCenter: pointExtBArcCenter, radius: previewCornerRadius, startAngle: CGFloat.pi / 2, endAngle: CGFloat.pi, clockwise: true)

                path.addLine(to: pointExtC)
                path.addArc(withCenter: pointExtDArcCenter, radius: previewCornerRadius, startAngle: CGFloat.pi, endAngle: (CGFloat.pi * 3 / 2), clockwise: true)

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
