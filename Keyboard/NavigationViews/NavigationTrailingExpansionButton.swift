import SwiftUI
import CommonExtensions

/// A material button for the trailing edge of a keyboard panel's navigation bar that toggles the keyboard's expanded height.
///
/// The symbol reflects the next action: expand the keyboard or restore its cached height.
struct NavigationTrailingExpansionButton: View {

        /// Supplies the expansion state, height updates, and audio and haptic feedback.
        @EnvironmentObject private var context: KeyboardViewController

        /// The SF Symbol displayed when the keyboard can be expanded.
        private let expandImageName: String = "arrow.down.backward.and.arrow.up.forward"

        /// The SF Symbol displayed when the keyboard can be restored to its cached height.
        private let collapseImageName: String = "arrow.up.forward.and.arrow.down.backward"

        /// Renders the symbol for the next height-toggle action over a regular-material circle.
        ///
        /// Transparent buttons extend the tappable area by 12 points on the leading side and 4 points on the trailing side, sharing the height-toggle action.
        var body: some View {
                HStack(spacing: 0) {
                        TransparentButton(width: 12, height: PresetConstant.buttonLength, action: action)
                        Button(action: action) {
                                ZStack {
                                        Color.interactiveClear
                                        Circle()
                                                .fill(Material.regular)
                                                .padding(1)
                                        Image(systemName: context.isKeyboardHeightExpanded ? collapseImageName : expandImageName)
                                                .resizable()
                                                .scaledToFit()
                                                .padding(13)
                                }
                                .frame(width: PresetConstant.buttonLength, height: PresetConstant.buttonLength)
                        }
                        .buttonStyle(.plain)
                        TransparentButton(width: 4, height: PresetConstant.buttonLength, action: action)
                }
        }

        /// Plays modification feedback and toggles between expanded and cached keyboard heights.
        private func action() {
                context.performAudioFeedback(.modify)
                context.triggerHapticFeedback()
                context.toggleKeyboardHeight()
        }
}
