import SwiftUI
import CoreIME
import CommonExtensions

struct NineteenKeyKeyboard: View {

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
                                T18T19FirstLetterRow()
                        case .numbers, .numbersAndSymbols:
                                T18T19FirstEnhancedLetterRow()
                        }
                        switch Options.inputKeyStyle {
                        case .clear:
                                SecondLetterRow()
                        case .numbers:
                                AltSecondLetterRow()
                        case .numbersAndSymbols:
                                SecondEnhancedLetterRow()
                        }
                        HStack(spacing: 0) {
                                ShiftKey(widthUnitTimes: 1.42)
                                switch Options.inputKeyStyle {
                                case .clear, .numbers:
                                        T18T19ThirdLetterRow()
                                case .numbersAndSymbols:
                                        T18T19ThirdEnhancedLetterRow()
                                }
                                BackspaceKey(widthUnitTimes: 1.42)
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

struct T18T19FirstLetterRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        T18EnhancedInputKey(
                                keyLocale: .leading,
                                event: .letterW,
                                keyModel: KeyModel(
                                        primary: KeyElement("w", extras: [.init("q", alignment: .bottomLeading)]),
                                        members: [KeyElement("q"), KeyElement("w")]
                                )
                        )
                        T18EnhancedInputKey(
                                keyLocale: .leading,
                                event: .letterE,
                                keyModel: KeyModel(
                                        primary: KeyElement("e", extras: [.init("r", alignment: .bottomTrailing)]),
                                        members: [KeyElement("e"), KeyElement("r")]
                                )
                        )
                        T18LetterInputKey(.letterT)
                        T18LetterInputKey(.letterY)
                        T18LetterInputKey(.letterU)
                        T18EnhancedInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("io"), members: [KeyElement("o"), KeyElement("i")]))
                        T18LetterInputKey(.letterP)
                }
        }
}
struct T18T19FirstEnhancedLetterRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        T18EnhancedInputKey(
                                keyLocale: .leading,
                                event: .letterW,
                                keyModel: KeyModel(
                                        primary: KeyElement("w", extras: [.init("q", alignment: .bottomLeading), .init("1", alignment: .topTrailing)]),
                                        members: [KeyElement("q"), KeyElement("w"), KeyElement("1")]
                                )
                        )
                        T18EnhancedInputKey(
                                keyLocale: .leading,
                                event: .letterE,
                                keyModel: KeyModel(
                                        primary: KeyElement("e", extras: [.init("r", alignment: .bottomTrailing), .init("2", alignment: .topTrailing)]),
                                        members: [KeyElement("e"), KeyElement("r"), KeyElement("2")]
                                )
                        )
                        T18EnhancedInputKey(
                                keyLocale: .leading,
                                event: .letterT,
                                keyModel: KeyModel(
                                        primary: KeyElement("t", extras: [.init("3", alignment: .topTrailing)]),
                                        members: [KeyElement("t"), KeyElement("3")]
                                )
                        )
                        T18EnhancedInputKey(
                                keyLocale: .leading,
                                event: .letterY,
                                keyModel: KeyModel(
                                        primary: KeyElement("y", extras: [.init("4", alignment: .topTrailing)]),
                                        members: [KeyElement("y"), KeyElement("4")]
                                )
                        )
                        T18EnhancedInputKey(
                                keyLocale: .leading,
                                event: .letterU,
                                keyModel: KeyModel(
                                        primary: KeyElement("u", extras: [.init("5", alignment: .topTrailing)]),
                                        members: [KeyElement("u"), KeyElement("5")]
                                )
                        )
                        T18EnhancedInputKey(
                                keyLocale: .trailing,
                                keyModel: KeyModel(
                                        primary: KeyElement("io", extras: [.init("6", alignment: .topTrailing)]),
                                        members: [KeyElement("o"), KeyElement("i"), KeyElement("6")]
                                )
                        )
                        T18EnhancedInputKey(
                                keyLocale: .trailing,
                                event: .letterP,
                                keyModel: KeyModel(
                                        primary: KeyElement("p", extras: [.init("7", alignment: .topTrailing)]),
                                        members: [KeyElement("p"), KeyElement("7")]
                                )
                        )
                }
        }
}

