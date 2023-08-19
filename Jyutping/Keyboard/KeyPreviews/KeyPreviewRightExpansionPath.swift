import SwiftUI

struct KeyPreviewRightExpansionPath: Shape {

        /// Count of the extras blocks
        let expansions: Int

        func path(in rect: CGRect) -> Path {
                let origin: CGPoint = CGPoint(x: rect.midX, y: rect.maxY)
                return Path.keyPreviewRightExpansionPath(origin: origin, previewCornerRadius: 10, keyWidth: rect.size.width, keyHeight: rect.size.height, keyCornerRadius: 5, expansions: expansions)
        }
}

extension Path {
        static func keyPreviewRightExpansionPath(origin: CGPoint, previewCornerRadius: CGFloat, keyWidth: CGFloat, keyHeight: CGFloat, keyCornerRadius: CGFloat, expansions: Int) -> Path {

                //    +-------------------------e------------+------------a---+
                //    +   |                     +            +            |   +
                //    E...F                     +            +            b...+
                //    +                         +            +                +
                //    +                         +            +                +
                //    +                         +            +            d...c
                //    +                         +            +            |   +
                //    D                         J------------+----------------+
                //     .                       .
                //       .                   .
                //         C               K
                //         +               +
                //         +               +
                //         +...B       M...L
                //         +   |       |   +
                //         +---A---o-------+

                let expansionWidth: CGFloat = keyWidth / 2.85
                let curveDistance: CGFloat = expansionWidth * 1.5
                let controlDistance: CGFloat = curveDistance / 3.0
                let peekWidth: CGFloat = keyWidth + (expansionWidth * 2)

                let pointA: CGPoint = CGPoint(x: origin.x - (keyWidth / 2.0) + keyCornerRadius, y: origin.y)
                let pointBArcCenter: CGPoint = CGPoint(x: pointA.x, y: pointA.y - keyCornerRadius)
                let pointC: CGPoint = CGPoint(x: origin.x - (keyWidth / 2.0), y: origin.y - keyHeight)

                let pointD: CGPoint = CGPoint(x: pointC.x - expansionWidth, y: pointC.y - curveDistance)
                let curve1Control1: CGPoint = CGPoint(x: pointC.x, y: pointC.y - controlDistance)
                let curve1Control2: CGPoint = CGPoint(x: pointD.x, y: curve1Control1.y)

                let pointE: CGPoint = CGPoint(x: pointD.x, y: pointD.y - keyHeight + previewCornerRadius)
                let pointFArcCenter: CGPoint = CGPoint(x: pointE.x + previewCornerRadius, y: pointE.y)

                let pointExtE: CGPoint = CGPoint(x: pointE.x + peekWidth, y: pointE.y - previewCornerRadius)
                let extendedWith: CGFloat = (keyWidth + 4) * CGFloat(expansions)
                let pointExtA: CGPoint = CGPoint(x: pointExtE.x + extendedWith - previewCornerRadius, y: pointExtE.y)
                let pointExtBArcCenter: CGPoint = CGPoint(x: pointExtA.x, y: pointE.y)

                let extrasHeight: CGFloat = curveDistance / 2.0
                let pointExtC: CGPoint = CGPoint(x: pointExtA.x + previewCornerRadius, y: pointD.y + extrasHeight - previewCornerRadius)
                let pointExtDArcCenter: CGPoint = CGPoint(x: pointExtA.x, y: pointExtC.y)

                let pointJ: CGPoint = CGPoint(x: pointExtE.x, y: pointD.y + extrasHeight)
                let pointK: CGPoint = CGPoint(x: pointC.x + keyWidth, y: pointC.y)
                let xControl: CGFloat = (pointJ.x - pointK.x) / 3.0
                let yControl: CGFloat = (pointK.y - pointJ.y) / 3.0
                let curve2Control1: CGPoint = CGPoint(x: pointJ.x - xControl, y: pointJ.y)
                let curve2Control2: CGPoint = CGPoint(x: pointK.x, y: pointK.y - yControl)

                let pointL: CGPoint = CGPoint(x: origin.x + (keyWidth / 2.0), y: pointBArcCenter.y)
                let pointMArcCenter: CGPoint = CGPoint(x: pointL.x - keyCornerRadius, y: pointL.y)

                return Path { path in
                        path.move(to: origin)

                        path.addLine(to: pointA)
                        path.addArc(center: pointBArcCenter, radius: keyCornerRadius, startAngle: .degrees(270), endAngle: .degrees(180), clockwise: false)

                        path.addLine(to: pointC)
                        path.addCurve(to: pointD, control1: curve1Control1, control2: curve1Control2)

                        path.addLine(to: pointE)
                        path.addArc(center: pointFArcCenter, radius: previewCornerRadius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)

                        path.addLine(to: pointExtA)
                        path.addArc(center: pointExtBArcCenter, radius: previewCornerRadius, startAngle: .degrees(90), endAngle: .zero, clockwise: false)
                        path.addLine(to: pointExtC)
                        path.addArc(center: pointExtDArcCenter, radius: previewCornerRadius, startAngle: .zero, endAngle: .degrees(90), clockwise: false)

                        path.addLine(to: pointJ)
                        path.addCurve(to: pointK, control1: curve2Control1, control2: curve2Control2)

                        path.addLine(to: pointL)
                        path.addArc(center: pointMArcCenter, radius: keyCornerRadius, startAngle: .zero, endAngle: .degrees(90), clockwise: false)

                        path.addLine(to: origin)
                }
        }
}
