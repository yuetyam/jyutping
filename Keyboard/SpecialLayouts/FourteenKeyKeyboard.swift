import SwiftUI
import CoreIME

struct FourteenKeyKeyboard: View {

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
                        case .clear:
                                SecondLetterRow()
                        case .numbers, .numbersAndSymbols:
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
                        T14InputKey(side: .leading, virtual: .letterW, unit: KeyUnit(primary: KeyElement("qw"), members: [KeyElement("q"), KeyElement("w")]))
                        T14InputKey(side: .leading, virtual: .letterE, unit: KeyUnit(primary: KeyElement("er"), members: [KeyElement("e"), KeyElement("r")]))
                        T14InputKey(side: .leading, unit: KeyUnit(primary: KeyElement("ty"), members: [KeyElement("t"), KeyElement("y")]))
                        T14InputKey(side: .leading, unit: KeyUnit(primary: KeyElement("ui"), members: [KeyElement("u"), KeyElement("i")]))
                        T14InputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("op"), members: [KeyElement("p"), KeyElement("o")]))
                }
        }
}
private struct FirstEnhancedLetterRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        T14InputKey(side: .leading, virtual: .letterW, unit: KeyUnit(primary: KeyElement("qw", extras: [.init("1", alignment: .topTrailing)]), members: [KeyElement("q"), KeyElement("w"), KeyElement("1")]))
                        T14InputKey(side: .leading, virtual: .letterE, unit: KeyUnit(primary: KeyElement("er", extras: [.init("2", alignment: .topTrailing)]), members: [KeyElement("e"), KeyElement("r"), KeyElement("2")]))
                        T14InputKey(side: .leading, unit: KeyUnit(primary: KeyElement("ty", extras: [.init("3", alignment: .topTrailing)]), members: [KeyElement("t"), KeyElement("y"), KeyElement("3")]))
                        T14InputKey(side: .leading, unit: KeyUnit(primary: KeyElement("ui", extras: [.init("4", alignment: .topTrailing)]), members: [KeyElement("u"), KeyElement("i"), KeyElement("4")]))
                        T14InputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("op", extras: [.init("5", alignment: .topTrailing)]), members: [KeyElement("p"), KeyElement("o"), KeyElement("5")]))
                }
        }
}

private struct SecondLetterRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        T14InputKey(side: .leading, unit: KeyUnit(primary: KeyElement("as"), members: [KeyElement("a"), KeyElement("s")]))
                        T14InputKey(side: .leading, unit: KeyUnit(primary: KeyElement("df"), members: [KeyElement("d"), KeyElement("f")]))
                        T14InputKey(side: .leading, unit: KeyUnit(primary: KeyElement("gh"), members: [KeyElement("g"), KeyElement("h")]))
                        T14InputKey(side: .leading, unit: KeyUnit(primary: KeyElement("jk"), members: [KeyElement("j"), KeyElement("k")]))
                        T14InputKey(side: .trailing, virtual: .letterL, unit: KeyUnit(primary: KeyElement("l"), members: [KeyElement("l")]))
                }
        }
}
private struct SecondEnhancedLetterRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        T14InputKey(side: .leading, unit: KeyUnit(primary: KeyElement("as", extras: [.init("6", alignment: .topTrailing)]), members: [KeyElement("a"), KeyElement("s"), KeyElement("6")]))
                        T14InputKey(side: .leading, unit: KeyUnit(primary: KeyElement("df", extras: [.init("7", alignment: .topTrailing)]), members: [KeyElement("d"), KeyElement("f"), KeyElement("7")]))
                        T14InputKey(side: .leading, unit: KeyUnit(primary: KeyElement("gh", extras: [.init("8", alignment: .topTrailing)]), members: [KeyElement("g"), KeyElement("h"), KeyElement("8")]))
                        T14InputKey(side: .leading, unit: KeyUnit(primary: KeyElement("jk", extras: [.init("9", alignment: .topTrailing)]), members: [KeyElement("j"), KeyElement("k"), KeyElement("9")]))
                        T14InputKey(side: .trailing, virtual: .letterL, unit: KeyUnit(primary: KeyElement("l", extras: [.init("0", alignment: .topTrailing)]), members: [KeyElement("l"), KeyElement("0")]))
                }
        }
}

private struct ThirdLetterRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        T14InputKey(side: .leading, coefficient: 1.85, virtual: .letterZ, unit: KeyUnit(primary: KeyElement("zx"), members: [KeyElement("z"), KeyElement("x")]))
                        T14InputKey(side: .leading, coefficient: 1.85, virtual: .letterC, unit: KeyUnit(primary: KeyElement("cv"), members: [KeyElement("c"), KeyElement("v")]))
                        T14InputKey(side: .leading, coefficient: 1.85, unit: KeyUnit(primary: KeyElement("bn"), members: [KeyElement("b"), KeyElement("n")]))
                        T14InputKey(side: .trailing, coefficient: 1.85, virtual: .letterM, unit: KeyUnit(primary: KeyElement("m"), members: [KeyElement("m")]))
                }
        }
}
private struct ThirdEnhancedLetterRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        T14InputKey(
                                side: .leading,
                                coefficient: 1.85,
                                virtual: .letterZ,
                                unit: KeyUnit(
                                        primary: KeyElement("zx", extras: [.init("～", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("z"),
                                                KeyElement("x"),
                                                KeyElement("～"),
                                                KeyElement("~", extras: [.init(PresetConstant.halfWidth, alignment: .top)])
                                        ]
                                )
                        )
                        T14InputKey(
                                side: .leading,
                                coefficient: 1.85,
                                virtual: .letterC,
                                unit: KeyUnit(
                                        primary: KeyElement("cv", extras: [.init("、", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("c"),
                                                KeyElement("v"),
                                                KeyElement("、")
                                        ]
                                )
                        )
                        T14InputKey(side: .leading, coefficient: 1.85, unit: KeyUnit(primary: KeyElement("bn", extras: [.init("；", alignment: .topTrailing)]), members: [KeyElement("b"), KeyElement("n"), KeyElement("；")]))
                        T14InputKey(side: .trailing, coefficient: 1.85, virtual: .letterM, unit: KeyUnit(primary: KeyElement("m", extras: [.init("：", alignment: .topTrailing)]), members: [KeyElement("m"), KeyElement("：")]))
                }
        }
}
