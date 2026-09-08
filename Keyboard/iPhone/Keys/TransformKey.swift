import SwiftUI
import CommonExtensions

/// Navigate between KeyboardForms
struct TransformKey: View {

        /// Create a TransformKey
        /// - Parameters:
        ///   - destination: Next KeyboardForm to route to
        ///   - coefficient: Multiplier to the `widthUnit`
        init(destination: KeyboardForm, coefficient: CGFloat = 1) {
                self.destination = destination
                self.coefficient = coefficient
        }

        private let destination: KeyboardForm
        private let coefficient: CGFloat

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme
        @State private var isTouching: Bool = false

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * coefficient
                let keyHeight: CGFloat = context.heightUnit
                let keyboardInterface = context.keyboardInterface
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                RoundedRectangle(cornerRadius: PresetConstant.keyCornerRadius)
                                        .fill(isTouching ? colorScheme.activeActionKeyColor : colorScheme.actionKeyColor)
                                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                        .padding(keyboardInterface.keyShapeInsets)
                                Text(verbatim: destination.compactTransformKeyTex).font(.staticBody)
                        }
                        .frame(width: keyWidth, height: keyHeight)
                }
                .buttonStyle(PressButtonStyle($isTouching) {
                        AudioFeedback.modified()
                        context.triggerHapticFeedback()
                        context.updateKeyboardForm(to: destination)
                })
        }
}
