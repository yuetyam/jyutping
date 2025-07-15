import SwiftUI
import CoreIME
import CommonExtensions

struct LargePadCangjieInputKey: View {

        init(_ event: InputEvent) {
                self.event = event
                self.letter = event.text
                let radical: Character = event.text.first.flatMap(CharacterStandard.cangjie(of:)) ?? "?"
                self.radical = String(radical)
        }

        private let event: InputEvent
        private let letter: String
        private let radical: String

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
                        ZStack(alignment: .topTrailing) {
                                Color.clear
                                Text(verbatim: letter)
                                        .textCase(textCase)
                                        .font(.footnote)
                                        .shallow()
                        }
                        .padding(.vertical, verticalPadding + 2)
                        .padding(.horizontal, horizontalPadding + 4)
                        Text(verbatim: radical)
                }
                .frame(width: keyWidth, height: keyHeight)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                if tapped.negative {
                                        AudioFeedback.inputed()
                                        tapped = true
                                }
                        }
                        .onEnded { _ in
                                context.process(event, isCapitalized: context.keyboardCase.isCapitalized)
                         }
                )
        }
}
