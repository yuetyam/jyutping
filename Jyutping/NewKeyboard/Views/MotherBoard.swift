import SwiftUI

struct MotherBoard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                switch context.keyboardType {
                case .settings:
                        SettingsView().environmentObject(context)
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
