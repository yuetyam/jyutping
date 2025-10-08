import SwiftUI
import CommonExtensions

struct BackspaceKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        private var keyColor: Color {
                return colorScheme.isDark ? .darkAction : .lightAction
        }
        private var keyActiveColor: Color {
                return colorScheme.isDark ? .activeDarkAction : .activeLightAction
        }

        @GestureState private var isTouching: Bool = false
        @State private var buffer: Int = 0
        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * 1.3
                let keyHeight: CGFloat = context.heightUnit
                let isPhoneLandscape: Bool = context.keyboardInterface.isPhoneLandscape
                let verticalPadding: CGFloat = isPhoneLandscape ? 3 : 6
                let horizontalPadding: CGFloat = isPhoneLandscape ? 6 : 3
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: PresetConstant.keyCornerRadius, style: .continuous)
                                .fill(isTouching ? keyActiveColor : keyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(.vertical, verticalPadding)
                                .padding(.horizontal, horizontalPadding)
                        Image.backspace.symbolVariant(isTouching ? .fill : .none).font(.symbol)
                }
                .frame(width: keyWidth, height: keyHeight)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                guard tapped.negative else { return }
                                AudioFeedback.deleted()
                                context.triggerHapticFeedback()
                                context.operate(.backspace)
                                tapped = true
                        }
                        .onEnded { value in
                                buffer = 0
                                let horizontalTranslation = value.translation.width
                                guard horizontalTranslation < -44 else { return }
                                AudioFeedback.deleted()
                                context.triggerHapticFeedback()
                                context.operate(.clearBuffer)
                         }
                )
                .onReceive(timer) { _ in
                        guard isTouching else { return }
                        if buffer > 3 {
                                AudioFeedback.deleted()
                                context.triggerHapticFeedback()
                                context.operate(.backspace)
                        } else {
                                buffer += 1
                        }
                }
        }
}
