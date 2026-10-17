import SwiftUI
import CommonExtensions

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassMotherBoard: View {
        @EnvironmentObject private var context: KeyboardViewController
        var body: some View {
                switch context.keyboardForm {
                case .placeholder:
                        Color.clear.frame(height: context.keyboardHeight)
                case .settings:
                        SettingsView().frame(height: context.keyboardHeight)
                case .editingPanel:
                        GlassEditingPanel().frame(height: context.keyboardHeight)
                case .layoutPicker:
                        LayoutPickerView().scrollEdgeEffectHidden().frame(height: context.keyboardHeight)
                case .detailInspecting:
                        DetailInspectingView().scrollEdgeEffectHidden().frame(height: context.keyboardHeight)
                case .emojiBoard:
                        EmojiBoard().scrollEdgeEffectHidden().frame(height: context.keyboardHeight)
                case .candidateBoard:
                        CandidateBoard().frame(height: context.keyboardHeight)
                case .numeric:
                        switch context.inputMethodMode {
                        case .abc:
                                switch context.keyboardInterface {
                                case .padPortraitSmall, .padLandscapeSmall:
                                        PadNumericKeyboard()
                                case .padPortraitMedium, .padLandscapeMedium:
                                        MediumPadNumericKeyboard()
                                case .padPortraitLarge, .padLandscapeLarge:
                                        LargePadNumericKeyboard()
                                default:
                                        GlassNumericKeyboard()
                                }
                        case .cantonese:
                                switch context.keyboardInterface {
                                case .padPortraitSmall, .padLandscapeSmall:
                                        PadCantoneseNumericKeyboard()
                                case .padPortraitMedium, .padLandscapeMedium:
                                        MediumPadCantoneseNumericKeyboard()
                                case .padPortraitLarge, .padLandscapeLarge:
                                        LargePadCantoneseNumericKeyboard()
                                default:
                                        GlassCantoneseNumericKeyboard()
                                }
                        }
                case .symbolic:
                        switch context.inputMethodMode {
                        case .abc:
                                switch context.keyboardInterface {
                                case .padPortraitSmall, .padLandscapeSmall:
                                        PadSymbolicKeyboard()
                                case .padPortraitMedium, .padLandscapeMedium:
                                        MediumPadSymbolicKeyboard()
                                case .padPortraitLarge, .padLandscapeLarge:
                                        LargePadNumericKeyboard()
                                default:
                                        GlassSymbolicKeyboard()
                                }
                        case .cantonese:
                                switch context.keyboardInterface {
                                case .padPortraitSmall, .padLandscapeSmall:
                                        PadCantoneseSymbolicKeyboard()
                                case .padPortraitMedium, .padLandscapeMedium:
                                        MediumPadCantoneseSymbolicKeyboard()
                                case .padPortraitLarge, .padLandscapeLarge:
                                        LargePadCantoneseNumericKeyboard()
                                default:
                                        GlassCantoneseSymbolicKeyboard()
                                }
                        }
                case .numberPad, .decimalPad:
                        switch context.keyboardInterface {
                        case .padPortraitSmall, .padLandscapeSmall:
                                PadNumericKeyboard()
                        case .padPortraitMedium, .padLandscapeMedium:
                                MediumPadNumericKeyboard()
                        case .padPortraitLarge, .padLandscapeLarge:
                                LargePadNumericKeyboard()
                        default:
                                GlassNumberPad(isDecimalPad: context.keyboardForm.isDecimalPad)
                        }
                case .dedicatedNumbers:
                        GlassTailoredNumericKeyboard()
                case .dedicatedStroke:
                        TailoredGlassStrokeReverseLookupKeyboard()
                default:
                        switch context.inputMethodMode {
                        case .abc:
                                switch context.keyboardInterface {
                                case .padPortraitSmall, .padLandscapeSmall:
                                        PadABCKeyboard()
                                case .padPortraitMedium, .padLandscapeMedium:
                                        MediumPadABCKeyboard()
                                case .padPortraitLarge, .padLandscapeLarge:
                                        LargePadABCKeyboard()
                                default:
                                        GlassABCKeyboard()
                                }
                        case .cantonese:
                                switch context.keyboardInterface {
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
                                default:
                                        switch context.compositionType {
                                        case .pinyin : GlassPinyinKeyboard()
                                        case .cangjie: GlassCangjieKeyboard()
                                        case .stroke : GlassStrokeKeyboard()
                                        case .primary:
                                                switch context.keyboardLayout {
                                                case .qwerty      : GlassCantoneseKeyboard()
                                                case .tripleStroke: GlassTripleStrokeKeyboard()
                                                case .nineKey     : NineKeyKeyboard()
                                                case .fourteenKey : GlassT14Keyboard()
                                                case .fifteenKey  : GlassT15Keyboard()
                                                case .eighteenKey : GlassT18Keyboard()
                                                case .nineteenKey : GlassT19Keyboard()
                                                case .twentyOneKey: GlassT21Keyboard()
                                                }
                                        }
                                }
                        }
                }
        }
}
