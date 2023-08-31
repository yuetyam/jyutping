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
                                                                KeyElement("１", header: "全形"),
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
                                                                KeyElement("２", header: "全形"),
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
                                                                KeyElement("３", header: "全形"),
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
                                                                KeyElement("４", header: "全形"),
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
                                                                KeyElement("５", header: "全形"),
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
                                                                KeyElement("６", header: "全形"),
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
                                                                KeyElement("７", header: "全形"),
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
                                                                KeyElement("８", header: "全形"),
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
                                                                KeyElement("９", header: "全形"),
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
                                                                KeyElement("０", header: "全形"),
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
                                        PadCompleteInputKey(keyLocale: .leading, upper: "&", keyModel: KeyModel(primary: KeyElement("@"), members: [KeyElement("@"), KeyElement("&")]))
                                        PadCompleteInputKey(keyLocale: .leading, upper: "¥", keyModel: KeyModel(primary: KeyElement("#"), members: [KeyElement("#"), KeyElement("¥")]))
                                        PadCompleteInputKey(keyLocale: .leading, upper: "€", keyModel: KeyModel(primary: KeyElement("$"), members: [KeyElement("$"), KeyElement("€")]))
                                        PadCompleteInputKey(keyLocale: .leading, upper: "*", keyModel: KeyModel(primary: KeyElement("/"), members: [KeyElement("/"), KeyElement("*")]))
                                        PadCompleteInputKey(keyLocale: .leading, upper: "【", keyModel: KeyModel(primary: KeyElement("（"), members: [KeyElement("（"), KeyElement("【")]))
                                        PadCompleteInputKey(keyLocale: .trailing, upper: "】", keyModel: KeyModel(primary: KeyElement("）"), members: [KeyElement("）"), KeyElement("】")]))
                                        PadCompleteInputKey(keyLocale: .trailing, upper: "『", keyModel: KeyModel(primary: KeyElement("「"), members: [KeyElement("「"), KeyElement("『"), KeyElement("﹂", header: "縱書")]))
                                        PadCompleteInputKey(keyLocale: .trailing, upper: "』", keyModel: KeyModel(primary: KeyElement("」"), members: [KeyElement("」"), KeyElement("』"), KeyElement("﹁", header: "縱書")]))
                                        PadCompleteInputKey(keyLocale: .trailing, upper: "\"", keyModel: KeyModel(primary: KeyElement("'"), members: [KeyElement("'"), KeyElement("\""), KeyElement("\u{2019}", footer: "2019"), KeyElement("\u{2018}", footer: "2018")]))
                                }
                                PadReturnKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0) {
                                PadTransformKey(destination: .symbolic, widthUnitTimes: 1)
                                Group {
                                        PadCompleteInputKey(keyLocale: .leading, upper: "§", keyModel: KeyModel(primary: KeyElement("%"), members: [KeyElement("%"), KeyElement("§")]))
                                        PadCompleteInputKey(keyLocale: .leading, upper: "", keyModel: KeyModel(primary: KeyElement("-"), members: [KeyElement("-"), KeyElement("\u{2014}")]))
                                        PadCompleteInputKey(keyLocale: .leading, upper: "+", keyModel: KeyModel(primary: KeyElement("～"), members: [KeyElement("～"), KeyElement("+")]))
                                        PadCompleteInputKey(keyLocale: .leading, upper: "=", keyModel: KeyModel(primary: KeyElement("⋯"), members: [KeyElement("⋯"), KeyElement("=")]))
                                        PadCompleteInputKey(keyLocale: .leading, upper: "·", keyModel: KeyModel(primary: KeyElement("、"), members: [KeyElement("、"), KeyElement("·")]))
                                        PadCompleteInputKey(keyLocale: .trailing, upper: "《", keyModel: KeyModel(primary: KeyElement("；"), members: [KeyElement("；"), KeyElement("《")]))
                                        PadCompleteInputKey(keyLocale: .trailing, upper: "》", keyModel: KeyModel(primary: KeyElement("："), members: [KeyElement("："), KeyElement("》")]))
                                }
                                PadUpperLowerInputKey(keyLocale: .trailing, upper: "！", lower: "，", keyModel: KeyModel(primary: KeyElement("，"), members: [KeyElement("，"), KeyElement("！"), KeyElement(",", header: "半形"), KeyElement("!", header: "半形")]))
                                PadUpperLowerInputKey(keyLocale: .trailing, upper: "？", lower: "。", keyModel: KeyModel(primary: KeyElement("。"), members: [KeyElement("。"), KeyElement("？"), KeyElement(".", header: "半形"), KeyElement("?", header: "半形")]))
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
