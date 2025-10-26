import SwiftUI
import CoreIME
import CommonExtensions

struct CantoneseNumericKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        if Options.needsNumberRow {
                                NumberRow()
                        }
                        HStack(spacing: 0) {
                                EnhancedInputKey(
                                        keyLocale: .leading,
                                        event: .number1,
                                        keyModel: KeyModel(
                                                primary: KeyElement("1"),
                                                members: [
                                                        KeyElement("1"),
                                                        KeyElement("１", header: PresetConstant.fullWidth),
                                                        KeyElement("壹"),
                                                        KeyElement("¹", header: "上標"),
                                                        KeyElement("₁", header: "下標"),
                                                        KeyElement("①")
                                                ]
                                        )
                                )
                                EnhancedInputKey(
                                        keyLocale: .leading,
                                        event: .number2,
                                        keyModel: KeyModel(
                                                primary: KeyElement("2"),
                                                members: [
                                                        KeyElement("2"),
                                                        KeyElement("２", header: PresetConstant.fullWidth),
                                                        KeyElement("貳"),
                                                        KeyElement("²", header: "上標"),
                                                        KeyElement("₂", header: "下標"),
                                                        KeyElement("②")
                                                ]
                                        )
                                )
                                EnhancedInputKey(
                                        keyLocale: .leading,
                                        event: .number3,
                                        keyModel: KeyModel(
                                                primary: KeyElement("3"),
                                                members: [
                                                        KeyElement("3"),
                                                        KeyElement("３", header: PresetConstant.fullWidth),
                                                        KeyElement("叁"),
                                                        KeyElement("³", header: "上標"),
                                                        KeyElement("₃", header: "下標"),
                                                        KeyElement("③")
                                                ]
                                        )
                                )
                                EnhancedInputKey(
                                        keyLocale: .leading,
                                        event: .number4,
                                        keyModel: KeyModel(
                                                primary: KeyElement("4"),
                                                members: [
                                                        KeyElement("4"),
                                                        KeyElement("４", header: PresetConstant.fullWidth),
                                                        KeyElement("肆"),
                                                        KeyElement("⁴", header: "上標"),
                                                        KeyElement("₄", header: "下標"),
                                                        KeyElement("④")
                                                ]
                                        )
                                )
                                EnhancedInputKey(
                                        keyLocale: .leading,
                                        event: .number5,
                                        keyModel: KeyModel(
                                                primary: KeyElement("5"),
                                                members: [
                                                        KeyElement("5"),
                                                        KeyElement("５", header: PresetConstant.fullWidth),
                                                        KeyElement("伍"),
                                                        KeyElement("⁵", header: "上標"),
                                                        KeyElement("₅", header: "下標"),
                                                        KeyElement("⑤")
                                                ]
                                        )
                                )
                                EnhancedInputKey(
                                        keyLocale: .trailing,
                                        event: .number6,
                                        keyModel: KeyModel(
                                                primary: KeyElement("6"),
                                                members: [
                                                        KeyElement("6"),
                                                        KeyElement("６", header: PresetConstant.fullWidth),
                                                        KeyElement("陸"),
                                                        KeyElement("⁶", header: "上標"),
                                                        KeyElement("₆", header: "下標"),
                                                        KeyElement("⑥")
                                                ]
                                        )
                                )
                                EnhancedInputKey(
                                        keyLocale: .trailing,
                                        event: .number7,
                                        keyModel: KeyModel(
                                                primary: KeyElement("7"),
                                                members: [
                                                        KeyElement("7"),
                                                        KeyElement("７", header: PresetConstant.fullWidth),
                                                        KeyElement("柒"),
                                                        KeyElement("⁷", header: "上標"),
                                                        KeyElement("₇", header: "下標"),
                                                        KeyElement("⑦")
                                                ]
                                        )
                                )
                                EnhancedInputKey(
                                        keyLocale: .trailing,
                                        event: .number8,
                                        keyModel: KeyModel(
                                                primary: KeyElement("8"),
                                                members: [
                                                        KeyElement("8"),
                                                        KeyElement("８", header: PresetConstant.fullWidth),
                                                        KeyElement("捌"),
                                                        KeyElement("⁸", header: "上標"),
                                                        KeyElement("₈", header: "下標"),
                                                        KeyElement("⑧")
                                                ]
                                        )
                                )
                                EnhancedInputKey(
                                        keyLocale: .trailing,
                                        event: .number9,
                                        keyModel: KeyModel(
                                                primary: KeyElement("9"),
                                                members: [
                                                        KeyElement("9"),
                                                        KeyElement("９", header: PresetConstant.fullWidth),
                                                        KeyElement("玖"),
                                                        KeyElement("⁹", header: "上標"),
                                                        KeyElement("₉", header: "下標"),
                                                        KeyElement("⑨")
                                                ]
                                        )
                                )
                                EnhancedInputKey(
                                        keyLocale: .trailing,
                                        event: .number0,
                                        keyModel: KeyModel(
                                                primary: KeyElement("0"),
                                                members: [
                                                        KeyElement("0"),
                                                        KeyElement("０", header: PresetConstant.fullWidth),
                                                        KeyElement("零"),
                                                        KeyElement("⁰", header: "上標"),
                                                        KeyElement("₀", header: "下標"),
                                                        KeyElement("⓪"),
                                                        KeyElement("拾"),
                                                        KeyElement("°", header: "度")
                                                ]
                                        )
                                )
                        }
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
