import SwiftUI
import CoreIME

struct FifteenKeyKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        if context.inputStage.isBuffering {
                                CandidateBar()
                        } else {
                                ToolBar()
                        }
                        if Options.needsNumberRow {
                                CantoneseNumberRow()
                        }
                        switch Options.inputKeyStyle {
                        case .clear:
                                FirstLetterRow()
                        case .numbers, .numbersAndSymbols:
                                FirstEnhancedLetterRow()
                        }
                        switch Options.inputKeyStyle {
                        case .clear, .numbers:
                                SecondLetterRow()
                        case .numbersAndSymbols:
                                SecondEnhancedLetterRow()
                        }
                        HStack(spacing: 0) {
                                ShiftKey()
                                switch Options.inputKeyStyle {
                                case .clear, .numbers:
                                        ThirdLetterRow()
                                case .numbersAndSymbols:
                                        ThirdEnhancedLetterRow()
                                }
                                BackspaceKey()
                        }
                        switch (context.keyboardInterface.isPadFloating, context.needsInputModeSwitchKey) {
                        case (true, true):
                                HStack(spacing: 0) {
                                        GlobeKey()
                                        TransformKey(destination: .numeric, widthUnitTimes: 2)
                                        SpaceKey()
                                        RightAlternativeKey()
                                        ReturnKey()
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

private struct FirstLetterRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        T14InputKey(side: .leading, virtual: .letterW, unit: KeyModel(primary: KeyElement("qw"), members: [KeyElement("w"), KeyElement("q")]))
                        T14InputKey(side: .leading, virtual: .letterE, unit: KeyModel(primary: KeyElement("er"), members: [KeyElement("e"), KeyElement("r")]))
                        T14InputKey(side: .leading, unit: KeyModel(primary: KeyElement("ty"), members: [KeyElement("t"), KeyElement("y")]))
                        T14InputKey(side: .leading, unit: KeyModel(primary: KeyElement("ui"), members: [KeyElement("u"), KeyElement("i")]))
                        T14InputKey(side: .trailing, unit: KeyModel(primary: KeyElement("op"), members: [KeyElement("p"), KeyElement("o")]))
                }
        }
}
private struct FirstEnhancedLetterRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        EnhancedInputKey(keyLocale: .leading, event: .letterQ, keyModel: KeyModel(primary: KeyElement("q", header: "1"), members: [KeyElement("q"), KeyElement("1")]))
                        EnhancedInputKey(keyLocale: .leading, event: .letterW, keyModel: KeyModel(primary: KeyElement("w", header: "2"), members: [KeyElement("w"), KeyElement("2")]))
                        EnhancedInputKey(keyLocale: .leading, event: .letterE, keyModel: KeyModel(primary: KeyElement("e", header: "3"), members: [KeyElement("e"), KeyElement("3")]))
                        EnhancedInputKey(keyLocale: .leading, event: .letterR, keyModel: KeyModel(primary: KeyElement("r", header: "4"), members: [KeyElement("r"), KeyElement("4")]))
                        EnhancedInputKey(keyLocale: .leading, event: .letterT, keyModel: KeyModel(primary: KeyElement("t", header: "5"), members: [KeyElement("t"), KeyElement("5")]))
                        EnhancedInputKey(keyLocale: .leading, event: .letterY, keyModel: KeyModel(primary: KeyElement("y", header: "6"), members: [KeyElement("y"), KeyElement("6")]))
                        EnhancedInputKey(keyLocale: .trailing, event: .letterU, keyModel: KeyModel(primary: KeyElement("u", header: "7"), members: [KeyElement("u"), KeyElement("7")]))
                        EnhancedInputKey(keyLocale: .trailing, event: .letterI, keyModel: KeyModel(primary: KeyElement("i", header: "8"), members: [KeyElement("i"), KeyElement("8")]))
                        EnhancedInputKey(keyLocale: .trailing, event: .letterO, keyModel: KeyModel(primary: KeyElement("o", header: "9"), members: [KeyElement("o"), KeyElement("9")]))
                        EnhancedInputKey(keyLocale: .trailing, event: .letterP, keyModel: KeyModel(primary: KeyElement("p", header: "0"), members: [KeyElement("p"), KeyElement("0")]))
                }
        }
}

private struct SecondLetterRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        T14InputKey(side: .leading, unit: KeyModel(primary: KeyElement("as"), members: [KeyElement("a"), KeyElement("s")]))
                        T14InputKey(side: .leading, unit: KeyModel(primary: KeyElement("df"), members: [KeyElement("d"), KeyElement("f")]))
                        T14InputKey(side: .leading, unit: KeyModel(primary: KeyElement("gh"), members: [KeyElement("g"), KeyElement("h")]))
                        T14InputKey(side: .leading, unit: KeyModel(primary: KeyElement("jk"), members: [KeyElement("j"), KeyElement("k")]))
                        T14InputKey(side: .trailing, virtual: .letterL, unit: KeyModel(primary: KeyElement("l"), members: [KeyElement("l")]))
                }
        }
}
private struct SecondEnhancedLetterRow: View {
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
                        EnhancedInputKey(keyLocale: .leading, event: .letterG, keyModel: KeyModel(primary: KeyElement("g", header: "（"), members: [KeyElement("g"), KeyElement("（")]))
                        EnhancedInputKey(keyLocale: .trailing, event: .letterH, keyModel: KeyModel(primary: KeyElement("h", header: "）"), members: [KeyElement("h"), KeyElement("）")]))
                        EnhancedInputKey(keyLocale: .trailing, event: .letterJ, keyModel: KeyModel(primary: KeyElement("j", header: "「"), members: [KeyElement("j"), KeyElement("「")]))
                        EnhancedInputKey(keyLocale: .trailing, event: .letterK, keyModel: KeyModel(primary: KeyElement("k", header: "」"), members: [KeyElement("k"), KeyElement("」")]))
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

private struct ThirdLetterRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        T14InputKey(side: .leading, coefficient: 1.85, virtual: .letterZ, unit: KeyModel(primary: KeyElement("zx"), members: [KeyElement("z"), KeyElement("x")]))
                        T14InputKey(side: .leading, coefficient: 1.85, virtual: .letterC, unit: KeyModel(primary: KeyElement("cv"), members: [KeyElement("c"), KeyElement("v")]))
                        T14InputKey(side: .leading, coefficient: 1.85, unit: KeyModel(primary: KeyElement("bn"), members: [KeyElement("b"), KeyElement("n")]))
                        T14InputKey(side: .trailing, coefficient: 1.85, virtual: .letterM, unit: KeyModel(primary: KeyElement("m"), members: [KeyElement("m")]))
                }
        }
}
private struct ThirdEnhancedLetterRow: View {
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
                        EnhancedInputKey(keyLocale: .leading, event: .letterV, keyModel: KeyModel(primary: KeyElement("v", header: "…"), members: [KeyElement("v"), KeyElement("…")]))
                        EnhancedInputKey(keyLocale: .leading, event: .letterB, keyModel: KeyModel(primary: KeyElement("b", header: "、"), members: [KeyElement("b"), KeyElement("、")]))
                        EnhancedInputKey(keyLocale: .trailing, event: .letterN, keyModel: KeyModel(primary: KeyElement("n", header: "；"), members: [KeyElement("n"), KeyElement("；")]))
                        EnhancedInputKey(keyLocale: .trailing, event: .letterM, keyModel: KeyModel(primary: KeyElement("m", header: "："), members: [KeyElement("m"), KeyElement("：")]))
                }
        }
}
