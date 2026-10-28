import SwiftUI

struct NavigationBar: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                ZStack {
                        Text("SettingsView.NavigationBar.HintText").font(.footnote).shallow()
                        HStack {
                                NavigationLeadingBackButton()
                                Spacer()
                                NavigationTrailingExpansionButton()
                        }
                }
                .frame(height: context.keyboardInterface.isCompact ? PresetConstant.buttonLength : PresetConstant.buttonLengthXL)
        }
}
