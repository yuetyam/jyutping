import SwiftUI
import CoreIME
import CommonExtensions

struct CangjieInputKey: View {

        init(_ letter: Character) {
                let radical: Character = CharacterStandard.cangjie(of: letter) ?? "?"
                self.letter = String(letter)
                self.radical = String(radical)
        }

        private let letter: String
        private let radical: String

        @EnvironmentObject private var context: KeyboardViewController

        @Environment(\.colorScheme) private var colorScheme
        private var keyColor: Color {
                switch colorScheme {
                case .light:
                        return .light
                case .dark:
                        return .dark
                @unknown default:
                        return .light
                }
        }
        private var keyPreviewColor: Color {
                switch colorScheme {
                case .light:
                        return .light
                case .dark:
                        return .darkOpacity
                @unknown default:
                        return .light
                }
        }
        private var keyActiveColor: Color {
                switch colorScheme {
                case .light:
                        return .lightEmphatic
                case .dark:
                        return .darkEmphatic
                @unknown default:
                        return .lightEmphatic
                }
        }

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
                let activeColor: Color = shouldPreviewKey ? keyColor : keyActiveColor
                let shouldShowLowercaseKeys: Bool = Options.showLowercaseKeys && context.keyboardCase.isLowercased
                let textCase: Text.Case = shouldShowLowercaseKeys ? .lowercase : .uppercase
                ZStack {
                        Color.interactiveClear
                        if (isTouching && shouldPreviewKey) {
                                BubbleShape()
                                        .fill(keyPreviewColor)
                                        .shadow(color: .shadowGray, radius: 1)
                                        .overlay {
                                                Text(verbatim: radical)
                                                        .font(.largeTitle)
                                                        .padding(.bottom, previewBottomOffset)
                                        }
                                        .padding(.vertical, verticalPadding)
                                        .padding(.horizontal, horizontalPadding)
                        } else {
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .fill(isTouching ? activeColor : keyColor)
                                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                        .padding(.vertical, verticalPadding)
                                        .padding(.horizontal, horizontalPadding)
                                ZStack(alignment: .topTrailing) {
                                        Color.clear
                                        Text(verbatim: letter)
                                                .textCase(textCase)
                                                .font(.footnote)
                                                .opacity(0.66)
                                }
                                .padding(.vertical, verticalPadding)
                                .padding(.horizontal, horizontalPadding + 2)
                                Text(verbatim: radical)
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
                                let text: String = context.keyboardCase.isLowercased ? letter : letter.uppercased()
                                context.operate(.process(text))
                         }
                )
        }
}
