import SwiftUI
import CommonExtensions

/// A glass-styled iPhone symbol key that processes its text on press-down.
///
/// Pressing shows a text preview bubble when enabled, or highlights and enlarges the glass key otherwise.
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassSymbolInputKey: View {

        /// Creates a glass-styled key for the given symbol text.
        ///
        /// - Parameters:
        ///   - text: The text displayed in the key and preview, and processed on press-down.
        ///   - coefficient: A multiplier for the keyboard's width unit. Defaults to one unit.
        init(_ text: String, coefficient: CGFloat = 1) {
                self.text = text
                self.coefficient = coefficient
        }

        /// Symbol text shared by the key label, preview, and input operation.
        private let text: String

        /// Key width as a multiple of the keyboard's width unit.
        private let coefficient: CGFloat


        /// Keyboard properties and handlers.
        @EnvironmentObject private var context: KeyboardViewController

        /// Retrieves the current system color scheme (light or dark mode) from the environment.
        @Environment(\.colorScheme) private var colorScheme

        /// Button press state reported by PressButtonStyle, used to select the display form.
        @State private var isTouching: Bool = false

        /// Renders the glass key and optional preview using the current keyboard interface's insets and preview offset.
        ///
        /// PressButtonStyle synchronizes the pressed state and plays audio feedback, triggers haptic feedback, and sends a text-processing operation to the controller on press-down.
        var body: some View {
                let keyWidth = context.widthUnit * coefficient
                let keyHeight = context.heightUnit
                let keyboardInterface = context.keyboardInterface
                let insets = keyboardInterface.keyShapeInsets
                let previewBottomOffset = keyboardInterface.previewBottomOffset(keyWidth: keyWidth, keyHeight: keyHeight, insets: insets)
                let displayForm = KeyDisplayForm.responsive(isInteracting: isTouching, shouldPreview: Options.keyTextPreview)
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                switch displayForm {
                                case .previewing, .expanding:
                                        Color.clear
                                                .glassEffect(.regular, in: BubbleShape())
                                                .overlay {
                                                        Text(verbatim: text)
                                                                .font(.largeTitle)
                                                                .padding(.bottom, previewBottomOffset)
                                                }
                                                .padding(insets)
                                case .normal, .reflecting:
                                        ZStack {
                                                Color.clear
                                                Text(verbatim: text).font(.letterCompact)
                                        }
                                        .glassEffect(displayForm.isReflecting ? .regular : .clear, in: .rect(cornerRadius: PresetConstant.keyCornerRadius))
                                        .shadow(color: displayForm.isReflecting ? colorScheme.glassShadow : Color.clear, radius: 0.5)
                                        .padding(displayForm.isReflecting ? insets.plused(-2) : insets)
                                }
                        }
                        .frame(width: keyWidth, height: keyHeight)
                }
                .buttonStyle(PressButtonStyle($isTouching) {
                        AudioFeedback.inputed()
                        context.triggerHapticFeedback()
                        context.operate(.process(text))
                })
        }
}
