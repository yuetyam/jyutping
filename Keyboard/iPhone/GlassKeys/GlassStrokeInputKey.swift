import SwiftUI
import CoreIME
import CommonExtensions

/// A glass-styled stroke key that handles input as soon as the button is pressed.
///
/// Displays a mapped stroke with a key-text caption, or the key text alone when no display stroke is available.
/// Key text follows the lowercase-key preference and current keyboard case.
/// Pressing shows a stroke or key-text preview bubble when enabled, or highlights and enlarges the glass key otherwise.
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassStrokeInputKey: View {

        /// Creates a glass-styled stroke key for the given input event.
        ///
        /// - Parameter virtual: The key whose text and optional display stroke are shown and whose event is handled on press-down.
        init(_ virtual: VirtualInputKey) {
                self.virtual = virtual
                self.strokeText = virtual.displayStrokeKeyText
        }

        /// Input event handled on press-down; its text supplies the caption or fallback label.
        private let virtual: VirtualInputKey

        /// Mapped stroke used for the main label and preview; nil makes the key display its input text alone.
        private let strokeText: String?

        /// Keyboard dimensions, case, input handling, and haptic feedback.
        @EnvironmentObject private var context: KeyboardViewController

        /// Current color scheme used to choose the pressed glass key's shadow color.
        @Environment(\.colorScheme) private var colorScheme

        /// Button press state reported by PressButtonStyle; may end when sliding outside the key.
        @State private var isTouching: Bool = false

        /// Renders the glass key, stroke or fallback text, optional caption, and preview using the current keyboard interface's geometry.
        ///
        /// PressButtonStyle synchronizes the pressed state and immediately plays input audio, triggers haptic feedback, and sends the input event to the controller.
        var body: some View {
                let keyWidth: CGFloat = context.widthUnit
                let keyHeight: CGFloat = context.heightUnit
                let keyboardInterface = context.keyboardInterface
                let insets = keyboardInterface.keyShapeInsets
                let previewBottomOffset = keyboardInterface.previewBottomOffset(keyWidth: keyWidth, keyHeight: keyHeight, insets: insets)
                let displayForm = KeyDisplayForm.responsive(isInteracting: isTouching, isLongPressing: false, shouldPreview: Options.keyTextPreview)
                let shouldShowLowercaseKeys: Bool = Options.showLowercaseKeys && context.keyboardCase.isLowercased
                let textCase: Text.Case = shouldShowLowercaseKeys ? .lowercase : .uppercase
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                switch displayForm {
                                case .previewing, .expanding:
                                        Color.clear
                                                .glassEffect(.regular, in: BubbleShape())
                                                .overlay {
                                                        Text(verbatim: strokeText ?? virtual.text)
                                                                .textCase(textCase)
                                                                .font(.largeTitle)
                                                                .padding(.bottom, previewBottomOffset)
                                                }
                                                .padding(insets)
                                case .normal, .reflecting:
                                        Color.clear
                                                .glassEffect(displayForm.isReflecting ? .regular : .clear, in: .rect(cornerRadius: PresetConstant.keyCornerRadius))
                                                .shadow(color: displayForm.isReflecting ? colorScheme.glassShadow : Color.clear, radius: 0.5)
                                                .padding(displayForm.isReflecting ? insets.plused(-2) : insets)
                                        if let strokeText {
                                                ZStack(alignment: .topTrailing) {
                                                        Color.clear
                                                        Text(verbatim: virtual.text)
                                                                .textCase(textCase)
                                                                .font(.labelCaption)
                                                                .shallow()
                                                }
                                                .padding(insets.plused(horizontal: 2))
                                                Text(verbatim: strokeText)
                                        } else {
                                                Text(verbatim: virtual.text)
                                                        .textCase(textCase)
                                                        .shallow()
                                        }
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
