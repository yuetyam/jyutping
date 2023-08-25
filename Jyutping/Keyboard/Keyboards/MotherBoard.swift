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
                                switch context.keyboardInterface {
                                case .phonePortrait:
                                        CantoneseNumericKeyboard()
                                case .phoneLandscape:
                                        CantoneseNumericKeyboard()
                                case .padFloating:
                                        CantoneseNumericKeyboard()
                                case .padPortraitSmall:
                                        PadCantoneseNumericKeyboard()
                                case .padPortraitMedium:
                                        PadCantoneseNumericKeyboard()
                                case .padPortraitLarge:
                                        LargePadCantoneseNumericKeyboard()
                                case .padLandscapeSmall:
                                        PadCantoneseNumericKeyboard()
                                case .padLandscapeMedium:
                                        PadCantoneseNumericKeyboard()
                                case .padLandscapeLarge:
                                        LargePadCantoneseNumericKeyboard()
                                }
                        case .abc:
                                switch context.keyboardInterface {
                                case .phonePortrait:
                                        NumericKeyboard()
                                case .phoneLandscape:
                                        NumericKeyboard()
                                case .padFloating:
                                        NumericKeyboard()
                                case .padPortraitSmall:
                                        PadNumericKeyboard()
                                case .padPortraitMedium:
                                        PadNumericKeyboard()
                                case .padPortraitLarge:
                                        LargePadNumericKeyboard()
                                case .padLandscapeSmall:
                                        PadNumericKeyboard()
                                case .padLandscapeMedium:
                                        PadNumericKeyboard()
                                case .padLandscapeLarge:
                                        LargePadNumericKeyboard()
                                }
                        }
                case .symbolic:
                        switch context.inputMethodMode {
                        case .cantonese:
                                if context.keyboardInterface.isCompact {
                                        CantoneseSymbolicKeyboard()
                                } else {
                                        PadCantoneseSymbolicKeyboard()
                                }
                        case .abc:
                                if context.keyboardInterface.isCompact {
                                        SymbolicKeyboard()
                                } else {
                                        PadSymbolicKeyboard()
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
                                switch context.keyboardInterface {
                                case .phonePortrait:
                                        AlphabeticKeyboard()
                                case .phoneLandscape:
                                        AlphabeticKeyboard()
                                case .padFloating:
                                        AlphabeticKeyboard()
                                case .padPortraitSmall:
                                        PadAlphabeticKeyboard()
                                case .padPortraitMedium:
                                        PadAlphabeticKeyboard()
                                case .padPortraitLarge:
                                        LargePadABCKeyboard()
                                case .padLandscapeSmall:
                                        PadAlphabeticKeyboard()
                                case .padLandscapeMedium:
                                        PadAlphabeticKeyboard()
                                case .padLandscapeLarge:
                                        LargePadABCKeyboard()
                                }
                        case .cantonese:
                                switch Options.keyboardLayout {
                                case .qwerty:
                                        switch context.qwertyForm {
                                        case .cangjie:
                                                if context.keyboardInterface.isCompact {
                                                        CangjieKeyboard()
                                                } else {
                                                        PadCangjieKeyboard()
                                                }
                                        case .stroke:
                                                if context.keyboardInterface.isCompact {
                                                        StrokeKeyboard()
                                                } else {
                                                        PadStrokeKeyboard()
                                                }
                                        default:
                                                switch context.keyboardInterface {
                                                case .phonePortrait:
                                                        AlphabeticKeyboard()
                                                case .phoneLandscape:
                                                        AlphabeticKeyboard()
                                                case .padFloating:
                                                        AlphabeticKeyboard()
                                                case .padPortraitSmall:
                                                        PadAlphabeticKeyboard()
                                                case .padPortraitMedium:
                                                        PadAlphabeticKeyboard()
                                                case .padPortraitLarge:
                                                        LargePadCantoneseKeyboard()
                                                case .padLandscapeSmall:
                                                        PadAlphabeticKeyboard()
                                                case .padLandscapeMedium:
                                                        PadAlphabeticKeyboard()
                                                case .padLandscapeLarge:
                                                        LargePadCantoneseKeyboard()
                                                }
                                        }
                                case .saamPing:
                                        switch context.qwertyForm {
                                        case .cangjie:
                                                if context.keyboardInterface.isCompact {
                                                        CangjieKeyboard()
                                                } else {
                                                        PadCangjieKeyboard()
                                                }
                                        case .stroke:
                                                if context.keyboardInterface.isCompact {
                                                        StrokeKeyboard()
                                                } else {
                                                        PadStrokeKeyboard()
                                                }
                                        default:
                                                switch context.keyboardInterface {
                                                case .phonePortrait:
                                                        SaamPingKeyboard()
                                                case .phoneLandscape:
                                                        SaamPingKeyboard()
                                                case .padFloating:
                                                        SaamPingKeyboard()
                                                case .padPortraitSmall:
                                                        PadSaamPingKeyboard()
                                                case .padPortraitMedium:
                                                        PadSaamPingKeyboard()
                                                case .padPortraitLarge:
                                                        LargePadSaamPingKeyboard()
                                                case .padLandscapeSmall:
                                                        PadSaamPingKeyboard()
                                                case .padLandscapeMedium:
                                                        PadSaamPingKeyboard()
                                                case .padLandscapeLarge:
                                                        LargePadSaamPingKeyboard()
                                                }
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
