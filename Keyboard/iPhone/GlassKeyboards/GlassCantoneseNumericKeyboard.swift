import SwiftUI
import CoreIME
import CommonExtensions

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassCantoneseNumericKeyboard: View {
        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        if Options.needsNumberRow {
                                CantoneseGlassNumberRow()
                        }
                        CantoneseGlassNumberRow()
                        GlassCantoneseNumericSymbolRow()
                        GlassCantoneseNumericPunctuationRow()
                        GlassCantoneseSymbolBottomKeyRow()
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct GlassCantoneseNumericSymbolRow: View {
        var body: some View {
                HStack(spacing: 0) {
                        GlassEnhancedInputKey(
                                side: .leading,
                                unit: KeyUnit(primary: KeyElement("-"),
                                                   members: [
                                                        KeyElement("-"),
                                                        KeyElement("－", extras: [.init(PresetConstant.fullWidth, alignment: .top), .init("FF0D", alignment: .bottom)]),
                                                        KeyElement("—", extras: [.init("2014", alignment: .bottom)]),
                                                        KeyElement("–", extras: [.init("2013", alignment: .bottom)]),
                                                        KeyElement("•", extras: [.init("2022", alignment: .bottom)])
                                                   ])
                        )
                        GlassEnhancedInputKey(
                                side: .leading,
                                unit: KeyUnit(primary: KeyElement("/"),
                                                   members: [
                                                        KeyElement("/"),
                                                        KeyElement("／", extras: [.init(PresetConstant.fullWidth, alignment: .top)]),
                                                        KeyElement("\\"),
                                                        KeyElement("÷")
                                                   ])
                        )
                        GlassEnhancedInputKey(
                                side: .leading,
                                unit: KeyUnit(primary: KeyElement("："),
                                                   members: [
                                                        KeyElement("："),
                                                        KeyElement(":", extras: [.init(PresetConstant.halfWidth, alignment: .top)])
                                                   ])
                        )
                        GlassEnhancedInputKey(
                                side: .leading,
                                unit: KeyUnit(primary: KeyElement("；"),
                                                   members: [
                                                        KeyElement("；"),
                                                        KeyElement(";", extras: [.init(PresetConstant.halfWidth, alignment: .top)])
                                                   ])
                        )
                        GlassEnhancedInputKey(
                                side: .leading,
                                unit: KeyUnit(primary: KeyElement("（"),
                                                   members: [
                                                        KeyElement("（"),
                                                        KeyElement("(", extras: [.init(PresetConstant.halfWidth, alignment: .top)])
                                                   ])
                        )
                        GlassEnhancedInputKey(
                                side: .trailing,
                                unit: KeyUnit(primary: KeyElement("）"),
                                                   members: [
                                                        KeyElement("）"),
                                                        KeyElement(")", extras: [.init(PresetConstant.halfWidth, alignment: .top)])
                                                   ])
                        )
                        GlassEnhancedInputKey(
                                side: .trailing,
                                unit: KeyUnit(primary: KeyElement("$"),
                                                   members: [
                                                        KeyElement("$"),
                                                        KeyElement("€"),
                                                        KeyElement("£"),
                                                        KeyElement("¥"),
                                                        KeyElement("₩"),
                                                        KeyElement("₽"),
                                                        KeyElement("¢")
                                                   ])
                        )
                        GlassEnhancedInputKey(
                                side: .trailing,
                                unit: KeyUnit(primary: KeyElement("@"),
                                                   members: [
                                                        KeyElement("@"),
                                                        KeyElement("＠", extras: [.init(PresetConstant.fullWidth, alignment: .top)])
                                                   ])
                        )
                        GlassEnhancedInputKey(
                                side: .trailing,
                                unit: KeyUnit(primary: KeyElement("「"),
                                                   members: [
                                                        KeyElement("「"),
                                                        KeyElement("『"),
                                                        KeyElement("\u{201C}"),
                                                        KeyElement("\u{2018}")
                                                   ])
                        )
                        GlassEnhancedInputKey(
                                side: .trailing,
                                unit: KeyUnit(primary: KeyElement("」"),
                                                   members: [
                                                        KeyElement("」"),
                                                        KeyElement("』"),
                                                        KeyElement("\u{201D}"),
                                                        KeyElement("\u{2019}")
                                                   ])
                        )
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct GlassCantoneseNumericPunctuationRow: View {
        var body: some View {
                HStack(spacing: 0) {
                        GlassTransformKey(.symbolic, coefficient: 1.35)
                        Spacer().frame(minWidth: 0)
                        GlassEnhancedInputKey(
                                side: .leading,
                                unit: KeyUnit(primary: KeyElement("。"),
                                                   members: [
                                                        KeyElement("。"),
                                                        KeyElement("｡", extras: [.init(PresetConstant.halfWidth, alignment: .top)]),
                                                        KeyElement("\u{2026}", extras: [.init("2026", alignment: .bottom)]),
                                                        KeyElement("\u{22EF}", extras: [.init("22EF", alignment: .bottom)])
                                                   ])
                        )
                        GlassEnhancedInputKey(
                                side: .leading,
                                unit: KeyUnit(primary: KeyElement("，"),
                                                   members: [
                                                        KeyElement("，"),
                                                        KeyElement(",", extras: [.init(PresetConstant.halfWidth, alignment: .top)])
                                                   ])
                        )
                        GlassEnhancedInputKey(
                                side: .leading,
                                unit: KeyUnit(primary: KeyElement("、"),
                                                   members: [
                                                        KeyElement("、"),
                                                        KeyElement("､", extras: [.init(PresetConstant.halfWidth, alignment: .top)])
                                                   ])
                        )
                        GlassEnhancedInputKey(
                                side: .leading,
                                unit: KeyUnit(primary: KeyElement("？"),
                                                   members: [
                                                        KeyElement("？"),
                                                        KeyElement("?", extras: [.init(PresetConstant.halfWidth, alignment: .top)])
                                                   ])
                        )
                        GlassEnhancedInputKey(
                                side: .trailing,
                                unit: KeyUnit(primary: KeyElement("！"),
                                                   members: [
                                                        KeyElement("！"),
                                                        KeyElement("!", extras: [.init(PresetConstant.halfWidth, alignment: .top)])
                                                   ])
                        )
                        GlassEnhancedInputKey(
                                side: .trailing,
                                unit: KeyUnit(primary: KeyElement("."),
                                                   members: [
                                                        KeyElement("."),
                                                        KeyElement("．", extras: [.init(PresetConstant.fullWidth, alignment: .top), .init("FF0E", alignment: .bottom)]),
                                                        KeyElement("…", extras: [.init("2026", alignment: .bottom)])
                                                   ])
                        )
                        GlassEnhancedInputKey(
                                side: .trailing,
                                unit: KeyUnit(primary: KeyElement("\u{0022}"),
                                                   members: [
                                                        KeyElement("\u{0022}", extras: [.init("0022", alignment: .bottom)]),
                                                        KeyElement("\u{FF02}", extras: [.init(PresetConstant.fullWidth, alignment: .top), .init("FF02", alignment: .bottom)]),
                                                        KeyElement("\u{201D}", extras: [.init(PresetConstant.right, alignment: .top), .init("201D", alignment: .bottom)]),
                                                        KeyElement("\u{201C}", extras: [.init(PresetConstant.left, alignment: .top), .init("201C", alignment: .bottom)])
                                                   ])
                        )
                        Spacer().frame(minWidth: 0)
                        GlassBackspaceKey()
                }
        }
}
