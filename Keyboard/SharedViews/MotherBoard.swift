import SwiftUI

struct MotherBoard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                switch context.keyboardForm {
                case .placeholder:
                        Color.clear.frame(height: context.keyboardHeight)
                case .settings:
                        SettingsView().frame(height: context.keyboardHeight)
                case .editingPanel:
                        EditingPanel().frame(height: context.keyboardHeight)
                case .layoutPicker:
                        KeyboardLayoutPickerView().frame(height: context.keyboardHeight)
                case .candidateBoard:
                        CandidateBoard().frame(height: context.keyboardHeight)
                case .emojiBoard:
                        EmojiBoard().frame(height: context.keyboardHeight)
                case .numeric:
                        switch context.inputMethodMode {
                        case .abc:
                                switch context.keyboardInterface {
                                case .phonePortrait, .phoneLandscape, .phoneOnPadPortrait, .phoneOnPadLandscape, .padFloating:
                                        NumericKeyboard()
                                case .padPortraitSmall, .padLandscapeSmall:
                                        PadNumericKeyboard()
                                case .padPortraitMedium, .padLandscapeMedium:
                                        MediumPadNumericKeyboard()
                                case .padPortraitLarge, .padLandscapeLarge:
                                        LargePadNumericKeyboard()
                                }
                        case .cantonese:
                                switch context.keyboardInterface {
                                case .phonePortrait, .phoneLandscape, .phoneOnPadPortrait, .phoneOnPadLandscape, .padFloating:
                                        CantoneseNumericKeyboard()
                                case .padPortraitSmall, .padLandscapeSmall:
                                        PadCantoneseNumericKeyboard()
                                case .padPortraitMedium, .padLandscapeMedium:
                                        MediumPadCantoneseNumericKeyboard()
                                case .padPortraitLarge, .padLandscapeLarge:
                                        LargePadCantoneseNumericKeyboard()
                                }
                        }
                case .symbolic:
                        switch context.inputMethodMode {
                        case .abc:
                                switch context.keyboardInterface {
                                case .phonePortrait, .phoneLandscape, .phoneOnPadPortrait, .phoneOnPadLandscape, .padFloating:
                                        SymbolicKeyboard()
                                case .padPortraitSmall, .padLandscapeSmall:
                                        PadSymbolicKeyboard()
                                case .padPortraitMedium, .padLandscapeMedium:
                                        MediumPadSymbolicKeyboard()
                                case .padPortraitLarge, .padLandscapeLarge:
                                        LargePadNumericKeyboard()
                                }
                        case .cantonese:
                                switch context.keyboardInterface {
                                case .phonePortrait, .phoneLandscape, .phoneOnPadPortrait, .phoneOnPadLandscape, .padFloating:
                                        CantoneseSymbolicKeyboard()
                                case .padPortraitSmall, .padLandscapeSmall:
                                        PadCantoneseSymbolicKeyboard()
                                case .padPortraitMedium, .padLandscapeMedium:
                                        MediumPadCantoneseSymbolicKeyboard()
                                case .padPortraitLarge, .padLandscapeLarge:
                                        LargePadCantoneseNumericKeyboard()
                                }
                        }
                case .numberPad, .decimalPad:
                        switch context.keyboardInterface {
                        case .phonePortrait, .phoneLandscape, .phoneOnPadPortrait, .phoneOnPadLandscape, .padFloating:
                                NumberPad(isDecimalPad: context.keyboardForm == .decimalPad)
                        case .padPortraitSmall, .padLandscapeSmall:
                                PadNumericKeyboard()
                        case .padPortraitMedium, .padLandscapeMedium:
                                MediumPadNumericKeyboard()
                        case .padPortraitLarge, .padLandscapeLarge:
                                LargePadNumericKeyboard()
                        }
                case .nineKeyNumeric:
                        if #available(iOSApplicationExtension 26.0, *) {
                                GlassNineKeyNumericKeyboard()
                        } else {
                                NineKeyNumericKeyboard()
                        }
                case .nineKeyStroke:
                        if #available(iOSApplicationExtension 26.0, *) {
                                GlassNineKeyStrokeKeyboard()
                        } else {
                                NineKeyStrokeKeyboard()
                        }
                default:
                        switch context.inputMethodMode {
                        case .abc:
                                switch context.keyboardInterface {
                                case .phonePortrait, .phoneLandscape, .phoneOnPadPortrait, .phoneOnPadLandscape, .padFloating:
                                        ABCKeyboard()
                                case .padPortraitSmall, .padLandscapeSmall:
                                        PadABCKeyboard()
                                case .padPortraitMedium, .padLandscapeMedium:
                                        MediumPadABCKeyboard()
                                case .padPortraitLarge, .padLandscapeLarge:
                                        LargePadABCKeyboard()
                                }
                        case .cantonese:
                                switch context.keyboardInterface {
                                case .phonePortrait, .phoneLandscape:
                                        switch context.compositionType {
                                        case .pinyin : PinyinKeyboard()
                                        case .cangjie: CangjieKeyboard()
                                        case .stroke : StrokeKeyboard()
                                        case .primary:
                                                switch context.keyboardLayout {
                                                case .qwerty      : CantoneseKeyboard()
                                                case .tripleStroke: TripleStrokeKeyboard()
                                                case .nineKey     : NineKeyKeyboard()
                                                case .fourteenKey : FourteenKeyKeyboard()
                                                case .fifteenKey  : FifteenKeyKeyboard()
                                                case .eighteenKey : EighteenKeyKeyboard()
                                                case .nineteenKey : NineteenKeyKeyboard()
                                                case .twentyOneKey: TwentyOneKeyKeyboard()
                                                }
                                        }
                                case .phoneOnPadPortrait, .phoneOnPadLandscape, .padFloating:
                                        switch context.compositionType {
                                        case .pinyin : PinyinKeyboard()
                                        case .cangjie: CangjieKeyboard()
                                        case .stroke : StrokeKeyboard()
                                        case .primary:
                                                switch context.keyboardLayout {
                                                case .tripleStroke: TripleStrokeKeyboard()
                                                case .nineKey: NineKeyKeyboard()
                                                default: CantoneseKeyboard()
                                                }
                                        }
                                case .padPortraitSmall, .padLandscapeSmall:
                                        switch context.compositionType {
                                        case .pinyin : PadCantoneseKeyboard()
                                        case .cangjie: PadCangjieKeyboard()
                                        case .stroke : PadStrokeKeyboard()
                                        case .primary:
                                                switch context.keyboardLayout {
                                                case .tripleStroke: PadTripleStrokeKeyboard()
                                                case .nineKey: NineKeyKeyboard()
                                                default: PadCantoneseKeyboard()
                                                }
                                        }
                                case .padPortraitMedium, .padLandscapeMedium:
                                        switch context.compositionType {
                                        case .pinyin : MediumPadCantoneseKeyboard()
                                        case .cangjie: MediumPadCangjieKeyboard()
                                        case .stroke : MediumPadStrokeKeyboard()
                                        case .primary:
                                                switch context.keyboardLayout {
                                                case .tripleStroke: MediumPadTripleStrokeKeyboard()
                                                case .nineKey: NineKeyKeyboard()
                                                default: MediumPadCantoneseKeyboard()
                                                }
                                        }
                                case .padPortraitLarge, .padLandscapeLarge:
                                        switch context.compositionType {
                                        case .pinyin : LargePadCantoneseKeyboard()
                                        case .cangjie: LargePadCangjieKeyboard()
                                        case .stroke : LargePadStrokeKeyboard()
                                        case .primary:
                                                switch context.keyboardLayout {
                                                case .tripleStroke: LargePadTripleStrokeKeyboard()
                                                case .nineKey: NineKeyKeyboard()
                                                default: LargePadCantoneseKeyboard()
                                                }
                                        }
                                }
                        }
                }
        }
}
