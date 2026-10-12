import SwiftUI
import CommonExtensions
import CoreIME

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassT19Keyboard: View {
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
                                GlassT18T19FirstKeyRow()
                        case .numbers, .symbols:
                                GlassT18T19FirstEnhancedKeyRow()
                        }
                        switch Options.inputKeyStyle {
                        case .clear:
                                GlassT19SecondKeyRow()
                        case .numbers:
                                GlassT19AltSecondKeyRow()
                        case .symbols:
                                GlassT19SecondEnhancedKeyRow()
                        }
                        HStack(spacing: 0) {
                                GlassShiftKey(coefficient: 1.42)
                                switch Options.inputKeyStyle {
                                case .clear, .numbers:
                                        GlassT18T19ThirdKeyRow()
                                case .symbols:
                                        GlassT18T19ThirdEnhancedKeyRow()
                                }
                                GlassBackspaceKey(coefficient: 1.42)
                        }
                        GlassCantoneseBottomKeyRow()
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassT18T19FirstKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        GlassT18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterW,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterW, extras: [.init(VirtualInputKey.letterQ.text, alignment: .bottomLeading)]),
                                        members: [KeyElement(virtual: .letterQ), KeyElement(virtual: .letterW)]
                                )
                        )
                        GlassT18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterE,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterE, extras: [.init(VirtualInputKey.letterR.text, alignment: .bottomTrailing)]),
                                        members: [KeyElement(virtual: .letterE), KeyElement(virtual: .letterR)]
                                )
                        )
                        GlassLetterAltInputKey(.letterT, coefficient: 1.42)
                        GlassLetterAltInputKey(.letterY, coefficient: 1.42)
                        GlassLetterAltInputKey(.letterU, coefficient: 1.42)
                        GlassT18EnhancedInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("io"), members: [KeyElement(virtual: .letterO), KeyElement(virtual: .letterI)]))
                        GlassLetterAltInputKey(.letterP, coefficient: 1.42)
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassT18T19FirstEnhancedKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        GlassT18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterW,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterW, extras: [.init(VirtualInputKey.letterQ.text, alignment: .bottomLeading), .init(VirtualInputKey.number1.text, alignment: .topTrailing)]),
                                        members: [KeyElement(virtual: .letterQ), KeyElement(virtual: .letterW), KeyElement(virtual: .number1)]
                                )
                        )
                        GlassT18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterE,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterE, extras: [.init(VirtualInputKey.letterR.text, alignment: .bottomTrailing), .init(VirtualInputKey.number2.text, alignment: .topTrailing)]),
                                        members: [KeyElement(virtual: .letterE), KeyElement(virtual: .letterR), KeyElement(virtual: .number2)]
                                )
                        )
                        GlassT18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterT,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterT, extras: [.init(VirtualInputKey.number3.text, alignment: .topTrailing)]),
                                        members: [KeyElement(virtual: .letterT), KeyElement(virtual: .number3)]
                                )
                        )
                        GlassT18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterY,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterY, extras: [.init(VirtualInputKey.number4.text, alignment: .topTrailing)]),
                                        members: [KeyElement(virtual: .letterY), KeyElement(virtual: .number4)]
                                )
                        )
                        GlassT18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterU,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterU, extras: [.init(VirtualInputKey.number5.text, alignment: .topTrailing)]),
                                        members: [KeyElement(virtual: .letterU), KeyElement(virtual: .number5)]
                                )
                        )
                        GlassT18EnhancedInputKey(
                                side: .trailing,
                                unit: KeyUnit(
                                        primary: KeyElement(VirtualInputKey.letterI.text + VirtualInputKey.letterO.text, extras: [.init(VirtualInputKey.number6.text, alignment: .topTrailing)]),
                                        members: [KeyElement(virtual: .letterO), KeyElement(virtual: .letterI), KeyElement(virtual: .number6)]
                                )
                        )
                        GlassT18EnhancedInputKey(
                                side: .trailing,
                                virtual: .letterP,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterP, extras: [.init(VirtualInputKey.number7.text, alignment: .topTrailing)]),
                                        members: [KeyElement(virtual: .letterP), KeyElement(virtual: .number7)]
                                )
                        )
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct GlassT19SecondKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        GlassLetterAltInputKey(.letterA, coefficient: 1.42)
                        GlassT18EnhancedInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("sd"), members: [KeyElement(virtual: .letterS), KeyElement(virtual: .letterD)]))
                        GlassLetterAltInputKey(.letterF, coefficient: 1.42)
                        GlassLetterAltInputKey(.letterG, coefficient: 1.42)
                        GlassLetterAltInputKey(.letterH, coefficient: 1.42)
                        GlassT18EnhancedInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("jk"), members: [KeyElement(virtual: .letterK), KeyElement(virtual: .letterJ)]))
                        GlassLetterAltInputKey(.letterL, coefficient: 1.42)
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct GlassT19AltSecondKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        GlassT18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterA,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterA, extras: [.init(VirtualInputKey.number8.text, alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterA),
                                                KeyElement(virtual: .number8),
                                        ]
                                )
                        )
                        GlassT18EnhancedInputKey(
                                side: .leading,
                                unit: KeyUnit(
                                        primary: KeyElement(VirtualInputKey.letterS.text + VirtualInputKey.letterD.text, extras: [.init(VirtualInputKey.number9.text, alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterS),
                                                KeyElement(virtual: .letterD),
                                                KeyElement(virtual: .number9),
                                        ]
                                )
                        )
                        GlassT18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterF,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterF, extras: [.init(VirtualInputKey.number0.text, alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterF),
                                                KeyElement(virtual: .number0),
                                        ]
                                )
                        )
                        GlassLetterAltInputKey(.letterG, coefficient: 1.42)
                        GlassLetterAltInputKey(.letterH, coefficient: 1.42)
                        GlassT18EnhancedInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement(VirtualInputKey.letterJ.text + VirtualInputKey.letterK.text), members: [KeyElement(virtual: .letterK), KeyElement(virtual: .letterJ)]))
                        GlassLetterAltInputKey(.letterL, coefficient: 1.42)
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct GlassT19SecondEnhancedKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        GlassT18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterA,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterA, extras: [.init("8", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterA),
                                                KeyElement("8"),
                                        ]
                                )
                        )
                        GlassT18EnhancedInputKey(
                                side: .leading,
                                unit: KeyUnit(
                                        primary: KeyElement("sd", extras: [.init("9", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterS),
                                                KeyElement(virtual: .letterD),
                                                KeyElement("9"),
                                        ]
                                )
                        )
                        GlassT18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterF,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterF, extras: [.init("0", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterF),
                                                KeyElement("0"),
                                        ]
                                )
                        )
                        GlassT18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterG,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterG, extras: [.init("@", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterG),
                                                KeyElement("@"),
                                        ]
                                )
                        )
                        GlassT18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterH,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterH, extras: [.init("#", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterH),
                                                KeyElement("#"),
                                        ]
                                )
                        )
                        GlassT18EnhancedInputKey(
                                side: .trailing,
                                unit: KeyUnit(
                                        primary: KeyElement("jk", extras: [.init("「", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterK),
                                                KeyElement(virtual: .letterJ),
                                                KeyElement("「"),
                                        ]
                                )
                        )
                        GlassT18EnhancedInputKey(
                                side: .trailing,
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
struct GlassT18T19ThirdKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        GlassT18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterZ,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterZ, extras: [.init(VirtualInputKey.letterX.text, alignment: .bottomTrailing)]),
                                        members: [KeyElement(virtual: .letterZ), KeyElement(virtual: .letterX)]
                                )
                        )
                        GlassT18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterC,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterC, extras: [.init(VirtualInputKey.letterV.text, alignment: .bottomTrailing)]),
                                        members: [KeyElement(virtual: .letterC), KeyElement(virtual: .letterV)]
                                )
                        )
                        GlassLetterAltInputKey(.letterB, coefficient: 1.42)
                        GlassLetterAltInputKey(.letterN, coefficient: 1.42)
                        GlassLetterAltInputKey(.letterM, coefficient: 1.42)
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassT18T19ThirdEnhancedKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        GlassT18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterZ,
                                unit: .init(
                                        primary: KeyElement(virtual: .letterZ, extras: [.init(VirtualInputKey.letterX.text, alignment: .bottomTrailing), .init("%", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterZ),
                                                KeyElement(virtual: .letterX),
                                                KeyElement("%"),
                                        ]
                                )
                        )
                        GlassT18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterC,
                                unit: .init(
                                        primary: KeyElement(virtual: .letterC, extras: [.init(VirtualInputKey.letterV.text, alignment: .bottomTrailing), .init("～", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterC),
                                                KeyElement(virtual: .letterV),
                                                KeyElement("～"),
                                                KeyElement("~", extras: [.init(PresetConstant.halfWidth, alignment: .top)]),
                                        ]
                                )
                        )
                        GlassT18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterB,
                                unit: .init(
                                        primary: KeyElement(virtual: .letterB, extras: [.init("、", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterB),
                                                KeyElement("、"),
                                        ]
                                )
                        )
                        GlassT18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterN,
                                unit: .init(
                                        primary: KeyElement(virtual: .letterN, extras: [.init("；", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterN),
                                                KeyElement("；"),
                                        ]
                                )
                        )
                        GlassT18EnhancedInputKey(
                                side: .trailing,
                                virtual: .letterM,
                                unit: .init(
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
