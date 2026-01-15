import SwiftUI
import CoreIME
import CommonExtensions

struct StrokeInputKey: View {

        init(_ event: VirtualInputKey) {
                self.event = event
                self.letter = event.text
                self.stroke = PresetConstant.strokeKeyMap[letter]
        }

        private let event: VirtualInputKey
        private let letter: String
        private let stroke: String?

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

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
                let activeColor: Color = shouldPreviewKey ? colorScheme.inputKeyColor : colorScheme.activeInputKeyColor
                let shouldShowLowercaseKeys: Bool = Options.showLowercaseKeys && context.keyboardCase.isLowercased
                let textCase: Text.Case = shouldShowLowercaseKeys ? .lowercase : .uppercase
                let keyTextBottomInset: CGFloat = shouldShowLowercaseKeys ? 3 : 0
                ZStack {
                        Color.interactiveClear
                        if (isTouching && shouldPreviewKey) {
                                BubbleShape()
                                        .fill(colorScheme.previewBubbleColor)
                                        .shadow(color: .shadowGray, radius: 1)
                                        .overlay {
                                                Text(verbatim: stroke ?? letter)
                                                        .textCase(textCase)
                                                        .font(.largeTitle)
                                                        .padding(.bottom, previewBottomOffset)
                                        }
                                        .padding(.vertical, verticalPadding)
                                        .padding(.horizontal, horizontalPadding)
                        } else {
                                RoundedRectangle(cornerRadius: PresetConstant.keyCornerRadius, style: .continuous)
                                        .fill(isTouching ? activeColor : colorScheme.inputKeyColor)
                                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                        .padding(.vertical, verticalPadding)
                                        .padding(.horizontal, horizontalPadding)
                                if let stroke {
                                        ZStack(alignment: .topTrailing) {
                                                Color.clear
                                                Text(verbatim: letter)
                                                        .textCase(textCase)
                                                        .font(.footnote)
                                                        .shallow()
                                        }
                                        .padding(.vertical, verticalPadding)
                                        .padding(.horizontal, horizontalPadding + 2)
                                        Text(verbatim: stroke)
                                } else {
                                        Text(verbatim: letter)
                                                .textCase(textCase)
                                                .shallow()
                                                .padding(.bottom, keyTextBottomInset)
                                }
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
                                context.handle(event)
                        }
                )
        }
}
