import SwiftUI
import CoreIME

/// Cantonese Triple-Stroke Layout. 粵拼三拼鍵盤佈局
struct TripleStrokeKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        if context.inputStage.isBuffering {
                                CandidateBar()
                        } else {
                                ToolBar()
                        }
                        if Options.needsNumberRow {
                                NumberRow()
                        }
                        switch Options.inputKeyStyle {
                        case .clear:
                                FirstKeyRow()
                        case .numbers, .numbersAndSymbols:
                                FirstEnhancedKeyRow()
                        }
                        HStack(spacing: 0) {
                                HiddenKey(key: .letterA)
                                switch Options.inputKeyStyle {
                                case .clear, .numbers:
                                        SecondKeyRow()
                                case .numbersAndSymbols:
                                        SecondEnhancedKeyRow()
                                }
                                HiddenKey(key: .letterL)
                        }
                        HStack(spacing: 0) {
                                ShiftKey()
                                HiddenKey(key: .letterZ)
                                switch Options.inputKeyStyle {
                                case .clear, .numbers:
                                        ThirdKeyRow()
                                case .numbersAndSymbols:
                                        ThirdEnhancedKeyRow()
                                }
                                HiddenKey(key: .backspace)
                                BackspaceKey()
                        }
                        switch (context.keyboardInterface.isPadFloating, context.needsInputModeSwitchKey) {
                        case (true, true):
                                if #available(iOSApplicationExtension 26.0, *) {
                                        HStack(spacing: 0) {
                                                TransformKey(destination: .numeric, widthUnitTimes: 2)
                                                LeftKey()
                                                SpaceKey()
                                                RightKey()
                                                ReturnKey()
                                        }
                                } else {
                                        HStack(spacing: 0) {
                                                GlobeKey()
                                                TransformKey(destination: .numeric, widthUnitTimes: 2)
                                                SpaceKey()
                                                RightAlternativeKey()
                                                ReturnKey()
                                        }
                                }
                        case (true, false):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .numeric, widthUnitTimes: 2)
                                        LeftKey()
                                        SpaceKey()
                                        RightKey()
                                        ReturnKey()
                                }
                        case (false, true):
                                HStack(spacing: 0) {
                                        TransformKey(destination: context.preferredNumericForm, widthUnitTimes: 2)
                                        GlobeKey()
                                        SpaceKey()
                                        RightAlternativeKey()
                                        ReturnKey()
                                }
                        case (false, false):
                                HStack(spacing: 0) {
                                        TransformKey(destination: context.preferredNumericForm, widthUnitTimes: 2)
                                        LeftKey()
                                        SpaceKey()
                                        RightKey()
                                        ReturnKey()
                                }
                        }
                }
        }
}

private struct FirstKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        EnhancedInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("aa"), members: [KeyElement("aa"), KeyElement("q")]))
                        LetterInputKey(.letterW)
                        LetterInputKey(.letterE)
                        EnhancedInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("oe", footer: "eo"), members: [KeyElement("oe"), KeyElement("r"), KeyElement("eo")]))
                        LetterInputKey(.letterT)
                        EnhancedInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("yu"), members: [KeyElement("yu"), KeyElement("y")]))
                        LetterInputKey(.letterU)
                        LetterInputKey(.letterI)
                        LetterInputKey(.letterO)
                        LetterInputKey(.letterP)
                }
        }
}
private struct FirstEnhancedKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        EnhancedInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("aa", header: "1"), members: [KeyElement("aa"), KeyElement("1"), KeyElement("q")]))
                        EnhancedInputKey(keyLocale: .leading, event: .letterW, keyModel: KeyModel(primary: KeyElement("w", header: "2"), members: [KeyElement("w"), KeyElement("2")]))
                        EnhancedInputKey(keyLocale: .leading, event: .letterE, keyModel: KeyModel(primary: KeyElement("e", header: "3"), members: [KeyElement("e"), KeyElement("3")]))
                        EnhancedInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("oe", header: "4", footer: "eo"), members: [KeyElement("oe"), KeyElement("4"), KeyElement("r"), KeyElement("eo")]))
                        EnhancedInputKey(keyLocale: .leading, event: .letterT, keyModel: KeyModel(primary: KeyElement("t", header: "5"), members: [KeyElement("t"), KeyElement("5")]))
                        EnhancedInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("yu", header: "6"), members: [KeyElement("yu"), KeyElement("6"), KeyElement("y")]))
                        EnhancedInputKey(keyLocale: .trailing, event: .letterU, keyModel: KeyModel(primary: KeyElement("u", header: "7"), members: [KeyElement("u"), KeyElement("7")]))
                        EnhancedInputKey(keyLocale: .trailing, event: .letterI, keyModel: KeyModel(primary: KeyElement("i", header: "8"), members: [KeyElement("i"), KeyElement("8")]))
                        EnhancedInputKey(keyLocale: .trailing, event: .letterO, keyModel: KeyModel(primary: KeyElement("o", header: "9"), members: [KeyElement("o"), KeyElement("9")]))
                        EnhancedInputKey(keyLocale: .trailing, event: .letterP, keyModel: KeyModel(primary: KeyElement("p", header: "0"), members: [KeyElement("p"), KeyElement("0")]))
                }
        }
}

