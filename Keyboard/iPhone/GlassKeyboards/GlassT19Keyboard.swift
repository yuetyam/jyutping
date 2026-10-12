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
                                // TODO: Implement GlassT18T19FirstEnhancedKeyRow
                                GlassFirstEnhancedLetterKeyRow()
                        }
                        HStack(spacing: 0) {
                                HiddenKey(key: .letterA)
                                switch Options.inputKeyStyle {
                                case .clear:
                                        GlassT19SecondKeyRow()
                                case .numbers:
                                        // TODO: Implement GlassT19AltSecondKeyRow
                                        GlassSecondEnhancedLetterKeyRow()
                                case .symbols:
                                        // TODO: Implement GlassT19SecondEnhancedKeyRow
                                        GlassSecondEnhancedLetterKeyRow()
                                }
                                HiddenKey(key: .letterL)
                        }
                        HStack(spacing: 0) {
                                GlassShiftKey(coefficient: 1.42)
                                HiddenKey(key: .letterZ)
                                switch Options.inputKeyStyle {
                                case .clear, .numbers:
                                        GlassT19ThirdKeyRow()
                                case .symbols:
                                        // TODO: Implement GlassT19ThirdEnhancedKeyRow
                                        GlassThirdEnhancedLetterKeyRow()
                                }
                                HiddenKey(key: .backspace)
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
private struct GlassT19ThirdKeyRow: View {
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
