import SwiftUI
import CoreIME
import CommonExtensions

struct TwentyOneKeyKeyboard: View {
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
                                SecondLetterRow(needsNumbers: false)
                        case .numbers:
                                SecondLetterRow(needsNumbers: true)
                        case .numbersAndSymbols:
                                SecondEnhancedLetterRow()
                        }
                        HStack(spacing: 0) {
                                ShiftKey(widthUnitTimes: 1.6)
                                HiddenKey(key: .letterZ)
                                switch Options.inputKeyStyle {
                                case .clear, .numbers:
                                        ThirdLetterRow()
                                case .numbersAndSymbols:
                                        ThirdEnhancedLetterRow()
                                }
                                HiddenKey(key: .letterM)
                                BackspaceKey(widthUnitTimes: 1.6)
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
                        T21EnhancedInputKey(
                                side: .leading,
                                virtual: .letterW,
                                unit: KeyUnit(
                                        primary: KeyElement("w", extras: [.init("q", alignment: .bottomLeading)]),
                                        members: [
                                                KeyElement("q"),
                                                KeyElement("w")
                                        ]
                                )
                        )
                        T21EnhancedInputKey(
                                side: .leading,
                                virtual: .letterE,
                                unit: KeyUnit(
                                        primary: KeyElement("e", extras: [.init("r", alignment: .bottomTrailing)]),
                                        members: [
                                                KeyElement("e"),
                                                KeyElement("r")
                                        ]
                                )
                        )
                        T21LetterInputKey(.letterT)
                        T21LetterInputKey(.letterY)
                        T21LetterInputKey(.letterU)
                        T21LetterInputKey(.letterI)
                        T21LetterInputKey(.letterO)
                        T21LetterInputKey(.letterP)
                }
        }
}
private struct FirstEnhancedLetterRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        T21EnhancedInputKey(
                                side: .leading,
                                virtual: .letterW,
                                unit: KeyUnit(
                                        primary: KeyElement("w", extras: [.init("q", alignment: .bottomLeading), .init("1", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("q"),
                                                KeyElement("w"),
                                                KeyElement("1"),
                                        ]
                                )
                        )
                        T21EnhancedInputKey(
                                side: .leading,
                                virtual: .letterE,
                                unit: KeyUnit(
                                        primary: KeyElement("e", extras: [.init("r", alignment: .bottomTrailing), .init("2", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("e"),
                                                KeyElement("r"),
                                                KeyElement("2"),
                                        ]
                                )
                        )
                        T21EnhancedInputKey(
                                side: .leading,
                                virtual: .letterT,
                                unit: KeyUnit(
                                        primary: KeyElement("t", extras: [.init("3", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("t"),
                                                KeyElement("3"),
                                        ]
                                )
                        )
                        T21EnhancedInputKey(
                                side: .leading,
                                virtual: .letterY,
                                unit: KeyUnit(
                                        primary: KeyElement("y", extras: [.init("4", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("y"),
                                                KeyElement("4"),
                                        ]
                                )
                        )
                        T21EnhancedInputKey(
                                side: .leading,
                                virtual: .letterU,
                                unit: KeyUnit(
                                        primary: KeyElement("u", extras: [.init("5", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("u"),
                                                KeyElement("5"),
                                        ]
                                )
                        )
                        T21EnhancedInputKey(
                                side: .leading,
                                virtual: .letterI,
                                unit: KeyUnit(
                                        primary: KeyElement("i", extras: [.init("6", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("i"),
                                                KeyElement("6"),
                                        ]
                                )
                        )
                        T21EnhancedInputKey(
                                side: .trailing,
                                virtual: .letterO,
                                unit: KeyUnit(
                                        primary: KeyElement("o", extras: [.init("7", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("o"),
                                                KeyElement("7"),
                                        ]
                                )
                        )
                        T21EnhancedInputKey(
                                side: .trailing,
                                virtual: .letterP,
                                unit: KeyUnit(
                                        primary: KeyElement("p", extras: [.init("8", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("p"),
                                                KeyElement("8"),
                                        ]
                                )
                        )
                }
        }
}

private struct SecondLetterRow: View {
        let needsNumbers: Bool
        var body: some View {
                HStack(spacing: 0 ) {
                        if needsNumbers {
                                T21EnhancedInputKey(
                                        side: .trailing,
                                        virtual: .letterA,
                                        unit: KeyUnit(
                                                primary: KeyElement("a", extras: [.init("9", alignment: .topTrailing)]),
                                                members: [
                                                        KeyElement("a"),
                                                        KeyElement("9"),
                                                ]
                                        )
                                )
                                T21EnhancedInputKey(
                                        side: .trailing,
                                        virtual: .letterS,
                                        unit: KeyUnit(
                                                primary: KeyElement("s", extras: [.init("0", alignment: .topTrailing)]),
                                                members: [
                                                        KeyElement("s"),
                                                        KeyElement("0"),
                                                ]
                                        )
                                )
                        } else {
                                T21LetterInputKey(.letterA)
                                T21LetterInputKey(.letterS)
                        }
                        T21LetterInputKey(.letterD)
                        T21LetterInputKey(.letterF)
                        T21LetterInputKey(.letterG)
                        T21LetterInputKey(.letterH)
                        T21EnhancedInputKey(
                                side: .trailing,
                                virtual: .letterK,
                                unit: KeyUnit(
                                        primary: KeyElement("k", extras: [.init("j", alignment: .bottomLeading)]),
                                        members: [
                                                KeyElement("k"),
                                                KeyElement("j")
                                        ]
                                )
                        )
                        T21LetterInputKey(.letterL)
                }
        }
}
private struct SecondEnhancedLetterRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        T21EnhancedInputKey(
                                side: .leading,
                                virtual: .letterA,
                                unit: KeyUnit(
                                        primary: KeyElement("a", extras: [.init("9", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("a"),
                                                KeyElement("9"),
                                        ]
                                )
                        )
                        T21EnhancedInputKey(
                                side: .leading,
                                virtual: .letterS,
                                unit: KeyUnit(
                                        primary: KeyElement("s", extras: [.init("0", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("s"),
                                                KeyElement("0"),
                                        ]
                                )
                        )
                        T21EnhancedInputKey(
                                side: .leading,
                                virtual: .letterD,
                                unit: KeyUnit(
                                        primary: KeyElement("d", extras: [.init("@", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("d"),
                                                KeyElement("@"),
                                        ]
                                )
                        )
                        T21EnhancedInputKey(
                                side: .leading,
                                virtual: .letterF,
                                unit: KeyUnit(
                                        primary: KeyElement("f", extras: [.init("#", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("f"),
                                                KeyElement("#"),
                                        ]
                                )
                        )
                        T21EnhancedInputKey(
                                side: .leading,
                                virtual: .letterG,
                                unit: KeyUnit(
                                        primary: KeyElement("g", extras: [.init("$", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("g"),
                                                KeyElement("$"),
                                        ]
                                )
                        )
                        T21EnhancedInputKey(
                                side: .leading,
                                virtual: .letterH,
                                unit: KeyUnit(
                                        primary: KeyElement("h", extras: [.init("/", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("h"),
                                                KeyElement("/"),
                                        ]
                                )
                        )
                        T21EnhancedInputKey(
                                side: .trailing,
                                virtual: .letterK,
                                unit: KeyUnit(
                                        primary: KeyElement("k", extras: [.init("j", alignment: .bottomLeading), .init("「", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("k"),
                                                KeyElement("j"),
                                                KeyElement("「"),
                                        ]
                                )
                        )
                        T21EnhancedInputKey(
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
private struct ThirdLetterRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        T21EnhancedInputKey(
                                side: .leading,
                                virtual: .letterZ,
                                unit: .init(
                                        primary: KeyElement("z", extras: [.init("x", alignment: .bottomTrailing)]),
                                        members: [
                                                KeyElement("z"),
                                                KeyElement("x")
                                        ]
                                )
                        )
                        T21EnhancedInputKey(
                                side: .leading,
                                virtual: .letterC,
                                unit: .init(
                                        primary: KeyElement("c", extras: [.init("v", alignment: .bottomTrailing)]),
                                        members: [
                                                KeyElement("c"),
                                                KeyElement("v")
                                        ]
                                )
                        )
                        T21LetterInputKey(.letterB)
                        T21LetterInputKey(.letterN)
                        T21LetterInputKey(.letterM)
                }
        }
}
private struct ThirdEnhancedLetterRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        T21EnhancedInputKey(
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
                        T21EnhancedInputKey(
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
                        T21EnhancedInputKey(
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
                        T21EnhancedInputKey(
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
                        T21EnhancedInputKey(
                                side: .leading,
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
