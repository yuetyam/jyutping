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
                                if context.keyboardInterface.isCompact {
                                        CantoneseNumericKeyboard()
                                } else {
                                        SmallPadCantoneseNumericKeyboard()
                                }
                        case .abc:
                                if context.keyboardInterface.isCompact {
                                        NumericKeyboard()
                                } else {
                                        SmallPadNumericKeyboard()
                                }
                        }
                case .symbolic:
                        switch context.inputMethodMode {
                        case .cantonese:
                                if context.keyboardInterface.isCompact {
                                        CantoneseSymbolicKeyboard()
                                } else {
                                        SmallPadCantoneseSymbolicKeyboard()
                                }
                        case .abc:
                                if context.keyboardInterface.isCompact {
                                        SymbolicKeyboard()
                                } else {
                                        SmallPadSymbolicKeyboard()
                                }
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
                                                if context.keyboardInterface.isCompact {
                                                        CangjieKeyboard()
                                                } else {
                                                        SmallPadCangjieKeyboard()
                                                }
                                        case .stroke:
                                                if context.keyboardInterface.isCompact {
                                                        StrokeKeyboard()
                                                } else {
                                                        SmallPadStrokeKeyboard()
                                                }
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
