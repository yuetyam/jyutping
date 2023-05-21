import SwiftUI

struct MotherBoard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                switch context.keyboardForm {
                case .settings:
                        if #available(iOSApplicationExtension 16.0, *) {
                                SettingsView().environmentObject(context)
                        } else {
                                SettingsViewIOS15().environmentObject(context)
                        }
                case .editingPanel:
                        EditingPanel().environmentObject(context)
                case .candidateBoard:
                        CandidateBoard().environmentObject(context)
                case .numeric:
                        NumericKeyboard().environmentObject(context)
                case .symbolic:
                        SymbolicKeyboard().environmentObject(context)
                default:
                        AlphabeticKeyboard().environmentObject(context)
                }
        }
}
