import SwiftUI
import CoreIME

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassT18Keyboard: View {

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
                        HStack(spacing: 0) {
                                HiddenKey(key: .letterA)
                                switch Options.inputKeyStyle {
                                case .clear:
                                        GlassT18SecondKeyRow()
                                case .numbers:
                                        GlassT18AltSecondKeyRow()
                                case .symbols:
                                        GlassT18SecondEnhancedKeyRow()
                                }
                                HiddenKey(key: .letterL)
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
private struct GlassT18SecondKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        GlassLetterAltInputKey(.letterA, coefficient: 1.42)
                        GlassT18EnhancedInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("sd"), members: [KeyElement(virtual: .letterS), KeyElement(virtual: .letterD)]))
                        GlassT18EnhancedInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("fg"), members: [KeyElement(virtual: .letterF), KeyElement(virtual: .letterG)]))
                        GlassLetterAltInputKey(.letterH, coefficient: 1.42)
                        GlassT18EnhancedInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("jk"), members: [KeyElement(virtual: .letterK), KeyElement(virtual: .letterJ)]))
                        GlassLetterAltInputKey(.letterL, coefficient: 1.42)
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct GlassT18AltSecondKeyRow: View {
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
                                        primary: KeyElement("sd", extras: [.init(VirtualInputKey.number9.text, alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterS),
                                                KeyElement(virtual: .letterD),
                                                KeyElement(virtual: .number9),
                                        ]
                                )
                        )
                        GlassT18EnhancedInputKey(
                                side: .leading,
                                unit: KeyUnit(
                                        primary: KeyElement("fg", extras: [.init(VirtualInputKey.number0.text, alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterF),
                                                KeyElement(virtual: .letterG),
                                                KeyElement(virtual: .number0),
                                        ]
                                )
                        )
                        GlassLetterAltInputKey(.letterH, coefficient: 1.42)
                        GlassT18EnhancedInputKey(
                                side: .trailing,
                                unit: KeyUnit(primary: KeyElement("jk"), members: [KeyElement(virtual: .letterK), KeyElement(virtual: .letterJ)])
                        )
                        GlassLetterAltInputKey(.letterL, coefficient: 1.42)
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct GlassT18SecondEnhancedKeyRow: View {
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
                                        primary: KeyElement("sd", extras: [.init(VirtualInputKey.number9.text, alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterS),
                                                KeyElement(virtual: .letterD),
                                                KeyElement(virtual: .number9),
                                        ]
                                )
                        )
                        GlassT18EnhancedInputKey(
                                side: .leading,
                                unit: KeyUnit(
                                        primary: KeyElement("fg", extras: [.init(VirtualInputKey.number0.text, alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterF),
                                                KeyElement(virtual: .letterG),
                                                KeyElement(virtual: .number0),
                                        ]
                                )
                        )
                        GlassT18EnhancedInputKey(
                                side: .leading,
                                virtual: .letterH,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .letterH, extras: [.init("@", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement(virtual: .letterH),
                                                KeyElement("@"),
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
