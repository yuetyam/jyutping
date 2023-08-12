import SwiftUI

struct KeyPreviewLeftExpansionPath: Shape {

        /// Count of the extras blocks
        let expansions: Int

        func path(in rect: CGRect) -> Path {
                let origin: CGPoint = CGPoint(x: rect.midX, y: rect.maxY)
                return Path.keyPreviewLeftExpansionPath(origin: origin, previewCornerRadius: 10, keyWidth: rect.size.width, keyHeight: rect.size.height, keyCornerRadius: 5, expansions: expansions)
        }
}

private extension Path {
        static func keyPreviewLeftExpansionPath(origin: CGPoint, previewCornerRadius: CGFloat, keyWidth: CGFloat, keyHeight: CGFloat, keyCornerRadius: CGFloat, expansions: Int) -> Path {

                //    +-----------+-----------+---------------------G---+
                //    +   |       +           +                     |   +
                //    c...d       +           +                     H...+
                //    +           +           +                         +
                //    +           +           +                         +
                //    +...b       +           +                         +
                //    +   |       +           +                         +
                //    +---a-------+-----------D                         J
                //                             .                       .
                //                               .                   .
                //                                 C               K
                //                                 +               +
                //                                 +               +
                //                                 +...B       M...L
                //                                 +   |       |   +
                //                                 +---A---o-------+

                let expansionWidth: CGFloat = keyWidth / 2.85
                let curveDistance: CGFloat = expansionWidth * 1.5
                let controlDistance: CGFloat = curveDistance / 3.0
                let maxWidth: CGFloat = keyWidth + (expansionWidth * 2)

                let pointA: CGPoint = CGPoint(x: origin.x - (keyWidth / 2.0) + keyCornerRadius, y: origin.y)
                let pointBArcCenter: CGPoint = CGPoint(x: pointA.x, y: pointA.y - keyCornerRadius)
                let pointC: CGPoint = CGPoint(x: origin.x - (keyWidth / 2.0), y: origin.y - keyHeight)

                let pointK: CGPoint = CGPoint(x: pointC.x + keyWidth, y: pointC.y)
                let pointJ: CGPoint = CGPoint(x: pointK.x + expansionWidth, y: pointK.y - curveDistance)
                let curve2Control1: CGPoint = CGPoint(x: pointJ.x, y: pointK.y - controlDistance)
                let curve2Control2: CGPoint = CGPoint(x: pointK.x, y: curve2Control1.y)

                let pointHArcCenter: CGPoint = CGPoint(x: pointJ.x - previewCornerRadius, y: pointJ.y - keyHeight + previewCornerRadius + 4)
                let pointG: CGPoint = CGPoint(x: pointHArcCenter.x, y: pointHArcCenter.y - previewCornerRadius)

                let pointD: CGPoint = CGPoint(x: pointJ.x - maxWidth, y: pointJ.y + previewCornerRadius)
                let extendedWith: CGFloat = (keyWidth + 4) * CGFloat(expansions) + previewCornerRadius
                let pointExtA: CGPoint = CGPoint(x: pointD.x - extendedWith + previewCornerRadius, y: pointD.y)
                let pointExtBArcCenter: CGPoint = CGPoint(x: pointExtA.x, y: pointExtA.y - previewCornerRadius)
                let pointExtC: CGPoint = CGPoint(x: pointExtA.x - previewCornerRadius, y: pointHArcCenter.y)
                let pointExtDArcCenter: CGPoint = CGPoint(x: pointExtBArcCenter.x, y: pointExtC.y)
                let control: CGFloat = (pointC.x - pointD.x) / 3
                let curve1Control1: CGPoint = CGPoint(x: pointC.x, y: pointC.y - control * 2)
                let curve1Control2: CGPoint = CGPoint(x: pointD.x, y: curve1Control1.y)

                let pointL: CGPoint = CGPoint(x: origin.x + (keyWidth / 2), y: pointBArcCenter.y)
                let pointMArcCenter: CGPoint = CGPoint(x: pointL.x - keyCornerRadius, y: pointL.y)

                return Path { path in
                        path.move(to: origin)

                        path.addLine(to: pointA)
                        path.addArc(center: pointBArcCenter, radius: keyCornerRadius, startAngle: .degrees(270), endAngle: .degrees(180), clockwise: false)

                        path.addLine(to: pointC)
                        path.addCurve(to: pointD, control1: curve1Control1, control2: curve1Control2)

                        path.addLine(to: pointExtA)
                        path.addArc(center: pointExtBArcCenter, radius: previewCornerRadius, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)

                        path.addLine(to: pointExtC)
                        path.addArc(center: pointExtDArcCenter, radius: previewCornerRadius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)

                        path.addLine(to: pointG)
                        path.addArc(center: pointHArcCenter, radius: previewCornerRadius, startAngle: .degrees(90), endAngle: .zero, clockwise: false)

                        path.addLine(to: pointJ)
                        path.addCurve(to: pointK, control1: curve2Control1, control2: curve2Control2)

                        path.addLine(to: pointL)
                        path.addArc(center: pointMArcCenter, radius: keyCornerRadius, startAngle: .zero, endAngle: .degrees(90), clockwise: false)

                        path.addLine(to: origin)
                }
        }
}
