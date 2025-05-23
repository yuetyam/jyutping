import SwiftUI

struct MotherBoard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                switch context.keyboardForm {
                case .settings:
                        if #available(iOSApplicationExtension 16.0, *) {
                                SettingsView().frame(height: context.isKeyboardHeightExpanded ? context.expandedKeyboardHeight : context.keyboardHeight)
                        } else {
                                SettingsViewIOS15().frame(height: context.isKeyboardHeightExpanded ? context.expandedKeyboardHeight : context.keyboardHeight)
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
                                case .phoneOnPadPortrait:
                                        CantoneseNumericKeyboard()
                                case .phoneOnPadLandscape:
                                        CantoneseNumericKeyboard()
                                case .padFloating:
                                        CantoneseNumericKeyboard()
                                case .padPortraitSmall:
                                        PadCantoneseNumericKeyboard()
                                case .padPortraitMedium:
                                        MediumPadCantoneseNumericKeyboard()
                                case .padPortraitLarge:
                                        LargePadCantoneseNumericKeyboard()
                                case .padLandscapeSmall:
                                        PadCantoneseNumericKeyboard()
                                case .padLandscapeMedium:
                                        MediumPadCantoneseNumericKeyboard()
                                case .padLandscapeLarge:
                                        LargePadCantoneseNumericKeyboard()
                                }
                        case .abc:
                                switch context.keyboardInterface {
                                case .phonePortrait:
                                        NumericKeyboard()
                                case .phoneLandscape:
                                        NumericKeyboard()
                                case .phoneOnPadPortrait:
                                        NumericKeyboard()
                                case .phoneOnPadLandscape:
                                        NumericKeyboard()
                                case .padFloating:
                                        NumericKeyboard()
                                case .padPortraitSmall:
                                        PadNumericKeyboard()
                                case .padPortraitMedium:
                                        MediumPadNumericKeyboard()
                                case .padPortraitLarge:
                                        LargePadNumericKeyboard()
                                case .padLandscapeSmall:
                                        PadNumericKeyboard()
                                case .padLandscapeMedium:
                                        MediumPadNumericKeyboard()
                                case .padLandscapeLarge:
                                        LargePadNumericKeyboard()
                                }
                        }
                case .symbolic:
                        switch context.inputMethodMode {
                        case .cantonese:
                                switch context.keyboardInterface {
                                case .padPortraitSmall, .padLandscapeSmall:
                                        PadCantoneseSymbolicKeyboard()
                                case .padPortraitMedium, .padLandscapeMedium:
                                        MediumPadCantoneseSymbolicKeyboard()
                                case .padPortraitLarge, .padLandscapeLarge:
                                        LargePadCantoneseNumericKeyboard()
                                default:
                                        CantoneseSymbolicKeyboard()
                                }
                        case .abc:
                                switch context.keyboardInterface {
                                case .padPortraitSmall, .padLandscapeSmall:
                                        PadSymbolicKeyboard()
                                case .padPortraitMedium, .padLandscapeMedium:
                                        MediumPadSymbolicKeyboard()
                                case .padPortraitLarge, .padLandscapeLarge:
                                        LargePadNumericKeyboard()
                                default:
                                        SymbolicKeyboard()
                                }
                        }
                case .numberPad:
                        switch context.keyboardInterface {
                        case .phonePortrait:
                                NumberPad(isDecimalPad: false)
                        case .phoneLandscape:
                                NumberPad(isDecimalPad: false)
                        case .phoneOnPadPortrait:
                                NumberPad(isDecimalPad: false)
                        case .phoneOnPadLandscape:
                                NumberPad(isDecimalPad: false)
                        case .padFloating:
                                NumberPad(isDecimalPad: false)
                        case .padPortraitSmall:
                                PadNumericKeyboard()
                        case .padPortraitMedium:
                                MediumPadNumericKeyboard()
                        case .padPortraitLarge:
                                LargePadNumericKeyboard()
                        case .padLandscapeSmall:
                                PadNumericKeyboard()
                        case .padLandscapeMedium:
                                MediumPadNumericKeyboard()
                        case .padLandscapeLarge:
                                LargePadNumericKeyboard()
                        }
                case .decimalPad:
                        switch context.keyboardInterface {
                        case .phonePortrait:
                                NumberPad(isDecimalPad: true)
                        case .phoneLandscape:
                                NumberPad(isDecimalPad: true)
                        case .phoneOnPadPortrait:
                                NumberPad(isDecimalPad: true)
                        case .phoneOnPadLandscape:
                                NumberPad(isDecimalPad: true)
                        case .padFloating:
                                NumberPad(isDecimalPad: true)
                        case .padPortraitSmall:
                                PadNumericKeyboard()
                        case .padPortraitMedium:
                                MediumPadNumericKeyboard()
                        case .padPortraitLarge:
                                LargePadNumericKeyboard()
                        case .padLandscapeSmall:
                                PadNumericKeyboard()
                        case .padLandscapeMedium:
                                MediumPadNumericKeyboard()
                        case .padLandscapeLarge:
                                LargePadNumericKeyboard()
                        }
                case .tenKeyNumeric:
                        TenKeyNumericKeyboard()
                case .tenKeyStroke:
                        TenKeyStrokeKeyboard()
                default:
                        switch context.inputMethodMode {
                        case .abc:
                                switch context.keyboardInterface {
                                case .phonePortrait:
                                        ABCKeyboard()
                                case .phoneLandscape:
                                        ABCKeyboard()
                                case .phoneOnPadPortrait:
                                        ABCKeyboard()
                                case .phoneOnPadLandscape:
                                        ABCKeyboard()
                                case .padFloating:
                                        ABCKeyboard()
                                case .padPortraitSmall:
                                        PadABCKeyboard()
                                case .padPortraitMedium:
                                        MediumPadABCKeyboard()
                                case .padPortraitLarge:
                                        LargePadABCKeyboard()
                                case .padLandscapeSmall:
                                        PadABCKeyboard()
                                case .padLandscapeMedium:
                                        MediumPadABCKeyboard()
                                case .padLandscapeLarge:
                                        LargePadABCKeyboard()
                                }
                        case .cantonese:
                                switch context.keyboardLayout {
                                case .qwerty:
                                        switch context.qwertyForm {
                                        case .cangjie:
                                                switch context.keyboardInterface {
                                                case .phonePortrait:
                                                        CangjieKeyboard()
                                                case .phoneLandscape:
                                                        CangjieKeyboard()
                                                case .phoneOnPadPortrait:
                                                        CangjieKeyboard()
                                                case .phoneOnPadLandscape:
                                                        CangjieKeyboard()
                                                case .padFloating:
                                                        CangjieKeyboard()
                                                case .padPortraitSmall:
                                                        PadCangjieKeyboard()
                                                case .padPortraitMedium:
                                                        MediumPadCangjieKeyboard()
                                                case .padPortraitLarge:
                                                        LargePadCangjieKeyboard()
                                                case .padLandscapeSmall:
                                                        PadCangjieKeyboard()
                                                case .padLandscapeMedium:
                                                        MediumPadCangjieKeyboard()
                                                case .padLandscapeLarge:
                                                        LargePadCangjieKeyboard()
                                                }
                                        case .stroke:
                                                switch context.keyboardInterface {
                                                case .phonePortrait:
                                                        StrokeKeyboard()
                                                case .phoneLandscape:
                                                        StrokeKeyboard()
                                                case .phoneOnPadPortrait:
                                                        StrokeKeyboard()
                                                case .phoneOnPadLandscape:
                                                        StrokeKeyboard()
                                                case .padFloating:
                                                        StrokeKeyboard()
                                                case .padPortraitSmall:
                                                        PadStrokeKeyboard()
                                                case .padPortraitMedium:
                                                        MediumPadStrokeKeyboard()
                                                case .padPortraitLarge:
                                                        LargePadStrokeKeyboard()
                                                case .padLandscapeSmall:
                                                        PadStrokeKeyboard()
                                                case .padLandscapeMedium:
                                                        MediumPadStrokeKeyboard()
                                                case .padLandscapeLarge:
                                                        LargePadStrokeKeyboard()
                                                }
                                        default:
                                                switch context.keyboardInterface {
                                                case .phonePortrait:
                                                        AlphabeticKeyboard()
                                                case .phoneLandscape:
                                                        AlphabeticKeyboard()
                                                case .phoneOnPadPortrait:
                                                        AlphabeticKeyboard()
                                                case .phoneOnPadLandscape:
                                                        AlphabeticKeyboard()
                                                case .padFloating:
                                                        AlphabeticKeyboard()
                                                case .padPortraitSmall:
                                                        PadCantoneseKeyboard()
                                                case .padPortraitMedium:
                                                        MediumPadCantoneseKeyboard()
                                                case .padPortraitLarge:
                                                        LargePadCantoneseKeyboard()
                                                case .padLandscapeSmall:
                                                        PadCantoneseKeyboard()
                                                case .padLandscapeMedium:
                                                        MediumPadCantoneseKeyboard()
                                                case .padLandscapeLarge:
                                                        LargePadCantoneseKeyboard()
                                                }
                                        }
                                case .tripleStroke:
                                        switch context.qwertyForm {
                                        case .cangjie:
                                                switch context.keyboardInterface {
                                                case .phonePortrait:
                                                        CangjieKeyboard()
                                                case .phoneLandscape:
                                                        CangjieKeyboard()
                                                case .phoneOnPadPortrait:
                                                        CangjieKeyboard()
                                                case .phoneOnPadLandscape:
                                                        CangjieKeyboard()
                                                case .padFloating:
                                                        CangjieKeyboard()
                                                case .padPortraitSmall:
                                                        PadCangjieKeyboard()
                                                case .padPortraitMedium:
                                                        MediumPadCangjieKeyboard()
                                                case .padPortraitLarge:
                                                        LargePadCangjieKeyboard()
                                                case .padLandscapeSmall:
                                                        PadCangjieKeyboard()
                                                case .padLandscapeMedium:
                                                        MediumPadCangjieKeyboard()
                                                case .padLandscapeLarge:
                                                        LargePadCangjieKeyboard()
                                                }
                                        case .stroke:
                                                switch context.keyboardInterface {
                                                case .phonePortrait:
                                                        StrokeKeyboard()
                                                case .phoneLandscape:
                                                        StrokeKeyboard()
                                                case .phoneOnPadPortrait:
                                                        StrokeKeyboard()
                                                case .phoneOnPadLandscape:
                                                        StrokeKeyboard()
                                                case .padFloating:
                                                        StrokeKeyboard()
                                                case .padPortraitSmall:
                                                        PadStrokeKeyboard()
                                                case .padPortraitMedium:
                                                        MediumPadStrokeKeyboard()
                                                case .padPortraitLarge:
                                                        LargePadStrokeKeyboard()
                                                case .padLandscapeSmall:
                                                        PadStrokeKeyboard()
                                                case .padLandscapeMedium:
                                                        MediumPadStrokeKeyboard()
                                                case .padLandscapeLarge:
                                                        LargePadStrokeKeyboard()
                                                }
                                        case .pinyin:
                                                switch context.keyboardInterface {
                                                case .phonePortrait:
                                                        AlphabeticKeyboard()
                                                case .phoneLandscape:
                                                        AlphabeticKeyboard()
                                                case .phoneOnPadPortrait:
                                                        AlphabeticKeyboard()
                                                case .phoneOnPadLandscape:
                                                        AlphabeticKeyboard()
                                                case .padFloating:
                                                        AlphabeticKeyboard()
                                                case .padPortraitSmall:
                                                        PadCantoneseKeyboard()
                                                case .padPortraitMedium:
                                                        MediumPadCangjieKeyboard()
                                                case .padPortraitLarge:
                                                        LargePadCantoneseKeyboard()
                                                case .padLandscapeSmall:
                                                        PadCantoneseKeyboard()
                                                case .padLandscapeMedium:
                                                        MediumPadCangjieKeyboard()
                                                case .padLandscapeLarge:
                                                        LargePadCantoneseKeyboard()
                                                }
                                        default:
                                                switch context.keyboardInterface {
                                                case .phonePortrait:
                                                        TripleStrokeKeyboard()
                                                case .phoneLandscape:
                                                        TripleStrokeKeyboard()
                                                case .phoneOnPadPortrait:
                                                        TripleStrokeKeyboard()
                                                case .phoneOnPadLandscape:
                                                        TripleStrokeKeyboard()
                                                case .padFloating:
                                                        TripleStrokeKeyboard()
                                                case .padPortraitSmall:
                                                        PadTripleStrokeKeyboard()
                                                case .padPortraitMedium:
                                                        MediumPadTripleStrokeKeyboard()
                                                case .padPortraitLarge:
                                                        LargePadTripleStrokeKeyboard()
                                                case .padLandscapeSmall:
                                                        PadTripleStrokeKeyboard()
                                                case .padLandscapeMedium:
                                                        MediumPadTripleStrokeKeyboard()
                                                case .padLandscapeLarge:
                                                        LargePadTripleStrokeKeyboard()
                                                }
                                        }
                                case .tenKey:
                                        TenKeyKeyboard()
                                }
                        }
                }
        }
}
