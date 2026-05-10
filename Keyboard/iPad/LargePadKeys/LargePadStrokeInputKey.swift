import SwiftUI
import CoreIME
import CommonExtensions

struct LargePadStrokeInputKey: View {

        init(_ virtual: VirtualInputKey) {
                self.virtual = virtual
                self.displayStroke = virtual.displayStrokeKeyText
        }

        private let virtual: VirtualInputKey
        private let displayStroke: String?

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @GestureState private var isTouching: Bool = false

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit
                let keyHeight: CGFloat = context.heightUnit
                let isLandscape: Bool = context.keyboardInterface.isPadLandscape
                let verticalPadding: CGFloat = isLandscape ? 5 : 4
                let horizontalPadding: CGFloat = isLandscape ? 5 : 4
                let shouldShowLowercaseKeys: Bool = Options.showLowercaseKeys && context.keyboardCase.isLowercased
                let textCase: Text.Case = shouldShowLowercaseKeys ? .lowercase : .uppercase
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous)
                                .fill(isTouching ? colorScheme.activeInputKeyColor : colorScheme.inputKeyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(.vertical, verticalPadding)
                                .padding(.horizontal, horizontalPadding)
                        if let displayStroke {
                                ZStack(alignment: .topTrailing) {
                                        Color.clear
                                        Text(verbatim: virtual.text)
                                                .textCase(textCase)
                                                .font(.footnote)
                                                .shallow()
                                }
                                .padding(.vertical, verticalPadding + 2)
                                .padding(.horizontal, horizontalPadding + 4)
                                Text(verbatim: displayStroke)
                        } else {
                                Text(verbatim: virtual.text)
                                        .textCase(textCase)
                                        .shallow()
                        }
                }
                .frame(width: keyWidth, height: keyHeight)
                .contentShape(.rect)
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                if tapped.negative {
                                        AudioFeedback.inputed()
                                        tapped = true
                                }
                        }
                        .onEnded { _ in
                                context.handle(virtual)
                        }
                )
        }
}
