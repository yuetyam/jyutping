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
                                                                KeyElement("－", extras: [.init(PresetConstant.fullWidth, alignment: .top), .init("FF0D", alignment: .bottom)]),
                                                                KeyElement("—", extras: [.init("2014", alignment: .bottom)]),
                                                                KeyElement("–", extras: [.init("2013", alignment: .bottom)]),
                                                                KeyElement("•", extras: [.init("2022", alignment: .bottom)])
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .leading,
                                        unit: KeyUnit(primary: KeyElement("/"),
                                                           members: [
                                                                KeyElement("/"),
                                                                KeyElement("／", extras: [.init(PresetConstant.fullWidth, alignment: .top)]),
                                                                KeyElement("\\"),
                                                                KeyElement("÷")
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .leading,
                                        unit: KeyUnit(primary: KeyElement("："),
                                                           members: [
                                                                KeyElement("："),
                                                                KeyElement(":", extras: [.init(PresetConstant.halfWidth, alignment: .top)])
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .leading,
                                        unit: KeyUnit(primary: KeyElement("；"),
                                                           members: [
                                                                KeyElement("；"),
                                                                KeyElement(";", extras: [.init(PresetConstant.halfWidth, alignment: .top)])
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .leading,
                                        unit: KeyUnit(primary: KeyElement("（"),
                                                           members: [
                                                                KeyElement("（"),
                                                                KeyElement("(", extras: [.init(PresetConstant.halfWidth, alignment: .top)])
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(primary: KeyElement("）"),
                                                           members: [
                                                                KeyElement("）"),
                                                                KeyElement(")", extras: [.init(PresetConstant.halfWidth, alignment: .top)])
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
                                                                KeyElement("＠", extras: [.init(PresetConstant.fullWidth, alignment: .top)])
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
                                                                KeyElement("｡", extras: [.init(PresetConstant.halfWidth, alignment: .top)]),
                                                                KeyElement("\u{2026}", extras: [.init("2026", alignment: .bottom)]),
                                                                KeyElement("\u{22EF}", extras: [.init("22EF", alignment: .bottom)])
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .leading,
                                        unit: KeyUnit(primary: KeyElement("，"),
                                                           members: [
                                                                KeyElement("，"),
                                                                KeyElement(",", extras: [.init(PresetConstant.halfWidth, alignment: .top)])
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .leading,
                                        unit: KeyUnit(primary: KeyElement("、"),
                                                           members: [
                                                                KeyElement("、"),
                                                                KeyElement("､", extras: [.init(PresetConstant.halfWidth, alignment: .top)])
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .leading,
                                        unit: KeyUnit(primary: KeyElement("？"),
                                                           members: [
                                                                KeyElement("？"),
                                                                KeyElement("?", extras: [.init(PresetConstant.halfWidth, alignment: .top)])
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(primary: KeyElement("！"),
                                                           members: [
                                                                KeyElement("！"),
                                                                KeyElement("!", extras: [.init(PresetConstant.halfWidth, alignment: .top)])
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(primary: KeyElement("."),
                                                           members: [
                                                                KeyElement("."),
                                                                KeyElement("．", extras: [.init(PresetConstant.fullWidth, alignment: .top), .init("FF0E", alignment: .bottom)]),
                                                                KeyElement("…", extras: [.init("2026", alignment: .bottom)])
                                                           ])
                                )
                                EnhancedInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(primary: KeyElement("\u{0022}"),
                                                           members: [
                                                                KeyElement("\u{0022}", extras: [.init("0022", alignment: .bottom)]),
                                                                KeyElement("\u{FF02}", extras: [.init(PresetConstant.fullWidth, alignment: .top), .init("FF02", alignment: .bottom)]),
                                                                KeyElement("\u{201D}", extras: [.init(PresetConstant.right, alignment: .top), .init("201D", alignment: .bottom)]),
                                                                KeyElement("\u{201C}", extras: [.init(PresetConstant.left, alignment: .top), .init("201C", alignment: .bottom)])
                                                           ])
                                )
                                Spacer()
                                BackspaceKey()
                        }
                        switch (context.keyboardInterface.isPadFloating, context.needsGlobeKey) {
                        case (true, true):
                                HStack(spacing: 0) {
                                        GlobeKey()
                                        TransformKey(destination: .primary, coefficient: 1.5)
                                        SharedBottomKeys.cantoneseComma
                                        SpaceKey()
                                        SharedBottomKeys.cantonesePeriod
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
                                        TransformKey(destination: .primary, coefficient: 1.5)
                                        GlobeKey()
                                        SharedBottomKeys.cantoneseComma
                                        SpaceKey()
                                        SharedBottomKeys.cantonesePeriod
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
