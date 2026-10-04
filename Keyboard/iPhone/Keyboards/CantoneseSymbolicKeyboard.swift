import SwiftUI

struct CantoneseSymbolicKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        if Options.needsNumberRow {
                                CantoneseNumberRow()
                        }
                        HStack(spacing: 0) {
                                EnhancedInputKey(
                                        side: .leading,
                                        unit: KeyUnit(primary: KeyElement("［"),
                                                           members: [
                                                                KeyElement("［"),
                                                                KeyElement("[", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)]),
                                                                KeyElement("【"),
                                                                KeyElement("〖"),
                                                                KeyElement("〔")
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .leading,
                                        unit: KeyUnit(primary: KeyElement("］"),
                                                           members: [
                                                                KeyElement("］"),
                                                                KeyElement("]", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)]),
                                                                KeyElement("】"),
                                                                KeyElement("〗"),
                                                                KeyElement("〕")
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .leading,
                                        unit: KeyUnit(primary: KeyElement("｛"),
                                                           members: [
                                                                KeyElement("｛"),
                                                                KeyElement("{", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .leading,
                                        unit: KeyUnit(primary: KeyElement("｝"),
                                                           members: [
                                                                KeyElement("｝"),
                                                                KeyElement("}", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .leading,
                                        unit: KeyUnit(primary: KeyElement("#"),
                                                           members: [
                                                                KeyElement("#"),
                                                                KeyElement("＃", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(primary: KeyElement("%"),
                                                           members: [
                                                                KeyElement("%"),
                                                                KeyElement("％", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                                KeyElement("‰")
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(primary: KeyElement("^"),
                                                           members: [
                                                                KeyElement("^"),
                                                                KeyElement("＾", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(primary: KeyElement("*"),
                                                           members: [
                                                                KeyElement("*"),
                                                                KeyElement("＊", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                                KeyElement("×"),
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(primary: KeyElement("+"),
                                                           members: [
                                                                KeyElement("+"),
                                                                KeyElement("＋", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(primary: KeyElement("="),
                                                           members: [
                                                                KeyElement("="),
                                                                KeyElement("＝", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                                KeyElement("≠"),
                                                                KeyElement("≈")
                                                           ])
                                )
                        }
                        HStack(spacing: 0) {
                                EnhancedInputKey(
                                        side: .leading,
                                        unit: KeyUnit(primary: KeyElement("_"),
                                                           members: [
                                                                KeyElement("_"),
                                                                KeyElement("＿", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                           ])
                                )
                                SymbolInputKey("\u{2014}")
                                EnhancedInputKey(
                                        side: .leading,
                                        unit: KeyUnit(primary: KeyElement("\\"),
                                                           members: [
                                                                KeyElement("\\"),
                                                                KeyElement("＼", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .leading,
                                        unit: KeyUnit(primary: KeyElement("｜"),
                                                           members: [
                                                                KeyElement("｜"),
                                                                KeyElement("|", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)]),
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .leading,
                                        unit: KeyUnit(primary: KeyElement("～"),
                                                           members: [
                                                                KeyElement("～"),
                                                                KeyElement("~", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)]),
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(primary: KeyElement("《"),
                                                           members: [
                                                                KeyElement("《"),
                                                                KeyElement("〈"),
                                                                KeyElement("<", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)]),
                                                                KeyElement("＜", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(primary: KeyElement("》"),
                                                           members: [
                                                                KeyElement("》"),
                                                                KeyElement("〉"),
                                                                KeyElement(">", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)]),
                                                                KeyElement("＞", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(primary: KeyElement("¥"),
                                                           members: [
                                                                KeyElement("¥"),
                                                                KeyElement("￥", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(primary: KeyElement("&"),
                                                           members: [
                                                                KeyElement("&"),
                                                                KeyElement("＆", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                                KeyElement("§"),
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(primary: KeyElement("\u{00B7}"),
                                                           members: [
                                                                KeyElement("\u{00B7}", extras: [.init("間隔號", alignment: .topTrailing), .init("00B7", alignment: .bottomTrailing)]),
                                                                KeyElement("\u{2022}", extras: [.init("項目符號", alignment: .topTrailing), .init("2022", alignment: .bottomTrailing)]),
                                                                KeyElement("\u{00B0}", extras: [.init("度", alignment: .topTrailing)]),
                                                                KeyElement("\u{2027}", extras: [.init("連字點", alignment: .topTrailing), .init("2027", alignment: .bottomTrailing)]),
                                                                KeyElement("\u{FF65}", extras: [.init("半寬中點", alignment: .topTrailing), .init("FF65", alignment: .bottomTrailing)]),
                                                                KeyElement("\u{30FB}", extras: [.init("全寬中點", alignment: .topTrailing), .init("30FB", alignment: .bottomTrailing)])
                                                           ])
                                )
                        }
                        HStack(spacing: 0) {
                                TransformKey(destination: .numeric, coefficient: 1.3)
                                Spacer()
                                EnhancedInputKey(
                                        side: .leading,
                                        unit: KeyUnit(primary: KeyElement("\u{2026}"),
                                                           members: [
                                                                KeyElement("\u{2026}", extras: [.init("2026", alignment: .bottomTrailing)]),
                                                                KeyElement("\u{22EF}", extras: [.init("22EF", alignment: .bottomTrailing)])
                                                           ])
                                )
                                SymbolInputKey("©")
                                SymbolInputKey("®")
                                SymbolInputKey("℗")
                                SymbolInputKey("™")
                                SymbolInputKey("℠")
                                EnhancedInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(primary: KeyElement("\u{0027}"),
                                                           members: [
                                                                KeyElement("\u{0027}", extras: [.init("0027", alignment: .bottomTrailing)]),
                                                                KeyElement("\u{FF07}", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing), .init("FF07", alignment: .bottomTrailing)]),
                                                                KeyElement("\u{2019}", extras: [.init("右", alignment: .topTrailing), .init("2019", alignment: .bottomTrailing)]),
                                                                KeyElement("\u{2018}", extras: [.init("左", alignment: .topTrailing), .init("2018", alignment: .bottomTrailing)]),
                                                                KeyElement("\u{0060}", extras: [.init("重音符", alignment: .topTrailing), .init("0060", alignment: .bottomTrailing)])
                                                           ])
                                )
                                Spacer()
                                BackspaceKey()
                        }
                        switch (context.keyboardInterface.isPadFloating, context.needsInputModeSwitchKey) {
                        case (true, true):
                                HStack(spacing: 0) {
                                        GlobeKey()
                                        TransformKey(destination: .primary, coefficient: 2)
                                        SpaceKey()
                                        SharedBottomKeys.altCantoneseComma
                                        ReturnKey()
                                }
                        case (true, false):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .primary, coefficient: 2)
                                        SharedBottomKeys.cantoneseComma
                                        SpaceKey()
                                        SharedBottomKeys.cantonesePeriod
                                        ReturnKey()
                                }
                        case (false, true):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .primary, coefficient: 2)
                                        GlobeKey()
                                        SpaceKey()
                                        SharedBottomKeys.altCantoneseComma
                                        ReturnKey()
                                }
                        case (false, false):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .primary, coefficient: 2)
                                        SharedBottomKeys.cantoneseComma
                                        SpaceKey()
                                        SharedBottomKeys.cantonesePeriod
                                        ReturnKey()
                                }
                        }
                }
        }
}
