import SwiftUI

struct PadKeyExpansionPath: Shape {

        /// Key location, left half (leading) or right half (trailing).
        let keyLocale: HorizontalEdge

        /// Count of the extras blocks
        let expansions: Int

        func path(in rect: CGRect) -> Path {
                let origin: CGPoint = CGPoint(x: rect.midX, y: rect.maxY)
                switch keyLocale {
                case .leading:
                        return Path.padKeyRightExpansionPath(origin: origin, keyWidth: rect.size.width, keyHeight: rect.size.height, cornerRadius: 5, expansions: expansions)
                case .trailing:
                        return Path.padKeyLeftExpansionPath(origin: origin, keyWidth: rect.size.width, keyHeight: rect.size.height, cornerRadius: 5, expansions: expansions)
                }
        }
}

extension Path {
        static func padKeyLeftExpansionPath(origin: CGPoint, keyWidth: CGFloat, keyHeight: CGFloat, cornerRadius: CGFloat, expansions: Int) -> Path {

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

                let extendedHeight: CGFloat = keyHeight
                let extendedWidthUnit: CGFloat = keyWidth
                let extendedWidth: CGFloat = extendedWidthUnit * CGFloat(expansions)
                let halfKeyWidth: CGFloat = keyWidth / 2.0

                let pointA: CGPoint = CGPoint(x: origin.x - halfKeyWidth + cornerRadius, y: origin.y)
                let pointBArcCenter: CGPoint = CGPoint(x: pointA.x, y: pointA.y - cornerRadius)
                let pointC: CGPoint = CGPoint(x: origin.x - halfKeyWidth, y: origin.y - keyHeight)

                let pointExtA: CGPoint = CGPoint(x: pointC.x - extendedWidth + cornerRadius, y: pointC.y)
                let pointExtBArcCenter: CGPoint = CGPoint(x: pointExtA.x, y: pointExtA.y - cornerRadius)
                let pointExtC: CGPoint = CGPoint(x: pointExtA.x - cornerRadius, y: pointExtA.y - extendedHeight + cornerRadius)
                let pointExtDArcCenter: CGPoint = CGPoint(x: pointExtA.x, y: pointExtC.y)

                let pointG: CGPoint = CGPoint(x: origin.x + halfKeyWidth - cornerRadius, y: pointExtC.y - cornerRadius)
                let pointHArcCenter: CGPoint = CGPoint(x: pointG.x, y: pointExtC.y)

                let pointL: CGPoint = CGPoint(x: origin.x + halfKeyWidth, y: pointBArcCenter.y)
                let pointMArcCenter: CGPoint = CGPoint(x: pointL.x - cornerRadius, y: pointL.y)

                return Path { path in
                        path.move(to: origin)

                        path.addLine(to: pointA)
                        path.addArc(center: pointBArcCenter, radius: cornerRadius, startAngle: .degrees(270), endAngle: .degrees(180), clockwise: false)

                        path.addLine(to: pointC)
                        path.addLine(to: pointExtA)
                        path.addArc(center: pointExtBArcCenter, radius: cornerRadius, startAngle: .degrees(270), endAngle: .degrees(180), clockwise: false)

                        path.addLine(to: pointExtC)
                        path.addArc(center: pointExtDArcCenter, radius: cornerRadius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)

                        path.addLine(to: pointG)
                        path.addArc(center: pointHArcCenter, radius: cornerRadius, startAngle: .degrees(90), endAngle: .zero, clockwise: false)

                        path.addLine(to: pointL)
                        path.addArc(center: pointMArcCenter, radius: cornerRadius, startAngle: .zero, endAngle: .degrees(90), clockwise: false)

                        path.addLine(to: origin)
                }
        }
}

extension Path {
        static func padKeyRightExpansionPath(origin: CGPoint, keyWidth: CGFloat, keyHeight: CGFloat, cornerRadius: CGFloat, expansions: Int) -> Path {

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

                let extendedHeight: CGFloat = keyHeight
                let extendedWidthUnit: CGFloat = keyWidth
                let extendedWidth: CGFloat = extendedWidthUnit * CGFloat(expansions)
                let halfKeyWidth: CGFloat = keyWidth / 2.0

                let pointA: CGPoint = CGPoint(x: origin.x - halfKeyWidth + cornerRadius, y: origin.y)
                let pointBArcCenter: CGPoint = CGPoint(x: pointA.x, y: pointA.y - cornerRadius)
                let pointC: CGPoint = CGPoint(x: origin.x - halfKeyWidth, y: origin.y - keyHeight)
                let pointE: CGPoint = CGPoint(x: pointC.x, y: pointC.y - extendedHeight + cornerRadius)
                let pointFArcCenter: CGPoint = CGPoint(x: pointA.x, y: pointE.y)

                let pointExtA: CGPoint = CGPoint(x: pointE.x + keyWidth + extendedWidth - cornerRadius, y: pointE.y - cornerRadius)
                let pointExtBArcCenter: CGPoint = CGPoint(x: pointExtA.x, y: pointE.y)
                let pointExtC: CGPoint = CGPoint(x: pointExtA.x + cornerRadius, y: pointC.y - cornerRadius)
                let pointExtDArcCenter: CGPoint = CGPoint(x: pointExtA.x, y: pointExtC.y)

                let pointK: CGPoint = CGPoint(x: origin.x + halfKeyWidth, y: pointC.y)

                let pointL: CGPoint = CGPoint(x: pointK.x, y: pointBArcCenter.y)
                let pointMArcCenter: CGPoint = CGPoint(x: pointL.x - cornerRadius, y: pointL.y)

                return Path { path in
                        path.move(to: origin)

                        path.addLine(to: pointA)
                        path.addArc(center: pointBArcCenter, radius: cornerRadius, startAngle: .degrees(270), endAngle: .degrees(180), clockwise: false)

                        path.addLine(to: pointE)
                        path.addArc(center: pointFArcCenter, radius: cornerRadius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)

                        path.addLine(to: pointExtA)
                        path.addArc(center: pointExtBArcCenter, radius: cornerRadius, startAngle: .degrees(90), endAngle: .zero, clockwise: false)

                        path.addLine(to: pointExtC)
                        path.addArc(center: pointExtDArcCenter, radius: cornerRadius, startAngle: .zero, endAngle: .degrees(90), clockwise: false)

                        path.addLine(to: pointK)

                        path.addLine(to: pointL)
                        path.addArc(center: pointMArcCenter, radius: cornerRadius, startAngle: .zero, endAngle: .degrees(90), clockwise: false)

                        path.addLine(to: origin)
                }
        }
}
