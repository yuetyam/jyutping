import SwiftUI
import CoreIME
import CommonExtensions

struct T18LetterInputKey: View {

        init(_ virtual: VirtualInputKey, coefficient: CGFloat = 1.42) {
                self.virtual = virtual
                self.coefficient = coefficient
        }

        private let virtual: VirtualInputKey

        private let coefficient: CGFloat

        @EnvironmentObject private var context: KeyboardViewController

        @Environment(\.colorScheme) private var colorScheme

        @State private var isTouching: Bool = false

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * coefficient
                let keyHeight: CGFloat = context.heightUnit
                let insets = context.keyboardInterface.keyShapeInsets
                let shouldShowLowercaseKeys: Bool = Options.showLowercaseKeys && context.keyboardCase.isLowercased
                let textCase: Text.Case = shouldShowLowercaseKeys ? .lowercase : .uppercase
                let keyTextBottomInset: CGFloat = shouldShowLowercaseKeys ? 3 : 0
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                RoundedRectangle(cornerRadius: PresetConstant.keyCornerRadius)
                                        .fill(colorScheme.inputKeyBackground(style: context.appearanceStyle, isPreviewEnabled: false, isInteracting: isTouching))
                                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                        .padding(insets)
                                Text(verbatim: virtual.text)
                                        .textCase(textCase)
                                        .font(.compactKeyLabel)
                                        .padding(.bottom, keyTextBottomInset)
                        }
                        .frame(width: keyWidth, height: keyHeight)
                }
                .buttonStyle(PressButtonStyle($isTouching) {
                        context.performAudioFeedback(.input)
                        context.triggerHapticFeedback()
                        context.handle(virtual)
                })
        }
}
