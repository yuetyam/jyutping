import SwiftUI

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassCantoneseSymbolicKeyboard: View {
        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        if Options.needsNumberRow {
                                CantoneseGlassNumberRow()
                        }
                        GlassCantoneseFirstSymbolRow()
                        GlassCantoneseSecondSymbolRow()
                        GlassCantoneseThirdSymbolRow()
                        GlassCantoneseSymbolBottomKeyRow()
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct GlassCantoneseFirstSymbolRow: View {
        var body: some View {
                HStack(spacing: 0) {
                        GlassEnhancedInputKey(
                                side: .leading,
                                unit: KeyUnit(primary: KeyElement("［"),
                                                   members: [
                                                        KeyElement("［"),
                                                        KeyElement("[", extras: [.init(PresetConstant.halfWidth, alignment: .top)]),
                                                        KeyElement("【"),
                                                        KeyElement("〖"),
                                                        KeyElement("〔")
                                                   ])
                        )
                        GlassEnhancedInputKey(
                                side: .leading,
                                unit: KeyUnit(primary: KeyElement("］"),
                                                   members: [
                                                        KeyElement("］"),
                                                        KeyElement("]", extras: [.init(PresetConstant.halfWidth, alignment: .top)]),
                                                        KeyElement("】"),
                                                        KeyElement("〗"),
                                                        KeyElement("〕")
                                                   ])
                        )
                        GlassEnhancedInputKey(
                                side: .leading,
                                unit: KeyUnit(primary: KeyElement("｛"),
                                                   members: [
                                                        KeyElement("｛"),
                                                        KeyElement("{", extras: [.init(PresetConstant.halfWidth, alignment: .top)])
                                                   ])
                        )
                        GlassEnhancedInputKey(
                                side: .leading,
                                unit: KeyUnit(primary: KeyElement("｝"),
                                                   members: [
                                                        KeyElement("｝"),
                                                        KeyElement("}", extras: [.init(PresetConstant.halfWidth, alignment: .top)])
                                                   ])
                        )
                        GlassEnhancedInputKey(
                                side: .leading,
                                unit: KeyUnit(primary: KeyElement("#"),
                                                   members: [
                                                        KeyElement("#"),
                                                        KeyElement("＃", extras: [.init(PresetConstant.fullWidth, alignment: .top)])
                                                   ])
                        )
                        GlassEnhancedInputKey(
                                side: .trailing,
                                unit: KeyUnit(primary: KeyElement("%"),
                                                   members: [
                                                        KeyElement("%"),
                                                        KeyElement("％", extras: [.init(PresetConstant.fullWidth, alignment: .top)]),
                                                        KeyElement("‰")
                                                   ])
                        )
                        GlassEnhancedInputKey(
                                side: .trailing,
                                unit: KeyUnit(primary: KeyElement("^"),
                                                   members: [
                                                        KeyElement("^"),
                                                        KeyElement("＾", extras: [.init(PresetConstant.fullWidth, alignment: .top)]),
                                                   ])
                        )
                        GlassEnhancedInputKey(
                                side: .trailing,
                                unit: KeyUnit(primary: KeyElement("*"),
                                                   members: [
                                                        KeyElement("*"),
                                                        KeyElement("＊", extras: [.init(PresetConstant.fullWidth, alignment: .top)]),
                                                        KeyElement("×", extras: [.init("乘號", alignment: .top)]),
                                                   ])
                        )
                        GlassEnhancedInputKey(
                                side: .trailing,
                                unit: KeyUnit(primary: KeyElement("+"),
                                                   members: [
                                                        KeyElement("+"),
                                                        KeyElement("＋", extras: [.init(PresetConstant.fullWidth, alignment: .top)]),
                                                   ])
                        )
                        GlassEnhancedInputKey(
                                side: .trailing,
                                unit: KeyUnit(primary: KeyElement("="),
                                                   members: [
                                                        KeyElement("="),
                                                        KeyElement("＝", extras: [.init(PresetConstant.fullWidth, alignment: .top)]),
                                                        KeyElement("≠"),
                                                        KeyElement("≈")
                                                   ])
                        )
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct GlassCantoneseSecondSymbolRow: View {
        var body: some View {
                HStack(spacing: 0) {
                        GlassEnhancedInputKey(
                                side: .leading,
                                unit: KeyUnit(primary: KeyElement("_"),
                                                   members: [
                                                        KeyElement("_"),
                                                        KeyElement("＿", extras: [.init(PresetConstant.fullWidth, alignment: .top)]),
                                                   ])
                        )
                        GlassSymbolInputKey("\u{2014}")
                        GlassEnhancedInputKey(
                                side: .leading,
                                unit: KeyUnit(primary: KeyElement("\\"),
                                                   members: [
                                                        KeyElement("\\"),
                                                        KeyElement("＼", extras: [.init(PresetConstant.fullWidth, alignment: .top)]),
                                                   ])
                        )
                        GlassEnhancedInputKey(
                                side: .leading,
                                unit: KeyUnit(primary: KeyElement("｜"),
                                                   members: [
                                                        KeyElement("｜"),
                                                        KeyElement("|", extras: [.init(PresetConstant.halfWidth, alignment: .top)]),
                                                   ])
                        )
                        GlassEnhancedInputKey(
                                side: .leading,
                                unit: KeyUnit(primary: KeyElement("～"),
                                                   members: [
                                                        KeyElement("～"),
                                                        KeyElement("~", extras: [.init(PresetConstant.halfWidth, alignment: .top)]),
                                                   ])
                        )
                        GlassEnhancedInputKey(
                                side: .trailing,
                                unit: KeyUnit(primary: KeyElement("《"),
                                                   members: [
                                                        KeyElement("《"),
                                                        KeyElement("〈"),
                                                        KeyElement("<", extras: [.init(PresetConstant.halfWidth, alignment: .top)]),
                                                        KeyElement("＜", extras: [.init(PresetConstant.fullWidth, alignment: .top)])
                                                   ])
                        )
                        GlassEnhancedInputKey(
                                side: .trailing,
                                unit: KeyUnit(primary: KeyElement("》"),
                                                   members: [
                                                        KeyElement("》"),
                                                        KeyElement("〉"),
                                                        KeyElement(">", extras: [.init(PresetConstant.halfWidth, alignment: .top)]),
                                                        KeyElement("＞", extras: [.init(PresetConstant.fullWidth, alignment: .top)])
                                                   ])
                        )
                        GlassEnhancedInputKey(
                                side: .trailing,
                                unit: KeyUnit(primary: KeyElement("¥"),
                                                   members: [
                                                        KeyElement("¥"),
                                                        KeyElement("￥", extras: [.init(PresetConstant.fullWidth, alignment: .top)])
                                                   ])
                        )
                        GlassEnhancedInputKey(
                                side: .trailing,
                                unit: KeyUnit(primary: KeyElement("&"),
                                                   members: [
                                                        KeyElement("&"),
                                                        KeyElement("＆", extras: [.init(PresetConstant.fullWidth, alignment: .top)]),
                                                        KeyElement("§"),
                                                   ])
                        )
                        GlassEnhancedInputKey(
                                side: .trailing,
                                unit: KeyUnit(primary: KeyElement("\u{00B7}"),
                                                   members: [
                                                        KeyElement("\u{00B7}", extras: [.init("間隔號", alignment: .top), .init("00B7", alignment: .bottom)]),
                                                        KeyElement("\u{2022}", extras: [.init("項目符號", alignment: .top), .init("2022", alignment: .bottom)]),
                                                        KeyElement("\u{00B0}", extras: [.init("度", alignment: .top)]),
                                                        KeyElement("\u{2027}", extras: [.init("連字點", alignment: .top), .init("2027", alignment: .bottom)]),
                                                        KeyElement("\u{FF65}", extras: [.init("半寬中點", alignment: .top), .init("FF65", alignment: .bottom)]),
                                                        KeyElement("\u{30FB}", extras: [.init("全寬中點", alignment: .top), .init("30FB", alignment: .bottom)])
                                                   ])
                        )
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct GlassCantoneseThirdSymbolRow: View {
        var body: some View {
                HStack(spacing: 0) {
                        GlassTransformKey(.numeric, coefficient: 1.3)
                        Spacer()
                        GlassEnhancedInputKey(
                                side: .leading,
                                unit: KeyUnit(primary: KeyElement("\u{2026}"),
                                                   members: [
                                                        KeyElement("\u{2026}", extras: [.init("2026", alignment: .bottom)]),
                                                        KeyElement("\u{22EF}", extras: [.init("22EF", alignment: .bottom)])
                                                   ])
                        )
                        GlassSymbolInputKey("©")
                        GlassSymbolInputKey("®")
                        GlassSymbolInputKey("℗")
                        GlassSymbolInputKey("™")
                        GlassSymbolInputKey("℠")
                        GlassEnhancedInputKey(
                                side: .trailing,
                                unit: KeyUnit(primary: KeyElement("\u{0027}"),
                                                   members: [
                                                        KeyElement("\u{0027}", extras: [.init("0027", alignment: .bottom)]),
                                                        KeyElement("\u{FF07}", extras: [.init(PresetConstant.fullWidth, alignment: .top), .init("FF07", alignment: .bottom)]),
                                                        KeyElement("\u{2019}", extras: [.init("右", alignment: .top), .init("2019", alignment: .bottom)]),
                                                        KeyElement("\u{2018}", extras: [.init("左", alignment: .top), .init("2018", alignment: .bottom)]),
                                                        KeyElement("\u{0060}", extras: [.init("重音符", alignment: .top), .init("0060", alignment: .bottom)])
                                                   ])
                        )
                        Spacer()
                        GlassBackspaceKey()
                }
        }
}
