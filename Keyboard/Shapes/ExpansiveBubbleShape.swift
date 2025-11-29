import SwiftUI

extension HorizontalEdge {
        var isLeading: Bool {
                return self == .leading
        }
        var isTrailing: Bool {
                return self == .trailing
        }
}

struct ExpansiveBubbleShape: Shape {
        
        /// Create an expansive bubble Shape
        /// - Parameters:
        ///   - keyLocale: Key location, left half (leading) or right half (trailing).
        ///   - expansionCount: Count of the extra blocks
        ///   - keyCornerRadius: Base view corner radius
        ///   - previewCornerRadius: Bubble preview corner radius
        init(keyLocale: HorizontalEdge, expansionCount: Int, keyCornerRadius: CGFloat = PresetConstant.keyCornerRadius, previewCornerRadius: CGFloat = PresetConstant.keyCornerRadius * 1.62) {
                self.keyLocale = keyLocale
                self.expansionCount = expansionCount
                self.keyCornerRadius = keyCornerRadius
                self.previewCornerRadius = previewCornerRadius
        }

        private let keyLocale: HorizontalEdge
        private let expansionCount: Int
        private let keyCornerRadius: CGFloat
        private let previewCornerRadius: CGFloat

        func path(in rect: CGRect) -> Path {
                let origin: CGPoint = CGPoint(x: rect.midX, y: rect.maxY)
                switch keyLocale {
                case .leading:
                        return Path.rightExpansionBubblePath(origin: origin, baseWidth: rect.size.width, baseHeight: rect.size.height, keyCornerRadius: keyCornerRadius, previewCornerRadius: previewCornerRadius, expansionCount: expansionCount)
                case .trailing:
                        return Path.leftExpansionBubblePath(origin: origin, baseWidth: rect.size.width, baseHeight: rect.size.height, keyCornerRadius: keyCornerRadius, previewCornerRadius: previewCornerRadius, expansionCount: expansionCount)
                }
        }
}


//    +-----------------------------X--------------+-----------a---+
//    +   |                         +              +           |   +
//    E...F                         +              +           b...+
//    +                             +              +               +
//    +                             +              +               +
//    +                             +              +           d...c
//    D                             +              +           |   +
//     .                            J--------------+---------------+
//       .                        .
//         .                    .
//           C               K
//           +               +
//           +               +
//           +...B       M...L
//           +   |       |   +
//           +---A---o-------+

private extension Path {
        static func rightExpansionBubblePath(origin: CGPoint, baseWidth: CGFloat, baseHeight: CGFloat, keyCornerRadius: CGFloat, previewCornerRadius: CGFloat, expansionCount: Int) -> Path {
                let isPhoneLandscape: Bool = (baseWidth > baseHeight) && (baseHeight < 43)
                let width: CGFloat = baseWidth / (3.0 / 5.0)
                let height: CGFloat = isPhoneLandscape ? (baseHeight / (2 / 6.0)) : baseHeight / ((2.5 / 6.0))
                let curveWidth: CGFloat = width / 5.0
                let curveHeight: CGFloat = isPhoneLandscape ? (height / 3.0) : (height / 6.0)
                let controlDistance: CGFloat = curveHeight / 3.0

                let extendedWith: CGFloat = baseWidth * CGFloat(expansionCount)
                let extrasHeight: CGFloat = curveHeight / 2.0

                let pointA: CGPoint = CGPoint(x: origin.x - (baseWidth / 2.0) + keyCornerRadius, y: origin.y)
                let pointB: CGPoint = CGPoint(x: pointA.x, y: pointA.y - keyCornerRadius)
                let pointC: CGPoint = CGPoint(x: origin.x - (baseWidth / 2.0), y: origin.y - baseHeight)

                let pointD: CGPoint = CGPoint(x: pointC.x - curveWidth, y: pointC.y - curveHeight)
                let curve1Control1: CGPoint = CGPoint(x: pointC.x, y: pointC.y - controlDistance)
                let curve1Control2: CGPoint = CGPoint(x: pointD.x, y: curve1Control1.y)

                let pointE: CGPoint = CGPoint(x: pointD.x, y: pointD.y - baseHeight + previewCornerRadius)
                let pointF: CGPoint = CGPoint(x: pointE.x + previewCornerRadius, y: pointE.y)

                let pointX: CGPoint = CGPoint(x: pointE.x + width, y: pointE.y - previewCornerRadius)

                let pointExtA: CGPoint = CGPoint(x: pointX.x + extendedWith - previewCornerRadius, y: pointX.y)
                let pointExtB: CGPoint = CGPoint(x: pointExtA.x, y: pointE.y)

                let pointJ: CGPoint = CGPoint(x: pointX.x, y: pointD.y + extrasHeight)

                let pointExtC: CGPoint = CGPoint(x: pointExtA.x + previewCornerRadius, y: pointJ.y - previewCornerRadius)
                let pointExtD: CGPoint = CGPoint(x: pointExtA.x, y: pointExtC.y)

                let pointK: CGPoint = CGPoint(x: pointC.x + baseWidth, y: pointC.y)
                let xControl: CGFloat = (pointJ.x - pointK.x) / 3.0
                let yControl: CGFloat = (pointK.y - pointJ.y) / 3.0
                let curve2Control1: CGPoint = CGPoint(x: pointJ.x - xControl, y: pointJ.y)
                let curve2Control2: CGPoint = CGPoint(x: pointK.x, y: pointK.y - yControl)

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

                        path.addLine(to: pointExtA)
                        path.addArc(center: pointExtB, radius: previewCornerRadius, startAngle: .degrees(270), endAngle: .zero, clockwise: false)

                        path.addLine(to: pointExtC)
                        path.addArc(center: pointExtD, radius: previewCornerRadius, startAngle: .zero, endAngle: .degrees(90), clockwise: false)

                        path.addLine(to: pointJ)
                        path.addCurve(to: pointK, control1: curve2Control1, control2: curve2Control2)

                        path.addLine(to: pointL)
                        path.addArc(center: pointM, radius: keyCornerRadius, startAngle: .zero, endAngle: .degrees(90), clockwise: false)

                        path.addLine(to: origin)
                }
        }
}


