import SwiftUI
import CommonExtensions
import CoreIME

/// An iPhone symbol key that processes text or handles an input event on press-down.
///
/// Pressing shows a text preview bubble when enabled, or highlights the key otherwise.
struct SymbolInputKey: View {

        /// Creates a key that processes the given symbol text.
        ///
        /// - Parameters:
        ///   - text: The text displayed in the key and preview, and processed on press-down.
        ///   - coefficient: Key width as a multiple of the keyboard's width unit. Defaults to one unit.
        init(_ text: String, coefficient: CGFloat = 1) {
                self.virtual = nil
                self.keyText = text
                self.coefficient = coefficient
        }

        /// Creates a key that handles the given input event.
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

        /// Renders the key and optional preview using the current keyboard interface's insets and preview offset.
        ///
        /// PressButtonStyle synchronizes the pressed state, plays audio feedback, triggers haptic feedback, and sends the input event or text-processing operation to the controller on press-down.
        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * coefficient
                let keyHeight: CGFloat = context.heightUnit
                let keyboardInterface = context.keyboardInterface
                let insets = keyboardInterface.keyShapeInsets
                let previewBottomOffset: CGFloat = keyboardInterface.previewBottomOffset(keyWidth: keyWidth, keyHeight: keyHeight, insets: insets)
                let isPreviewEnabled: Bool = context.isKeyTextPreviewEnabled
                let displayForm: KeyDisplayForm = KeyDisplayForm.responsive(isInteracting: isTouching, isLongPressEngaged: false, isPreviewEnabled: isPreviewEnabled)
                let keyColor = colorScheme.inputKeyBackground(style: context.appearanceStyle, isPreviewEnabled: isPreviewEnabled, isInteracting: isTouching)
                let bubbleColor = colorScheme.bubbleBackground(style: context.appearanceStyle)
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                switch displayForm {
                                case .previewing, .expanding:
                                        BubbleShape()
                                                .fill(bubbleColor)
                                                .shadow(color: .shadowGray, radius: 1)
                                                .overlay {
                                                        Text(verbatim: keyText)
                                                                .font(.largeTitle)
                                                                .padding(.bottom, previewBottomOffset)
                                                }
                                                .padding(insets)
                                case .normal, .reflecting:
                                        RoundedRectangle(cornerRadius: PresetConstant.keyCornerRadius)
                                                .fill(keyColor)
                                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                                .padding(insets)
                                        Text(verbatim: keyText).font(.compactKeyLabel)
                                }
                        }
                        .frame(width: keyWidth, height: keyHeight)
                }
                .buttonStyle(PressButtonStyle($isTouching) {
                        context.performAudioFeedback(.input)
                        context.triggerHapticFeedback()
                        if let virtual {
                                context.handle(virtual)
                        } else {
                                context.operate(.process(keyText))
                        }
                })
        }
}
