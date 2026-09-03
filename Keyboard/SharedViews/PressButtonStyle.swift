import SwiftUI

/// A button style that exposes the button's current pressed state and executes an action immediately when the button is pressed.
///
/// Unlike a button's normal action, which is typically invoked when the user completes the interaction by releasing the button, the `action` provided to this style is invoked as soon as the button becomes pressed.
///
/// The current pressed state is continuously reflected by `isTouching`. This makes the style useful for buttons that need to respond to the beginning and end of a touch interaction, such as keyboard keys.
///
/// - Important: The `action` is called whenever `configuration.isPressed` changes from `false` to `true`. It may therefore be called multiple times if the button is pressed repeatedly.
///
/// - Parameters:
///   - isTouching: A binding that receives the button's current pressed state. It is set to `true` while the button is pressed and `false` after the press ends.
///   - action: The action to execute when the button becomes pressed.
struct PressButtonStyle: ButtonStyle {

        @Binding private var isTouching: Bool
        private let action: () -> Void

        /// Creates a button style that reports its pressed state and performs an action when the button is pressed.
        ///
        /// - Parameters:
        ///   - isTouching: A binding used to expose whether the button is currently being pressed.
        ///   - action: The closure to execute when the button becomes pressed.
        init(_ isTouching: Binding<Bool>, action: @escaping () -> Void) {
                self._isTouching = isTouching
                self.action = action
        }


        // TODO: - Use the new `onChange` when increasing the minSDK to iOS 17

        /// Creates the view representing the styled button.
        ///
        /// The label supplied by the button is returned without additional visual modifications. Changes to the button's pressed state are observed to keep `isTouching` synchronized with `configuration.isPressed`.
        ///
        /// When the button transitions into the pressed state, `action` is executed immediately rather than waiting for the normal button activation event.
        ///
        /// - Parameter configuration: The configuration provided by SwiftUI,
        ///   containing the button's label and current interaction state.
        /// - Returns: The view used to render the button.
        func makeBody(configuration: Configuration) -> some View {
                configuration.label
                        .onChange(of: configuration.isPressed) { isPressed in
                                isTouching = isPressed
                                if isPressed {
                                        action()
                                }
                        }
        }
}
