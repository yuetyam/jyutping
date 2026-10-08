import SwiftUI
import CommonExtensions

/// A glass-styled return key that handles the return operation .
///
/// Displays confirmation text while composing, a return symbol for the default return type, or an action symbol with a compact label for other return types.
/// Available action keys use the accent color while idle; pressing highlights and enlarges the glass key.
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassEnterKey: View {

        /// Creates a glass-styled return key.
        ///
        /// - Parameter coefficient: Multiplier applied to the keyboard's width unit. Defaults to 2.
        init(coefficient: CGFloat = 2) {
                self.coefficient = coefficient
        }

        /// Multiplier applied to the keyboard's width unit.
        private let coefficient: CGFloat


        /// Keyboard properties and handlers.
        @EnvironmentObject private var context: KeyboardViewController

        /// Retrieves the current system color scheme (light or dark mode) from the environment.
        @Environment(\.colorScheme) private var colorScheme

        /// Button press state reported by PressButtonStyle; may end when sliding outside the key.
        @State private var isTouching: Bool = false

        /// Renders the glass key using the current keyboard interface's geometry and return-key state.
        ///
        /// Unavailable keys display dimmed labels while idle. PressButtonStyle synchronizes the pressed state, plays sound feedback, triggers haptic feedback, and sends the return operation to the controller.
        /// The controller handles composition confirmation and newline insertion.
        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * coefficient
                let keyHeight: CGFloat = context.heightUnit
                let insets = context.keyboardInterface.keyShapeInsets
                let isDefaultReturn: Bool = context.returnKeyType.isDefaultReturn
                let keyState: ReturnKeyState = context.returnKeyState
                let glassBackColor: Color = {
                        guard isTouching.negative else { return Color.clear }
                        switch keyState {
                        case .standbyABC, .standbyMutilated, .standbyTraditional:
                                return isDefaultReturn ? Color.clear : Color.accentColor
                        default:
                                return Color.clear
                        }
                }()
                let foreColor: Color = {
                        guard isTouching.negative else { return Color.primary }
                        switch keyState {
                        case .bufferingMutilated, .bufferingTraditional:
                                return Color.primary
                        case .standbyABC, .standbyMutilated, .standbyTraditional:
                                return isDefaultReturn ? Color.primary : Color.white
                        case .unavailableABC, .unavailableMutilated, .unavailableTraditional:
                                return Color.primary.opacity(0.5)
                        }
                }()
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                glassBackColor
                                        .clipShape(.rect(cornerRadius: PresetConstant.keyCornerRadius))
                                        .glassEffect(isTouching ? .regular : .clear, in: .rect(cornerRadius: PresetConstant.keyCornerRadius))
                                        .shadow(color: isTouching ? colorScheme.glassShadow : Color.clear, radius: 0.5)
                                        .padding(isTouching ? insets.plused(-2) : insets)
                                switch (keyState.isBuffering, isDefaultReturn) {
                                case (true, _):
                                        Text(context.returnKeyText).font(.staticBody)
                                case (false, true):
                                        Image.return
                                default:
                                        ZStack(alignment: .bottomTrailing) {
                                                Color.clear
                                                Text(context.returnKeyText).font(.labelCaption)
                                        }
                                        .padding(insets.plused(1))
                                        switch context.returnKeyType {
                                        case .continue, .next:
                                                Image.chevronForward
                                        case .done:
                                                Image.checkmark
                                        case .go, .route, .join:
                                                Image.arrowForward
                                        case .search, .google, .yahoo:
                                                Image.search
                                        case .send:
                                                Image.arrowUp
                                        default:
                                                Image.return
                                        }
                                }
                        }
                        .font(.symbol)
                        .foregroundStyle(foreColor)
                        .frame(width: keyWidth, height: keyHeight)
                }
                .buttonStyle(PressButtonStyle($isTouching) {
                        AudioFeedback.modified()
                        context.triggerHapticFeedback()
                        context.operate(.return)
                })
        }
}
