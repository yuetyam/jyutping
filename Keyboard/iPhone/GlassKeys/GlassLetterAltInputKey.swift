import SwiftUI
import CoreIME
import CommonExtensions

/// A glass-styled letter key that handles input as soon as the button is pressed.
///
/// The label follows the lowercase-key preference and current keyboard case.
/// Pressing highlights and enlarges the glass key.
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassLetterAltInputKey: View {

        /// Creates a glass-styled letter key for the given input event.
        ///
        /// - Parameters:
        ///   - virtual: The key whose text is displayed and whose event is handled on press-down.
        ///   - coefficient: Key width as a multiple of the keyboard's width unit. Defaults to 1.42 for eighteen- and nineteen-key layouts.
        init(_ virtual: VirtualInputKey, coefficient: CGFloat = 1.42) {
                self.virtual = virtual
                self.coefficient = coefficient
        }

        /// Input event handled on press-down; its text supplies the key label and preview.
        private let virtual: VirtualInputKey

        /// Key width as a multiple of the keyboard's width unit.
        private let coefficient: CGFloat

        /// Keyboard properties and handlers.
        @EnvironmentObject private var context: KeyboardViewController

        /// Retrieves the current system color scheme (light or dark mode) from the environment.
        @Environment(\.colorScheme) private var colorScheme

        /// Button press state reported by PressButtonStyle; may end when sliding outside the key.
        @State private var isTouching: Bool = false

        /// Renders the glass key using the current keyboard interface's geometry.
        ///
        /// PressButtonStyle synchronizes the pressed state and plays sound feedback, triggers haptic feedback, and sends the event to the controller, which applies the keyboard case.
        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * coefficient
                let keyHeight: CGFloat = context.heightUnit
                let insets = context.keyboardInterface.keyShapeInsets
                let shouldShowLowercaseKeys: Bool = Options.showLowercaseKeys && context.keyboardCase.isLowercased
                let textCase: Text.Case = shouldShowLowercaseKeys ? .lowercase : .uppercase
                let keyTextBottomInset: CGFloat = shouldShowLowercaseKeys ? 3 : 0
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                ZStack {
                                        Color.clear
                                        Text(verbatim: virtual.text)
                                                .textCase(textCase)
                                                .font(.compactKeyLabel)
                                                .padding(.bottom, keyTextBottomInset)
                                }
                                .glassEffect(isTouching ? .regular : .clear, in: .rect(cornerRadius: PresetConstant.keyCornerRadius))
                                .shadow(color: isTouching ? colorScheme.glassShadow : Color.clear, radius: 0.5)
                                .padding(isTouching ? insets.plused(-2) : insets)
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
