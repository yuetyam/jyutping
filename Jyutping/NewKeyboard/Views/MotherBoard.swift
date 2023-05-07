import SwiftUI

struct MotherBoard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                switch context.keyboardType {
                case .settings:
                        if #available(iOSApplicationExtension 16.0, *) {
                                SettingsView().environmentObject(context)
                        } else {
                                SettingsViewIOS15().environmentObject(context)
                        }
                case .candidateBoard:
                        CandidateBoard().environmentObject(context)
                default:
                        VStack(spacing: 0) {
                                if context.inputStage.isBuffering {
                                        CandidateScrollBar().environmentObject(context)
                                } else {
                                        ToolBar().environmentObject(context)
                                }
                                KeyboardStack().environmentObject(context)
                        }
                }
        }
}
