import SwiftUI
import CoreIME
import CommonExtensions

/// A twenty-one-key letter key that handles input as soon as the button is pressed.
///
/// The label follows the lowercase-key preference and current keyboard case.
/// Pressing shows a preview bubble when enabled, or changes the key's background color otherwise.
struct T21LetterInputKey: View {

        /// Creates a twenty-one-key letter key for the given input event.
        ///
        /// - Parameter virtual: The key whose text is displayed and whose event is handled on press-down.
        init(_ virtual: VirtualInputKey) {
                self.virtual = virtual
        }

        /// Input event handled on press-down; its text supplies the key label and preview.
        private let virtual: VirtualInputKey

        /// Keyboard dimensions, case, input handling, and haptic feedback.
        @EnvironmentObject private var context: KeyboardViewController

        /// Current color scheme used to choose the key and preview colors.
        @Environment(\.colorScheme) private var colorScheme

        /// Button press state reported by PressButtonStyle; may end when sliding outside the key.
        @State private var isTouching: Bool = false

        /// Renders the key and its optional preview using the current keyboard interface's geometry.
        ///
        /// PressButtonStyle synchronizes the pressed state and immediately plays input audio, triggers haptic feedback, and sends the event to the controller, which applies the keyboard case.
        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * 1.25
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
                                        Text(verbatim: virtual.text)
                                                .textCase(textCase)
                                                .font(.compactKeyLabel)
                                                .padding(.bottom, keyTextBottomInset)
                                }
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
