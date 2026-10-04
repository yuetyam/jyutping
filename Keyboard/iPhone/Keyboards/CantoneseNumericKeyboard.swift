import SwiftUI
import CoreIME
import CommonExtensions

struct CantoneseNumericKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        if Options.needsNumberRow {
                                CantoneseNumberRow()
                        }
                        CantoneseNumberRow()
                        HStack(spacing: 0) {
                                EnhancedInputKey(
                                        side: .leading,
                                        unit: KeyUnit(primary: KeyElement("-"),
                                                           members: [
                                                                KeyElement("-"),
                                                                KeyElement("－", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing), .init("FF0D", alignment: .bottomTrailing)]),
                                                                KeyElement("—", extras: [.init("2014", alignment: .bottomTrailing)]),
                                                                KeyElement("–", extras: [.init("2013", alignment: .bottomTrailing)]),
                                                                KeyElement("•", extras: [.init("2022", alignment: .bottomTrailing)])
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .leading,
                                        unit: KeyUnit(primary: KeyElement("/"),
                                                           members: [
                                                                KeyElement("/"),
                                                                KeyElement("／", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                                KeyElement("\\"),
                                                                KeyElement("÷")
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .leading,
                                        unit: KeyUnit(primary: KeyElement("："),
                                                           members: [
                                                                KeyElement("："),
                                                                KeyElement(":", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .leading,
                                        unit: KeyUnit(primary: KeyElement("；"),
                                                           members: [
                                                                KeyElement("；"),
                                                                KeyElement(";", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .leading,
                                        unit: KeyUnit(primary: KeyElement("（"),
                                                           members: [
                                                                KeyElement("（"),
                                                                KeyElement("(", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(primary: KeyElement("）"),
                                                           members: [
                                                                KeyElement("）"),
                                                                KeyElement(")", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])
                                                           ])
                                )
                                EnhancedInputKey(
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
                                EnhancedInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(primary: KeyElement("@"),
                                                           members: [
                                                                KeyElement("@"),
                                                                KeyElement("＠", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(primary: KeyElement("「"),
                                                           members: [
                                                                KeyElement("「"),
                                                                KeyElement("『"),
                                                                KeyElement("\u{201C}"),
                                                                KeyElement("\u{2018}")
                                                           ])
                                )
                                EnhancedInputKey(
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
                        HStack(spacing: 0) {
                                TransformKey(destination: .symbolic, coefficient: 1.3)
                                Spacer()
                                EnhancedInputKey(
                                        side: .leading,
                                        unit: KeyUnit(primary: KeyElement("。"),
                                                           members: [
                                                                KeyElement("。"),
                                                                KeyElement("｡", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)]),
                                                                KeyElement("\u{2026}", extras: [.init("2026", alignment: .bottomTrailing)]),
                                                                KeyElement("\u{22EF}", extras: [.init("22EF", alignment: .bottomTrailing)])
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .leading,
                                        unit: KeyUnit(primary: KeyElement("，"),
                                                           members: [
                                                                KeyElement("，"),
                                                                KeyElement(",", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .leading,
                                        unit: KeyUnit(primary: KeyElement("、"),
                                                           members: [
                                                                KeyElement("、"),
                                                                KeyElement("､", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .leading,
                                        unit: KeyUnit(primary: KeyElement("？"),
                                                           members: [
                                                                KeyElement("？"),
                                                                KeyElement("?", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(primary: KeyElement("！"),
                                                           members: [
                                                                KeyElement("！"),
                                                                KeyElement("!", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(primary: KeyElement("."),
                                                           members: [
                                                                KeyElement("."),
                                                                KeyElement("．", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing), .init("FF0E", alignment: .bottomTrailing)]),
                                                                KeyElement("…", extras: [.init("2026", alignment: .bottomTrailing)])
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(primary: KeyElement("\u{0022}"),
                                                           members: [
                                                                KeyElement("\u{0022}", extras: [.init("0022", alignment: .bottomTrailing)]),
                                                                KeyElement("\u{FF02}", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing), .init("FF02", alignment: .bottomTrailing)]),
                                                                KeyElement("\u{201D}", extras: [.init("右", alignment: .topTrailing), .init("201D", alignment: .bottomTrailing)]),
                                                                KeyElement("\u{201C}", extras: [.init("左", alignment: .topTrailing), .init("201C", alignment: .bottomTrailing)])
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
