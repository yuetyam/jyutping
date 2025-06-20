import SwiftUI

struct PadCantoneseNumericKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        HStack(spacing: 0 ) {
                                Group {
                                        PadCompleteInputKey(
                                                keyLocale: .leading,
                                                upper: "^",
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
                                        PadCompleteInputKey(
                                                keyLocale: .leading,
                                                upper: "_",
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
                                        PadCompleteInputKey(
                                                keyLocale: .leading,
                                                upper: "｜",
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
                                        PadCompleteInputKey(
                                                keyLocale: .leading,
                                                upper: "\\",
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
                                        PadCompleteInputKey(
                                                keyLocale: .leading,
                                                upper: "<",
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
                                        PadCompleteInputKey(
                                                keyLocale: .leading,
                                                upper: ">",
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
                                        PadCompleteInputKey(
                                                keyLocale: .trailing,
                                                upper: "{",
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
                                        PadCompleteInputKey(
                                                keyLocale: .trailing,
                                                upper: "}",
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
                                        PadCompleteInputKey(
                                                keyLocale: .trailing,
                                                upper: ",",
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
                                        PadCompleteInputKey(
                                                keyLocale: .trailing,
                                                upper: ".",
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
                                PadBackspaceKey(widthUnitTimes: 1)
                        }
                        HStack(spacing: 0) {
                                PlaceholderKey()
                                Group {
                                        PadCompleteInputKey(keyLocale: .leading, upper: "&", keyModel: KeyModel(primary: KeyElement("@"), members: [KeyElement("@"), KeyElement("&"), KeyElement("＠", header: PresetConstant.fullWidth)]))
                                        PadCompleteInputKey(keyLocale: .leading, upper: "¥", keyModel: KeyModel(primary: KeyElement("#"), members: [KeyElement("#"), KeyElement("¥"), KeyElement("＃", header: PresetConstant.fullWidth)]))
                                        PadCompleteInputKey(keyLocale: .leading, upper: "€", keyModel: KeyModel(primary: KeyElement("$"), members: [KeyElement("$"), KeyElement("€"), KeyElement("£"), KeyElement("¥"), KeyElement("₩"), KeyElement("₽"), KeyElement("¢")]))
                                        PadCompleteInputKey(keyLocale: .leading, upper: "*", keyModel: KeyModel(primary: KeyElement("/"), members: [KeyElement("/"), KeyElement("*"), KeyElement("／", header: PresetConstant.fullWidth)]))
                                        PadCompleteInputKey(keyLocale: .leading, upper: "【", keyModel: KeyModel(primary: KeyElement("（"), members: [KeyElement("（"), KeyElement("【"), KeyElement("(", header: PresetConstant.halfWidth)]))
                                        PadCompleteInputKey(keyLocale: .trailing, upper: "】", keyModel: KeyModel(primary: KeyElement("）"), members: [KeyElement("）"), KeyElement("】"), KeyElement(")", header: PresetConstant.halfWidth)]))
                                        PadCompleteInputKey(keyLocale: .trailing, upper: "『", keyModel: KeyModel(primary: KeyElement("「"), members: [KeyElement("「"), KeyElement("『"), KeyElement("\u{201C}"), KeyElement("\u{2018}")]))
                                        PadCompleteInputKey(keyLocale: .trailing, upper: "』", keyModel: KeyModel(primary: KeyElement("」"), members: [KeyElement("」"), KeyElement("』"), KeyElement("\u{201D}"), KeyElement("\u{2019}")]))
                                        PadCompleteInputKey(
                                                keyLocale: .trailing,
                                                upper: "\"",
                                                keyModel: KeyModel(
                                                        primary: KeyElement("'"),
                                                        members: [
                                                                KeyElement("'"),
                                                                KeyElement("\""),
                                                                KeyElement("\u{2019}", header: "右", footer: "2019"),
                                                                KeyElement("\u{2018}", header: "左", footer: "2018"),
                                                                KeyElement("\u{FF07}", header: PresetConstant.fullWidth, footer: "FF07"),
                                                                KeyElement("\u{0060}", header: "重音符", footer: "0060")
                                                        ]
                                                )
                                        )
                                }
                                PadReturnKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0) {
                                PadTransformKey(destination: .symbolic, widthUnitTimes: 1)
                                Group {
                                        PadCompleteInputKey(keyLocale: .leading, upper: "§", keyModel: KeyModel(primary: KeyElement("%"), members: [KeyElement("%"), KeyElement("§"), KeyElement("％", header: PresetConstant.fullWidth), KeyElement("‰")]))
                                        PadCompleteInputKey(keyLocale: .leading, upper: "\u{2014}", keyModel: KeyModel(primary: KeyElement("-"), members: [KeyElement("-"), KeyElement("\u{2014}", footer: "2014"), KeyElement("\u{FF0D}", header: PresetConstant.fullWidth, footer: "FF0D"), KeyElement("•", header: "項目符號", footer: "2022")]))
                                        PadCompleteInputKey(keyLocale: .leading, upper: "+", keyModel: KeyModel(primary: KeyElement("～"), members: [KeyElement("～"), KeyElement("+"), KeyElement("~", header: PresetConstant.halfWidth)]))
                                        PadCompleteInputKey(keyLocale: .leading, upper: "=", keyModel: KeyModel(primary: KeyElement("⋯"), members: [KeyElement("⋯"), KeyElement("=")]))
                                        PadCompleteInputKey(keyLocale: .leading, upper: "·", keyModel: KeyModel(primary: KeyElement("、"), members: [KeyElement("、"), KeyElement("·", header: "間隔號", footer: "00B7"), KeyElement("､", header: PresetConstant.halfWidth)]))
                                        PadCompleteInputKey(keyLocale: .trailing, upper: "《", keyModel: KeyModel(primary: KeyElement("；"), members: [KeyElement("；"), KeyElement("《"), KeyElement(";", header: PresetConstant.halfWidth)]))
                                        PadCompleteInputKey(keyLocale: .trailing, upper: "》", keyModel: KeyModel(primary: KeyElement("："), members: [KeyElement("："), KeyElement("》"), KeyElement(":", header: PresetConstant.halfWidth)]))
                                }
                                PadUpperLowerInputKey(keyLocale: .trailing, upper: "！", lower: "，", keyModel: KeyModel(primary: KeyElement("，"), members: [KeyElement("，"), KeyElement("！"), KeyElement(",", header: PresetConstant.halfWidth), KeyElement("!", header: PresetConstant.halfWidth)]))
                                PadUpperLowerInputKey(
                                        keyLocale: .trailing,
                                        upper: "？",
                                        lower: "。",
                                        keyModel: KeyModel(
                                                primary: KeyElement("。"),
                                                members: [
                                                        KeyElement("。"),
                                                        KeyElement("？"),
                                                        KeyElement("｡", header: PresetConstant.halfWidth),
                                                        KeyElement("?", header: PresetConstant.halfWidth),
                                                        KeyElement("."),
                                                        KeyElement("．", header: PresetConstant.fullWidth),
                                                ]
                                        )
                                )
                                PadTransformKey(destination: .symbolic, widthUnitTimes: 1)
                        }
                        HStack(spacing: 0) {
                                if context.needsInputModeSwitchKey {
                                        PadGlobeKey(widthUnitTimes: 1.5)
                                } else {
                                        PadTransformKey(destination: .alphabetic, widthUnitTimes: 1.5)
                                }
                                PadTransformKey(destination: .alphabetic, widthUnitTimes: 1.5)
                                PadSpaceKey()
                                PadTransformKey(destination: .alphabetic, widthUnitTimes: 1.5)
                                PadDismissKey(widthUnitTimes: 1.5)
                        }
                }
        }
}
