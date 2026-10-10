import SwiftUI

/// Glass-style symbolic keyboard for ABC mode.
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassSymbolicKeyboard: View {
        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        if Options.needsNumberRow {
                                ABCGlassNumberRow()
                        }
                        GlassABCSymbolicFirstRow()
                        GlassABCSymbolicSecondRow()
                        GlassABCSymbolicThirdRow()
                        GlassABCSymbolBottomKeyRow()
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct GlassABCSymbolicFirstRow: View {
        var body: some View {
                HStack(spacing: 0) {
                        GlassSymbolInputKey("[")
                        GlassSymbolInputKey("]")
                        GlassSymbolInputKey("{")
                        GlassSymbolInputKey("}")
                        GlassSymbolInputKey("#")
                        GlassEnhancedInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("%"), members: [KeyElement("%"), KeyElement("‰")]))
                        GlassSymbolInputKey("^")
                        GlassSymbolInputKey("*")
                        GlassSymbolInputKey("+")
                        GlassEnhancedInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("="), members: [KeyElement("="), KeyElement("≠"), KeyElement("≈")]))
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct GlassABCSymbolicSecondRow: View {
        var body: some View {
                HStack(spacing: 0) {
                        GlassSymbolInputKey("_")
                        GlassSymbolInputKey("\\")
                        GlassSymbolInputKey("|")
                        GlassSymbolInputKey("~")
                        GlassSymbolInputKey("<")
                        GlassSymbolInputKey(">")
                        GlassSymbolInputKey("€")
                        GlassSymbolInputKey("£")
                        GlassSymbolInputKey("¥")
                        GlassSymbolInputKey("•")
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct GlassABCSymbolicThirdRow: View {
        var body: some View {
                HStack(spacing: 0) {
                        GlassTransformKey(.numeric, coefficient: 1.35)
                        Spacer().frame(minWidth: 0)
                        GlassSymbolInputKey("…")
                        GlassSymbolInputKey("©")
                        GlassSymbolInputKey("®")
                        GlassSymbolInputKey("℗")
                        GlassSymbolInputKey("™")
                        GlassSymbolInputKey("℠")
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
