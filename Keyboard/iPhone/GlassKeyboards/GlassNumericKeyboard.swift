import SwiftUI
import CoreIME
import CommonExtensions

/// Glass-style numeric keyboard for ABC mode.
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassNumericKeyboard: View {
        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        if Options.needsNumberRow {
                                ABCGlassNumberRow()
                        }
                        ABCGlassNumberRow()
                        GlassABCNumericSecondRow()
                        GlassABCNumericThirdRow()
                        GlassABCSymbolBottomKeyRow()
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct GlassABCNumericSecondRow: View {
        var body: some View {
                HStack(spacing: 0) {
                        GlassEnhancedInputKey(
                                side: .leading,
                                unit: KeyUnit(
                                        primary: KeyElement("-"),
                                        members: [
                                                KeyElement("-"),
                                                KeyElement("–", extras: [.init("2013", alignment: .bottom)]),
                                                KeyElement("—", extras: [.init("2014", alignment: .bottom)]),
                                                KeyElement("•", extras: [.init("2022", alignment: .bottom)])
                                        ]
                                )
                        )
                        GlassEnhancedInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("/"), members: [KeyElement("/"), KeyElement("\\")]))
                        GlassSymbolInputKey(":")
                        GlassSymbolInputKey(";")
                        GlassSymbolInputKey("(")
                        GlassSymbolInputKey(")")
                        GlassEnhancedInputKey(
                                side: .trailing,
                                unit: KeyUnit(
                                        primary: KeyElement("$"),
                                        members: [
                                                KeyElement("$"),
                                                KeyElement("€"),
                                                KeyElement("£"),
                                                KeyElement("¥"),
                                                KeyElement("₩"),
                                                KeyElement("₽"),
                                                KeyElement("¢")
                                        ]
                                )
                        )
                        GlassEnhancedInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("&"), members: [KeyElement("&"), KeyElement("§")]))
                        GlassSymbolInputKey("@")
                        GlassEnhancedInputKey(
                                side: .trailing,
                                unit: KeyUnit(
                                        primary: KeyElement("\u{0022}"),
                                        members: [
                                                KeyElement("\u{0022}", extras: [.init("0022", alignment: .bottom)]),
                                                KeyElement("\u{201D}", extras: [.init("201D", alignment: .bottom)]),
                                                KeyElement("\u{201C}", extras: [.init("201C", alignment: .bottom)]),
                                                KeyElement("\u{201E}", extras: [.init("201E", alignment: .bottom)]),
                                                KeyElement("\u{00BB}", extras: [.init("00BB", alignment: .bottom)]),
                                                KeyElement("\u{00AB}", extras: [.init("00AB", alignment: .bottom)])
                                        ]
                                )
                        )
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct GlassABCNumericThirdRow: View {
        var body: some View {
                HStack(spacing: 0) {
                        GlassTransformKey(.symbolic, coefficient: 1.35)
                        Spacer().frame(minWidth: 0)
                        GlassEnhancedInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("."), members: [KeyElement("."), KeyElement("…")]))
                        GlassSymbolInputKey(",")
                        GlassEnhancedInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("?"), members: [KeyElement("?"), KeyElement("¿")]))
                        GlassEnhancedInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("!"), members: [KeyElement("!"), KeyElement("¡")]))
                        GlassEnhancedInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("%"), members: [KeyElement("%"), KeyElement("‰")]))
                        GlassSymbolInputKey("*")
                        GlassEnhancedInputKey(
                                side: .trailing,
                                unit: KeyUnit(
                                        primary: KeyElement("\u{0027}"),
                                        members: [
                                                KeyElement("\u{0027}", extras: [.init("0027", alignment: .bottom)]),
                                                KeyElement("\u{2019}", extras: [.init("2019", alignment: .bottom)]),
                                                KeyElement("\u{2018}", extras: [.init("2018", alignment: .bottom)]),
                                                KeyElement("\u{0060}", extras: [.init("0060", alignment: .bottom)])
                                        ]
                                )
                        )
                        Spacer().frame(minWidth: 0)
                        GlassBackspaceKey()
                }
        }
}
