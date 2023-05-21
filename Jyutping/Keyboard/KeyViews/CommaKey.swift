import SwiftUI

private struct CommaKeyText: View {

        let isABCMode: Bool
        let needsInputModeSwitchKey: Bool
        let isBuffering: Bool
        let width: CGFloat
        let height: CGFloat

        var body: some View {
                if isABCMode {
                        if needsInputModeSwitchKey {
                                Text(verbatim: ".")
                        } else {
                                Text(verbatim: ",")
                        }
                } else {
                        if isBuffering {
                                Text(verbatim: "'")
                                VStack(spacing: 0) {
                                        Text(verbatim: " ").padding(.top, 12)
                                        Spacer()
                                        Text(verbatim: "分隔").font(.keyFooter).foregroundColor(.secondary).padding(.bottom, 12)
                                }
                                .frame(width: width, height:height)
                        } else {
                                Text(verbatim: "，")
                        }
                }
        }
}

struct CommaKey: View {

        @EnvironmentObject private var context: KeyboardViewController

        @Environment(\.colorScheme) private var colorScheme
        private var keyColor: Color {
                switch colorScheme {
                case .light:
                        return .light
                case .dark:
                        return .dark
                @unknown default:
                        return .light
                }
        }

        @GestureState private var isTouching: Bool = false

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        if isTouching {
                                KeyPreview()
                                        .fill(keyColor)
                                        .shadow(color: .black.opacity(0.4), radius: 0.5)
                                        .overlay {
                                                CommaKeyText(isABCMode: context.inputMethodMode.isABC, needsInputModeSwitchKey: context.needsInputModeSwitchKey, isBuffering: context.inputStage.isBuffering, width: context.widthUnit, height: context.heightUnit)
                                                        .font(.largeTitle)
                                                        .padding(.bottom, context.heightUnit * 2.0)
                                        }
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 3)
                        } else {
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .fill(keyColor)
                                        .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 3)
                                CommaKeyText(isABCMode: context.inputMethodMode.isABC, needsInputModeSwitchKey: context.needsInputModeSwitchKey, isBuffering: context.inputStage.isBuffering, width: context.widthUnit, height: context.heightUnit)
                        }
                }
                .frame(width: context.widthUnit, height: context.heightUnit)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                if !tapped {
                                        tapped = true
                                }
                        }
                        .onEnded { _ in
                                if context.inputMethodMode.isABC {
                                        if context.needsInputModeSwitchKey {
                                                context.operate(.punctuation("."))
                                        } else {
                                                context.operate(.punctuation(","))
                                        }
                                } else {
                                        if context.inputStage.isBuffering {
                                                context.operate(.input("'"))
                                        } else {
                                                context.operate(.punctuation("，"))
                                        }
                                }
                         }
                )
        }
}

struct KeyPreview: Shape {
        func path(in rect: CGRect) -> Path {
                let origin: CGPoint = CGPoint(x: rect.midX, y: rect.maxY)
                let bezierPath = UIBezierPath.previewBezierPath(origin: origin, previewCornerRadius: 10, keyWidth: rect.size.width, keyHeight: rect.size.height, keyCornerRadius: 5)
                return Path(bezierPath.cgPath)
        }
}

extension UIBezierPath {
        static func previewBezierPath(origin: CGPoint, previewCornerRadius: CGFloat, keyWidth: CGFloat, keyHeight: CGFloat, keyCornerRadius: CGFloat) -> UIBezierPath {

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

                let expansionWidth: CGFloat = keyWidth / 2.85
                let curveDistance: CGFloat = expansionWidth * 1.5
                let controlDistance: CGFloat = curveDistance / 3.0

                let pointA: CGPoint = CGPoint(x: origin.x - (keyWidth / 2.0) + keyCornerRadius, y: origin.y)
                let pointBArcCenter: CGPoint = CGPoint(x: pointA.x, y: pointA.y - keyCornerRadius)
                let pointC: CGPoint = CGPoint(x: origin.x - (keyWidth / 2.0), y: origin.y - keyHeight)

                let pointD: CGPoint = CGPoint(x: pointC.x - expansionWidth, y: pointC.y - curveDistance)
                let curve1Control1: CGPoint = CGPoint(x: pointC.x, y: pointC.y - controlDistance)
                let curve1Control2: CGPoint = CGPoint(x: pointD.x, y: curve1Control1.y)

                let pointE: CGPoint = CGPoint(x: pointD.x, y: pointD.y - keyHeight + previewCornerRadius + 3)
                let pointFArcCenter: CGPoint = CGPoint(x: pointE.x + previewCornerRadius, y: pointE.y)

                let maxWidth: CGFloat = keyWidth + (expansionWidth * 2)
                let pointG: CGPoint = CGPoint(x: pointFArcCenter.x + (maxWidth - previewCornerRadius * 2), y: pointFArcCenter.y - previewCornerRadius)
                let pointHArcCenter: CGPoint = CGPoint(x: pointG.x, y: pointFArcCenter.y)

                let pointJ: CGPoint = CGPoint(x: pointHArcCenter.x + previewCornerRadius, y: pointD.y)
                let pointK: CGPoint = CGPoint(x: pointC.x + keyWidth, y: pointC.y)
                let curve2Control1: CGPoint = CGPoint(x: pointJ.x, y: curve1Control1.y)
                let curve2Control2: CGPoint = CGPoint(x: pointK.x, y: curve2Control1.y)

                let pointL: CGPoint = CGPoint(x: origin.x + (keyWidth / 2.0), y: pointBArcCenter.y)
                let pointMArcCenter: CGPoint = CGPoint(x: pointL.x - keyCornerRadius, y: pointL.y)

                let path: UIBezierPath = UIBezierPath()
                path.move(to: origin)

                path.addLine(to: pointA)
                path.addArc(withCenter: pointBArcCenter, radius: keyCornerRadius, startAngle: (3 * CGFloat.pi / 2.0), endAngle: CGFloat.pi, clockwise: true)

                path.addLine(to: pointC)
                path.addCurve(to: pointD, controlPoint1: curve1Control1, controlPoint2: curve1Control2)

                path.addLine(to: pointE)
                path.addArc(withCenter: pointFArcCenter, radius: previewCornerRadius, startAngle: CGFloat.pi, endAngle: (3 * CGFloat.pi / 2.0), clockwise: true)

                path.addLine(to: pointG)
                path.addArc(withCenter: pointHArcCenter, radius: previewCornerRadius, startAngle: (CGFloat.pi / 2.0), endAngle: 0, clockwise: true)

                path.addLine(to: pointJ)
                path.addCurve(to: pointK, controlPoint1: curve2Control1, controlPoint2: curve2Control2)

                path.addLine(to: pointL)
                path.addArc(withCenter: pointMArcCenter, radius: keyCornerRadius, startAngle: 0, endAngle: (CGFloat.pi / 2.0), clockwise: true)

                path.close()
                return path
        }
}
