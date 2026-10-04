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
                                        side: .leading,
                                        unit: KeyUnit(
                                                primary: KeyElement("."),
                                                members: [
                                                        KeyElement(".", extras: [.init("002E", alignment: .bottom)]),
                                                        KeyElement("．", extras: [.init(PresetConstant.fullWidth, alignment: .top), .init("FF0E", alignment: .bottom)]),
                                                        KeyElement("…"),
                                                ]
                                        )
                                )
                                Group {
                                        LargePadExpansibleInputKey(
                                                side: .leading,
                                                virtual: .number1,
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
                                        LargePadExpansibleInputKey(
                                                side: .leading,
                                                virtual: .number2,
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
                                        LargePadExpansibleInputKey(
                                                side: .leading,
                                                virtual: .number3,
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
                                        LargePadExpansibleInputKey(
                                                side: .leading,
                                                virtual: .number4,
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
                                        LargePadExpansibleInputKey(
                                                side: .leading,
                                                virtual: .number5,
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
                                        LargePadExpansibleInputKey(
                                                side: .leading,
                                                virtual: .number6,
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
                                        LargePadExpansibleInputKey(
                                                side: .trailing,
                                                virtual: .number7,
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
                                        LargePadExpansibleInputKey(
                                                side: .trailing,
                                                virtual: .number8,
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
                                        LargePadExpansibleInputKey(
                                                side: .trailing,
                                                virtual: .number9,
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
                                        LargePadExpansibleInputKey(
                                                side: .trailing,
                                                virtual: .number0,
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
                                LargePadExpansibleInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(
                                                primary: KeyElement("<"),
                                                members: [
                                                        KeyElement("<"),
                                                        KeyElement("＜", extras: [.init(PresetConstant.fullWidth, alignment: .top)])
                                                ]
                                        )
                                )
                                LargePadExpansibleInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(
                                                primary: KeyElement(">"),
                                                members: [
                                                        KeyElement(">"),
                                                        KeyElement("＞", extras: [.init(PresetConstant.fullWidth, alignment: .top)])
                                                ]
                                        )
                                )
                                LargePadBackspaceKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0 ) {
                                LargePadTabKey(widthUnitTimes: 1.5)
                                Group {
                                        LargePadExpansibleInputKey(
                                                side: .leading,
                                                unit: KeyUnit(
                                                        primary: KeyElement("［"),
                                                        members: [
                                                                KeyElement("［"),
                                                                KeyElement("[", extras: [.init(PresetConstant.halfWidth, alignment: .top)]),
                                                                KeyElement("【"),
                                                                KeyElement("〖"),
                                                                KeyElement("〔")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                side: .leading,
                                                unit: KeyUnit(
                                                        primary: KeyElement("］"),
                                                        members: [
                                                                KeyElement("］"),
                                                                KeyElement("]", extras: [.init(PresetConstant.halfWidth, alignment: .top)]),
                                                                KeyElement("】"),
                                                                KeyElement("〗"),
                                                                KeyElement("〕")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                side: .leading,
                                                unit: KeyUnit(
                                                        primary: KeyElement("｛"),
                                                        members: [
                                                                KeyElement("｛"),
                                                                KeyElement("{", extras: [.init(PresetConstant.halfWidth, alignment: .top)])
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                side: .leading,
                                                unit: KeyUnit(
                                                        primary: KeyElement("｝"),
                                                        members: [
                                                                KeyElement("｝"),
                                                                KeyElement("}", extras: [.init(PresetConstant.halfWidth, alignment: .top)])
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                side: .leading,
                                                unit: KeyUnit(
                                                        primary: KeyElement("#"),
                                                        members: [
                                                                KeyElement("#"),
                                                                KeyElement("＃", extras: [.init(PresetConstant.fullWidth, alignment: .top)])
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                side: .trailing,
                                                unit: KeyUnit(
                                                        primary: KeyElement("%"),
                                                        members: [
                                                                KeyElement("%"),
                                                                KeyElement("％", extras: [.init(PresetConstant.fullWidth, alignment: .top)]),
                                                                KeyElement("‰")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                side: .trailing,
                                                unit: KeyUnit(
                                                        primary: KeyElement("^"),
                                                        members: [
                                                                KeyElement("^"),
                                                                KeyElement("＾", extras: [.init(PresetConstant.fullWidth, alignment: .top)]),
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                side: .trailing,
                                                unit: KeyUnit(
                                                        primary: KeyElement("*"),
                                                        members: [
                                                                KeyElement("*"),
                                                                KeyElement("＊", extras: [.init(PresetConstant.fullWidth, alignment: .top)]),
                                                                KeyElement("×"),
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                side: .trailing,
                                                unit: KeyUnit(
                                                        primary: KeyElement("+"),
                                                        members: [
                                                                KeyElement("+"),
                                                                KeyElement("＋", extras: [.init(PresetConstant.fullWidth, alignment: .top)]),
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                side: .trailing,
                                                unit: KeyUnit(
                                                        primary: KeyElement("="),
                                                        members: [
                                                                KeyElement("="),
                                                                KeyElement("＝", extras: [.init(PresetConstant.fullWidth, alignment: .top)]),
                                                                KeyElement("≠"),
                                                                KeyElement("≈")
                                                        ]
                                                )
                                        )
                                }
                                LargePadExpansibleInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(
                                                primary: KeyElement("\\"),
                                                members: [
                                                        KeyElement("\\"),
                                                        KeyElement("＼", extras: [.init(PresetConstant.fullWidth, alignment: .top)])
                                                ]
                                        )
                                )
                                LargePadExpansibleInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(
                                                primary: KeyElement("|"),
                                                members: [
                                                        KeyElement("|"),
                                                        KeyElement("｜", extras: [.init(PresetConstant.fullWidth, alignment: .top)])
                                                ]
                                        )
                                )
                                LargePadExpansibleInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(
                                                primary: KeyElement("_"),
                                                members: [
                                                        KeyElement("_"),
                                                        KeyElement("＿", extras: [.init(PresetConstant.fullWidth, alignment: .top), .init("FF3F", alignment: .bottom)])
                                                ]
                                        )
                                )
                        }
                        HStack(spacing: 0) {
                                LargePadCapsLockKey(widthUnitTimes: 1.75).hidden()
                                Group {
                                        LargePadExpansibleInputKey(
                                                side: .leading,
                                                unit: KeyUnit(
                                                        primary: KeyElement("-"),
                                                        members: [
                                                                KeyElement("-"),
                                                                KeyElement("\u{FF0D}", extras: [.init(PresetConstant.fullWidth, alignment: .top), .init("FF0D", alignment: .bottom)]),
                                                                KeyElement("\u{2013}", extras: [.init("2013", alignment: .bottom)]),
                                                                KeyElement("\u{2014}", extras: [.init("2014", alignment: .bottom)]),
                                                                KeyElement("•", extras: [.init("項目符號", alignment: .top), .init("2022", alignment: .bottom)]),
                                                                KeyElement("\u{2027}", extras: [.init("連字點", alignment: .top), .init("2027", alignment: .bottom)]),
                                                                KeyElement("\u{FF65}", extras: [.init("半寬中點", alignment: .top), .init("FF65", alignment: .bottom)]),
                                                                KeyElement("\u{30FB}", extras: [.init("全寬中點", alignment: .top), .init("30FB", alignment: .bottom)])
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                side: .leading,
                                                unit: KeyUnit(
                                                        primary: KeyElement("/"),
                                                        members: [
                                                                KeyElement("/"),
                                                                KeyElement("／", extras: [.init(PresetConstant.fullWidth, alignment: .top)])
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                side: .leading,
                                                unit: KeyUnit(
                                                        primary: KeyElement("："),
                                                        members: [
                                                                KeyElement("："),
                                                                KeyElement(":", extras: [.init(PresetConstant.halfWidth, alignment: .top)])
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                side: .leading,
                                                unit: KeyUnit(
                                                        primary: KeyElement("；"),
                                                        members: [
                                                                KeyElement("；"),
                                                                KeyElement(";", extras: [.init(PresetConstant.halfWidth, alignment: .top)])
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                side: .leading,
                                                unit: KeyUnit(
                                                        primary: KeyElement("）"),
                                                        members: [
                                                                KeyElement("）"),
                                                                KeyElement("(", extras: [.init(PresetConstant.halfWidth, alignment: .top)])
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                side: .leading,
                                                unit: KeyUnit(
                                                        primary: KeyElement("）"),
                                                        members: [
                                                                KeyElement("）"),
                                                                KeyElement(")", extras: [.init(PresetConstant.halfWidth, alignment: .top)])
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                side: .trailing,
                                                unit: KeyUnit(
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
                                                side: .trailing,
                                                unit: KeyUnit(
                                                        primary: KeyElement("&"),
                                                        members: [
                                                                KeyElement("&"),
                                                                KeyElement("＆", extras: [.init(PresetConstant.fullWidth, alignment: .top)]),
                                                                KeyElement("§")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                side: .trailing,
                                                unit: KeyUnit(
                                                        primary: KeyElement("@"),
                                                        members: [
                                                                KeyElement("@"),
                                                                KeyElement("＠", extras: [.init(PresetConstant.fullWidth, alignment: .top)])
                                                        ]
                                                )
                                        )
                                }
                                LargePadExpansibleInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(
                                                primary: KeyElement("'"),
                                                members: [
                                                        KeyElement("'", extras: [.init("0027", alignment: .bottom)]),
                                                        KeyElement("\u{2019}", extras: [.init("右", alignment: .top), .init("2019", alignment: .bottom)]),
                                                        KeyElement("\u{2018}", extras: [.init("左", alignment: .top), .init("2018", alignment: .bottom)]),
                                                        KeyElement("\u{FF07}", extras: [.init(PresetConstant.fullWidth, alignment: .top), .init("FF07", alignment: .bottom)]),
                                                        KeyElement("\u{0060}", extras: [.init("重音符", alignment: .top), .init("0060", alignment: .bottom)])
                                                ]
                                        )
                                )
                                LargePadExpansibleInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(
                                                primary: KeyElement("¥"),
                                                members: [
                                                        KeyElement("¥"),
                                                        KeyElement("￥", extras: [.init(PresetConstant.fullWidth, alignment: .top)])
                                                ]
                                        )
                                )
                                LargePadReturnKey(widthUnitTimes: 1.75)
                        }
                        HStack(spacing: 0) {
                                LargePadShiftKey(side: .leading, coefficient: 2.25).hidden()
                                Group {
                                        LargePadExpansibleInputKey(
                                                side: .leading,
                                                unit: KeyUnit(
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
                                                side: .leading,
                                                unit: KeyUnit(
                                                        primary: KeyElement("…"),
                                                        members: [
                                                                KeyElement("…", extras: [.init("2026", alignment: .bottom)]),
                                                                KeyElement("⋯", extras: [.init("22EF", alignment: .bottom)])
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                side: .leading,
                                                unit: KeyUnit(
                                                        primary: KeyElement("。"),
                                                        members: [
                                                                KeyElement("。"),
                                                                KeyElement("｡", extras: [.init(PresetConstant.halfWidth, alignment: .top)])
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                side: .leading,
                                                unit: KeyUnit(
                                                        primary: KeyElement("，"),
                                                        members: [
                                                                KeyElement("，"),
                                                                KeyElement(",", extras: [.init(PresetConstant.halfWidth, alignment: .top)])
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                side: .leading,
                                                unit: KeyUnit(
                                                        primary: KeyElement("、"),
                                                        members: [
                                                                KeyElement("、"),
                                                                KeyElement("､", extras: [.init(PresetConstant.halfWidth, alignment: .top)]),
                                                                KeyElement("･", extras: [.init("半寬中點", alignment: .top), .init("FF65", alignment: .bottom)]),
                                                                KeyElement("・", extras: [.init("全寬中點", alignment: .top), .init("30FB", alignment: .bottom)]),
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                side: .trailing,
                                                unit: KeyUnit(
                                                        primary: KeyElement("？"),
                                                        members: [
                                                                KeyElement("？"),
                                                                KeyElement("?", extras: [.init(PresetConstant.halfWidth, alignment: .top)]),
                                                                KeyElement("¿")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                side: .trailing,
                                                unit: KeyUnit(
                                                        primary: KeyElement("！"),
                                                        members: [
                                                                KeyElement("！"),
                                                                KeyElement("!", extras: [.init(PresetConstant.halfWidth, alignment: .top)]),
                                                                KeyElement("¡")
                                                        ]
                                                )
                                        )
                                }
                                LargePadExpansibleInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(
                                                primary: KeyElement("～"),
                                                members: [
                                                        KeyElement("～"),
                                                        KeyElement("~", extras: [.init(PresetConstant.halfWidth, alignment: .top)])
                                                ]
                                        )
                                )
                                LargePadExpansibleInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(
                                                primary: KeyElement("\u{201C}"),
                                                members: [
                                                        KeyElement("\u{201C}", extras: [.init("201C", alignment: .bottom)]),
                                                        KeyElement("\u{0022}", extras: [.init("0022", alignment: .bottom)]),
                                                        KeyElement("\u{FF02}", extras: [.init("FF02", alignment: .bottom)])
                                                ]
                                        )
                                )
                                LargePadExpansibleInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(
                                                primary: KeyElement("\u{201D}"),
                                                members: [
                                                        KeyElement("\u{201D}", extras: [.init("201D", alignment: .bottom)]),
                                                        KeyElement("\u{0022}", extras: [.init("0022", alignment: .bottom)]),
                                                        KeyElement("\u{FF02}", extras: [.init("FF02", alignment: .bottom)])
                                                ]
                                        )
                                )
                                LargePadExpansibleInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(
                                                primary: KeyElement("「"),
                                                           members: [
                                                                KeyElement("「"),
                                                                KeyElement("『")
                                                           ]
                                        )
                                )
                                LargePadExpansibleInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(
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
