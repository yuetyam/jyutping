import SwiftUI
import CoreIME

struct LargePadCantoneseKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        if context.inputStage.isBuffering {
                                CandidateBar()
                        } else {
                                ToolBar()
                        }
                        if context.keyboardCase.isUppercased {
                                HStack(spacing: 0 ) {
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("～"),
                                                        members: [
                                                                KeyElement("～"),
                                                                KeyElement("~", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)]),
                                                                KeyElement("≈")
                                                        ]
                                                )
                                        )
                                        Group {
                                                LargePadExpansibleInputKey(
                                                        keyLocale: .leading,
                                                        keyModel: KeyUnit(
                                                                primary: KeyElement("！"),
                                                                members: [
                                                                        KeyElement("！"),
                                                                        KeyElement("!", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])
                                                                ]
                                                        )
                                                )
                                                LargePadExpansibleInputKey(
                                                        keyLocale: .leading,
                                                        keyModel: KeyUnit(
                                                                primary: KeyElement("@"),
                                                                members: [
                                                                        KeyElement("@"),
                                                                        KeyElement("＠", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])
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
                                                        keyLocale: .leading,
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
                                                        keyLocale: .leading,
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
                                                        keyLocale: .leading,
                                                        keyModel: KeyUnit(
                                                                primary: KeyElement("……"),
                                                                members: [
                                                                        KeyElement("……"),
                                                                        KeyElement("…")
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
                                                                primary: KeyElement("（"),
                                                                members: [
                                                                        KeyElement("（"),
                                                                        KeyElement("(", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])
                                                                ]
                                                        )
                                                )
                                                LargePadExpansibleInputKey(
                                                        keyLocale: .trailing,
                                                        keyModel: KeyUnit(
                                                                primary: KeyElement("）"),
                                                                members: [
                                                                        KeyElement("）"),
                                                                        KeyElement(")", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])
                                                                ]
                                                        )
                                                )
                                        }
                                        LargePadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("——"),
                                                        members: [
                                                                KeyElement("——"),
                                                                KeyElement("⸺", extras: [.init("2E3A", alignment: .bottomTrailing)])
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("+"),
                                                        members: [
                                                                KeyElement("+"),
                                                                KeyElement("＋", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])
                                                        ]
                                                )
                                        )
                                        LargePadBackspaceKey(widthUnitTimes: 1.5)
                                }
                        } else {
                                HStack(spacing: 0 ) {
                                        LargePadUpperLowerInputKey(
                                                keyLocale: .leading,
                                                upper: "～",
                                                lower: "·",
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("·"),
                                                        members: [
                                                                KeyElement("·", extras: [.init("間隔號", alignment: .topTrailing), .init("00B7", alignment: .bottomTrailing)]),
                                                                KeyElement("～"),
                                                                KeyElement("~", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)]),
                                                                KeyElement("`", extras: [.init("重音符", alignment: .topTrailing), .init("0060", alignment: .bottomTrailing)]),
                                                                KeyElement("•", extras: [.init("項目符號", alignment: .topTrailing), .init("2022", alignment: .bottomTrailing)]),
                                                                KeyElement("‧", extras: [.init("連字點", alignment: .topTrailing), .init("2027", alignment: .bottomTrailing)]),
                                                                KeyElement("･", extras: [.init("半寬中點", alignment: .topTrailing), .init("FF65", alignment: .bottomTrailing)]),
                                                                KeyElement("・", extras: [.init("全寬中點", alignment: .topTrailing), .init("30FB", alignment: .bottomTrailing)])
                                                        ]
                                                )
                                        )
                                        Group {
                                                LargePadUpperLowerInputKey(
                                                        keyLocale: .leading,
                                                        upper: "！",
                                                        lower: "1",
                                                        event: .number1,
                                                        keyModel: KeyUnit(
                                                                primary: KeyElement("1"),
                                                                members: [
                                                                        KeyElement("1"),
                                                                        KeyElement("！"),
                                                                        KeyElement("!", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        keyLocale: .leading,
                                                        upper: "@",
                                                        lower: "2",
                                                        event: .number2,
                                                        keyModel: KeyUnit(
                                                                primary: KeyElement("2"),
                                                                members: [
                                                                        KeyElement("2"),
                                                                        KeyElement("@"),
                                                                        KeyElement("＠", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        keyLocale: .leading,
                                                        upper: "#",
                                                        lower: "3",
                                                        event: .number3,
                                                        keyModel: KeyUnit(
                                                                primary: KeyElement("3"),
                                                                members: [
                                                                        KeyElement("3"),
                                                                        KeyElement("#"),
                                                                        KeyElement("＃", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        keyLocale: .leading,
                                                        upper: "$",
                                                        lower: "4",
                                                        event: .number4,
                                                        keyModel: KeyUnit(
                                                                primary: KeyElement("4"),
                                                                members: [
                                                                        KeyElement("4"),
                                                                        KeyElement("$")
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        keyLocale: .leading,
                                                        upper: "%",
                                                        lower: "5",
                                                        event: .number5,
                                                        keyModel: KeyUnit(
                                                                primary: KeyElement("5"),
                                                                members: [
                                                                        KeyElement("5"),
                                                                        KeyElement("%"),
                                                                        KeyElement("％", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                                        KeyElement("‰")
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        keyLocale: .leading,
                                                        upper: "……",
                                                        lower: "6",
                                                        event: .number6,
                                                        keyModel: KeyUnit(
                                                                primary: KeyElement("6"),
                                                                members: [
                                                                        KeyElement("6"),
                                                                        KeyElement("……"),
                                                                        KeyElement("…")
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        keyLocale: .trailing,
                                                        upper: "&",
                                                        lower: "7",
                                                        event: .number7,
                                                        keyModel: KeyUnit(
                                                                primary: KeyElement("7"),
                                                                members: [
                                                                        KeyElement("7"),
                                                                        KeyElement("&"),
                                                                        KeyElement("＆", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                                        KeyElement("§")
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        keyLocale: .trailing,
                                                        upper: "*",
                                                        lower: "8",
                                                        event: .number8,
                                                        keyModel: KeyUnit(
                                                                primary: KeyElement("8"),
                                                                members: [
                                                                        KeyElement("8"),
                                                                        KeyElement("*"),
                                                                        KeyElement("＊", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        keyLocale: .trailing,
                                                        upper: "（",
                                                        lower: "9",
                                                        event: .number9,
                                                        keyModel: KeyUnit(
                                                                primary: KeyElement("9"),
                                                                members: [
                                                                        KeyElement("9"),
                                                                        KeyElement("（"),
                                                                        KeyElement("(", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        keyLocale: .trailing,
                                                        upper: "）",
                                                        lower: "0",
                                                        event: .number0,
                                                        keyModel: KeyUnit(
                                                                primary: KeyElement("0"),
                                                                members: [
                                                                        KeyElement("0"),
                                                                        KeyElement("）"),
                                                                        KeyElement(")", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])
                                                                ]
                                                        )
                                                )
                                        }
                                        LargePadUpperLowerInputKey(
                                                keyLocale: .trailing,
                                                upper: "——",
                                                lower: "-",
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("-"),
                                                        members: [
                                                                KeyElement("-"),
                                                                KeyElement("——"),
                                                                KeyElement("⸺", extras: [.init("2E3A", alignment: .bottomTrailing)])
                                                        ]
                                                )
                                        )
                                        LargePadUpperLowerInputKey(
                                                keyLocale: .trailing,
                                                upper: "+",
                                                lower: "=",
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("="),
                                                        members: [
                                                                KeyElement("="),
                                                                KeyElement("+"),
                                                                KeyElement("＋", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                                KeyElement("＝", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])
                                                        ]
                                                )
                                        )
                                        LargePadBackspaceKey(widthUnitTimes: 1.5)
                                }
                        }
                        HStack(spacing: 0 ) {
                                LargePadTabKey(widthUnitTimes: 1.5)
                                Group {
                                        LargePadLetterInputKey(.letterQ)
                                        LargePadLetterInputKey(.letterW)
                                        LargePadLetterInputKey(.letterE)
                                        LargePadLetterInputKey(.letterR)
                                        LargePadLetterInputKey(.letterT)
                                        LargePadLetterInputKey(.letterY)
                                        LargePadLetterInputKey(.letterU)
                                        LargePadLetterInputKey(.letterI)
                                        LargePadLetterInputKey(.letterO)
                                        LargePadLetterInputKey(.letterP)
                                }
                                if context.keyboardCase.isUppercased {
                                        LargePadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyUnit(primary: KeyElement("『"), members: [KeyElement("『"), KeyElement("「")]))
                                        LargePadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyUnit(primary: KeyElement("』"), members: [KeyElement("』"), KeyElement("」")]))
                                        LargePadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyUnit(primary: KeyElement("｜"), members: [KeyElement("｜"), KeyElement("|", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])]))
                                } else {
                                        LargePadUpperLowerInputKey(keyLocale: .trailing, upper: "『", lower: "「", keyModel: KeyUnit(primary: KeyElement("「"), members: [KeyElement("「"), KeyElement("『")]))
                                        LargePadUpperLowerInputKey(keyLocale: .trailing, upper: "』", lower: "」", keyModel: KeyUnit(primary: KeyElement("」"), members: [KeyElement("」"), KeyElement("』")]))
                                        LargePadUpperLowerInputKey(keyLocale: .trailing, upper: "｜", lower: "、", keyModel: KeyUnit(primary: KeyElement("、"), members: [KeyElement("、"), KeyElement("｜"), KeyElement("|", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)]), KeyElement("､", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])]))
                                }
                        }
                        HStack(spacing: 0) {
                                LargePadCapsLockKey(widthUnitTimes: 1.75)
                                Group {
                                        LargePadLetterInputKey(.letterA)
                                        LargePadLetterInputKey(.letterS)
                                        LargePadLetterInputKey(.letterD)
                                        LargePadLetterInputKey(.letterF)
                                        LargePadLetterInputKey(.letterG)
                                        LargePadLetterInputKey(.letterH)
                                        LargePadLetterInputKey(.letterJ)
                                        LargePadLetterInputKey(.letterK)
                                        LargePadLetterInputKey(.letterL)
                                }
                                if context.keyboardCase.isUppercased {
                                        LargePadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyUnit(primary: KeyElement("："), members: [KeyElement("："), KeyElement(":", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])]))
                                        LargePadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyUnit(primary: KeyElement("\""), members: [KeyElement("\""), KeyElement("\u{201D}", extras: [.init("右", alignment: .topTrailing), .init("201D", alignment: .bottomTrailing)]), KeyElement("\u{201C}", extras: [.init("左", alignment: .topTrailing), .init("201C", alignment: .bottomTrailing)])]))
                                } else {
                                        LargePadUpperLowerInputKey(keyLocale: .trailing, upper: "：", lower: "；", keyModel: KeyUnit(primary: KeyElement("；"), members: [KeyElement("；"), KeyElement("："), KeyElement(";", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)]), KeyElement(":", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])]))
                                        LargePadUpperLowerInputKey(
                                                keyLocale: .trailing,
                                                upper: "\"",
                                                lower: "'",
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("'"),
                                                        members: [
                                                                KeyElement("'"),
                                                                KeyElement("\""),
                                                                KeyElement("\u{2019}", extras: [.init("右", alignment: .topTrailing), .init("2019", alignment: .bottomTrailing)]),
                                                                KeyElement("\u{2018}", extras: [.init("左", alignment: .topTrailing), .init("2018", alignment: .bottomTrailing)])
                                                        ]
                                                )
                                        )
                                }
                                LargePadReturnKey(widthUnitTimes: 1.75)
                        }
                        HStack(spacing: 0) {
                                LargePadShiftKey(side: .leading, coefficient: 2.25)
                                Group {
                                        LargePadLetterInputKey(.letterZ)
                                        LargePadLetterInputKey(.letterX)
                                        LargePadLetterInputKey(.letterC)
                                        LargePadLetterInputKey(.letterV)
                                        LargePadLetterInputKey(.letterB)
                                        LargePadLetterInputKey(.letterN)
                                        LargePadLetterInputKey(.letterM)
                                }
                                if context.keyboardCase.isUppercased {
                                        LargePadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyUnit(primary: KeyElement("《"), members: [KeyElement("《"), KeyElement("〈"), KeyElement("<"), KeyElement("＜", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])]))
                                        LargePadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyUnit(primary: KeyElement("》"), members: [KeyElement("》"), KeyElement("〉"), KeyElement(">"), KeyElement("＞", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])]))
                                        LargePadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyUnit(primary: KeyElement("？"), members: [KeyElement("？"), KeyElement("?", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])]))
                                } else {
                                        LargePadUpperLowerInputKey(keyLocale: .trailing, upper: "《", lower: "，", keyModel: KeyUnit(primary: KeyElement("，"), members: [KeyElement("，"), KeyElement("《")]))
                                        LargePadUpperLowerInputKey(keyLocale: .trailing, upper: "》", lower: "。", keyModel: KeyUnit(primary: KeyElement("。"), members: [KeyElement("。"), KeyElement("》")]))
                                        LargePadUpperLowerInputKey(keyLocale: .trailing, upper: "？", lower: "/", keyModel: KeyUnit(primary: KeyElement("/"), members: [KeyElement("/"), KeyElement("？"), KeyElement("／", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])]))
                                }
                                LargePadShiftKey(side: .trailing, coefficient: 2.25)
                        }
                        HStack(spacing: 0) {
                                if context.needsInputModeSwitchKey {
                                        LargePadGlobeKey(widthUnitTimes: 2.125)
                                } else {
                                        LargePadTransformKey(destination: .numeric, side: .leading, coefficient: 2.125)
                                }
                                LargePadLeftKey(widthUnitTimes: 2.125)
                                LargePadSpaceKey()
                                LargePadRightKey(widthUnitTimes: 2.125)
                                LargePadDismissKey(widthUnitTimes: 2.125)
                        }
                }
        }
}
