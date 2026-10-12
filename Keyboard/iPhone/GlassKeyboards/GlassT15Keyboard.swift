import SwiftUI
import CommonExtensions
import CoreIME

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassT15Keyboard: View {
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
                                GlassT15FirstKeyRow()
                        case .numbers, .symbols:
                                GlassT15FirstEnhancedKeyRow()
                        }
                        HStack(spacing: 0) {
                                HiddenKey(key: .letterA)
                                switch Options.inputKeyStyle {
                                case .clear:
                                        GlassT15SecondKeyRow()
                                case .numbers, .symbols:
                                        GlassT15SecondEnhancedKeyRow()
                                }
                                HiddenKey(key: .letterL)
                        }
                        HStack(spacing: 0) {
                                GlassShiftKey(coefficient: 1.66)
                                switch Options.inputKeyStyle {
                                case .clear, .numbers:
                                        GlassT15ThirdKeyRow()
                                case .symbols:
                                        GlassT15ThirdEnhancedKeyRow()
                                }
                                GlassBackspaceKey(coefficient: 1.66)
                        }
                        GlassCantoneseBottomKeyRow()
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct GlassT15FirstKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        GlassEnhancedAltInputKey(
                                side: .leading,
                                coefficient: 1.66,
                                virtual: .letterW,
                                unit: KeyUnit(
                                        primary: KeyElement("qw"),
                                        members: [KeyElement(virtual: .letterQ), KeyElement(virtual: .letterW)]
                                )
                        )
                        GlassEnhancedAltInputKey(
                                side: .leading,
                                coefficient: 1.66,
                                virtual: .letterE,
                                unit: KeyUnit(
                                        primary: KeyElement("er"),
                                        members: [KeyElement(virtual: .letterE), KeyElement(virtual: .letterR)]
                                )
                        )
                        GlassLetterAltInputKey(.letterT, coefficient: 1.66)
                        GlassLetterAltInputKey(.letterY, coefficient: 1.66)
                        GlassEnhancedAltInputKey(
                                side: .leading,
                                coefficient: 1.66,
                                unit: KeyUnit(
                                        primary: KeyElement("ui"),
                                        members: [KeyElement(virtual: .letterU), KeyElement(virtual: .letterI)]
                                )
                        )
                        GlassEnhancedAltInputKey(
                                side: .trailing,
                                coefficient: 1.66,
                                unit: KeyUnit(
                                        primary: KeyElement("op"),
                                        members: [KeyElement(virtual: .letterP), KeyElement(virtual: .letterO)]
                                )
                        )
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct GlassT15FirstEnhancedKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        GlassEnhancedAltInputKey(
                                side: .leading,
                                coefficient: 1.66,
                                virtual: .letterW,
                                unit: KeyUnit(
                                        primary: KeyElement("qw", extras: [.init(VirtualInputKey.number1.text, alignment: .topTrailing)]),
                                        members: [KeyElement(virtual: .letterQ), KeyElement(virtual: .letterW), KeyElement(virtual: .number1)]
                                )
                        )
                        GlassEnhancedAltInputKey(
                                side: .leading,
                                coefficient: 1.66,
                                virtual: .letterE,
                                unit: KeyUnit(
                                        primary: KeyElement("er", extras: [.init(VirtualInputKey.number2.text, alignment: .topTrailing)]),
                                        members: [KeyElement(virtual: .letterE), KeyElement(virtual: .letterR), KeyElement(virtual: .number2)]
                                )
                        )
                        GlassEnhancedAltInputKey(
                                side: .leading,
                                coefficient: 1.66,
                                virtual: .letterT,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterT, extras: [.init(VirtualInputKey.number3.text, alignment: .topTrailing)]),
                                        members: [KeyElement(virtual: .letterT), KeyElement(virtual: .number3)]
                                )
                        )
                        GlassEnhancedAltInputKey(
                                side: .leading,
                                coefficient: 1.66,
                                virtual: .letterY,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterY, extras: [.init(VirtualInputKey.number4.text, alignment: .topTrailing)]),
                                        members: [KeyElement(virtual: .letterY), KeyElement(virtual: .number4)]
                                )
                        )
                        GlassEnhancedAltInputKey(
                                side: .leading,
                                coefficient: 1.66,
                                unit: KeyUnit(
                                        primary: KeyElement("ui", extras: [.init(VirtualInputKey.number5.text, alignment: .topTrailing)]),
                                        members: [KeyElement(virtual: .letterU), KeyElement(virtual: .letterI), KeyElement(virtual: .number5)]
                                )
                        )
                        GlassEnhancedAltInputKey(
                                side: .trailing,
                                coefficient: 1.66,
                                unit: KeyUnit(
                                        primary: KeyElement("op", extras: [.init(VirtualInputKey.number6.text, alignment: .topTrailing)]),
                                        members: [KeyElement(virtual: .letterP), KeyElement(virtual: .letterO), KeyElement(virtual: .number6)]
                                )
                        )
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct GlassT15SecondKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        GlassEnhancedAltInputKey(
                                side: .leading,
                                coefficient: 1.66,
                                unit: KeyUnit(
                                        primary: KeyElement("as"),
                                        members: [KeyElement(virtual: .letterA), KeyElement(virtual: .letterS)]
                                )
                        )
                        GlassEnhancedAltInputKey(
                                side: .leading,
                                coefficient: 1.66,
                                unit: KeyUnit(
                                        primary: KeyElement("df"),
                                        members: [KeyElement(virtual: .letterD), KeyElement(virtual: .letterF)]
                                )
                        )
                        GlassEnhancedAltInputKey(
                                side: .leading,
                                coefficient: 1.66,
                                unit: KeyUnit(
                                        primary: KeyElement("gh"),
                                        members: [KeyElement(virtual: .letterG), KeyElement(virtual: .letterH)]
                                )
                        )
                        GlassEnhancedAltInputKey(
                                side: .leading,
                                coefficient: 1.66,
                                unit: KeyUnit(
                                        primary: KeyElement("jk"),
                                        members: [KeyElement(virtual: .letterJ), KeyElement(virtual: .letterK)]
                                )
                        )
                        GlassLetterAltInputKey(.letterL, coefficient: 1.66)
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct GlassT15SecondEnhancedKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        GlassEnhancedAltInputKey(
                                side: .leading,
                                coefficient: 1.66,
                                unit: KeyUnit(
                                        primary: KeyElement("as", extras: [.init(VirtualInputKey.number7.text, alignment: .topTrailing)]),
                                        members: [KeyElement(virtual: .letterA), KeyElement(virtual: .letterS), KeyElement(virtual: .number7)]
                                )
                        )
                        GlassEnhancedAltInputKey(
                                side: .leading,
                                coefficient: 1.66,
                                unit: KeyUnit(
                                        primary: KeyElement("df", extras: [.init(VirtualInputKey.number8.text, alignment: .topTrailing)]),
                                        members: [KeyElement(virtual: .letterD), KeyElement(virtual: .letterF), KeyElement(virtual: .number8)]
                                )
                        )
                        GlassEnhancedAltInputKey(
                                side: .leading,
                                coefficient: 1.66,
                                unit: KeyUnit(
                                        primary: KeyElement("gh", extras: [.init(VirtualInputKey.number9.text, alignment: .topTrailing)]),
                                        members: [KeyElement(virtual: .letterG), KeyElement(virtual: .letterH), KeyElement(virtual: .number9)]
                                )
                        )
                        GlassEnhancedAltInputKey(
                                side: .leading,
                                coefficient: 1.66,
                                unit: KeyUnit(
                                        primary: KeyElement("jk", extras: [.init(VirtualInputKey.number0.text, alignment: .topTrailing)]),
                                        members: [KeyElement(virtual: .letterJ), KeyElement(virtual: .letterK), KeyElement(virtual: .number0)]
                                )
                        )
                        GlassEnhancedAltInputKey(
                                side: .trailing,
                                coefficient: 1.66,
                                virtual: .letterL,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterL, extras: [.init("%", alignment: .topTrailing)]),
                                        members: [KeyElement(virtual: .letterL), KeyElement("%")]
                                )
                        )
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct GlassT15ThirdKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        GlassEnhancedAltInputKey(
                                side: .leading,
                                coefficient: 1.66,
                                virtual: .letterZ,
                                unit: KeyUnit(
                                        primary: KeyElement("zx"),
                                        members: [KeyElement(virtual: .letterZ), KeyElement(virtual: .letterX)]
                                )
                        )
                        GlassEnhancedAltInputKey(
                                side: .leading,
                                coefficient: 1.66,
                                virtual: .letterC,
                                unit: KeyUnit(
                                        primary: KeyElement("cv"),
                                        members: [KeyElement(virtual: .letterC), KeyElement(virtual: .letterV)]
                                )
                        )
                        GlassEnhancedAltInputKey(
                                side: .leading,
                                coefficient: 1.66,
                                unit: KeyUnit(
                                        primary: KeyElement("bn"),
                                        members: [KeyElement(virtual: .letterB), KeyElement(virtual: .letterN)]
                                )
                        )
                        GlassLetterAltInputKey(.letterM, coefficient: 1.66)
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct GlassT15ThirdEnhancedKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        GlassEnhancedAltInputKey(
                                side: .leading,
                                coefficient: 1.66,
                                virtual: .letterZ,
                                unit: KeyUnit(
                                        primary: KeyElement("zx", extras: [.init("～", alignment: .topTrailing)]),
                                        members: [KeyElement(virtual: .letterZ), KeyElement(virtual: .letterX), KeyElement("～"), KeyElement("~", extras: [.init(PresetConstant.halfWidth, alignment: .top)])]
                                )
                        )
                        GlassEnhancedAltInputKey(
                                side: .leading,
                                coefficient: 1.66,
                                virtual: .letterC,
                                unit: KeyUnit(
                                        primary: KeyElement("cv", extras: [.init("、", alignment: .topTrailing)]),
                                        members: [KeyElement(virtual: .letterC), KeyElement(virtual: .letterV), KeyElement("、")]
                                )
                        )
                        GlassEnhancedAltInputKey(
                                side: .leading,
                                coefficient: 1.66,
                                unit: KeyUnit(
                                        primary: KeyElement("bn", extras: [.init("；", alignment: .topTrailing)]),
                                        members: [KeyElement(virtual: .letterB), KeyElement(virtual: .letterN), KeyElement("；")]
                                )
                        )
                        GlassEnhancedAltInputKey(
                                side: .trailing,
                                coefficient: 1.66,
                                virtual: .letterM,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterM, extras: [.init("：", alignment: .topTrailing)]),
                                        members: [KeyElement(virtual: .letterM), KeyElement("：")]
                                )
                        )
                }
        }
}