private struct SecondLetterRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        T18LetterInputKey(.letterA)
                        T18LetterInputKey(.letterS)
                        T18EnhancedInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("df"), members: [KeyElement("d"), KeyElement("f")]))
                        T18LetterInputKey(.letterG)
                        T18LetterInputKey(.letterH)
                        T18EnhancedInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("jk"), members: [KeyElement("k"), KeyElement("j")]))
                        T18LetterInputKey(.letterL)
                }
        }
}
private struct AltSecondLetterRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        T18EnhancedInputKey(
                                keyLocale: .leading,
                                event: .letterA,
                                keyModel: KeyUnit(
                                        primary: KeyElement("a", extras: [.init("8", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("a"),
                                                KeyElement("8"),
                                        ]
                                )
                        )
                        T18EnhancedInputKey(
                                keyLocale: .leading,
                                event: .letterS,
                                keyModel: KeyUnit(
                                        primary: KeyElement("s", extras: [.init("9", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("s"),
                                                KeyElement("9"),
                                        ]
                                )
                        )
                        T18EnhancedInputKey(
                                keyLocale: .leading,
                                keyModel: KeyUnit(
                                        primary: KeyElement("df", extras: [.init("0", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("d"),
                                                KeyElement("f"),
                                                KeyElement("0"),
                                        ]
                                )
                        )
                        T18LetterInputKey(.letterG)
                        T18LetterInputKey(.letterH)
                        T18EnhancedInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("jk"), members: [KeyElement("k"), KeyElement("j")]))
                        T18LetterInputKey(.letterL)
                }
        }
}
private struct SecondEnhancedLetterRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        T18EnhancedInputKey(
                                keyLocale: .leading,
                                event: .letterA,
                                keyModel: KeyUnit(
                                        primary: KeyElement("a", extras: [.init("8", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("a"),
                                                KeyElement("8"),
                                        ]
                                )
                        )
                        T18EnhancedInputKey(
                                keyLocale: .leading,
                                event: .letterS,
                                keyModel: KeyUnit(
                                        primary: KeyElement("s", extras: [.init("9", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("s"),
                                                KeyElement("9"),
                                        ]
                                )
                        )
                        T18EnhancedInputKey(
                                keyLocale: .leading,
                                keyModel: KeyUnit(
                                        primary: KeyElement("df", extras: [.init("0", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("d"),
                                                KeyElement("f"),
                                                KeyElement("0"),
                                        ]
                                )
                        )
                        T18EnhancedInputKey(
                                keyLocale: .leading,
                                event: .letterG,
                                keyModel: KeyUnit(
                                        primary: KeyElement("g", extras: [.init("@", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("g"),
                                                KeyElement("@"),
                                        ]
                                )
                        )
                        T18EnhancedInputKey(
                                keyLocale: .leading,
                                event: .letterH,
                                keyModel: KeyUnit(
                                        primary: KeyElement("h", extras: [.init("#", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("h"),
                                                KeyElement("#"),
                                        ]
                                )
                        )
                        T18EnhancedInputKey(
                                keyLocale: .trailing,
                                keyModel: KeyUnit(
                                        primary: KeyElement("jk", extras: [.init("「", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("k"),
                                                KeyElement("j"),
                                                KeyElement("「"),
                                        ]
                                )
                        )
                        T18EnhancedInputKey(
                                keyLocale: .trailing,
                                event: .letterL,
                                keyModel: KeyUnit(
                                        primary: KeyElement("l", extras: [.init("」", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("l"),
                                                KeyElement("」"),
                                        ]
                                )
                        )
                }
        }
}

struct T18T19ThirdLetterRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        T18EnhancedInputKey(
                                keyLocale: .leading,
                                event: .letterZ,
                                keyModel: KeyModel(
                                        primary: KeyElement("z", extras: [.init("x", alignment: .bottomTrailing)]),
                                        members: [KeyElement("z"), KeyElement("x")]
                                )
                        )
                        T18EnhancedInputKey(
                                keyLocale: .leading,
                                event: .letterC,
                                keyModel: KeyModel(
                                        primary: KeyElement("c", extras: [.init("v", alignment: .bottomTrailing)]),
                                        members: [KeyElement("c"), KeyElement("v")]
                                )
                        )
                        T18LetterInputKey(.letterB)
                        T18LetterInputKey(.letterN)
                        T18LetterInputKey(.letterM)
                }
        }
}
struct T18T19ThirdEnhancedLetterRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        T18EnhancedInputKey(
                                keyLocale: .leading,
                                event: .letterZ,
                                keyModel: .init(
                                        primary: KeyElement("z", extras: [.init("x", alignment: .bottomTrailing), .init("%", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("z"),
                                                KeyElement("x"),
                                                KeyElement("%"),
                                        ]
                                )
                        )
                        T18EnhancedInputKey(
                                keyLocale: .leading,
                                event: .letterC,
                                keyModel: .init(
                                        primary: KeyElement("c", extras: [.init("v", alignment: .bottomTrailing), .init("～", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("c"),
                                                KeyElement("v"),
                                                KeyElement("～"),
                                                KeyElement("~", extras: [.init(PresetConstant.halfWidth, alignment: .top)]),
                                        ]
                                )
                        )
                        T18EnhancedInputKey(
                                keyLocale: .leading,
                                event: .letterB,
                                keyModel: .init(
                                        primary: KeyElement("b", extras: [.init("、", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("b"),
                                                KeyElement("、"),
                                        ]
                                )
                        )
                        T18EnhancedInputKey(
                                keyLocale: .leading,
                                event: .letterN,
                                keyModel: .init(
                                        primary: KeyElement("n", extras: [.init("；", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("n"),
                                                KeyElement("；"),
                                        ]
                                )
                        )
                        T18EnhancedInputKey(
                                keyLocale: .trailing,
                                event: .letterM,
                                keyModel: .init(
                                        primary: KeyElement("m", extras: [.init("：", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("m"),
                                                KeyElement("："),
                                        ]
                                )
                        )
                }
        }
}
