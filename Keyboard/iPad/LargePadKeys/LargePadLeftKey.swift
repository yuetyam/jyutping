import SwiftUI
import CommonExtensions
import CoreIME

struct LargePadLeftKey: View {

        let widthUnitTimes: CGFloat

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @GestureState private var isTouching: Bool = false

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * widthUnitTimes
                let keyHeight: CGFloat = context.heightUnit
                let isLandscape: Bool = context.keyboardInterface.isPadLandscape
                let verticalPadding: CGFloat = isLandscape ? 5 : 4
                let horizontalPadding: CGFloat = isLandscape ? 5 : 4
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous)
                                .fill(isTouching ? colorScheme.activeActionKeyColor : colorScheme.actionKeyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(.vertical, verticalPadding)
                                .padding(.horizontal, horizontalPadding)
                        if context.inputStage.isBuffering {
                                ZStack(alignment: .bottom) {
                                        Color.clear
                                        Text(verbatim: PresetConstant.separate)
                                                .font(.keyFootnote)
                                                .shallow()
                                }
                                .padding(.vertical, verticalPadding + 7)
                                Text(verbatim: String.apostrophe)
                        } else {
                                ZStack(alignment: .bottomLeading) {
                                        Color.clear
                                        Text(verbatim: KeyboardForm.numeric.padTransformKeyText)
                                }
                                .padding(.vertical, verticalPadding + 7)
                                .padding(.horizontal, horizontalPadding + 7)
                        }
                }
                .frame(width: keyWidth, height: keyHeight)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                if tapped.negative {
                                        AudioFeedback.modified()
                                        tapped = true
                                }
                        }
                        .onEnded { _ in
                                if context.inputStage.isBuffering {
                                        context.handle(.apostrophe)
                                } else {
                                        context.updateKeyboardForm(to: .numeric)
                                }
                        }
                )
        }
}
