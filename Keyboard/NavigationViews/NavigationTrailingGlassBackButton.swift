import SwiftUI

/// A glass back button for the trailing edge of a keyboard panel's navigation bar on iOS 26 and later.
///
/// The visible chevron and adjacent transparent buttons all return to the previous keyboard form.
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct NavigationTrailingGlassBackButton: View {

        /// Supplies keyboard routing and audio and haptic feedback.
        @EnvironmentObject private var context: KeyboardViewController

        /// Renders an upward chevron with a clear circular glass effect.
        ///
        /// Transparent buttons extend the tappable area by 12 points on the leading side and 4 points on the trailing side.
        var body: some View {
                HStack(spacing: 0) {
                        TransparentButton(width: 12, height: PresetConstant.buttonLength, action: action)
                        Button(action: action) {
                                ZStack{
                                        Color.interactiveClear
                                        Image.chevronUp
                                                .resizable()
                                                .scaledToFit()
                                                .padding(12)
                                }
                                .glassEffect(.clear, in: .circle)
                                .padding(1)
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
