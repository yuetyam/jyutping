import SwiftUI
import CoreIME

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassT21Keyboard: View {
        @EnvironmentObject private var context: KeyboardViewController
        var body: some View {
                VStack(spacing: 0) {
                        if context.inputStage.isBuffering {
                                CandidateBar()
                        } else {
                                ToolBar()
                        }
                        if Options.needsNumberRow {
                                CantoneseGlassNumberRow()
                        }
                        switch Options.inputKeyStyle {
                        case .clear:
                                FirstT21GlassKeyRow()
                        case .numbers, .symbols:
                                FirstT21GlassEnhancedKeyRow()
                        }
                        HStack(spacing: 0) {
                                HiddenKey(key: .letterA)
                                switch Options.inputKeyStyle {
                                case .clear:
                                        SecondT21GlassKeyRow(needsNumbers: false)
                                case .numbers:
                                        SecondT21GlassKeyRow(needsNumbers: true)
                                case .symbols:
                                        SecondT21GlassEnhancedKeyRow()
                                }
                                HiddenKey(key: .letterL)
                        }
                        HStack(spacing: 0) {
                                GlassShiftKey(coefficient: 1.65)
                                HiddenKey(key: .letterZ)
                                switch Options.inputKeyStyle {
                                case .clear, .numbers:
                                        ThirdT21GlassKeyRow()
                                case .symbols:
                                        ThirdT21GlassEnhancedKeyRow()
                                }
                                HiddenKey(key: .backspace)
                                GlassBackspaceKey(coefficient: 1.65)
                        }
                        GlassCantoneseBottomKeyRow()
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct FirstT21GlassKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        GlassEnhancedInputKey(
                                side: .leading,
                                coefficient: 1.25,
                                virtual: .letterW,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterW, extras: [.init(VirtualInputKey.letterQ.text, alignment: .bottomLeading)]),
                                        members: [
                                                KeyElement(virtual: .letterQ),
                                                KeyElement(virtual: .letterW)
                                        ]
                                )
                        )
                        GlassEnhancedInputKey(
                                side: .leading,
                                coefficient: 1.25,
                                virtual: .letterE,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterE, extras: [.init(VirtualInputKey.letterR.text, alignment: .bottomTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterE),
                                                KeyElement(virtual: .letterR)
                                        ]
                                )
                        )
                        GlassLetterInputKey(.letterT, coefficient: 1.25)
                        GlassLetterInputKey(.letterY, coefficient: 1.25)
                        GlassLetterInputKey(.letterU, coefficient: 1.25)
                        GlassLetterInputKey(.letterI, coefficient: 1.25)
                        GlassLetterInputKey(.letterO, coefficient: 1.25)
                        GlassLetterInputKey(.letterP, coefficient: 1.25)
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct FirstT21GlassEnhancedKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        GlassEnhancedInputKey(
                                side: .leading,
                                coefficient: 1.25,
                                virtual: .letterW,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterW, extras: [.init(VirtualInputKey.letterQ.text, alignment: .bottomLeading), .init("1", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterQ),
                                                KeyElement(virtual: .letterW),
                                                KeyElement("1"),
                                        ]
                                )
                        )
                        GlassEnhancedInputKey(
                                side: .leading,
                                coefficient: 1.25,
                                virtual: .letterE,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterE, extras: [.init(VirtualInputKey.letterR.text, alignment: .bottomTrailing), .init("2", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterE),
                                                KeyElement(virtual: .letterR),
                                                KeyElement("2"),
                                        ]
                                )
                        )
                        GlassEnhancedInputKey(
                                side: .leading,
                                coefficient: 1.25,
                                virtual: .letterT,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterT, extras: [.init("3", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterT),
                                                KeyElement("3"),
                                        ]
                                )
                        )
                        GlassEnhancedInputKey(
                                side: .leading,
                                coefficient: 1.25,
                                virtual: .letterY,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterY, extras: [.init("4", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterY),
                                                KeyElement("4"),
                                        ]
                                )
                        )
                        GlassEnhancedInputKey(
                                side: .leading,
                                coefficient: 1.25,
                                virtual: .letterU,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterU, extras: [.init("5", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterU),
                                                KeyElement("5"),
                                        ]
                                )
                        )
                        GlassEnhancedInputKey(
                                side: .leading,
                                coefficient: 1.25,
                                virtual: .letterI,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterI, extras: [.init("6", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterI),
                                                KeyElement("6"),
                                        ]
                                )
                        )
                        GlassEnhancedInputKey(
                                side: .trailing,
                                coefficient: 1.25,
                                virtual: .letterO,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterO, extras: [.init("7", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterO),
                                                KeyElement("7"),
                                        ]
                                )
                        )
                        GlassEnhancedInputKey(
                                side: .trailing,
                                coefficient: 1.25,
                                virtual: .letterP,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterP, extras: [.init("8", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterP),
                                                KeyElement("8"),
                                        ]
                                )
                        )
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct SecondT21GlassKeyRow: View {
        let needsNumbers: Bool
        var body: some View {
                HStack(spacing: 0 ) {
                        if needsNumbers {
                                GlassEnhancedInputKey(
                                        side: .leading,
                                        coefficient: 1.25,
                                        virtual: .letterA,
                                        unit: KeyUnit(
                                                primary: KeyElement(virtual: .letterA, extras: [.init("9", alignment: .topTrailing)]),
                                                members: [
                                                        KeyElement(virtual: .letterA),
                                                        KeyElement("9"),
                                                ]
                                        )
                                )
                                GlassEnhancedInputKey(
                                        side: .leading,
                                        coefficient: 1.25,
                                        virtual: .letterS,
                                        unit: KeyUnit(
                                                primary: KeyElement(virtual: .letterS, extras: [.init("0", alignment: .topTrailing)]),
                                                members: [
                                                        KeyElement(virtual: .letterS),
                                                        KeyElement("0"),
                                                ]
                                        )
                                )
                        } else {
                                GlassLetterInputKey(.letterA, coefficient: 1.25)
                                GlassLetterInputKey(.letterS, coefficient: 1.25)
                        }
                        GlassLetterInputKey(.letterD, coefficient: 1.25)
                        GlassLetterInputKey(.letterF, coefficient: 1.25)
                        GlassLetterInputKey(.letterG, coefficient: 1.25)
                        GlassLetterInputKey(.letterH, coefficient: 1.25)
                        GlassEnhancedInputKey(
                                side: .trailing,
                                coefficient: 1.25,
                                virtual: .letterK,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterK, extras: [.init(VirtualInputKey.letterJ.text, alignment: .bottomLeading)]),
                                        members: [
                                                KeyElement(virtual: .letterK),
                                                KeyElement(virtual: .letterJ)
                                        ]
                                )
                        )
                        GlassLetterInputKey(.letterL, coefficient: 1.25)
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct SecondT21GlassEnhancedKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        GlassEnhancedInputKey(
                                side: .leading,
                                coefficient: 1.25,
                                virtual: .letterA,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterA, extras: [.init("9", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterA),
                                                KeyElement("9"),
                                        ]
                                )
                        )
                        GlassEnhancedInputKey(
                                side: .leading,
                                coefficient: 1.25,
                                virtual: .letterS,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterS, extras: [.init("0", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterS),
                                                KeyElement("0"),
                                        ]
                                )
                        )
                        GlassEnhancedInputKey(
                                side: .leading,
                                coefficient: 1.25,
                                virtual: .letterD,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterD, extras: [.init("@", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterD),
                                                KeyElement("@"),
                                        ]
                                )
                        )
                        GlassEnhancedInputKey(
                                side: .leading,
                                coefficient: 1.25,
                                virtual: .letterF,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterF, extras: [.init("#", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterF),
                                                KeyElement("#"),
                                        ]
                                )
                        )
                        GlassEnhancedInputKey(
                                side: .leading,
                                coefficient: 1.25,
                                virtual: .letterG,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterG, extras: [.init("$", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterG),
                                                KeyElement("$"),
                                        ]
                                )
                        )
                        GlassEnhancedInputKey(
                                side: .leading,
                                coefficient: 1.25,
                                virtual: .letterH,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterH, extras: [.init("/", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterH),
                                                KeyElement("/"),
                                        ]
                                )
                        )
                        GlassEnhancedInputKey(
                                side: .trailing,
                                coefficient: 1.25,
                                virtual: .letterK,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterK, extras: [.init(VirtualInputKey.letterJ.text, alignment: .bottomLeading), .init("「", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterK),
                                                KeyElement(virtual: .letterJ),
                                                KeyElement("「"),
                                        ]
                                )
                        )
                        GlassEnhancedInputKey(
                                side: .trailing,
                                coefficient: 1.25,
                                virtual: .letterL,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterL, extras: [.init("」", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterL),
                                                KeyElement("」"),
                                        ]
                                )
                        )
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct ThirdT21GlassKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        GlassEnhancedInputKey(
                                side: .leading,
                                coefficient: 1.25,
                                virtual: .letterZ,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterZ, extras: [.init(VirtualInputKey.letterX.text, alignment: .bottomTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterZ),
                                                KeyElement(virtual: .letterX)
                                        ]
                                )
                        )
                        GlassEnhancedInputKey(
                                side: .leading,
                                coefficient: 1.25,
                                virtual: .letterC,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterC, extras: [.init(VirtualInputKey.letterV.text, alignment: .bottomTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterC),
                                                KeyElement(virtual: .letterV)
                                        ]
                                )
                        )
                        GlassLetterInputKey(.letterB, coefficient: 1.25)
                        GlassLetterInputKey(.letterN, coefficient: 1.25)
                        GlassLetterInputKey(.letterM, coefficient: 1.25)
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct ThirdT21GlassEnhancedKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        GlassEnhancedInputKey(
                                side: .leading,
                                coefficient: 1.25,
                                virtual: .letterZ,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterZ, extras: [.init(VirtualInputKey.letterX.text, alignment: .bottomTrailing), .init("%", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterZ),
                                                KeyElement(virtual: .letterX),
                                                KeyElement("%"),
                                        ]
                                )
                        )
                        GlassEnhancedInputKey(
                                side: .leading,
                                coefficient: 1.25,
                                virtual: .letterC,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterC, extras: [.init(VirtualInputKey.letterV.text, alignment: .bottomTrailing), .init("～", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterC),
                                                KeyElement(virtual: .letterV),
                                                KeyElement("～"),
                                                KeyElement("~", extras: [.init(PresetConstant.halfWidth, alignment: .top)]),
                                        ]
                                )
                        )
                        GlassEnhancedInputKey(
                                side: .leading,
                                coefficient: 1.25,
                                virtual: .letterB,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterB, extras: [.init("、", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterB),
                                                KeyElement("、"),
                                        ]
                                )
                        )
                        GlassEnhancedInputKey(
                                side: .leading,
                                coefficient: 1.25,
                                virtual: .letterN,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterN, extras: [.init("；", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterN),
                                                KeyElement("；"),
                                        ]
                                )
                        )
                        GlassEnhancedInputKey(
                                side: .leading,
                                coefficient: 1.25,
                                virtual: .letterM,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterM, extras: [.init("：", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterM),
                                                KeyElement("："),
                                        ]
                                )
                        )
                }
        }
}
