import SwiftUI

struct MotherBoard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                switch context.keyboardForm {
                case .settings:
                        if #available(iOSApplicationExtension 16.0, *) {
                                SettingsView()
                        } else {
                                SettingsViewIOS15()
                        }
                case .editingPanel:
                        EditingPanel()
                case .candidateBoard:
                        CandidateBoard()
                case .emojiBoard:
                        EmojiBoard()
                case .numeric:
                        switch context.inputMethodMode {
                        case .cantonese:
                                CantoneseNumericKeyboard()
                        case .abc:
                                NumericKeyboard()
                        }
                case .symbolic:
                        switch context.inputMethodMode {
                        case .cantonese:
                                CantoneseSymbolicKeyboard()
                        case .abc:
                                SymbolicKeyboard()
                        }
                case .tenKeyNumeric:
                        TenKeyNumericKeyboard()
                case .numberPad:
                        NumberPad(isDecimalPad: false)
                case .decimalPad:
                        NumberPad(isDecimalPad: true)
                default:
                        switch context.inputMethodMode {
                        case .abc:
                                if context.keyboardInterface.isCompact {
                                        AlphabeticKeyboard()
                                } else {
                                        SmallPadAlphabeticKeyboard()
                                }
                        case .cantonese:
                                switch Options.keyboardLayout {
                                case .qwerty:
                                        switch context.qwertyForm {
                                        case .cangjie:
                                                CangjieKeyboard()
                                        case .stroke:
                                                StrokeKeyboard()
                                        default:
                                                if context.keyboardInterface.isCompact {
                                                        AlphabeticKeyboard()
                                                } else {
                                                        SmallPadAlphabeticKeyboard()
                                                }
                                        }
                                case .saamPing:
                                        switch context.qwertyForm {
                                        case .cangjie:
                                                CangjieKeyboard()
                                        case .stroke:
                                                StrokeKeyboard()
                                        default:
                                                SaamPingKeyboard()
                                        }
                                case .tenKey:
                                        if context.keyboardInterface.isCompact {
                                                TenKeyKeyboard()
                                        } else {
                                                AlphabeticKeyboard()
                                        }
                                }
                        }
                }
        }
}
