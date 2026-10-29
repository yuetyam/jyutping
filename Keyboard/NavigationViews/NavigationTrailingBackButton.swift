import SwiftUI
import CommonExtensions

/// A material back button for the trailing edge of a keyboard panel's navigation bar.
///
/// The visible chevron and adjacent transparent buttons all return to the previous keyboard form.
struct NavigationTrailingBackButton: View {

        /// Supplies keyboard routing and audio and haptic feedback.
        @EnvironmentObject private var context: KeyboardViewController

        /// Renders an upward chevron over a regular-material circle.
        ///
        /// Transparent buttons extend the tappable area by 12 points on the leading side and 4 points on the trailing side.
        var body: some View {
                HStack(spacing: 0) {
                        TransparentButton(width: 12, height: PresetConstant.buttonLength, action: action)
                        Button(action: action) {
                                ZStack{
                                        Color.interactiveClear
                                        Circle()
                                                .fill(Material.regular)
                                                .padding(1)
                                        Image.chevronUp
                                                .resizable()
                                                .scaledToFit()
                                                .padding(12)
                                }
                                .frame(width: PresetConstant.buttonLength, height: PresetConstant.buttonLength)
                        }
                        .buttonStyle(.plain)
                        TransparentButton(width: 4, height: PresetConstant.buttonLength, action: action)
                }
        }

        /// Plays modification feedback and asks the controller to restore the previous keyboard form.
        private func action() {
                context.performAudioFeedback(.modify)
                context.triggerHapticFeedback()
                context.routeBackKeyboardForm()
        }
}
