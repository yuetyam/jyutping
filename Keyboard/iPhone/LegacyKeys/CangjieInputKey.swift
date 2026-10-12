import SwiftUI
import CoreIME
import CommonExtensions

/// A Cangjie radical key that handles input as soon as the button is pressed.
///
/// Displays the radical with a letter caption that follows the lowercase-key preference and current keyboard case.
/// Pressing shows a radical preview bubble when enabled, or changes the key's background color otherwise.
struct CangjieInputKey: View {

        /// Creates a Cangjie key for the given input event.
        ///
        /// - Parameter virtual: The key whose letter and corresponding radical are displayed and whose event is handled on press-down.
        init(_ virtual: VirtualInputKey) {
                self.virtual = virtual
                self.letter = virtual.text
                self.radical = if let root = Converter.cangjie(of: virtual) { String(root) } else { String.questionMark }
        }

        /// Input event handled on press-down.
        private let virtual: VirtualInputKey

        /// Letter caption derived from the input key's text.
        private let letter: String

        /// Cangjie radical used for the main label and preview; falls back to "?" for an unmapped key.
        private let radical: String

        /// Keyboard dimensions, case, input handling, and haptic feedback.
        @EnvironmentObject private var context: KeyboardViewController

        /// Current color scheme used to choose the key and preview colors.
        @Environment(\.colorScheme) private var colorScheme

        /// Button press state reported by PressButtonStyle; may end when sliding outside the key.
        @State private var isTouching: Bool = false

        /// Renders the radical, letter caption, and optional preview using the current keyboard interface's geometry.
        ///
        /// PressButtonStyle synchronizes the pressed state and immediately plays input audio, triggers haptic feedback, and sends the input event to the controller.
        var body: some View {
                let keyWidth: CGFloat = context.widthUnit
                let keyHeight: CGFloat = context.heightUnit
                let keyboardInterface = context.keyboardInterface
                let insets = keyboardInterface.keyShapeInsets
                let previewBottomOffset = keyboardInterface.previewBottomOffset(keyWidth: keyWidth, keyHeight: keyHeight, insets: insets)
                let shouldPreviewKey: Bool = Options.keyTextPreview
                let activeColor: Color = shouldPreviewKey ? colorScheme.inputKeyColor : colorScheme.activeInputKeyColor
                let displayForm = KeyDisplayForm.responsive(isInteracting: isTouching, isLongPressing: false, shouldPreview: shouldPreviewKey)
                let shouldShowLowercaseKeys: Bool = Options.showLowercaseKeys && context.keyboardCase.isLowercased
                let textCase: Text.Case = shouldShowLowercaseKeys ? .lowercase : .uppercase
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                switch displayForm {
                                case .previewing, .expanding:
                                        BubbleShape()
                                                .fill(colorScheme.previewBubbleColor)
                                                .shadow(color: .shadowGray, radius: 1)
                                                .overlay {
                                                        Text(verbatim: radical)
                                                                .font(.largeTitle)
                                                                .padding(.bottom, previewBottomOffset)
                                                }
                                                .padding(insets)
                                case .normal, .reflecting:
                                        RoundedRectangle(cornerRadius: PresetConstant.keyCornerRadius)
                                                .fill(isTouching ? activeColor : colorScheme.inputKeyColor)
                                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                                .padding(insets)
                                        ZStack(alignment: .topTrailing) {
                                                Color.clear
                                                Text(verbatim: letter)
                                                        .textCase(textCase)
                                                        .font(.labelCaption)
                                                        .shallow()
                                        }
                                        .padding(insets.plused(horizontal: 2))
                                        Text(verbatim: radical)
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
