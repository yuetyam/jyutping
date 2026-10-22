import SwiftUI
import CommonExtensions

/// A back button for the leading edge of a keyboard panel's navigation bar.
///
/// The visible chevron and adjacent transparent buttons all return to the previous keyboard form.
struct NavigationLeadingBackButton: View {

        /// Supplies keyboard routing and audio and haptic feedback.
        @EnvironmentObject private var context: KeyboardViewController

        /// Renders a circular glass button on iOS 26 and later, or a regular-material circle on earlier systems.
        ///
        /// Transparent buttons extend the tappable area by 4 points on the leading side and 12 points on the trailing side.
        var body: some View {
                HStack(spacing: 0) {
                        TransparentButton(width: 4, height: PresetConstant.buttonLength, action: action)
                        if #available(iOSApplicationExtension 26.0, *) {
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
                        } else {
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
                        }
                        TransparentButton(width: 12, height: PresetConstant.buttonLength, action: action)
                }
        }

        /// Plays modification feedback and asks the controller to restore the previous keyboard form.
        private func action() {
                context.performAudioFeedback(.modify)
                context.triggerHapticFeedback()
                context.routeBackKeyboardForm()
        }
}
