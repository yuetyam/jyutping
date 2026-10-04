import SwiftUI

struct PadCantoneseNumericKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        HStack(spacing: 0 ) {
                                Group {
                                        PadAdvancedInputKey(
                                                keyLocale: .leading,
                                                upper: "^",
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("1"),
                                                        members: [
                                                                KeyElement("1"),
                                                                KeyElement("１", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                                KeyElement("壹"),
                                                                KeyElement("¹", extras: [.init("上標", alignment: .topTrailing)]),
                                                                KeyElement("₁", extras: [.init("下標", alignment: .topTrailing)]),
                                                                KeyElement("①")
                                                        ]
                                                )
                                        )
                                        PadAdvancedInputKey(
                                                keyLocale: .leading,
                                                upper: "_",
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("2"),
                                                        members: [
                                                                KeyElement("2"),
                                                                KeyElement("２", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                                KeyElement("貳"),
                                                                KeyElement("²", extras: [.init("上標", alignment: .topTrailing)]),
                                                                KeyElement("₂", extras: [.init("下標", alignment: .topTrailing)]),
                                                                KeyElement("②")
                                                        ]
                                                )
                                        )
                                        PadAdvancedInputKey(
                                                keyLocale: .leading,
                                                upper: "｜",
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("3"),
                                                        members: [
                                                                KeyElement("3"),
                                                                KeyElement("３", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                                KeyElement("叁"),
                                                                KeyElement("³", extras: [.init("上標", alignment: .topTrailing)]),
                                                                KeyElement("₃", extras: [.init("下標", alignment: .topTrailing)]),
                                                                KeyElement("③")
                                                        ]
                                                )
                                        )
                                        PadAdvancedInputKey(
                                                keyLocale: .leading,
                                                upper: "\\",
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("4"),
                                                        members: [
                                                                KeyElement("4"),
                                                                KeyElement("４", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                                KeyElement("肆"),
                                                                KeyElement("⁴", extras: [.init("上標", alignment: .topTrailing)]),
                                                                KeyElement("₄", extras: [.init("下標", alignment: .topTrailing)]),
                                                                KeyElement("④")
                                                        ]
                                                )
                                        )
                                        PadAdvancedInputKey(
                                                keyLocale: .leading,
                                                upper: "<",
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("5"),
                                                        members: [
                                                                KeyElement("5"),
                                                                KeyElement("５", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                                KeyElement("伍"),
                                                                KeyElement("⁵", extras: [.init("上標", alignment: .topTrailing)]),
                                                                KeyElement("₅", extras: [.init("下標", alignment: .topTrailing)]),
                                                                KeyElement("⑤")
                                                        ]
                                                )
                                        )
                                        PadAdvancedInputKey(
                                                keyLocale: .leading,
                                                upper: ">",
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("6"),
                                                        members: [
                                                                KeyElement("6"),
                                                                KeyElement("６", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                                KeyElement("陸"),
                                                                KeyElement("⁶", extras: [.init("上標", alignment: .topTrailing)]),
                                                                KeyElement("₆", extras: [.init("下標", alignment: .topTrailing)]),
                                                                KeyElement("⑥")
                                                        ]
                                                )
                                        )
                                        PadAdvancedInputKey(
                                                keyLocale: .trailing,
                                                upper: "{",
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("7"),
                                                        members: [
                                                                KeyElement("7"),
                                                                KeyElement("７", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                                KeyElement("柒"),
                                                                KeyElement("⁷", extras: [.init("上標", alignment: .topTrailing)]),
                                                                KeyElement("₇", extras: [.init("下標", alignment: .topTrailing)]),
                                                                KeyElement("⑦")
                                                        ]
                                                )
                                        )
                                        PadAdvancedInputKey(
                                                keyLocale: .trailing,
                                                upper: "}",
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("8"),
                                                        members: [
                                                                KeyElement("8"),
                                                                KeyElement("８", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                                KeyElement("捌"),
                                                                KeyElement("⁸", extras: [.init("上標", alignment: .topTrailing)]),
                                                                KeyElement("₈", extras: [.init("下標", alignment: .topTrailing)]),
                                                                KeyElement("⑧")
                                                        ]
                                                )
                                        )
                                        PadAdvancedInputKey(
                                                keyLocale: .trailing,
                                                upper: ",",
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("9"),
                                                        members: [
                                                                KeyElement("9"),
                                                                KeyElement("９", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                                KeyElement("玖"),
                                                                KeyElement("⁹", extras: [.init("上標", alignment: .topTrailing)]),
                                                                KeyElement("₉", extras: [.init("下標", alignment: .topTrailing)]),
                                                                KeyElement("⑨")
                                                        ]
                                                )
                                        )
                                        PadAdvancedInputKey(
                                                keyLocale: .trailing,
                                                upper: ".",
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("0"),
                                                        members: [
                                                                KeyElement("0"),
                                                                KeyElement("０", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                                KeyElement("零"),
                                                                KeyElement("⁰", extras: [.init("上標", alignment: .topTrailing)]),
                                                                KeyElement("₀", extras: [.init("下標", alignment: .topTrailing)]),
                                                                KeyElement("⓪"),
                                                                KeyElement("拾"),
                                                                KeyElement("°", extras: [.init("度", alignment: .topTrailing)])
                                                        ]
                                                )
                                        )
                                }
                                PadBackspaceKey(widthUnitTimes: 1)
                        }
                        HStack(spacing: 0) {
                                Spacer()
                                Group {
                                        PadAdvancedInputKey(keyLocale: .leading, upper: "&", keyModel: KeyUnit(primary: KeyElement("@"), members: [KeyElement("@"), KeyElement("&"), KeyElement("＠", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])]))
                                        PadAdvancedInputKey(keyLocale: .leading, upper: "¥", keyModel: KeyUnit(primary: KeyElement("#"), members: [KeyElement("#"), KeyElement("¥"), KeyElement("＃", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])]))
                                        PadAdvancedInputKey(keyLocale: .leading, upper: "€", keyModel: KeyUnit(primary: KeyElement("$"), members: [KeyElement("$"), KeyElement("€"), KeyElement("£"), KeyElement("¥"), KeyElement("₩"), KeyElement("₽"), KeyElement("¢")]))
                                        PadAdvancedInputKey(keyLocale: .leading, upper: "*", keyModel: KeyUnit(primary: KeyElement("/"), members: [KeyElement("/"), KeyElement("*"), KeyElement("／", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])]))
                                        PadAdvancedInputKey(keyLocale: .leading, upper: "【", keyModel: KeyUnit(primary: KeyElement("（"), members: [KeyElement("（"), KeyElement("【"), KeyElement("(", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])]))
                                        PadAdvancedInputKey(keyLocale: .trailing, upper: "】", keyModel: KeyUnit(primary: KeyElement("）"), members: [KeyElement("）"), KeyElement("】"), KeyElement(")", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])]))
                                        PadAdvancedInputKey(keyLocale: .trailing, upper: "『", keyModel: KeyUnit(primary: KeyElement("「"), members: [KeyElement("「"), KeyElement("『"), KeyElement("\u{201C}"), KeyElement("\u{2018}")]))
                                        PadAdvancedInputKey(keyLocale: .trailing, upper: "』", keyModel: KeyUnit(primary: KeyElement("」"), members: [KeyElement("」"), KeyElement("』"), KeyElement("\u{201D}"), KeyElement("\u{2019}")]))
                                        PadAdvancedInputKey(
                                                keyLocale: .trailing,
                                                upper: "\"",
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("'"),
                                                        members: [
                                                                KeyElement("'"),
                                                                KeyElement("\""),
                                                                KeyElement("\u{2019}", extras: [.init("右", alignment: .topTrailing), .init("2019", alignment: .bottomTrailing)]),
                                                                KeyElement("\u{2018}", extras: [.init("左", alignment: .topTrailing), .init("2018", alignment: .bottomTrailing)]),
                                                                KeyElement("\u{FF07}", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing), .init("FF07", alignment: .bottomTrailing)]),
                                                                KeyElement("\u{0060}", extras: [.init("重音符", alignment: .topTrailing), .init("0060", alignment: .bottomTrailing)])
                                                        ]
                                                )
                                        )
                                }
                                PadReturnKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0) {
                                PadTransformKey(destination: .symbolic, coefficient: 1)
                                Group {
                                        PadAdvancedInputKey(keyLocale: .leading, upper: "§", keyModel: KeyUnit(primary: KeyElement("%"), members: [KeyElement("%"), KeyElement("§"), KeyElement("％", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]), KeyElement("‰")]))
                                        PadAdvancedInputKey(keyLocale: .leading, upper: "\u{2014}", keyModel: KeyUnit(primary: KeyElement("-"), members: [KeyElement("-"), KeyElement("\u{2014}", extras: [.init("2014", alignment: .bottomTrailing)]), KeyElement("\u{FF0D}", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing), .init("FF0D", alignment: .bottomTrailing)]), KeyElement("•", extras: [.init("項目符號", alignment: .topTrailing), .init("2022", alignment: .bottomTrailing)])]))
                                        PadAdvancedInputKey(keyLocale: .leading, upper: "+", keyModel: KeyUnit(primary: KeyElement("～"), members: [KeyElement("～"), KeyElement("+"), KeyElement("~", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])]))
                                        PadAdvancedInputKey(keyLocale: .leading, upper: "=", keyModel: KeyUnit(primary: KeyElement("⋯"), members: [KeyElement("⋯"), KeyElement("=")]))
                                        PadAdvancedInputKey(keyLocale: .leading, upper: "·", keyModel: KeyUnit(primary: KeyElement("、"), members: [KeyElement("、"), KeyElement("·", extras: [.init("間隔號", alignment: .topTrailing), .init("00B7", alignment: .bottomTrailing)]), KeyElement("､", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])]))
                                        PadAdvancedInputKey(keyLocale: .trailing, upper: "《", keyModel: KeyUnit(primary: KeyElement("；"), members: [KeyElement("；"), KeyElement("《"), KeyElement(";", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])]))
                                        PadAdvancedInputKey(keyLocale: .trailing, upper: "》", keyModel: KeyUnit(primary: KeyElement("："), members: [KeyElement("："), KeyElement("》"), KeyElement(":", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])]))
                                }
                                PadUpperLowerInputKey(keyLocale: .trailing, upper: "！", lower: "，", keyModel: KeyUnit(primary: KeyElement("，"), members: [KeyElement("，"), KeyElement("！"), KeyElement(",", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)]), KeyElement("!", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])]))
                                PadUpperLowerInputKey(
                                        keyLocale: .trailing,
                                        upper: "？",
                                        lower: "。",
                                        keyModel: KeyUnit(
                                                primary: KeyElement("。"),
                                                members: [
                                                        KeyElement("。"),
                                                        KeyElement("？"),
                                                        KeyElement("｡", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)]),
                                                        KeyElement("?", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)]),
                                                        KeyElement("."),
                                                        KeyElement("．", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                ]
                                        )
                                )
                                PadTransformKey(destination: .symbolic, coefficient: 1)
                        }
                        HStack(spacing: 0) {
                                if context.needsInputModeSwitchKey {
                                        PadGlobeKey(widthUnitTimes: 1.5)
                                } else {
                                        PadTransformKey(destination: .primary, coefficient: 1.5)
                                }
                                PadTransformKey(destination: .primary, coefficient: 1.5)
                                PadSpaceKey()
                                PadTransformKey(destination: .primary, coefficient: 1.5)
                                PadDismissKey(widthUnitTimes: 1.5)
                        }
                }
        }
}
