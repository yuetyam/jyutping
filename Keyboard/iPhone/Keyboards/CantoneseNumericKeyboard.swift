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
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("-"),
                                                           members: [
                                                                KeyElement("-"),
                                                                KeyElement("－", header: PresetConstant.fullWidth, footer: "FF0D"),
                                                                KeyElement("—", footer: "2014"),
                                                                KeyElement("–", footer: "2013"),
                                                                KeyElement("•", footer: "2022")
                                                           ])
                                )
                                EnhancedInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("/"),
                                                           members: [
                                                                KeyElement("/"),
                                                                KeyElement("／", header: PresetConstant.fullWidth),
                                                                KeyElement("\\"),
                                                                KeyElement("÷")
                                                           ])
                                )
                                EnhancedInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("："),
                                                           members: [
                                                                KeyElement("："),
                                                                KeyElement(":", header: PresetConstant.halfWidth)
                                                           ])
                                )
                                EnhancedInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("；"),
                                                           members: [
                                                                KeyElement("；"),
                                                                KeyElement(";", header: PresetConstant.halfWidth)
                                                           ])
                                )
                                EnhancedInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("（"),
                                                           members: [
                                                                KeyElement("（"),
                                                                KeyElement("(", header: PresetConstant.halfWidth)
                                                           ])
                                )
                                EnhancedInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("）"),
                                                           members: [
                                                                KeyElement("）"),
                                                                KeyElement(")", header: PresetConstant.halfWidth)
                                                           ])
                                )
                                EnhancedInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("$"),
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
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("@"),
                                                           members: [
                                                                KeyElement("@"),
                                                                KeyElement("＠", header: PresetConstant.fullWidth)
                                                           ])
                                )
                                EnhancedInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("「"),
                                                           members: [
                                                                KeyElement("「"),
                                                                KeyElement("『"),
                                                                KeyElement("\u{201C}"),
                                                                KeyElement("\u{2018}")
                                                           ])
                                )
                                EnhancedInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("」"),
                                                           members: [
                                                                KeyElement("」"),
                                                                KeyElement("』"),
                                                                KeyElement("\u{201D}"),
                                                                KeyElement("\u{2019}")
                                                           ])
                                )
                        }
                        HStack(spacing: 0) {
                                TransformKey(destination: .symbolic, widthUnitTimes: 1.3)
                                Spacer()
                                EnhancedInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("。"),
                                                           members: [
                                                                KeyElement("。"),
                                                                KeyElement("｡", header: PresetConstant.halfWidth),
                                                                KeyElement("\u{2026}", footer: "2026"),
                                                                KeyElement("\u{22EF}", footer: "22EF")
                                                           ])
                                )
                                EnhancedInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("，"),
                                                           members: [
                                                                KeyElement("，"),
                                                                KeyElement(",", header: PresetConstant.halfWidth)
                                                           ])
                                )
                                EnhancedInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("、"),
                                                           members: [
                                                                KeyElement("、"),
                                                                KeyElement("､", header: PresetConstant.halfWidth)
                                                           ])
                                )
                                EnhancedInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("？"),
                                                           members: [
                                                                KeyElement("？"),
                                                                KeyElement("?", header: PresetConstant.halfWidth)
                                                           ])
                                )
                                EnhancedInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("！"),
                                                           members: [
                                                                KeyElement("！"),
                                                                KeyElement("!", header: PresetConstant.halfWidth)
                                                           ])
                                )
                                EnhancedInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("."),
                                                           members: [
                                                                KeyElement("."),
                                                                KeyElement("．", header: PresetConstant.fullWidth, footer: "FF0E"),
                                                                KeyElement("…", footer: "2026")
                                                           ])
                                )
                                EnhancedInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("\u{0022}"),
                                                           members: [
                                                                KeyElement("\u{0022}", footer: "0022"),
                                                                KeyElement("\u{FF02}", header: PresetConstant.fullWidth, footer: "FF02"),
                                                                KeyElement("\u{201D}", header: "右", footer: "201D"),
                                                                KeyElement("\u{201C}", header: "左", footer: "201C")
                                                           ])
                                )
                                Spacer()
                                BackspaceKey()
                        }
                        switch (context.keyboardInterface.isPadFloating, context.needsInputModeSwitchKey) {
                        case (true, true):
                                if #available(iOSApplicationExtension 26.0, *) {
                                        HStack(spacing: 0) {
                                                TransformKey(destination: .alphabetic, widthUnitTimes: 2)
                                                SharedBottomKeys.cantoneseComma
                                                SpaceKey()
                                                SharedBottomKeys.cantonesePeriod
                                                ReturnKey()
                                        }
                                } else {
                                        HStack(spacing: 0) {
                                                GlobeKey()
                                                TransformKey(destination: .alphabetic, widthUnitTimes: 2)
                                                SpaceKey()
                                                SharedBottomKeys.altCantoneseComma
                                                ReturnKey()
                                        }
                                }
                        case (true, false):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .alphabetic, widthUnitTimes: 2)
                                        SharedBottomKeys.cantoneseComma
                                        SpaceKey()
                                        SharedBottomKeys.cantonesePeriod
                                        ReturnKey()
                                }
                        case (false, true):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .alphabetic, widthUnitTimes: 2)
                                        GlobeKey()
                                        SpaceKey()
                                        SharedBottomKeys.altCantoneseComma
                                        ReturnKey()
                                }
                        case (false, false):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .alphabetic, widthUnitTimes: 2)
                                        SharedBottomKeys.cantoneseComma
                                        SpaceKey()
                                        SharedBottomKeys.cantonesePeriod
                                        ReturnKey()
                                }
                        }
                }
        }
}
