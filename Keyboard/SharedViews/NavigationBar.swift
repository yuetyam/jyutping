import SwiftUI

struct NavigationBar: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                ZStack {
                        Text("NavigationBar.HintText.Scrollable").font(.footnote).shallow()
                        HStack {
                                NavigationLeadingBackButton()
                                Spacer()
                                NavigationTrailingExpansionButton()
                        }
                }
                .frame(height: context.keyboardInterface.isCompact ? PresetConstant.buttonLength : PresetConstant.buttonLengthXL)
        }
}
