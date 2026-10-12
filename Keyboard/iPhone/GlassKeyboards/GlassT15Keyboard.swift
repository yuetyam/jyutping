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
                                GlassT15FirstKeyRow()
                        }
                        HStack(spacing: 0) {
                                HiddenKey(key: .letterA)
                                switch Options.inputKeyStyle {
                                case .clear:
                                        GlassT15SecondKeyRow()
                                case .numbers:
                                        GlassT15SecondKeyRow()
                                case .symbols:
                                        GlassT15SecondKeyRow()
                                }
                                HiddenKey(key: .letterL)
                        }
                        HStack(spacing: 0) {
                                GlassShiftKey(coefficient: 1.66)
                                switch Options.inputKeyStyle {
                                case .clear, .numbers:
                                        GlassT15ThirdKeyRow()
                                case .symbols:
                                        GlassT15ThirdKeyRow()
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
                        GlassT18EnhancedInputKey(
                                side: .leading,
                                coefficient: 1.66,
                                virtual: .letterW,
                                unit: KeyUnit(
                                        primary: KeyElement("qw"),
                                        members: [KeyElement(virtual: .letterQ), KeyElement(virtual: .letterW)]
                                )
                        )
                        GlassT18EnhancedInputKey(
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
                        GlassT18EnhancedInputKey(
                                side: .leading,
                                coefficient: 1.66,
                                unit: KeyUnit(
                                        primary: KeyElement("ui"),
                                        members: [KeyElement(virtual: .letterU), KeyElement(virtual: .letterI)]
                                )
                        )
                        GlassT18EnhancedInputKey(
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
private struct GlassT15SecondKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        GlassT18EnhancedInputKey(
                                side: .leading,
                                coefficient: 1.66,
                                unit: KeyUnit(
                                        primary: KeyElement("as"),
                                        members: [KeyElement(virtual: .letterA), KeyElement(virtual: .letterS)]
                                )
                        )
                        GlassT18EnhancedInputKey(
                                side: .leading,
                                coefficient: 1.66,
                                unit: KeyUnit(
                                        primary: KeyElement("df"),
                                        members: [KeyElement(virtual: .letterD), KeyElement(virtual: .letterF)]
                                )
                        )
                        GlassT18EnhancedInputKey(
                                side: .leading,
                                coefficient: 1.66,
                                unit: KeyUnit(
                                        primary: KeyElement("gn"),
                                        members: [KeyElement(virtual: .letterG), KeyElement(virtual: .letterN)]
                                )
                        )
                        GlassT18EnhancedInputKey(
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
private struct GlassT15ThirdKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        GlassT18EnhancedInputKey(
                                side: .leading,
                                coefficient: 1.66,
                                virtual: .letterZ,
                                unit: KeyUnit(
                                        primary: KeyElement("zx"),
                                        members: [KeyElement(virtual: .letterZ), KeyElement(virtual: .letterX)]
                                )
                        )
                        GlassT18EnhancedInputKey(
                                side: .leading,
                                coefficient: 1.66,
                                virtual: .letterC,
                                unit: KeyUnit(
                                        primary: KeyElement("cv"),
                                        members: [KeyElement(virtual: .letterC), KeyElement(virtual: .letterV)]
                                )
                        )
                        GlassT18EnhancedInputKey(
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
