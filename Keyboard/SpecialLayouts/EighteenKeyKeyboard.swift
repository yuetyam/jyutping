import SwiftUI
import CoreIME

struct EighteenKeyKeyboard: View {

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
                        HStack(spacing: 0) {
                                HiddenKey(key: .letterA)
                                switch Options.inputKeyStyle {
                                case .clear:
                                        SecondLetterRow()
                                case .numbers:
                                        SecondLetterAltRow()
                                case .numbersAndSymbols:
                                        SecondEnhancedLetterRow()
                                }
                                HiddenKey(key: .letterL)
                        }
                        HStack(spacing: 0) {
                                ShiftKey()
                                HiddenKey(key: .letterZ)
                                switch Options.inputKeyStyle {
                                case .clear, .numbers:
                                        T18T19ThirdLetterRow()
                                case .numbersAndSymbols:
                                        T18T19ThirdEnhancedLetterRow()
                                }
                                HiddenKey(key: .backspace)
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

private struct SecondLetterRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        T18LetterInputKey(.letterA)
                        T18LetterInputKey(.letterS)
                        T18EnhancedInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("df"), members: [KeyElement("d"), KeyElement("f")]))
                        T18EnhancedInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("gh"), members: [KeyElement("g"), KeyElement("h")]))
                        T18EnhancedInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("jk"), members: [KeyElement("j"), KeyElement("k")]))
                        T18LetterInputKey(.letterL)
                }
        }
}
private struct SecondLetterAltRow: View {
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
                        T18EnhancedInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("gh"), members: [KeyElement("g"), KeyElement("h")]))
                        T18EnhancedInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("jk"), members: [KeyElement("j"), KeyElement("k")]))
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
                                keyModel: KeyUnit(
                                        primary: KeyElement("gh", extras: [.init("@", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("g"),
                                                KeyElement("h"),
                                                KeyElement("@"),
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
