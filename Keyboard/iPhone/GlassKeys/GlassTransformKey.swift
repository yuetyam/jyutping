import SwiftUI
import CommonExtensions

/// A glass-styled key that navigates to another keyboard form.
///
/// Displays the destination's compact transform label and highlights and enlarges the glass key while pressed.
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassTransformKey: View {

        /// Creates a glass-styled keyboard navigation key.
        ///
        /// - Parameters:
        ///   - destination: The keyboard form to route to.
        ///   - coefficient: Multiplier applied to the keyboard's width unit.
        init(_ destination: KeyboardForm, coefficient: CGFloat = 2) {
                self.destination = destination
                self.coefficient = coefficient
        }

        /// Keyboard form handled on pressing; supplies the compact key label.
        private let destination: KeyboardForm

        /// Multiplier applied to the keyboard's width unit.
        private let coefficient: CGFloat


        /// Keyboard properties and handlers.
        @EnvironmentObject private var context: KeyboardViewController

        /// Retrieves the current system color scheme (light or dark mode) from the environment.
        @Environment(\.colorScheme) private var colorScheme

        /// Button press state reported by PressButtonStyle; may end when sliding outside the key.
        @State private var isTouching: Bool = false

        /// Renders the glass key using the current keyboard interface's geometry.
        ///
        /// PressButtonStyle synchronizes the pressed state and plays sound feedback, triggers haptic feedback, and routes to the destination keyboard form.
        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * coefficient
                let keyHeight: CGFloat = context.heightUnit
                let insets = context.keyboardInterface.keyShapeInsets
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                ZStack {
                                        Color.clear
                                        Text(verbatim: destination.compactTransformKeyTex).font(.staticBody)
                                }
                                .glassEffect(isTouching ? .regular : .clear, in: .rect(cornerRadius: PresetConstant.keyCornerRadius))
                                .shadow(color: isTouching ? colorScheme.glassShadow : Color.clear, radius: 0.5)
                                .padding(isTouching ? insets.plused(-2) : insets)
                        }
                        .frame(width: keyWidth, height: keyHeight)
                }
                .buttonStyle(PressButtonStyle($isTouching) {
                        AudioFeedback.modified()
                        context.triggerHapticFeedback()
                        context.updateKeyboardForm(to: destination)
                })
        }
}
