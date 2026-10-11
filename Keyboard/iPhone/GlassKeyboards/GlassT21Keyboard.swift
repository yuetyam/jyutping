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
                                // TODO: Implement FirstT21GlassEnhancedKeyRow
                                GlassFirstEnhancedLetterKeyRow()
                        }
                        HStack(spacing: 0) {
                                HiddenKey(key: .letterA)
                                switch Options.inputKeyStyle {
                                case .clear, .numbers:
                                        SecondT21GlassKeyRow()
                                case .symbols:
                                        // TODO: Implement SecondT21GlassEnhancedKeyRow
                                        GlassSecondEnhancedLetterKeyRow()
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
                                        // TODO: Implement ThirdT21GlassEnhancedKeyRow
                                        GlassThirdEnhancedLetterKeyRow()
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
private struct SecondT21GlassKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        GlassLetterInputKey(.letterA, coefficient: 1.25)
                        GlassLetterInputKey(.letterS, coefficient: 1.25)
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
