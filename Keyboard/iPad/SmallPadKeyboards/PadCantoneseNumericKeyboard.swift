import SwiftUI

struct PadCantoneseNumericKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        HStack(spacing: 0 ) {
                                Group {
                                        PadAdvancedInputKey(
                                                side: .leading,
                                                upper: "^",
                                                unit: KeyUnit(
                                                        primary: KeyElement("1"),
                                                        members: [
                                                                KeyElement("1"),
                                                                KeyElement("１", extras: [.init(PresetConstant.fullWidth, alignment: .top)]),
                                                                KeyElement("壹"),
                                                                KeyElement("¹", extras: [.init("上標", alignment: .top)]),
                                                                KeyElement("₁", extras: [.init("下標", alignment: .top)]),
                                                                KeyElement("①")
                                                        ]
                                                )
                                        )
                                        PadAdvancedInputKey(
                                                side: .leading,
                                                upper: "_",
                                                unit: KeyUnit(
                                                        primary: KeyElement("2"),
                                                        members: [
                                                                KeyElement("2"),
                                                                KeyElement("２", extras: [.init(PresetConstant.fullWidth, alignment: .top)]),
                                                                KeyElement("貳"),
                                                                KeyElement("²", extras: [.init("上標", alignment: .top)]),
                                                                KeyElement("₂", extras: [.init("下標", alignment: .top)]),
                                                                KeyElement("②")
                                                        ]
                                                )
                                        )
                                        PadAdvancedInputKey(
                                                side: .leading,
                                                upper: "｜",
                                                unit: KeyUnit(
                                                        primary: KeyElement("3"),
                                                        members: [
                                                                KeyElement("3"),
                                                                KeyElement("３", extras: [.init(PresetConstant.fullWidth, alignment: .top)]),
                                                                KeyElement("叁"),
                                                                KeyElement("³", extras: [.init("上標", alignment: .top)]),
                                                                KeyElement("₃", extras: [.init("下標", alignment: .top)]),
                                                                KeyElement("③")
                                                        ]
                                                )
                                        )
                                        PadAdvancedInputKey(
                                                side: .leading,
                                                upper: "\\",
                                                unit: KeyUnit(
                                                        primary: KeyElement("4"),
                                                        members: [
                                                                KeyElement("4"),
                                                                KeyElement("４", extras: [.init(PresetConstant.fullWidth, alignment: .top)]),
                                                                KeyElement("肆"),
                                                                KeyElement("⁴", extras: [.init("上標", alignment: .top)]),
                                                                KeyElement("₄", extras: [.init("下標", alignment: .top)]),
                                                                KeyElement("④")
                                                        ]
                                                )
                                        )
                                        PadAdvancedInputKey(
                                                side: .leading,
                                                upper: "<",
                                                unit: KeyUnit(
                                                        primary: KeyElement("5"),
                                                        members: [
                                                                KeyElement("5"),
                                                                KeyElement("５", extras: [.init(PresetConstant.fullWidth, alignment: .top)]),
                                                                KeyElement("伍"),
                                                                KeyElement("⁵", extras: [.init("上標", alignment: .top)]),
                                                                KeyElement("₅", extras: [.init("下標", alignment: .top)]),
                                                                KeyElement("⑤")
                                                        ]
                                                )
                                        )
                                        PadAdvancedInputKey(
                                                side: .leading,
                                                upper: ">",
                                                unit: KeyUnit(
                                                        primary: KeyElement("6"),
                                                        members: [
                                                                KeyElement("6"),
                                                                KeyElement("６", extras: [.init(PresetConstant.fullWidth, alignment: .top)]),
                                                                KeyElement("陸"),
                                                                KeyElement("⁶", extras: [.init("上標", alignment: .top)]),
                                                                KeyElement("₆", extras: [.init("下標", alignment: .top)]),
                                                                KeyElement("⑥")
                                                        ]
                                                )
                                        )
                                        PadAdvancedInputKey(
                                                side: .trailing,
                                                upper: "{",
                                                unit: KeyUnit(
                                                        primary: KeyElement("7"),
                                                        members: [
                                                                KeyElement("7"),
                                                                KeyElement("７", extras: [.init(PresetConstant.fullWidth, alignment: .top)]),
                                                                KeyElement("柒"),
                                                                KeyElement("⁷", extras: [.init("上標", alignment: .top)]),
                                                                KeyElement("₇", extras: [.init("下標", alignment: .top)]),
                                                                KeyElement("⑦")
                                                        ]
                                                )
                                        )
                                        PadAdvancedInputKey(
                                                side: .trailing,
                                                upper: "}",
                                                unit: KeyUnit(
                                                        primary: KeyElement("8"),
                                                        members: [
                                                                KeyElement("8"),
                                                                KeyElement("８", extras: [.init(PresetConstant.fullWidth, alignment: .top)]),
                                                                KeyElement("捌"),
                                                                KeyElement("⁸", extras: [.init("上標", alignment: .top)]),
                                                                KeyElement("₈", extras: [.init("下標", alignment: .top)]),
                                                                KeyElement("⑧")
                                                        ]
                                                )
                                        )
                                        PadAdvancedInputKey(
                                                side: .trailing,
                                                upper: ",",
                                                unit: KeyUnit(
                                                        primary: KeyElement("9"),
                                                        members: [
                                                                KeyElement("9"),
                                                                KeyElement("９", extras: [.init(PresetConstant.fullWidth, alignment: .top)]),
                                                                KeyElement("玖"),
                                                                KeyElement("⁹", extras: [.init("上標", alignment: .top)]),
                                                                KeyElement("₉", extras: [.init("下標", alignment: .top)]),
                                                                KeyElement("⑨")
                                                        ]
                                                )
                                        )
                                        PadAdvancedInputKey(
                                                side: .trailing,
                                                upper: ".",
                                                unit: KeyUnit(
                                                        primary: KeyElement("0"),
                                                        members: [
                                                                KeyElement("0"),
                                                                KeyElement("０", extras: [.init(PresetConstant.fullWidth, alignment: .top)]),
                                                                KeyElement("零"),
                                                                KeyElement("⁰", extras: [.init("上標", alignment: .top)]),
                                                                KeyElement("₀", extras: [.init("下標", alignment: .top)]),
                                                                KeyElement("⓪"),
                                                                KeyElement("拾"),
                                                                KeyElement("°", extras: [.init("度", alignment: .top)])
                                                        ]
                                                )
                                        )
                                }
                                PadBackspaceKey(widthUnitTimes: 1)
                        }
                        HStack(spacing: 0) {
                                Spacer()
                                Group {
                                        PadAdvancedInputKey(side: .leading, upper: "&", unit: KeyUnit(primary: KeyElement("@"), members: [KeyElement("@"), KeyElement("&"), KeyElement("＠", extras: [.init(PresetConstant.fullWidth, alignment: .top)])]))
                                        PadAdvancedInputKey(side: .leading, upper: "¥", unit: KeyUnit(primary: KeyElement("#"), members: [KeyElement("#"), KeyElement("¥"), KeyElement("＃", extras: [.init(PresetConstant.fullWidth, alignment: .top)])]))
                                        PadAdvancedInputKey(side: .leading, upper: "€", unit: KeyUnit(primary: KeyElement("$"), members: [KeyElement("$"), KeyElement("€"), KeyElement("£"), KeyElement("¥"), KeyElement("₩"), KeyElement("₽"), KeyElement("¢")]))
                                        PadAdvancedInputKey(side: .leading, upper: "*", unit: KeyUnit(primary: KeyElement("/"), members: [KeyElement("/"), KeyElement("*"), KeyElement("／", extras: [.init(PresetConstant.fullWidth, alignment: .top)])]))
                                        PadAdvancedInputKey(side: .leading, upper: "【", unit: KeyUnit(primary: KeyElement("（"), members: [KeyElement("（"), KeyElement("【"), KeyElement("(", extras: [.init(PresetConstant.halfWidth, alignment: .top)])]))
                                        PadAdvancedInputKey(side: .trailing, upper: "】", unit: KeyUnit(primary: KeyElement("）"), members: [KeyElement("）"), KeyElement("】"), KeyElement(")", extras: [.init(PresetConstant.halfWidth, alignment: .top)])]))
                                        PadAdvancedInputKey(side: .trailing, upper: "『", unit: KeyUnit(primary: KeyElement("「"), members: [KeyElement("「"), KeyElement("『"), KeyElement("\u{201C}"), KeyElement("\u{2018}")]))
                                        PadAdvancedInputKey(side: .trailing, upper: "』", unit: KeyUnit(primary: KeyElement("」"), members: [KeyElement("」"), KeyElement("』"), KeyElement("\u{201D}"), KeyElement("\u{2019}")]))
                                        PadAdvancedInputKey(
                                                side: .trailing,
                                                upper: "\"",
                                                unit: KeyUnit(
                                                        primary: KeyElement("'"),
                                                        members: [
                                                                KeyElement("'"),
                                                                KeyElement("\""),
                                                                KeyElement("\u{2019}", extras: [.init("右", alignment: .top), .init("2019", alignment: .bottom)]),
                                                                KeyElement("\u{2018}", extras: [.init("左", alignment: .top), .init("2018", alignment: .bottom)]),
                                                                KeyElement("\u{FF07}", extras: [.init(PresetConstant.fullWidth, alignment: .top), .init("FF07", alignment: .bottom)]),
                                                                KeyElement("\u{0060}", extras: [.init("重音符", alignment: .top), .init("0060", alignment: .bottom)])
                                                        ]
                                                )
                                        )
                                }
                                PadReturnKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0) {
                                PadTransformKey(destination: .symbolic, coefficient: 1)
                                Group {
                                        PadAdvancedInputKey(side: .leading, upper: "§", unit: KeyUnit(primary: KeyElement("%"), members: [KeyElement("%"), KeyElement("§"), KeyElement("％", extras: [.init(PresetConstant.fullWidth, alignment: .top)]), KeyElement("‰")]))
                                        PadAdvancedInputKey(side: .leading, upper: "\u{2014}", unit: KeyUnit(primary: KeyElement("-"), members: [KeyElement("-"), KeyElement("\u{2014}", extras: [.init("2014", alignment: .bottom)]), KeyElement("\u{FF0D}", extras: [.init(PresetConstant.fullWidth, alignment: .top), .init("FF0D", alignment: .bottom)]), KeyElement("•", extras: [.init("項目符號", alignment: .top), .init("2022", alignment: .bottom)])]))
                                        PadAdvancedInputKey(side: .leading, upper: "+", unit: KeyUnit(primary: KeyElement("～"), members: [KeyElement("～"), KeyElement("+"), KeyElement("~", extras: [.init(PresetConstant.halfWidth, alignment: .top)])]))
                                        PadAdvancedInputKey(side: .leading, upper: "=", unit: KeyUnit(primary: KeyElement("⋯"), members: [KeyElement("⋯"), KeyElement("=")]))
                                        PadAdvancedInputKey(side: .leading, upper: "·", unit: KeyUnit(primary: KeyElement("、"), members: [KeyElement("、"), KeyElement("·", extras: [.init("間隔號", alignment: .top), .init("00B7", alignment: .bottom)]), KeyElement("､", extras: [.init(PresetConstant.halfWidth, alignment: .top)])]))
                                        PadAdvancedInputKey(side: .trailing, upper: "《", unit: KeyUnit(primary: KeyElement("；"), members: [KeyElement("；"), KeyElement("《"), KeyElement(";", extras: [.init(PresetConstant.halfWidth, alignment: .top)])]))
                                        PadAdvancedInputKey(side: .trailing, upper: "》", unit: KeyUnit(primary: KeyElement("："), members: [KeyElement("："), KeyElement("》"), KeyElement(":", extras: [.init(PresetConstant.halfWidth, alignment: .top)])]))
                                }
                                PadUpperLowerInputKey(side: .trailing, upper: "！", lower: "，", unit: KeyUnit(primary: KeyElement("，"), members: [KeyElement("，"), KeyElement("！"), KeyElement(",", extras: [.init(PresetConstant.halfWidth, alignment: .top)]), KeyElement("!", extras: [.init(PresetConstant.halfWidth, alignment: .top)])]))
                                PadUpperLowerInputKey(
                                        side: .trailing,
                                        upper: "？",
                                        lower: "。",
                                        unit: KeyUnit(
                                                primary: KeyElement("。"),
                                                members: [
                                                        KeyElement("。"),
                                                        KeyElement("？"),
                                                        KeyElement("｡", extras: [.init(PresetConstant.halfWidth, alignment: .top)]),
                                                        KeyElement("?", extras: [.init(PresetConstant.halfWidth, alignment: .top)]),
                                                        KeyElement("."),
                                                        KeyElement("．", extras: [.init(PresetConstant.fullWidth, alignment: .top)]),
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
