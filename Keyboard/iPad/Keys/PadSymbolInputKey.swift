import SwiftUI
import CommonExtensions

/// ABC mode Numeric/Symbolic input key
struct PadSymbolInputKey: View {

        init(_ keyText: String, widthUnitTimes: CGFloat = 1) {
                self.keyText = keyText
                self.widthUnitTimes = widthUnitTimes
        }

        private let keyText: String
        private let widthUnitTimes: CGFloat

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
                                        .fill(isTouching ? colorScheme.activeInputKeyColor : colorScheme.inputKeyColor)
                                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                        .padding(.vertical, verticalPadding)
                                        .padding(.horizontal, horizontalPadding)
                                Text(verbatim: keyText).font(.title2)
                        }
                        .frame(width: keyWidth, height: keyHeight)
                }
                .buttonStyle(PressButtonStyle($isTouching) {
                        AudioFeedback.inputed()
                        context.operate(.input(keyText))
                })
        }
}
