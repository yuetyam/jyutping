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
                        case .numbers, .symbols:
                                T18T19FirstEnhancedLetterRow()
                        }
                        switch Options.inputKeyStyle {
                        case .clear:
                                SecondLetterRow()
                        case .numbers:
                                AltSecondLetterRow()
                        case .symbols:
                                SecondEnhancedLetterRow()
                        }
                        HStack(spacing: 0) {
                                ShiftKey(coefficient: 1.42)
                                switch Options.inputKeyStyle {
                                case .clear, .numbers:
                                        T18T19ThirdLetterRow()
                                case .symbols:
                                        T18T19ThirdEnhancedLetterRow()
                                }
                                BackspaceKey(coefficient: 1.42)
                        }
                        CantoneseBottomKeyRow()
                }
        }
}

struct T18T19FirstLetterRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        T18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterW,
                                unit: KeyUnit(
                                        primary: KeyElement("w", extras: [.init("q", alignment: .bottomLeading)]),
                                        members: [KeyElement("q"), KeyElement("w")]
                                )
                        )
                        T18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterE,
                                unit: KeyUnit(
                                        primary: KeyElement("e", extras: [.init("r", alignment: .bottomTrailing)]),
                                        members: [KeyElement("e"), KeyElement("r")]
                                )
                        )
                        T18LetterInputKey(.letterT)
                        T18LetterInputKey(.letterY)
                        T18LetterInputKey(.letterU)
                        T18EnhancedInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("io"), members: [KeyElement("o"), KeyElement("i")]))
                        T18LetterInputKey(.letterP)
                }
        }
}
struct T18T19FirstEnhancedLetterRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        T18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterW,
                                unit: KeyUnit(
                                        primary: KeyElement("w", extras: [.init("q", alignment: .bottomLeading), .init("1", alignment: .topTrailing)]),
                                        members: [KeyElement("q"), KeyElement("w"), KeyElement("1")]
                                )
                        )
                        T18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterE,
                                unit: KeyUnit(
                                        primary: KeyElement("e", extras: [.init("r", alignment: .bottomTrailing), .init("2", alignment: .topTrailing)]),
                                        members: [KeyElement("e"), KeyElement("r"), KeyElement("2")]
                                )
                        )
                        T18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterT,
                                unit: KeyUnit(
                                        primary: KeyElement("t", extras: [.init("3", alignment: .topTrailing)]),
                                        members: [KeyElement("t"), KeyElement("3")]
                                )
                        )
                        T18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterY,
                                unit: KeyUnit(
                                        primary: KeyElement("y", extras: [.init("4", alignment: .topTrailing)]),
                                        members: [KeyElement("y"), KeyElement("4")]
                                )
                        )
                        T18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterU,
                                unit: KeyUnit(
                                        primary: KeyElement("u", extras: [.init("5", alignment: .topTrailing)]),
                                        members: [KeyElement("u"), KeyElement("5")]
                                )
                        )
                        T18EnhancedInputKey(
                                side: .trailing,
                                unit: KeyUnit(
                                        primary: KeyElement("io", extras: [.init("6", alignment: .topTrailing)]),
                                        members: [KeyElement("o"), KeyElement("i"), KeyElement("6")]
                                )
                        )
                        T18EnhancedInputKey(
                                side: .trailing,
                                virtual: .letterP,
                                unit: KeyUnit(
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
                        T18EnhancedInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("sd"), members: [KeyElement("s"), KeyElement("d")]))
                        T18LetterInputKey(.letterF)
                        T18LetterInputKey(.letterG)
                        T18LetterInputKey(.letterH)
                        T18EnhancedInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("jk"), members: [KeyElement("k"), KeyElement("j")]))
                        T18LetterInputKey(.letterL)
                }
        }
}
private struct AltSecondLetterRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        T18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterA,
                                unit: KeyUnit(
                                        primary: KeyElement("a", extras: [.init("8", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("a"),
                                                KeyElement("8"),
                                        ]
                                )
                        )
                        T18EnhancedInputKey(
                                side: .leading,
                                unit: KeyUnit(
                                        primary: KeyElement("sd", extras: [.init("9", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("s"),
                                                KeyElement("d"),
                                                KeyElement("9"),
                                        ]
                                )
                        )
                        T18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterF,
                                unit: KeyUnit(
                                        primary: KeyElement("f", extras: [.init("0", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("f"),
                                                KeyElement("0"),
                                        ]
                                )
                        )
                        T18LetterInputKey(.letterG)
                        T18LetterInputKey(.letterH)
                        T18EnhancedInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("jk"), members: [KeyElement("k"), KeyElement("j")]))
                        T18LetterInputKey(.letterL)
                }
        }
}
private struct SecondEnhancedLetterRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        T18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterA,
                                unit: KeyUnit(
                                        primary: KeyElement("a", extras: [.init("8", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("a"),
                                                KeyElement("8"),
                                        ]
                                )
                        )
                        T18EnhancedInputKey(
                                side: .leading,
                                unit: KeyUnit(
                                        primary: KeyElement("sd", extras: [.init("9", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("s"),
                                                KeyElement("d"),
                                                KeyElement("9"),
                                        ]
                                )
                        )
                        T18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterF,
                                unit: KeyUnit(
                                        primary: KeyElement("f", extras: [.init("0", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("f"),
                                                KeyElement("0"),
                                        ]
                                )
                        )
                        T18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterG,
                                unit: KeyUnit(
                                        primary: KeyElement("g", extras: [.init("@", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("g"),
                                                KeyElement("@"),
                                        ]
                                )
                        )
                        T18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterH,
                                unit: KeyUnit(
                                        primary: KeyElement("h", extras: [.init("#", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("h"),
                                                KeyElement("#"),
                                        ]
                                )
                        )
                        T18EnhancedInputKey(
                                side: .trailing,
                                unit: KeyUnit(
                                        primary: KeyElement("jk", extras: [.init("「", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("k"),
                                                KeyElement("j"),
                                                KeyElement("「"),
                                        ]
                                )
                        )
                        T18EnhancedInputKey(
                                side: .trailing,
                                virtual: .letterL,
                                unit: KeyUnit(
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
                                side: .leading,
                                virtual: .letterZ,
                                unit: KeyUnit(
                                        primary: KeyElement("z", extras: [.init("x", alignment: .bottomTrailing)]),
                                        members: [KeyElement("z"), KeyElement("x")]
                                )
                        )
                        T18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterC,
                                unit: KeyUnit(
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
                                side: .leading,
                                virtual: .letterZ,
                                unit: .init(
                                        primary: KeyElement("z", extras: [.init("x", alignment: .bottomTrailing), .init("%", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("z"),
                                                KeyElement("x"),
                                                KeyElement("%"),
                                        ]
                                )
                        )
                        T18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterC,
                                unit: .init(
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
                                side: .leading,
                                virtual: .letterB,
                                unit: .init(
                                        primary: KeyElement("b", extras: [.init("、", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("b"),
                                                KeyElement("、"),
                                        ]
                                )
                        )
                        T18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterN,
                                unit: .init(
                                        primary: KeyElement("n", extras: [.init("；", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("n"),
                                                KeyElement("；"),
                                        ]
                                )
                        )
                        T18EnhancedInputKey(
                                side: .trailing,
                                virtual: .letterM,
                                unit: .init(
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
