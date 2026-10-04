import SwiftUI
import CoreIME

struct PinyinKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        CandidateBar()
                        if Options.needsNumberRow {
                                CantoneseNumberRow()
                        }
                        /*
                        switch Options.inputKeyStyle {
                        case .clear:
                                FirstLetterKeyRow()
                        case .numbers, .symbols:
                                FirstEnhancedLetterKeyRow()
                        }
                        */
                        FirstLetterKeyRow()
                        HStack(spacing: 0) {
                                HiddenKey(key: .letterA)
                                /*
                                switch Options.inputKeyStyle {
                                case .clear, .numbers:
                                        SecondLetterKeyRow()
                                case .symbols:
                                        SecondEnhancedLetterKeyRow()
                                }
                                */
                                SecondLetterKeyRow()
                                HiddenKey(key: .letterL)
                        }
                        HStack(spacing: 0) {
                                ShiftKey()
                                HiddenKey(key: .letterZ)
                                /*
                                switch Options.inputKeyStyle {
                                case .clear, .numbers:
                                        PinyinThirdLetterKeyRow()
                                case .symbols:
                                        PinyinThirdEnhancedLetterRow()
                                }
                                */
                                PinyinThirdLetterKeyRow()
                                HiddenKey(key: .backspace)
                                BackspaceKey()
                        }
                        HStack(spacing: 0) {
                                TransformKey(destination: context.preferredNumericForm, coefficient: 2)
                                LeftKey()
                                SpaceKey()
                                RightKey()
                                ReturnKey()
                        }
                }
        }
}

private struct PinyinThirdLetterKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        LetterInputKey(.letterZ)
                        LetterInputKey(.letterX)
                        LetterInputKey(.letterC)
                        PinyinSpecialLetterKey()
                        LetterInputKey(.letterB)
                        LetterInputKey(.letterN)
                        LetterInputKey(.letterM)
                }
        }
}
private struct PinyinThirdEnhancedLetterRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        EnhancedInputKey(
                                side: .leading,
                                virtual: .letterZ,
                                unit: KeyUnit(
                                        primary: KeyElement("z", extras: [.init("%", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("z"),
                                                KeyElement("%"),
                                                KeyElement("％", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                KeyElement("‰")
                                        ]
                                )
                        )
                        EnhancedInputKey(side: .leading, virtual: .letterX, unit: KeyUnit(primary: KeyElement("x", extras: [.init("-", alignment: .topTrailing)]), members: [KeyElement("x"), KeyElement("-")]))
                        EnhancedInputKey(side: .leading, virtual: .letterC, unit: KeyUnit(primary: KeyElement("c", extras: [.init("～", alignment: .topTrailing)]), members: [KeyElement("c"), KeyElement("～"), KeyElement("~", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])]))
                        PinyinSpecialInputKey()
                        EnhancedInputKey(side: .leading, virtual: .letterB, unit: KeyUnit(primary: KeyElement("b", extras: [.init("、", alignment: .topTrailing)]), members: [KeyElement("b"), KeyElement("、")]))
                        EnhancedInputKey(side: .trailing, virtual: .letterN, unit: KeyUnit(primary: KeyElement("n", extras: [.init("；", alignment: .topTrailing)]), members: [KeyElement("n"), KeyElement("；")]))
                        EnhancedInputKey(side: .trailing, virtual: .letterM, unit: KeyUnit(primary: KeyElement("m", extras: [.init("：", alignment: .topTrailing)]), members: [KeyElement("m"), KeyElement("：")]))
                }
        }
}
