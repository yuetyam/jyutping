import SwiftUI

struct PadExpansiveBubbleShape: Shape {

        /// Description
        /// - Parameters:
        ///   - keyLocale: Key location, left half (leading) or right half (trailing).
        ///   - expansionCount: Count of the extras blocks.
        ///   - cornerRadius: Arc CornerRadius.
        init(keyLocale: HorizontalEdge, expansionCount: Int, cornerRadius: CGFloat = 5) {
                self.keyLocale = keyLocale
                self.expansionCount = expansionCount
                self.cornerRadius = cornerRadius
        }

        private let keyLocale: HorizontalEdge
        private let expansionCount: Int
        private let cornerRadius: CGFloat

        func path(in rect: CGRect) -> Path {
                let origin: CGPoint = CGPoint(x: rect.midX, y: rect.maxY)
                switch keyLocale {
                case .leading:
                        return Path.padRightExpansionBubblePath(origin: origin, baseWidth: rect.size.width, baseHeight: rect.size.height, cornerRadius: cornerRadius, expansionCount: expansionCount)
                case .trailing:
                        return Path.padLeftExpansionBubblePath(origin: origin, baseWidth: rect.size.width, baseHeight: rect.size.height, cornerRadius: cornerRadius, expansionCount: expansionCount)
                }
        }
}


//    +---------------+---------------+------------a---+
//    +   |           +               +            |   +
//    E...F           +               +            b...+
//    +               +               +                +
//    +               +               +                +
//    +               +               +            d...c
//    +               +               +            |   +
//    C               K---------------+----------------+
//    +               +
//    +               +
//    +               +
//    +...B       M...L
//    +   |       |   +
//    +---A---o-------+

private extension Path {
        static func padRightExpansionBubblePath(origin: CGPoint, baseWidth: CGFloat, baseHeight: CGFloat, cornerRadius: CGFloat, expansionCount: Int) -> Path {

                let extendedWidth: CGFloat = baseWidth * CGFloat(expansionCount)
                let halfBaseWidth: CGFloat = baseWidth / 2.0
                let extraHeight: CGFloat = 4

                let pointA: CGPoint = CGPoint(x: origin.x - halfBaseWidth + cornerRadius, y: origin.y)
                let pointB: CGPoint = CGPoint(x: pointA.x, y: pointA.y - cornerRadius)
                let pointC: CGPoint = CGPoint(x: origin.x - halfBaseWidth, y: origin.y - baseHeight - extraHeight)
                let pointE: CGPoint = CGPoint(x: pointC.x, y: pointC.y - baseHeight + cornerRadius)
                let pointF: CGPoint = CGPoint(x: pointA.x, y: pointE.y)

                let pointExtA: CGPoint = CGPoint(x: pointE.x + baseWidth + extendedWidth - cornerRadius, y: pointE.y - cornerRadius)
                let pointExtB: CGPoint = CGPoint(x: pointExtA.x, y: pointE.y)
                let pointExtC: CGPoint = CGPoint(x: pointExtA.x + cornerRadius, y: pointC.y - cornerRadius)
                let pointExtD: CGPoint = CGPoint(x: pointExtA.x, y: pointExtC.y)

                let pointK: CGPoint = CGPoint(x: origin.x + halfBaseWidth, y: pointC.y)

                let pointL: CGPoint = CGPoint(x: pointK.x, y: pointB.y)
                let pointM: CGPoint = CGPoint(x: pointL.x - cornerRadius, y: pointL.y)

                return Path { path in
                        path.move(to: origin)

                        path.addLine(to: pointA)
                        path.addArc(center: pointB, radius: cornerRadius, startAngle: .degrees(270), endAngle: .degrees(180), clockwise: false)

                        path.addLine(to: pointE)
                        path.addArc(center: pointF, radius: cornerRadius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)

                        path.addLine(to: pointExtA)
                        path.addArc(center: pointExtB, radius: cornerRadius, startAngle: .degrees(90), endAngle: .zero, clockwise: false)

                        path.addLine(to: pointExtC)
                        path.addArc(center: pointExtD, radius: cornerRadius, startAngle: .zero, endAngle: .degrees(90), clockwise: false)

                        path.addLine(to: pointK)

                        path.addLine(to: pointL)
                        path.addArc(center: pointM, radius: cornerRadius, startAngle: .zero, endAngle: .degrees(90), clockwise: false)

                        path.addLine(to: origin)
                }
        }
}


//    +---------------+---------------+-----------G---+
//    +   +           +               +           +   +
//    c...d           +               +           H...+
//    +               +               +               +
//    +               +               +               +
//    +...b           +               +               +
//    +   +           +               +               +
//    +---a-----------+---------------C               +
//                                    +               +
//                                    +               +
//                                    +               +
//                                    +...B       M...L
//                                    +   |       |   +
//                                    +---A---o-------+

private extension Path {
        static func padLeftExpansionBubblePath(origin: CGPoint, baseWidth: CGFloat, baseHeight: CGFloat, cornerRadius: CGFloat, expansionCount: Int) -> Path {

                let extendedWidth: CGFloat = baseWidth * CGFloat(expansionCount)
                let halfBaseWidth: CGFloat = baseWidth / 2.0
                let extraHeight: CGFloat = 4

                let pointA: CGPoint = CGPoint(x: origin.x - halfBaseWidth + cornerRadius, y: origin.y)
                let pointB: CGPoint = CGPoint(x: pointA.x, y: pointA.y - cornerRadius)
                let pointC: CGPoint = CGPoint(x: origin.x - halfBaseWidth, y: origin.y - baseHeight - extraHeight)

                let pointExtA: CGPoint = CGPoint(x: pointC.x - extendedWidth + cornerRadius, y: pointC.y)
                let pointExtB: CGPoint = CGPoint(x: pointExtA.x, y: pointExtA.y - cornerRadius)
                let pointExtC: CGPoint = CGPoint(x: pointExtA.x - cornerRadius, y: pointExtA.y - baseHeight + cornerRadius)
                let pointExtD: CGPoint = CGPoint(x: pointExtA.x, y: pointExtC.y)

                let pointG: CGPoint = CGPoint(x: origin.x + halfBaseWidth - cornerRadius, y: pointC.y - baseHeight)
                let pointH: CGPoint = CGPoint(x: pointG.x, y: pointG.y + cornerRadius)

                let pointL: CGPoint = CGPoint(x: origin.x + halfBaseWidth, y: pointB.y)
                let pointM: CGPoint = CGPoint(x: pointL.x - cornerRadius, y: pointL.y)

                return Path { path in
                        path.move(to: origin)

                        path.addLine(to: pointA)
                        path.addArc(center: pointB, radius: cornerRadius, startAngle: .degrees(270), endAngle: .degrees(180), clockwise: false)

                        path.addLine(to: pointC)
                        path.addLine(to: pointExtA)
                        path.addArc(center: pointExtB, radius: cornerRadius, startAngle: .degrees(270), endAngle: .degrees(180), clockwise: false)

                        path.addLine(to: pointExtC)
                        path.addArc(center: pointExtD, radius: cornerRadius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)

                        path.addLine(to: pointG)
                        path.addArc(center: pointH, radius: cornerRadius, startAngle: .degrees(90), endAngle: .zero, clockwise: false)

                        path.addLine(to: pointL)
                        path.addArc(center: pointM, radius: cornerRadius, startAngle: .zero, endAngle: .degrees(90), clockwise: false)

                        path.addLine(to: origin)
                }
        }
}
