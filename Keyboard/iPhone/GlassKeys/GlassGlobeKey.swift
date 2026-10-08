import SwiftUI
import CommonExtensions

/// A glass-styled globe key for switching between system input methods.
///
/// Displays the globe symbol over clear glass and delegates touch handling to UIGlobeButton, preserving the system input-mode list and press-down audio and haptic feedback.
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassGlobeKey: View {

        /// Creates a glass-styled input-mode switch key.
        ///
        /// - Parameter coefficient: Multiplier applied to the keyboard's width unit.
        init(coefficient: CGFloat = 1) {
                self.coefficient = coefficient
        }

        /// Multiplier applied to the keyboard's width unit.
        private let coefficient: CGFloat


        /// Keyboard properties and handlers.
        @EnvironmentObject private var context: KeyboardViewController

        /// Retrieves the current system color scheme (light or dark mode) from the environment.
        @Environment(\.colorScheme) private var colorScheme

        /// Renders the globe symbol and glass background using the current keyboard interface's geometry.
        ///
        /// UIGlobeButton overlays the full key area to forward touch events to the system input-mode handler and trigger feedback on press-down.
        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * coefficient
                let keyHeight: CGFloat = context.heightUnit
                let insets = context.keyboardInterface.keyShapeInsets
                ZStack {
                        Color.interactiveClear
                        ZStack {
                                Color.clear
                                Image.globe.font(.symbol)
                        }
                        .glassEffect(.clear, in: .rect(cornerRadius: PresetConstant.keyCornerRadius))
                        .padding(insets)
                        UIGlobeButton()
                }
                .frame(width: keyWidth, height: keyHeight)
        }
}
