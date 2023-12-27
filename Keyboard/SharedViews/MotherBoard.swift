import SwiftUI

struct MotherBoard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                switch context.keyboardForm {
                case .settings:
                        if #available(iOSApplicationExtension 16.0, *) {
                                SettingsView().frame(height: context.keyboardHeight)
                        } else {
                                SettingsViewIOS15().frame(height: context.keyboardHeight)
                        }
                case .editingPanel:
                        EditingPanel().frame(height: context.keyboardHeight)
                case .candidateBoard:
                        CandidateBoard().frame(height: context.keyboardHeight)
                case .emojiBoard:
                        EmojiBoard().frame(height: context.keyboardHeight)
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
                case .numberPad:
                        switch context.keyboardInterface {
                        case .phonePortrait:
                                NumberPad(isDecimalPad: false)
                        case .phoneLandscape:
                                NumberPad(isDecimalPad: false)
                        case .padFloating:
                                NumberPad(isDecimalPad: false)
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
                case .decimalPad:
                        switch context.keyboardInterface {
                        case .phonePortrait:
                                NumberPad(isDecimalPad: true)
                        case .phoneLandscape:
                                NumberPad(isDecimalPad: true)
                        case .padFloating:
                                NumberPad(isDecimalPad: true)
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
                case .tenKeyNumeric:
                        // iPhone only
                        TenKeyNumericKeyboard()
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
                                        PadABCKeyboard()
                                case .padPortraitMedium:
                                        PadABCKeyboard()
                                case .padPortraitLarge:
                                        LargePadABCKeyboard()
                                case .padLandscapeSmall:
                                        PadABCKeyboard()
                                case .padLandscapeMedium:
                                        PadABCKeyboard()
                                case .padLandscapeLarge:
                                        LargePadABCKeyboard()
                                }
                        case .cantonese:
                                switch Options.keyboardLayout {
                                case .qwerty:
                                        switch context.qwertyForm {
                                        case .cangjie:
                                                switch context.keyboardInterface {
                                                case .phonePortrait:
                                                        CangjieKeyboard()
                                                case .phoneLandscape:
                                                        CangjieKeyboard()
                                                case .padFloating:
                                                        CangjieKeyboard()
                                                case .padPortraitSmall:
                                                        PadCangjieKeyboard()
                                                case .padPortraitMedium:
                                                        PadCangjieKeyboard()
                                                case .padPortraitLarge:
                                                        LargePadCangjieKeyboard()
                                                case .padLandscapeSmall:
                                                        PadCangjieKeyboard()
                                                case .padLandscapeMedium:
                                                        PadCangjieKeyboard()
                                                case .padLandscapeLarge:
                                                        LargePadCangjieKeyboard()
                                                }
                                        case .stroke:
                                                switch context.keyboardInterface {
                                                case .phonePortrait:
                                                        StrokeKeyboard()
                                                case .phoneLandscape:
                                                        StrokeKeyboard()
                                                case .padFloating:
                                                        StrokeKeyboard()
                                                case .padPortraitSmall:
                                                        PadStrokeKeyboard()
                                                case .padPortraitMedium:
                                                        PadStrokeKeyboard()
                                                case .padPortraitLarge:
                                                        LargePadStrokeKeyboard()
                                                case .padLandscapeSmall:
                                                        PadStrokeKeyboard()
                                                case .padLandscapeMedium:
                                                        PadStrokeKeyboard()
                                                case .padLandscapeLarge:
                                                        LargePadStrokeKeyboard()
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
                                                        PadCantoneseKeyboard()
                                                case .padPortraitMedium:
                                                        PadCantoneseKeyboard()
                                                case .padPortraitLarge:
                                                        LargePadCantoneseKeyboard()
                                                case .padLandscapeSmall:
                                                        PadCantoneseKeyboard()
                                                case .padLandscapeMedium:
                                                        PadCantoneseKeyboard()
                                                case .padLandscapeLarge:
                                                        LargePadCantoneseKeyboard()
                                                }
                                        }
                                case .saamPing:
                                        switch context.qwertyForm {
                                        case .cangjie:
                                                switch context.keyboardInterface {
                                                case .phonePortrait:
                                                        CangjieKeyboard()
                                                case .phoneLandscape:
                                                        CangjieKeyboard()
                                                case .padFloating:
                                                        CangjieKeyboard()
                                                case .padPortraitSmall:
                                                        PadCangjieKeyboard()
                                                case .padPortraitMedium:
                                                        PadCangjieKeyboard()
                                                case .padPortraitLarge:
                                                        LargePadCangjieKeyboard()
                                                case .padLandscapeSmall:
                                                        PadCangjieKeyboard()
                                                case .padLandscapeMedium:
                                                        PadCangjieKeyboard()
                                                case .padLandscapeLarge:
                                                        LargePadCangjieKeyboard()
                                                }
                                        case .stroke:
                                                switch context.keyboardInterface {
                                                case .phonePortrait:
                                                        StrokeKeyboard()
                                                case .phoneLandscape:
                                                        StrokeKeyboard()
                                                case .padFloating:
                                                        StrokeKeyboard()
                                                case .padPortraitSmall:
                                                        PadStrokeKeyboard()
                                                case .padPortraitMedium:
                                                        PadStrokeKeyboard()
                                                case .padPortraitLarge:
                                                        LargePadStrokeKeyboard()
                                                case .padLandscapeSmall:
                                                        PadStrokeKeyboard()
                                                case .padLandscapeMedium:
                                                        PadStrokeKeyboard()
                                                case .padLandscapeLarge:
                                                        LargePadStrokeKeyboard()
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
                                        // iPhone Only
                                        TenKeyKeyboard()
                                }
                        }
                }
        }
}
