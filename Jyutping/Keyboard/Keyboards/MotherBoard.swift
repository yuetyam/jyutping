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
                case .emojiBoard:
                        EmojiBoard().environmentObject(context)
                case .numeric:
                        NumericKeyboard().environmentObject(context)
                case .symbolic:
                        SymbolicKeyboard().environmentObject(context)
                default:
                        switch context.inputMethodMode {
                        case .abc:
                                AlphabeticKeyboard().environmentObject(context)
                        case .cantonese:
                                switch Options.keyboardLayout {
                                case .qwerty:
                                        AlphabeticKeyboard().environmentObject(context)
                                case .saamPing:
                                        AlphabeticKeyboard().environmentObject(context)
                                case .tenKey:
                                        if context.keyboardInterface.isCompact {
                                                TenKeyKeyboard().environmentObject(context)
                                        } else {
                                                AlphabeticKeyboard().environmentObject(context)
                                        }
                                }
                        }
                }
        }
}
