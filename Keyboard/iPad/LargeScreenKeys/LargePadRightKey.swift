import SwiftUI

struct LargePadRightKey: View {

        let widthUnitTimes: CGFloat

        @EnvironmentObject private var context: KeyboardViewController

        @Environment(\.colorScheme) private var colorScheme
        private var keyColor: Color {
                switch colorScheme {
                case .light:
                        return .lightEmphatic
                case .dark:
                        return .darkEmphatic
                @unknown default:
                        return .lightEmphatic
                }
        }
        private var activeKeyColor: Color {
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
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(isTouching ? activeKeyColor : keyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(4)
                        if context.inputStage.isBuffering {
                                ZStack(alignment: .bottom) {
                                        Color.clear
                                        Text(verbatim: "分隔")
                                                .font(.keyFooter)
                                                .padding(.bottom, 12)
                                }
                                .opacity(0.8)
                                Text(verbatim: "'")
                        } else {
                                ZStack(alignment: .bottomTrailing) {
                                        Color.clear
                                        Text(verbatim: ".?123")
                                                .padding(12)
                                }
                        }
                }
                .frame(width: context.widthUnit * widthUnitTimes, height: context.heightUnit)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                if !tapped {
                                        AudioFeedback.modified()
                                        tapped = true
                                }
                        }
                        .onEnded { _ in
                                if context.inputStage.isBuffering {
                                        context.operate(.separate)
                                } else {
                                        context.updateKeyboardForm(to: .numeric)
                                }
                         }
                )
        }
}
