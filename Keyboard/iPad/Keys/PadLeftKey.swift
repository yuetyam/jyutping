import SwiftUI
import CommonExtensions
import CoreIME

struct PadLeftKey: View {

        let widthUnitTimes: CGFloat

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @State private var isTouching: Bool = false

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * widthUnitTimes
                let keyHeight: CGFloat = context.heightUnit
                let isLandscape: Bool = context.keyboardInterface.isPadLandscape
                let verticalPadding: CGFloat = isLandscape ? 7 : 5
                let horizontalPadding: CGFloat = isLandscape ? 7 : 5
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius)
                                        .fill(isTouching ? colorScheme.activeActionKeyColor : colorScheme.actionKeyColor)
                                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                        .padding(.vertical, verticalPadding)
                                        .padding(.horizontal, horizontalPadding)
                                ZStack(alignment: .bottom) {
                                        Color.clear
                                        Text(verbatim: PresetConstant.separate).font(.labelCaption)
                                }
                                .padding(.bottom, verticalPadding + 5)
                                .opacity(context.inputStage.isBuffering ? 0.5 : 0)
                                Text(verbatim: context.inputStage.isBuffering ? String.apostrophe : KeyboardForm.numeric.padTransformKeyText)
                        }
                        .frame(width: keyWidth, height: keyHeight)
                }
                .buttonStyle(PressButtonStyle($isTouching) {
                        AudioFeedback.modified()
                        if context.inputStage.isBuffering {
                                context.handle(.apostrophe)
                        } else {
                                context.updateKeyboardForm(to: .numeric)
                        }
                })
        }
}
