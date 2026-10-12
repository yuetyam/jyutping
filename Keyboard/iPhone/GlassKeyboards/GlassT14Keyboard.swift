import SwiftUI
import CommonExtensions
import CoreIME

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassT14Keyboard: View {
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
                                GlassT14FirstKeyRow()
                        case .numbers, .symbols:
                                GlassT14FirstKeyRow()
                        }
                        switch Options.inputKeyStyle {
                        case .clear:
                                GlassT14SecondKeyRow()
                        case .numbers, .symbols:
                                GlassT14SecondKeyRow()
                        }
                        HStack(spacing: 0) {
                                GlassShiftKey(coefficient: 1.3)
                                switch Options.inputKeyStyle {
                                case .clear, .numbers:
                                        GlassT14ThirdKeyRow()
                                case .symbols:
                                        GlassT14ThirdKeyRow()
                                }
                                GlassBackspaceKey(coefficient: 1.3)
                        }
                        GlassCantoneseBottomKeyRow()
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct GlassT14FirstKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        GlassEnhancedAltInputKey(
                                side: .leading,
                                coefficient: 2,
                                virtual: .letterW,
                                unit: KeyUnit(
                                        primary: KeyElement("qw"),
                                        members: [KeyElement(virtual: .letterQ), KeyElement(virtual: .letterW)]
                                )
                        )
                        GlassEnhancedAltInputKey(
                                side: .leading,
                                coefficient: 2,
                                virtual: .letterE,
                                unit: KeyUnit(
                                        primary: KeyElement("er"),
                                        members: [KeyElement(virtual: .letterE), KeyElement(virtual: .letterR)]
                                )
                        )
                        GlassEnhancedAltInputKey(
                                side: .leading,
                                coefficient: 2,
                                unit: KeyUnit(
                                        primary: KeyElement("ty"),
                                        members: [KeyElement(virtual: .letterT), KeyElement(virtual: .letterY)]
                                )
                        )
                        GlassEnhancedAltInputKey(
                                side: .leading,
                                coefficient: 2,
                                unit: KeyUnit(
                                        primary: KeyElement("ui"),
                                        members: [KeyElement(virtual: .letterU), KeyElement(virtual: .letterI)]
                                )
                        )
                        GlassEnhancedAltInputKey(
                                side: .trailing,
                                coefficient: 2,
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
private struct GlassT14SecondKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        GlassEnhancedAltInputKey(
                                side: .leading,
                                coefficient: 2,
                                unit: KeyUnit(
                                        primary: KeyElement("as"),
                                        members: [KeyElement(virtual: .letterA), KeyElement(virtual: .letterS)]
                                )
                        )
                        GlassEnhancedAltInputKey(
                                side: .leading,
                                coefficient: 2,
                                unit: KeyUnit(
                                        primary: KeyElement("df"),
                                        members: [KeyElement(virtual: .letterD), KeyElement(virtual: .letterF)]
                                )
                        )
                        GlassEnhancedAltInputKey(
                                side: .leading,
                                coefficient: 2,
                                unit: KeyUnit(
                                        primary: KeyElement("gn"),
                                        members: [KeyElement(virtual: .letterG), KeyElement(virtual: .letterN)]
                                )
                        )
                        GlassEnhancedAltInputKey(
                                side: .leading,
                                coefficient: 2,
                                unit: KeyUnit(
                                        primary: KeyElement("jk"),
                                        members: [KeyElement(virtual: .letterJ), KeyElement(virtual: .letterK)]
                                )
                        )
                        GlassLetterAltInputKey(.letterL, coefficient: 2)
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct GlassT14ThirdKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        GlassEnhancedAltInputKey(
                                side: .leading,
                                coefficient: 1.85,
                                virtual: .letterZ,
                                unit: KeyUnit(
                                        primary: KeyElement("zx"),
                                        members: [KeyElement(virtual: .letterZ), KeyElement(virtual: .letterX)]
                                )
                        )
                        GlassEnhancedAltInputKey(
                                side: .leading,
                                coefficient: 1.85,
                                virtual: .letterC,
                                unit: KeyUnit(
                                        primary: KeyElement("cv"),
                                        members: [KeyElement(virtual: .letterC), KeyElement(virtual: .letterV)]
                                )
                        )
                        GlassEnhancedAltInputKey(
                                side: .leading,
                                coefficient: 1.85,
                                unit: KeyUnit(
                                        primary: KeyElement("bn"),
                                        members: [KeyElement(virtual: .letterB), KeyElement(virtual: .letterN)]
                                )
                        )
                        GlassLetterAltInputKey(.letterM, coefficient: 1.85)
                }
        }
}
