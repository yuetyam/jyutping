import SwiftUI

/// Compact Keyboard (iPhone & iPadFloating) Key Preview Bubble
struct BubbleShape: Shape {
        func path(in rect: CGRect) -> Path {
                let origin: CGPoint = CGPoint(x: rect.midX, y: rect.maxY)
                return Self.bubblePath(origin: origin, baseWidth: rect.size.width, baseHeight: rect.size.height, keyCornerRadius: PresetConstant.keyCornerRadius, previewCornerRadius: PresetConstant.keyCornerRadius * 2)
        }
}

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

private extension BubbleShape {
        static func bubblePath(origin: CGPoint, baseWidth: CGFloat, baseHeight: CGFloat, keyCornerRadius: CGFloat, previewCornerRadius: CGFloat) -> Path {
                let isPhoneLandscape: Bool = (baseWidth > baseHeight)
                let width: CGFloat = baseWidth / (3.0 / 5.0)
                let height: CGFloat = isPhoneLandscape ? (baseHeight / (2 / 6.0)) : baseHeight / ((2.5 / 6.0))
                let curveWidth: CGFloat = width / 5.0
                let curveHeight: CGFloat = isPhoneLandscape ? (height / 3.0) : (height / 6.0)
                let controlDistance: CGFloat = curveHeight / 3.0

                let pointA: CGPoint = CGPoint(x: origin.x - (baseWidth / 2.0) + keyCornerRadius, y: origin.y)
                let pointB: CGPoint = CGPoint(x: pointA.x, y: pointA.y - keyCornerRadius)
                let pointC: CGPoint = CGPoint(x: origin.x - (baseWidth / 2.0), y: origin.y - baseHeight)

                let pointD: CGPoint = CGPoint(x: pointC.x - curveWidth, y: pointC.y - curveHeight)
                let curve1Control1: CGPoint = CGPoint(x: pointC.x, y: pointC.y - controlDistance)
                let curve1Control2: CGPoint = CGPoint(x: pointD.x, y: curve1Control1.y)

                let pointE: CGPoint = CGPoint(x: pointD.x, y: pointD.y - baseHeight + previewCornerRadius)
                let pointF: CGPoint = CGPoint(x: pointE.x + previewCornerRadius, y: pointE.y)

                let pointG: CGPoint = CGPoint(x: pointF.x + width - (previewCornerRadius * 2), y: pointF.y - previewCornerRadius)
                let pointH: CGPoint = CGPoint(x: pointG.x, y: pointF.y)

                let pointJ: CGPoint = CGPoint(x: pointH.x + previewCornerRadius, y: pointD.y)
                let pointK: CGPoint = CGPoint(x: pointC.x + baseWidth, y: pointC.y)
                let curve2Control1: CGPoint = CGPoint(x: pointJ.x, y: curve1Control1.y)
                let curve2Control2: CGPoint = CGPoint(x: pointK.x, y: curve2Control1.y)

                let pointL: CGPoint = CGPoint(x: origin.x + (baseWidth / 2.0), y: pointB.y)
                let pointM: CGPoint = CGPoint(x: pointL.x - keyCornerRadius, y: pointL.y)

                return Path { path in
                        path.move(to: origin)

                        path.addLine(to: pointA)
                        path.addArc(center: pointB, radius: keyCornerRadius, startAngle: .degrees(270), endAngle: .degrees(180), clockwise: false)

                        path.addLine(to: pointC)
                        path.addCurve(to: pointD, control1: curve1Control1, control2: curve1Control2)

                        path.addLine(to: pointE)
                        path.addArc(center: pointF, radius: previewCornerRadius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)

                        path.addLine(to: pointG)
                        path.addArc(center: pointH, radius: previewCornerRadius, startAngle: .degrees(270), endAngle: .zero, clockwise: false)

                        path.addLine(to: pointJ)
                        path.addCurve(to: pointK, control1: curve2Control1, control2: curve2Control2)

                        path.addLine(to: pointL)
                        path.addArc(center: pointM, radius: keyCornerRadius, startAngle: .zero, endAngle: .degrees(90), clockwise: false)

                        path.addLine(to: origin)
                }
        }
}
