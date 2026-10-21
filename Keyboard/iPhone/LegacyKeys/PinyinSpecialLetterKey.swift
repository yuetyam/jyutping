import SwiftUI
import CommonExtensions
import CoreIME

/// A Pinyin V key with an umlaut hint that handles input as soon as the button is pressed.
///
/// The letter and hint follow the lowercase-key preference and current keyboard case.
/// Pressing shows a V preview when enabled, or changes the key's background color otherwise.
struct PinyinSpecialLetterKey: View {

        /// Virtual V input representing ü in Pinyin; its text supplies the key label and preview.
        private let virtual: VirtualInputKey = .letterV

        /// Umlaut hint displayed at the bottom trailing corner of the key.
        private let footer: String = "ü"

        /// Keyboard dimensions, case, input handling, and haptic feedback.
        @EnvironmentObject private var context: KeyboardViewController

        /// Current color scheme used to choose the key and preview colors.
        @Environment(\.colorScheme) private var colorScheme

        /// Button press state reported by PressButtonStyle; may end when sliding outside the key.
        @State private var isTouching: Bool = false

        /// Renders the V key, umlaut hint, and optional preview using the current keyboard interface's geometry.
        ///
        /// PressButtonStyle synchronizes the pressed state and immediately plays input audio, triggers haptic feedback, and sends the V event to the controller, which applies the keyboard case.
        var body: some View {
                let keyWidth: CGFloat = context.widthUnit
                let keyHeight: CGFloat = context.heightUnit
                let keyboardInterface = context.keyboardInterface
                let insets = keyboardInterface.keyShapeInsets
                let previewBottomOffset = keyboardInterface.previewBottomOffset(keyWidth: keyWidth, keyHeight: keyHeight, insets: insets)
                let isPreviewEnabled: Bool = context.isKeyTextPreviewEnabled
                let keyColor = colorScheme.inputKeyBackground(style: context.appearanceStyle, isPreviewEnabled: isPreviewEnabled, isInteracting: isTouching)
                let bubbleColor = colorScheme.bubbleBackground(style: context.appearanceStyle)
                let displayForm = KeyDisplayForm.responsive(isInteracting: isTouching, isLongPressEngaged: false, isPreviewEnabled: isPreviewEnabled)
                let shouldShowLowercaseKeys: Bool = Options.showLowercaseKeys && context.keyboardCase.isLowercased
                let textCase: Text.Case = shouldShowLowercaseKeys ? .lowercase : .uppercase
                let keyTextBottomInset: CGFloat = shouldShowLowercaseKeys ? 3 : 0
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                switch displayForm {
                                case .previewing, .expanding:
                                        BubbleShape()
                                                .fill(bubbleColor)
                                                .shadow(color: .shadowGray, radius: 1)
                                                .overlay {
                                                        Text(verbatim: virtual.text)
                                                                .textCase(textCase)
                                                                .font(.largeTitle)
                                                                .padding(.bottom, previewBottomOffset)
                                                }
                                                .padding(insets)
                                case .normal, .reflecting:
                                        RoundedRectangle(cornerRadius: PresetConstant.keyCornerRadius)
                                                .fill(keyColor)
                                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                                .padding(insets)
                                        ZStack(alignment: .bottomTrailing) {
                                                Color.clear
                                                Text(verbatim: footer)
                                                        .textCase(textCase)
                                                        .font(.labelCaption)
                                                        .shallow()
                                        }
                                        .padding(insets.plused(horizontal: 2))
                                        Text(verbatim: virtual.text)
                                                .textCase(textCase)
                                                .font(.compactKeyLabel)
                                                .padding(.bottom, keyTextBottomInset)
                                }
                        }
                        .frame(width: keyWidth, height: keyHeight)
                }
                .buttonStyle(PressButtonStyle($isTouching) {
                        AudioFeedback.inputed()
                        context.triggerHapticFeedback()
                        context.handle(virtual)
                })
        }
}
