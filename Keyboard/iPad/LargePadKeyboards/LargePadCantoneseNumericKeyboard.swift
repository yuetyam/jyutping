import SwiftUI
import CommonExtensions
import CoreIME

struct LargePadCantoneseNumericKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        HStack(spacing: 0 ) {
                                LargePadExpansibleInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyUnit(
                                                primary: KeyElement("."),
                                                members: [
                                                        KeyElement(".", extras: [.init("002E", alignment: .bottomTrailing)]),
                                                        KeyElement("．", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing), .init("FF0E", alignment: .bottomTrailing)]),
                                                        KeyElement("…"),
                                                ]
                                        )
                                )
                                Group {
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                event: .number1,
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
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                event: .number2,
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
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                event: .number3,
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
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                event: .number4,
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
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                event: .number5,
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
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                event: .number6,
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
                                        LargePadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                event: .number7,
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
                                        LargePadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                event: .number8,
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
                                        LargePadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                event: .number9,
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
                                        LargePadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                event: .number0,
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
                                LargePadExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyUnit(
                                                primary: KeyElement("<"),
                                                members: [
                                                        KeyElement("<"),
                                                        KeyElement("＜", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])
                                                ]
                                        )
                                )
                                LargePadExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyUnit(
                                                primary: KeyElement(">"),
                                                members: [
                                                        KeyElement(">"),
                                                        KeyElement("＞", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])
                                                ]
                                        )
                                )
                                LargePadBackspaceKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0 ) {
                                LargePadTabKey(widthUnitTimes: 1.5)
                                Group {
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("［"),
                                                        members: [
                                                                KeyElement("［"),
                                                                KeyElement("[", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)]),
                                                                KeyElement("【"),
                                                                KeyElement("〖"),
                                                                KeyElement("〔")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("］"),
                                                        members: [
                                                                KeyElement("］"),
                                                                KeyElement("]", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)]),
                                                                KeyElement("】"),
                                                                KeyElement("〗"),
                                                                KeyElement("〕")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("｛"),
                                                        members: [
                                                                KeyElement("｛"),
                                                                KeyElement("{", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("｝"),
                                                        members: [
                                                                KeyElement("｝"),
                                                                KeyElement("}", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("#"),
                                                        members: [
                                                                KeyElement("#"),
                                                                KeyElement("＃", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("%"),
                                                        members: [
                                                                KeyElement("%"),
                                                                KeyElement("％", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                                KeyElement("‰")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("^"),
                                                        members: [
                                                                KeyElement("^"),
                                                                KeyElement("＾", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("*"),
                                                        members: [
                                                                KeyElement("*"),
                                                                KeyElement("＊", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                                KeyElement("×"),
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("+"),
                                                        members: [
                                                                KeyElement("+"),
                                                                KeyElement("＋", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("="),
                                                        members: [
                                                                KeyElement("="),
                                                                KeyElement("＝", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                                KeyElement("≠"),
                                                                KeyElement("≈")
                                                        ]
                                                )
                                        )
                                }
                                LargePadExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyUnit(
                                                primary: KeyElement("\\"),
                                                members: [
                                                        KeyElement("\\"),
                                                        KeyElement("＼", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])
                                                ]
                                        )
                                )
                                LargePadExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyUnit(
                                                primary: KeyElement("|"),
                                                members: [
                                                        KeyElement("|"),
                                                        KeyElement("｜", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])
                                                ]
                                        )
                                )
                                LargePadExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyUnit(
                                                primary: KeyElement("_"),
                                                members: [
                                                        KeyElement("_"),
                                                        KeyElement("＿", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing), .init("FF3F", alignment: .bottomTrailing)])
                                                ]
                                        )
                                )
                        }
                        HStack(spacing: 0) {
                                LargePadCapsLockKey(widthUnitTimes: 1.75).hidden()
                                Group {
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("-"),
                                                        members: [
                                                                KeyElement("-"),
                                                                KeyElement("\u{FF0D}", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing), .init("FF0D", alignment: .bottomTrailing)]),
                                                                KeyElement("\u{2013}", extras: [.init("2013", alignment: .bottomTrailing)]),
                                                                KeyElement("\u{2014}", extras: [.init("2014", alignment: .bottomTrailing)]),
                                                                KeyElement("•", extras: [.init("項目符號", alignment: .topTrailing), .init("2022", alignment: .bottomTrailing)]),
                                                                KeyElement("\u{2027}", extras: [.init("連字點", alignment: .topTrailing), .init("2027", alignment: .bottomTrailing)]),
                                                                KeyElement("\u{FF65}", extras: [.init("半寬中點", alignment: .topTrailing), .init("FF65", alignment: .bottomTrailing)]),
                                                                KeyElement("\u{30FB}", extras: [.init("全寬中點", alignment: .topTrailing), .init("30FB", alignment: .bottomTrailing)])
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("/"),
                                                        members: [
                                                                KeyElement("/"),
                                                                KeyElement("／", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("："),
                                                        members: [
                                                                KeyElement("："),
                                                                KeyElement(":", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("；"),
                                                        members: [
                                                                KeyElement("；"),
                                                                KeyElement(";", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("）"),
                                                        members: [
                                                                KeyElement("）"),
                                                                KeyElement("(", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("）"),
                                                        members: [
                                                                KeyElement("）"),
                                                                KeyElement(")", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                keyModel: KeyUnit(
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
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("&"),
                                                        members: [
                                                                KeyElement("&"),
                                                                KeyElement("＆", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                                KeyElement("§")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("@"),
                                                        members: [
                                                                KeyElement("@"),
                                                                KeyElement("＠", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])
                                                        ]
                                                )
                                        )
                                }
                                LargePadExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyUnit(
                                                primary: KeyElement("'"),
                                                members: [
                                                        KeyElement("'", extras: [.init("0027", alignment: .bottomTrailing)]),
                                                        KeyElement("\u{2019}", extras: [.init("右", alignment: .topTrailing), .init("2019", alignment: .bottomTrailing)]),
                                                        KeyElement("\u{2018}", extras: [.init("左", alignment: .topTrailing), .init("2018", alignment: .bottomTrailing)]),
                                                        KeyElement("\u{FF07}", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing), .init("FF07", alignment: .bottomTrailing)]),
                                                        KeyElement("\u{0060}", extras: [.init("重音符", alignment: .topTrailing), .init("0060", alignment: .bottomTrailing)])
                                                ]
                                        )
                                )
                                LargePadExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyUnit(
                                                primary: KeyElement("¥"),
                                                members: [
                                                        KeyElement("¥"),
                                                        KeyElement("￥", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])
                                                ]
                                        )
                                )
                                LargePadReturnKey(widthUnitTimes: 1.75)
                        }
                        HStack(spacing: 0) {
                                LargePadShiftKey(side: .leading, coefficient: 2.25).hidden()
                                Group {
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("©"),
                                                        members: [
                                                                KeyElement("©"),
                                                                KeyElement("®"),
                                                                KeyElement("™"),
                                                                KeyElement("℠")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("…"),
                                                        members: [
                                                                KeyElement("…", extras: [.init("2026", alignment: .bottomTrailing)]),
                                                                KeyElement("⋯", extras: [.init("22EF", alignment: .bottomTrailing)])
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("。"),
                                                        members: [
                                                                KeyElement("。"),
                                                                KeyElement("｡", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("，"),
                                                        members: [
                                                                KeyElement("，"),
                                                                KeyElement(",", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("、"),
                                                        members: [
                                                                KeyElement("、"),
                                                                KeyElement("､", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)]),
                                                                KeyElement("･", extras: [.init("半寬中點", alignment: .topTrailing), .init("FF65", alignment: .bottomTrailing)]),
                                                                KeyElement("・", extras: [.init("全寬中點", alignment: .topTrailing), .init("30FB", alignment: .bottomTrailing)]),
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("？"),
                                                        members: [
                                                                KeyElement("？"),
                                                                KeyElement("?", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)]),
                                                                KeyElement("¿")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("！"),
                                                        members: [
                                                                KeyElement("！"),
                                                                KeyElement("!", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)]),
                                                                KeyElement("¡")
                                                        ]
                                                )
                                        )
                                }
                                LargePadExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyUnit(
                                                primary: KeyElement("～"),
                                                members: [
                                                        KeyElement("～"),
                                                        KeyElement("~", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])
                                                ]
                                        )
                                )
                                LargePadExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyUnit(
                                                primary: KeyElement("\u{201C}"),
                                                members: [
                                                        KeyElement("\u{201C}", extras: [.init("201C", alignment: .bottomTrailing)]),
                                                        KeyElement("\u{0022}", extras: [.init("0022", alignment: .bottomTrailing)]),
                                                        KeyElement("\u{FF02}", extras: [.init("FF02", alignment: .bottomTrailing)])
                                                ]
                                        )
                                )
                                LargePadExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyUnit(
                                                primary: KeyElement("\u{201D}"),
                                                members: [
                                                        KeyElement("\u{201D}", extras: [.init("201D", alignment: .bottomTrailing)]),
                                                        KeyElement("\u{0022}", extras: [.init("0022", alignment: .bottomTrailing)]),
                                                        KeyElement("\u{FF02}", extras: [.init("FF02", alignment: .bottomTrailing)])
                                                ]
                                        )
                                )
                                LargePadExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyUnit(
                                                primary: KeyElement("「"),
                                                           members: [
                                                                KeyElement("「"),
                                                                KeyElement("『")
                                                           ]
                                        )
                                )
                                LargePadExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyUnit(
                                                primary: KeyElement("」"),
                                                           members: [
                                                                KeyElement("」"),
                                                                KeyElement("』")
                                                           ]
                                        )
                                )
                                Spacer()
                        }
                        HStack(spacing: 0) {
                                if context.needsInputModeSwitchKey {
                                        LargePadGlobeKey(widthUnitTimes: 2.125)
                                } else {
                                        LargePadTransformKey(destination: .primary, side: .leading, coefficient: 2.125)
                                }
                                LargePadTransformKey(destination: .primary, side: .leading, coefficient: 2.125)
                                LargePadSpaceKey()
                                LargePadTransformKey(destination: .primary, side: .trailing, coefficient: 2.125)
                                LargePadDismissKey(widthUnitTimes: 2.125)
                        }
                }
        }
}