//    +-----------+-----------+------------------------G---+
//    +   |       +           +                        |   +
//    c...d       +           +                        H...+
//    +           +           +                            +
//    +           +           +                            +
//    +...b       +           +                            +
//    +   |       +           +                            J
//    +---a-------+-----------D                           .
//                              .                       .
//                                .                   .
//                                  C               K
//                                  +               +
//                                  +               +
//                                  +...B       M...L
//                                  +   |       |   +
//                                  +---A---o-------+

private extension Path {
        static func leftExpansionBubblePath(origin: CGPoint, baseWidth: CGFloat, baseHeight: CGFloat, keyCornerRadius: CGFloat, previewCornerRadius: CGFloat, expansionCount: Int) -> Path {
                let isPhoneLandscape: Bool = (baseWidth > baseHeight) && (baseHeight < 43)
                let width: CGFloat = baseWidth / (3.0 / 5.0)
                let height: CGFloat = isPhoneLandscape ? (baseHeight / (2 / 6.0)) : baseHeight / ((2.5 / 6.0))
                let curveWidth: CGFloat = width / 5.0
                let curveHeight: CGFloat = isPhoneLandscape ? (height / 3.0) : (height / 6.0)
                let controlDistance: CGFloat = curveHeight / 3.0

                let extendedWith: CGFloat = baseWidth * CGFloat(expansionCount)
                let extrasHeight: CGFloat = curveHeight / 2.0

                let pointA: CGPoint = CGPoint(x: origin.x - (baseWidth / 2.0) + keyCornerRadius, y: origin.y)
                let pointB: CGPoint = CGPoint(x: pointA.x, y: pointA.y - keyCornerRadius)

                let pointC: CGPoint = CGPoint(x: origin.x - (baseWidth / 2.0), y: origin.y - baseHeight)
                let pointD: CGPoint = CGPoint(x: pointC.x - curveWidth, y: pointC.y - curveHeight + extrasHeight)

                let xControl: CGFloat = (pointC.x - pointD.x) / 3.0
                let yControl: CGFloat = (pointC.y - pointD.y) / 3.0
                let curve1Control1: CGPoint = CGPoint(x: pointC.x, y: pointC.y - yControl)
                let curve1Control2: CGPoint = CGPoint(x: pointD.x + xControl, y: pointD.y)

                let pointL: CGPoint = CGPoint(x: pointC.x + baseWidth, y: pointB.y)
                let pointM: CGPoint = CGPoint(x: pointL.x - keyCornerRadius, y: pointL.y)

                let pointK: CGPoint = CGPoint(x: pointC.x + baseWidth, y: pointC.y)
                let pointJ: CGPoint = CGPoint(x: pointK.x + curveWidth, y: pointK.y - curveHeight)
                let curve2Control1: CGPoint = CGPoint(x: pointJ.x, y: pointK.y - controlDistance)
                let curve2Control2: CGPoint = CGPoint(x: pointK.x, y: curve2Control1.y)

                let pointG: CGPoint = CGPoint(x: pointJ.x - previewCornerRadius, y: pointJ.y - baseHeight)
                let pointH: CGPoint = CGPoint(x: pointG.x, y: pointG.y + previewCornerRadius)

                let pointExtA: CGPoint = CGPoint(x: pointD.x - extendedWith + previewCornerRadius, y: pointD.y)
                let pointExtB: CGPoint = CGPoint(x: pointExtA.x, y: pointExtA.y - previewCornerRadius)
                let pointExtC: CGPoint = CGPoint(x: pointExtB.x - previewCornerRadius, y: pointH.y)
                let pointExtD: CGPoint = CGPoint(x: pointExtB.x, y: pointExtC.y)

                return Path { path in
                        path.move(to: origin)

                        path.addLine(to: pointA)
                        path.addArc(center: pointB, radius: keyCornerRadius, startAngle: .degrees(270), endAngle: .degrees(180), clockwise: false)

                        path.addLine(to: pointC)
                        path.addCurve(to: pointD, control1: curve1Control1, control2: curve1Control2)

                        path.addLine(to: pointExtA)
                        path.addArc(center: pointExtB, radius: previewCornerRadius, startAngle: .degrees(270), endAngle: .degrees(180), clockwise: false)

                        path.addLine(to: pointExtC)
                        path.addArc(center: pointExtD, radius: previewCornerRadius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)

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
