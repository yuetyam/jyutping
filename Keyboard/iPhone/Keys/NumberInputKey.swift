import SwiftUI
import CoreIME
import CommonExtensions

/// iPhone number row key view
struct NumberInputKey: View {

        init(_ event: InputEvent) {
                self.event = event
                self.keyText = event.text
        }

        private let event: InputEvent
        private let keyText: String

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        private var keyColor: Color {
                return colorScheme.isDark ? .darkInput : .lightInput
        }
        private var keyActiveColor: Color {
                return colorScheme.isDark ? .activeDarkInput : .activeLightInput
        }
        private var keyPreviewColor: Color {
                return colorScheme.isDark ? .solidDarkInput : .lightInput
        }

        @GestureState private var isTouching: Bool = false

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit
                let keyHeight: CGFloat = context.heightUnit
                let isPhoneLandscape: Bool = context.keyboardInterface.isPhoneLandscape
                let verticalPadding: CGFloat = isPhoneLandscape ? 3 : 6
                let horizontalPadding: CGFloat = isPhoneLandscape ? 6 : 3
                // let baseWidth: CGFloat = keyWidth - (horizontalPadding * 2)
                let baseHeight: CGFloat = keyHeight - (verticalPadding * 2)
                let shapeHeight: CGFloat = isPhoneLandscape ? (baseHeight / (2 / 6.0)) : baseHeight / ((2.5 / 6.0))
                let curveHeight: CGFloat = isPhoneLandscape ? (shapeHeight / 3.0) : (shapeHeight / 6.0)
                let previewBottomOffset: CGFloat = (baseHeight * 2) + (curveHeight * 1.5)
                let shouldPreviewKey: Bool = Options.keyTextPreview
                let activeColor: Color = shouldPreviewKey ? keyColor : keyActiveColor
                ZStack {
                        Color.interactiveClear
                        if (isTouching && shouldPreviewKey) {
                                BubbleShape()
                                        .fill(keyPreviewColor)
                                        .shadow(color: .shadowGray, radius: 1)
                                        .overlay {
                                                Text(verbatim: keyText)
                                                        .font(.largeTitle)
                                                        .padding(.bottom, previewBottomOffset)
                                        }
                                        .padding(.vertical, verticalPadding)
                                        .padding(.horizontal, horizontalPadding)
                        } else {
                                RoundedRectangle(cornerRadius: PresetConstant.keyCornerRadius, style: .continuous)
                                        .fill(isTouching ? activeColor : keyColor)
                                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                        .padding(.vertical, verticalPadding)
                                        .padding(.horizontal, horizontalPadding)
                                Text(verbatim: keyText)
                                        .font(.letterCompact)
                        }
                }
                .frame(width: keyWidth, height: keyHeight)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                if tapped.negative {
                                        AudioFeedback.inputed()
                                        context.triggerHapticFeedback()
                                        tapped = true
                                }
                        }
                        .onEnded { _ in
                                context.handle(event, isCapitalized: false)
                         }
                )
        }
}

/// Number row at the top of iPhone keyboards
struct NumberRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        NumberInputKey(.number1)
                        NumberInputKey(.number2)
                        NumberInputKey(.number3)
                        NumberInputKey(.number4)
                        NumberInputKey(.number5)
                        NumberInputKey(.number6)
                        NumberInputKey(.number7)
                        NumberInputKey(.number8)
                        NumberInputKey(.number9)
                        NumberInputKey(.number0)
                }
        }
}
