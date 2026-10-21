import SwiftUI
import CommonExtensions
import CoreIME

/// A glass-styled iPhone symbol key that processes text or handles an input event on press-down.
///
/// Pressing shows a text preview bubble when enabled, or highlights and enlarges the glass key otherwise.
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassSymbolInputKey: View {

        /// Creates a glass-styled key that processes the given symbol text.
        ///
        /// - Parameters:
        ///   - text: The text displayed in the key and preview, and processed on press-down.
        ///   - coefficient: Key width as a multiple of the keyboard's width unit. Defaults to one unit.
        init(_ text: String, coefficient: CGFloat = 1) {
                self.virtual = nil
                self.keyText = text
                self.coefficient = coefficient
        }

        /// Creates a glass-styled key that handles the given input event.
        ///
        /// - Parameters:
        ///   - virtual: The key whose text is displayed and whose event is handled on press-down.
        ///   - coefficient: Key width as a multiple of the keyboard's width unit. Defaults to one unit.
        init(virtual: VirtualInputKey, coefficient: CGFloat = 1) {
                self.virtual = virtual
                self.keyText = virtual.text
                self.coefficient = coefficient
        }

        /// Optional input event handled on press-down; when nil, keyText is processed instead.
        private let virtual: VirtualInputKey?

        /// Text displayed in the key and preview, taken from the symbol text or input event.
        private let keyText: String

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
        /// PressButtonStyle synchronizes the pressed state, plays audio feedback, triggers haptic feedback, and sends the input event or text-processing operation to the controller on press-down.
        var body: some View {
                let keyWidth = context.widthUnit * coefficient
                let keyHeight = context.heightUnit
                let keyboardInterface = context.keyboardInterface
                let insets = keyboardInterface.keyShapeInsets
                let previewBottomOffset = keyboardInterface.previewBottomOffset(keyWidth: keyWidth, keyHeight: keyHeight, insets: insets)
                let displayForm = KeyDisplayForm.responsive(isInteracting: isTouching, isPreviewEnabled: context.isKeyTextPreviewEnabled)
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                switch displayForm {
                                case .previewing, .expanding:
                                        Color.clear
                                                .glassEffect(.regular, in: BubbleShape())
                                                .overlay {
                                                        Text(verbatim: keyText)
                                                                .font(.largeTitle)
                                                                .padding(.bottom, previewBottomOffset)
                                                }
                                                .padding(insets)
                                case .normal, .reflecting:
                                        ZStack {
                                                Color.clear
                                                Text(verbatim: keyText).font(.compactKeyLabel)
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
                        if let virtual {
                                context.handle(virtual)
                        } else {
                                context.operate(.process(keyText))
                        }
                })
        }
}
