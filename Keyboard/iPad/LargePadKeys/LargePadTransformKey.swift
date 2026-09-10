import SwiftUI
import CommonExtensions

struct LargePadTransformKey: View {

        /// Create a LargePadTransformKey
        /// - Parameters:
        ///   - destination: Next KeyboardForm to route to
        ///   - side: Key location, left half screen (leading) or right half screen (trailing).
        ///   - coefficient: Multiplier to the `widthUnit`
        init(destination: KeyboardForm, side: HorizontalEdge, coefficient: CGFloat = 1) {
                self.destination = destination
                self.side = side
                self.coefficient = coefficient
        }
        private let destination: KeyboardForm
        private let side: HorizontalEdge
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
                                RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius)
                                        .fill(isTouching ? colorScheme.activeActionKeyColor : colorScheme.actionKeyColor)
                                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                        .padding(keyboardInterface.keyShapeInsets)
                                ZStack(alignment: side.isLeading ? .bottomLeading : .bottomTrailing) {
                                        Color.clear
                                        Text(verbatim: destination.padTransformKeyText)
                                }
                                .padding(keyboardInterface.keyShapeInsets.plused(7))
                        }
                        .frame(width: keyWidth, height: keyHeight)
                }
                .buttonStyle(PressButtonStyle($isTouching) {
                        AudioFeedback.modified()
                        context.updateKeyboardForm(to: destination)
                })
        }
}
