import SwiftUI

struct LargePadCantoneseNumericKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        HStack(spacing: 0 ) {
                                LargePadExpansibleInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(
                                                primary: KeyElement("."),
                                                members: [
                                                        KeyElement(".", footer: "002E"),
                                                        KeyElement("．", header: "全寬", footer: "FF0E"),
                                                        KeyElement("…"),
                                                ]
                                        )
                                )
                                Group {
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("1"),
                                                        members: [
                                                                KeyElement("1"),
                                                                KeyElement("１", header: "全寬"),
                                                                KeyElement("壹"),
                                                                KeyElement("¹", header: "上標"),
                                                                KeyElement("₁", header: "下標"),
                                                                KeyElement("①")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("2"),
                                                        members: [
                                                                KeyElement("2"),
                                                                KeyElement("２", header: "全寬"),
                                                                KeyElement("貳"),
                                                                KeyElement("²", header: "上標"),
                                                                KeyElement("₂", header: "下標"),
                                                                KeyElement("②")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("3"),
                                                        members: [
                                                                KeyElement("3"),
                                                                KeyElement("３", header: "全寬"),
                                                                KeyElement("叁"),
                                                                KeyElement("³", header: "上標"),
                                                                KeyElement("₃", header: "下標"),
                                                                KeyElement("③")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("4"),
                                                        members: [
                                                                KeyElement("4"),
                                                                KeyElement("４", header: "全寬"),
                                                                KeyElement("肆"),
                                                                KeyElement("⁴", header: "上標"),
                                                                KeyElement("₄", header: "下標"),
                                                                KeyElement("④")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("5"),
                                                        members: [
                                                                KeyElement("5"),
                                                                KeyElement("５", header: "全寬"),
                                                                KeyElement("伍"),
                                                                KeyElement("⁵", header: "上標"),
                                                                KeyElement("₅", header: "下標"),
                                                                KeyElement("⑤")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("6"),
                                                        members: [
                                                                KeyElement("6"),
                                                                KeyElement("６", header: "全寬"),
                                                                KeyElement("陸"),
                                                                KeyElement("⁶", header: "上標"),
                                                                KeyElement("₆", header: "下標"),
                                                                KeyElement("⑥")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("7"),
                                                        members: [
                                                                KeyElement("7"),
                                                                KeyElement("７", header: "全寬"),
                                                                KeyElement("柒"),
                                                                KeyElement("⁷", header: "上標"),
                                                                KeyElement("₇", header: "下標"),
                                                                KeyElement("⑦")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("8"),
                                                        members: [
                                                                KeyElement("8"),
                                                                KeyElement("８", header: "全寬"),
                                                                KeyElement("捌"),
                                                                KeyElement("⁸", header: "上標"),
                                                                KeyElement("₈", header: "下標"),
                                                                KeyElement("⑧")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("9"),
                                                        members: [
                                                                KeyElement("9"),
                                                                KeyElement("９", header: "全寬"),
                                                                KeyElement("玖"),
                                                                KeyElement("⁹", header: "上標"),
                                                                KeyElement("₉", header: "下標"),
                                                                KeyElement("⑨")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("0"),
                                                        members: [
                                                                KeyElement("0"),
                                                                KeyElement("０", header: "全寬"),
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
                                LargePadInstantInputKey("<")
                                LargePadInstantInputKey(">")
                                LargePadBackspaceKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0 ) {
                                TabKey(widthUnitTimes: 1.5)
                                Group {
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("［"),
                                                        members: [
                                                                KeyElement("［"),
                                                                KeyElement("[", header: "半寬"),
                                                                KeyElement("【"),
                                                                KeyElement("〖"),
                                                                KeyElement("〔")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("］"),
                                                        members: [
                                                                KeyElement("］"),
                                                                KeyElement("]", header: "半寬"),
                                                                KeyElement("】"),
                                                                KeyElement("〗"),
                                                                KeyElement("〕")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("｛"),
                                                        members: [
                                                                KeyElement("｛"),
                                                                KeyElement("{", header: "半寬")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("｝"),
                                                        members: [
                                                                KeyElement("｝"),
                                                                KeyElement("}", header: "半寬")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("#"),
                                                        members: [
                                                                KeyElement("#"),
                                                                KeyElement("＃", header: "全寬")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("%"),
                                                        members: [
                                                                KeyElement("%"),
                                                                KeyElement("％", header: "全寬"),
                                                                KeyElement("‰")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("^"),
                                                        members: [
                                                                KeyElement("^"),
                                                                KeyElement("＾", header: "全寬"),
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("*"),
                                                        members: [
                                                                KeyElement("*"),
                                                                KeyElement("＊", header: "全寬"),
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("+"),
                                                        members: [
                                                                KeyElement("+"),
                                                                KeyElement("＋", header: "全寬"),
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("="),
                                                        members: [
                                                                KeyElement("="),
                                                                KeyElement("＝", header: "全寬"),
                                                                KeyElement("≠"),
                                                                KeyElement("≈")
                                                        ]
                                                )
                                        )
                                }
                                LargePadExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(
                                                primary: KeyElement("\\"),
                                                members: [
                                                        KeyElement("\\"),
                                                        KeyElement("＼", header: "全寬")
                                                ]
                                        )
                                )
                                LargePadExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(
                                                primary: KeyElement("|"),
                                                members: [
                                                        KeyElement("|"),
                                                        KeyElement("｜", header: "全寬")
                                                ]
                                        )
                                )
                                LargePadExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(
                                                primary: KeyElement("_"),
                                                members: [
                                                        KeyElement("_"),
                                                        KeyElement("＿", header: "全寬", footer: "FF3F")
                                                ]
                                        )
                                )
                        }
                        HStack(spacing: 0) {
                                CapsLockKey(widthUnitTimes: 1.75).hidden()
                                Group {
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("-"),
                                                        members: [
                                                                KeyElement("-"),
                                                                KeyElement("\u{FF0D}", header: "全寬", footer: "FF0D"),
                                                                KeyElement("\u{2013}", footer: "2013"),
                                                                KeyElement("\u{2014}", footer: "2014"),
                                                                KeyElement("•", header: "Bullet", footer: "2022")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("/"),
                                                        members: [
                                                                KeyElement("/"),
                                                                KeyElement("／", header: "全寬")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("："),
                                                        members: [
                                                                KeyElement("："),
                                                                KeyElement(":", header: "半寬")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("；"),
                                                        members: [
                                                                KeyElement("；"),
                                                                KeyElement(";", header: "半寬")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("）"),
                                                        members: [
                                                                KeyElement("）"),
                                                                KeyElement("(", header: "半寬")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("）"),
                                                        members: [
                                                                KeyElement("）"),
                                                                KeyElement(")", header: "半寬")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("$"),
                                                        members: [
                                                                KeyElement("$"),
                                                                KeyElement("€"),
                                                                KeyElement("£"),
                                                                KeyElement("¥"),
                                                                KeyElement("₩"),
                                                                KeyElement("₽"),
                                                                KeyElement("¢")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("&"),
                                                        members: [
                                                                KeyElement("&"),
                                                                KeyElement("＆", header: "全寬"),
                                                                KeyElement("§")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("@"),
                                                        members: [
                                                                KeyElement("@"),
                                                                KeyElement("＠", header: "全寬")
                                                        ]
                                                )
                                        )
                                }
                                LargePadExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(
                                                primary: KeyElement("'"),
                                                members: [
                                                        KeyElement("'", footer: "0027"),
                                                        KeyElement("\u{2019}", footer: "2019"),
                                                        KeyElement("\u{2018}", footer: "2018"),
                                                        KeyElement("\u{FF07}", header: "全寬", footer: "FF07"),
                                                        KeyElement("\u{0060}", header: "Backtick", footer: "0060")
                                                ]
                                        )
                                )
                                LargePadInstantInputKey("¥")
                                LargePadReturnKey(widthUnitTimes: 1.75)
                        }
                        HStack(spacing: 0) {
                                LargePadShiftKey(keyLocale: .leading, widthUnitTimes: 2.25).hidden()
                                Group {
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("©"),
                                                        members: [
                                                                KeyElement("©"),
                                                                KeyElement("®"),
                                                                KeyElement("™"),
                                                                KeyElement("\u{F8FF}")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("…"),
                                                        members: [
                                                                KeyElement("…"),
                                                                KeyElement("⋯", footer: "22EF"),
                                                                KeyElement("……", footer: "2026*2")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("。"),
                                                        members: [
                                                                KeyElement("。"),
                                                                KeyElement("｡", header: "半寬"),
                                                                KeyElement("……", footer: "2026*2")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("，"),
                                                        members: [
                                                                KeyElement("，"),
                                                                KeyElement(",", header: "半寬")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("、"),
                                                        members: [
                                                                KeyElement("、"),
                                                                KeyElement("・", header: "中點", footer: "30FB")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("？"),
                                                        members: [
                                                                KeyElement("？"),
                                                                KeyElement("?", header: "半寬"),
                                                                KeyElement("¿")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("！"),
                                                        members: [
                                                                KeyElement("！"),
                                                                KeyElement("!", header: "半寬"),
                                                                KeyElement("¡")
                                                        ]
                                                )
                                        )
                                }
                                LargePadExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(
                                                primary: KeyElement("～"),
                                                members: [
                                                        KeyElement("～"),
                                                        KeyElement("~", header: "半寬")
                                                ]
                                        )
                                )
                                LargePadExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(
                                                primary: KeyElement("\u{201C}"),
                                                members: [
                                                        KeyElement("\u{201C}", footer: "201C"),
                                                        KeyElement("\u{0022}", footer: "0022"),
                                                        KeyElement("\u{FF02}", footer: "FF02")
                                                ]
                                        )
                                )
                                LargePadExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(
                                                primary: KeyElement("\u{201D}"),
                                                members: [
                                                        KeyElement("\u{201D}", footer: "201D"),
                                                        KeyElement("\u{0022}", footer: "0022"),
                                                        KeyElement("\u{FF02}", footer: "FF02")
                                                ]
                                        )
                                )
                                LargePadExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(
                                                primary: KeyElement("「"),
                                                           members: [
                                                                KeyElement("「"),
                                                                KeyElement("『"),
                                                                KeyElement("﹂", header: "縱書"),
                                                                KeyElement("﹄", header: "縱書")
                                                           ]
                                        )
                                )
                                LargePadExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(
                                                primary: KeyElement("」"),
                                                           members: [
                                                                KeyElement("」"),
                                                                KeyElement("』"),
                                                                KeyElement("﹁", header: "縱書"),
                                                                KeyElement("﹃", header: "縱書")
                                                           ]
                                        )
                                )
                                PlaceholderKey()
                        }
                        HStack(spacing: 0) {
                                if context.needsInputModeSwitchKey {
                                        LargePadGlobeKey(widthUnitTimes: 2.125)
                                } else {
                                        LargePadTransformKey(destination: .alphabetic, keyLocale: .leading, widthUnitTimes: 2.125)
                                }
                                LargePadTransformKey(destination: .alphabetic, keyLocale: .leading, widthUnitTimes: 2.125)
                                PadSpaceKey()
                                LargePadTransformKey(destination: .alphabetic, keyLocale: .trailing, widthUnitTimes: 2.125)
                                LargePadDismissKey(widthUnitTimes: 2.125)
                        }
                }
        }
}
