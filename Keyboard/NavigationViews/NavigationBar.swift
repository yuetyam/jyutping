import SwiftUI

/// A keyboard panel's navigation bar with a centered scrolling hint, a leading back button, and a trailing height toggle.
///
/// Uses glass buttons when the Glass appearance is selected on iOS 26 and later, and material buttons otherwise.
struct NavigationBar: View {

        /// Supplies the selected appearance and keyboard interface used to size the bar.
        @EnvironmentObject private var context: KeyboardViewController

        /// Overlays the navigation controls on the localized hint and uses a taller bar for non-compact interfaces.
        var body: some View {
                ZStack {
                        Text("NavigationBar.HintText.Scrollable").font(.footnote).shallow()
                        if #available(iOSApplicationExtension 26.0, *), context.appearanceStyle.isGlass {
                                HStack {
                                        NavigationLeadingGlassBackButton()
                                        Spacer()
                                        NavigationTrailingGlassExpansionButton()
                                }
                        } else {
                                HStack {
                                        NavigationLeadingBackButton()
                                        Spacer()
                                        NavigationTrailingExpansionButton()
                                }
                        }
                }
                .frame(height: context.keyboardInterface.isCompact ? PresetConstant.buttonLength : PresetConstant.buttonLengthXL)
        }
}
