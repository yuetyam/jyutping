import SwiftUI
import CommonExtensions
import CoreIME

struct LargePadInstantInputKey: View {

        private let keyText: String
        private let event: VirtualInputKey?

        init(_ keyText: String, event: VirtualInputKey? = nil) {
                self.keyText = keyText
                self.event = event
        }

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @State private var isTouching: Bool = false

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit
                let keyHeight: CGFloat = context.heightUnit
                let isLandscape: Bool = context.keyboardInterface.isPadLandscape
                let verticalPadding: CGFloat = isLandscape ? 5 : 4
                let horizontalPadding: CGFloat = isLandscape ? 5 : 4
                let shouldShowLowercaseKeys: Bool = Options.showLowercaseKeys && context.keyboardCase.isLowercased
                let textCase: Text.Case = shouldShowLowercaseKeys ? .lowercase : .uppercase
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius)
                                        .fill(isTouching ? colorScheme.activeInputKeyColor : colorScheme.inputKeyColor)
                                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                        .padding(.vertical, verticalPadding)
                                        .padding(.horizontal, horizontalPadding)
                                Text(verbatim: keyText)
                                        .textCase(textCase)
                                        .font(.title2)
                        }
                        .frame(width: keyWidth, height: keyHeight)
                }
                .buttonStyle(PressButtonStyle($isTouching) {
                        AudioFeedback.inputed()
                        if let event {
                                context.handle(event)
                        } else {
                                let text: String = context.keyboardCase.isLowercased ? keyText : keyText.uppercased()
                                context.operate(.input(text))
                        }
                })
        }
}
