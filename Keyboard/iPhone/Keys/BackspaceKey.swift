import SwiftUI
import CommonExtensions

struct BackspaceKey: View {

        /// Create a backspace key
        /// - Parameter coefficient: Multiplier to the `widthUnit`
        init(coefficient: CGFloat = 1.3) {
                self.coefficient = coefficient
        }
        private let coefficient: CGFloat

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @State private var isTouching: Bool = false
        @State private var buffer: Int = 0

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * coefficient
                let keyHeight: CGFloat = context.heightUnit
                let isPhoneLandscape: Bool = context.keyboardInterface.isPhoneLandscape
                let verticalPadding: CGFloat = isPhoneLandscape ? 3 : 6
                let horizontalPadding: CGFloat = isPhoneLandscape ? 6 : 3
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                RoundedRectangle(cornerRadius: PresetConstant.keyCornerRadius)
                                        .fill(isTouching ? colorScheme.activeActionKeyColor : colorScheme.actionKeyColor)
                                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                        .padding(.vertical, verticalPadding)
                                        .padding(.horizontal, horizontalPadding)
                                Image.backspace.symbolVariant(isTouching ? .fill : .none).font(.symbol)
                        }
                        .frame(width: keyWidth, height: keyHeight)
                }
                .buttonStyle(PressButtonStyle($isTouching) {
                        buffer = 0
                        AudioFeedback.deleted()
                        context.triggerHapticFeedback()
                        context.operate(.backspace)
                })
                .simultaneousGesture(DragGesture(minimumDistance: 0)
                        .onEnded { value in
                                buffer = 0
                                guard (value.translation.width < -44) || (value.translation.height < -44) else { return }
                                AudioFeedback.deleted()
                                context.triggerHapticFeedback()
                                context.operate(.clearBuffer)
                        }
                )
                .task(id: isTouching) {
                        guard isTouching else { return }
                        while Task.isCancelled.negative {
                                try? await Task.sleep(for: .milliseconds(100)) // 0.1s
                                if isTouching {
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
        }
}
