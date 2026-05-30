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
                                        AltSecondLetterRow()
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
                        T18EnhancedInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("sd"), members: [KeyElement("s"), KeyElement("d")]))
                        T18EnhancedInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("fg"), members: [KeyElement("f"), KeyElement("g")]))
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
                                unit: KeyUnit(
                                        primary: KeyElement("fg", extras: [.init("0", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("f"),
                                                KeyElement("g"),
                                                KeyElement("0"),
                                        ]
                                )
                        )
                        T18LetterInputKey(.letterH)
                        T18EnhancedInputKey(
                                side: .trailing,
                                unit: KeyUnit(primary: KeyElement("jk"), members: [KeyElement("k"), KeyElement("j")])
                        )
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
                                unit: KeyUnit(
                                        primary: KeyElement("fg", extras: [.init("0", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("f"),
                                                KeyElement("g"),
                                                KeyElement("0"),
                                        ]
                                )
                        )
                        T18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterH,
                                unit: KeyUnit(
                                        primary: KeyElement("h", extras: [.init("@", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("h"),
                                                KeyElement("@"),
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