private struct SecondKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        LetterInputKey(.letterA)
                        LetterInputKey(.letterS)
                        LetterInputKey(.letterD)
                        LetterInputKey(.letterF)
                        EnhancedInputKey(keyLocale: .leading, event: .letterG, keyModel: KeyModel(primary: KeyElement("g"), members: [KeyElement("g"), KeyElement("gw")]))
                        LetterInputKey(.letterH)
                        LetterInputKey(.letterJ)
                        EnhancedInputKey(keyLocale: .trailing, event: .letterK, keyModel: KeyModel(primary: KeyElement("k"), members: [KeyElement("k"), KeyElement("kw")]))
                        LetterInputKey(.letterL)
                }
        }
}
private struct SecondEnhancedKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        EnhancedInputKey(keyLocale: .leading, event: .letterA, keyModel: KeyModel(primary: KeyElement("a", header: "@"), members: [KeyElement("a"), KeyElement("@")]))
                        EnhancedInputKey(keyLocale: .leading, event: .letterS, keyModel: KeyModel(primary: KeyElement("s", header: "#"), members: [KeyElement("s"), KeyElement("#")]))
                        EnhancedInputKey(keyLocale: .leading, event: .letterD, keyModel: KeyModel(primary: KeyElement("d", header: "$"), members: [KeyElement("d"), KeyElement("$"), KeyElement("¥")]))
                        EnhancedInputKey(
                                keyLocale: .leading,
                                event: .letterF,
                                keyModel: KeyModel(
                                        primary: KeyElement("f", header: "/"),
                                        members: [
                                                KeyElement("f"),
                                                KeyElement("/"),
                                                KeyElement("／", header: PresetConstant.fullWidth),
                                                KeyElement("\\"),
                                                KeyElement("＼", header: PresetConstant.fullWidth)
                                        ]
                                )
                        )
                        EnhancedInputKey(keyLocale: .leading, event: .letterG, keyModel: KeyModel(primary: KeyElement("g", header: "（"), members: [KeyElement("g"), KeyElement("（"), KeyElement("gw")]))
                        EnhancedInputKey(keyLocale: .trailing, event: .letterH, keyModel: KeyModel(primary: KeyElement("h", header: "）"), members: [KeyElement("h"), KeyElement("）")]))
                        EnhancedInputKey(keyLocale: .trailing, event: .letterJ, keyModel: KeyModel(primary: KeyElement("j", header: "「"), members: [KeyElement("j"), KeyElement("「")]))
                        EnhancedInputKey(keyLocale: .trailing, event: .letterK, keyModel: KeyModel(primary: KeyElement("k", header: "」"), members: [KeyElement("k"), KeyElement("」"), KeyElement("kw")]))
                        EnhancedInputKey(
                                keyLocale: .trailing,
                                event: .letterL,
                                keyModel: KeyModel(
                                        primary: KeyElement("l", header: "'"),
                                        members: [
                                                KeyElement("l"),
                                                KeyElement("'", footer: "0027"),
                                                KeyElement("’", header: "右", footer: "2019"),
                                                KeyElement("‘", header: "左", footer: "2018"),
                                                KeyElement("\"", footer: "0022"),
                                                KeyElement("”", header: "右", footer: "201D"),
                                                KeyElement("“", header: "左", footer: "201C")
                                        ]
                                )
                        )
                }
        }
}

private struct ThirdKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        LetterInputKey(.letterZ)
                        EnhancedInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("gw", footer: "kw"), members: [KeyElement("gw"), KeyElement("x"), KeyElement("kw")]))
                        LetterInputKey(.letterC)
                        EnhancedInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("ng"), members: [KeyElement("ng"), KeyElement("v")]))
                        LetterInputKey(.letterB)
                        LetterInputKey(.letterN)
                        LetterInputKey(.letterM)
                }
        }
}
private struct ThirdEnhancedKeyRow: View {
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
                        EnhancedInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("gw", header: "-", footer: "kw"), members: [KeyElement("gw"), KeyElement("-"), KeyElement("x"), KeyElement("kw")]))
                        EnhancedInputKey(keyLocale: .leading, event: .letterC, keyModel: KeyModel(primary: KeyElement("c", header: "～"), members: [KeyElement("c"), KeyElement("～"), KeyElement("~", header: PresetConstant.halfWidth)]))
                        EnhancedInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("ng", header: "…"), members: [KeyElement("ng"), KeyElement("…"), KeyElement("v")]))
                        EnhancedInputKey(keyLocale: .leading, event: .letterB, keyModel: KeyModel(primary: KeyElement("b", header: "、"), members: [KeyElement("b"), KeyElement("、")]))
                        EnhancedInputKey(keyLocale: .trailing, event: .letterN, keyModel: KeyModel(primary: KeyElement("n", header: "；"), members: [KeyElement("n"), KeyElement("；")]))
                        EnhancedInputKey(keyLocale: .trailing, event: .letterM, keyModel: KeyModel(primary: KeyElement("m", header: "："), members: [KeyElement("m"), KeyElement("：")]))
                }
        }
}
