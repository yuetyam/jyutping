import SwiftUI

struct ToneChartView: View {
        var body: some View {
                GeometryReader { geometry in
                        let height = geometry.size.height
                        let width = geometry.size.width

                        let widthUnit: CGFloat = width / 13.0
                        let heightUnit: CGFloat = height / 5.0

                        // Calculate y position for level k
                        let yOf = { k in (CGFloat(6 - k) - 0.5) * heightUnit }

                        ZStack {
                                Text(verbatim: "高")
                                        .font(.copilot)
                                        .position(x: 0, y: -4)
                                ForEach(1..<6, id: \.self) { levelValue in
                                        Text(verbatim: "\(levelValue)")
                                                .monospacedDigit()
                                                .position(x: 0, y: yOf(levelValue))
                                }
                                Text(verbatim: "低")
                                        .font(.copilot)
                                        .position(x: 0, y: height + 4)
                                ForEach(1..<6, id: \.self) { k in
                                        Path { path in
                                                path.move(to: CGPoint(x: 18, y: yOf(k)))
                                                path.addLine(to: CGPoint(x: width, y: yOf(k)))
                                        }
                                        .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [0, 6]))
                                }

                                Path { path in
                                        path.move(to: CGPoint(x: widthUnit, y: yOf(5)))
                                        path.addLine(to: CGPoint(x: widthUnit * 2.5, y: yOf(5)))
                                }
                                .stroke(Color.red, lineWidth: 4)

                                Path { path in
                                        path.move(to: CGPoint(x: widthUnit * 3, y: yOf(3)))
                                        path.addLine(to: CGPoint(x: widthUnit * 4.5, y: yOf(5)))
                                }
                                .stroke(Color.teal, lineWidth: 4)

                                Path { path in
                                        path.move(to: CGPoint(x: widthUnit * 5, y: yOf(3)))
                                        path.addLine(to: CGPoint(x: widthUnit * 6.5, y: yOf(3)))
                                }
                                .stroke(Color.purple, lineWidth: 4)

                                Path { path in
                                        path.move(to: CGPoint(x: widthUnit * 7, y: yOf(2)))
                                        path.addLine(to: CGPoint(x: widthUnit * 8.5, y: yOf(1)))
                                }
                                .stroke(Color.orange, lineWidth: 4)

                                Path { path in
                                        path.move(to: CGPoint(x: widthUnit * 9, y: yOf(1)))
                                        path.addLine(to: CGPoint(x: widthUnit * 10.5, y: yOf(3)))
                                }
                                .stroke(Color.green, lineWidth: 4)

                                Path { path in
                                        path.move(to: CGPoint(x: widthUnit * 11, y: yOf(2)))
                                        path.addLine(to: CGPoint(x: widthUnit * 12.5, y: yOf(2)))
                                }
                                .stroke(Color.blue, lineWidth: 4)

                                Text(verbatim: "1 陰平")
                                        .font(.master)
                                        .position(x: widthUnit * 1.5 + 8, y: yOf(5) - 16)
                                Text(verbatim: "2 陰上")
                                        .font(.master)
                                        .position(x: widthUnit * 3.5 - 12, y: yOf(4) - 16)
                                Text(verbatim: "3 陰去")
                                        .font(.master)
                                        .position(x: widthUnit * 5.5 + 10, y: yOf(3) - 16)
                                Text(verbatim: "4 陽平")
                                        .font(.master)
                                        .position(x: widthUnit * 7.5 - 12, y: yOf(1) - 16)
                                Text(verbatim: "5 陽上")
                                        .font(.master)
                                        .position(x: widthUnit * 9.5 - 12, y: yOf(2) - 16)
                                Text(verbatim: "6 陽去")
                                        .font(.master)
                                        .position(x: widthUnit * 11.5 + 8, y: yOf(2) - 16)
                        }
                }
        }
}

#Preview {
        ToneChartView()
                .background(Color.gray.opacity(0.5))
                .padding()
}
