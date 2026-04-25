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
                        case .numbers, .numbersAndSymbols:
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
                                case .numbersAndSymbols:
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
                                case .numbersAndSymbols:
                                        PinyinThirdEnhancedLetterRow()
                                }
                                */
                                PinyinThirdLetterKeyRow()
                                HiddenKey(key: .backspace)
                                BackspaceKey()
                        }
                        HStack(spacing: 0) {
                                TransformKey(destination: context.preferredNumericForm, widthUnitTimes: 2)
                                SpaceKey()
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
                                keyLocale: .leading,
                                event: .letterZ,
                                keyModel: KeyModel(
                                        primary: KeyElement("z", header: "%"),
                                        members: [
                                                KeyElement("z"),
                                                KeyElement("%"),
                                                KeyElement("％", header: PresetConstant.fullWidth),
                                                KeyElement("‰")
                                        ]
                                )
                        )
                        EnhancedInputKey(keyLocale: .leading, event: .letterX, keyModel: KeyModel(primary: KeyElement("x", header: "-"), members: [KeyElement("x"), KeyElement("-")]))
                        EnhancedInputKey(keyLocale: .leading, event: .letterC, keyModel: KeyModel(primary: KeyElement("c", header: "～"), members: [KeyElement("c"), KeyElement("～"), KeyElement("~", header: PresetConstant.halfWidth)]))
                        PinyinSpecialInputKey()
                        EnhancedInputKey(keyLocale: .leading, event: .letterB, keyModel: KeyModel(primary: KeyElement("b", header: "、"), members: [KeyElement("b"), KeyElement("、")]))
                        EnhancedInputKey(keyLocale: .trailing, event: .letterN, keyModel: KeyModel(primary: KeyElement("n", header: "；"), members: [KeyElement("n"), KeyElement("；")]))
                        EnhancedInputKey(keyLocale: .trailing, event: .letterM, keyModel: KeyModel(primary: KeyElement("m", header: "："), members: [KeyElement("m"), KeyElement("：")]))
                }
        }
}
