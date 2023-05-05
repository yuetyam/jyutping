import SwiftUI

struct MotherBoard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                if context.keyboardType == .settings {
                        SettingsView().environmentObject(context)
                } else {
                        VStack(spacing: 0) {
                                ToolBar().environmentObject(context)
                                KeyboardStack().environmentObject(context)
                        }
                }
        }
}
