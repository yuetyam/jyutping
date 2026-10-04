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
                                                side: .leading,
                                                unit: KeyUnit(
                                                        primary: KeyElement("～"),
                                                        members: [
                                                                KeyElement("～"),
                                                                KeyElement("~", extras: [.init(PresetConstant.halfWidth, alignment: .top)]),
                                                                KeyElement("≈")
                                                        ]
                                                )
                                        )
                                        Group {
                                                LargePadExpansibleInputKey(
                                                        side: .leading,
                                                        unit: KeyUnit(
                                                                primary: KeyElement("！"),
                                                                members: [
                                                                        KeyElement("！"),
                                                                        KeyElement("!", extras: [.init(PresetConstant.halfWidth, alignment: .top)])
                                                                ]
                                                        )
                                                )
                                                LargePadExpansibleInputKey(
                                                        side: .leading,
                                                        unit: KeyUnit(
                                                                primary: KeyElement("@"),
                                                                members: [
                                                                        KeyElement("@"),
                                                                        KeyElement("＠", extras: [.init(PresetConstant.fullWidth, alignment: .top)])
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
                                                        side: .leading,
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
                                                        side: .leading,
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
                                                        side: .leading,
                                                        unit: KeyUnit(
                                                                primary: KeyElement("……"),
                                                                members: [
                                                                        KeyElement("……"),
                                                                        KeyElement("…")
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
                                                                primary: KeyElement("（"),
                                                                members: [
                                                                        KeyElement("（"),
                                                                        KeyElement("(", extras: [.init(PresetConstant.halfWidth, alignment: .top)])
                                                                ]
                                                        )
                                                )
                                                LargePadExpansibleInputKey(
                                                        side: .trailing,
                                                        unit: KeyUnit(
                                                                primary: KeyElement("）"),
                                                                members: [
                                                                        KeyElement("）"),
                                                                        KeyElement(")", extras: [.init(PresetConstant.halfWidth, alignment: .top)])
                                                                ]
                                                        )
                                                )
                                        }
                                        LargePadExpansibleInputKey(
                                                side: .trailing,
                                                unit: KeyUnit(
                                                        primary: KeyElement("——"),
                                                        members: [
                                                                KeyElement("——"),
                                                                KeyElement("⸺", extras: [.init("2E3A", alignment: .bottom)])
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                side: .trailing,
                                                unit: KeyUnit(
                                                        primary: KeyElement("+"),
                                                        members: [
                                                                KeyElement("+"),
                                                                KeyElement("＋", extras: [.init(PresetConstant.fullWidth, alignment: .top)])
                                                        ]
                                                )
                                        )
                                        LargePadBackspaceKey(widthUnitTimes: 1.5)
                                }
                        } else {
                                HStack(spacing: 0 ) {
                                        LargePadUpperLowerInputKey(
                                                side: .leading,
                                                upper: "～",
                                                lower: "·",
                                                unit: KeyUnit(
                                                        primary: KeyElement("·"),
                                                        members: [
                                                                KeyElement("·", extras: [.init("間隔號", alignment: .top), .init("00B7", alignment: .bottom)]),
                                                                KeyElement("～"),
                                                                KeyElement("~", extras: [.init(PresetConstant.halfWidth, alignment: .top)]),
                                                                KeyElement("`", extras: [.init("重音符", alignment: .top), .init("0060", alignment: .bottom)]),
                                                                KeyElement("•", extras: [.init("項目符號", alignment: .top), .init("2022", alignment: .bottom)]),
                                                                KeyElement("‧", extras: [.init("連字點", alignment: .top), .init("2027", alignment: .bottom)]),
                                                                KeyElement("･", extras: [.init("半寬中點", alignment: .top), .init("FF65", alignment: .bottom)]),
                                                                KeyElement("・", extras: [.init("全寬中點", alignment: .top), .init("30FB", alignment: .bottom)])
                                                        ]
                                                )
                                        )
                                        Group {
                                                LargePadUpperLowerInputKey(
                                                        side: .leading,
                                                        upper: "！",
                                                        lower: "1",
                                                        virtual: .number1,
                                                        unit: KeyUnit(
                                                                primary: KeyElement("1"),
                                                                members: [
                                                                        KeyElement("1"),
                                                                        KeyElement("！"),
                                                                        KeyElement("!", extras: [.init(PresetConstant.halfWidth, alignment: .top)])
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        side: .leading,
                                                        upper: "@",
                                                        lower: "2",
                                                        virtual: .number2,
                                                        unit: KeyUnit(
                                                                primary: KeyElement("2"),
                                                                members: [
                                                                        KeyElement("2"),
                                                                        KeyElement("@"),
                                                                        KeyElement("＠", extras: [.init(PresetConstant.fullWidth, alignment: .top)])
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        side: .leading,
                                                        upper: "#",
                                                        lower: "3",
                                                        virtual: .number3,
                                                        unit: KeyUnit(
                                                                primary: KeyElement("3"),
                                                                members: [
                                                                        KeyElement("3"),
                                                                        KeyElement("#"),
                                                                        KeyElement("＃", extras: [.init(PresetConstant.fullWidth, alignment: .top)])
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        side: .leading,
                                                        upper: "$",
                                                        lower: "4",
                                                        virtual: .number4,
                                                        unit: KeyUnit(
                                                                primary: KeyElement("4"),
                                                                members: [
                                                                        KeyElement("4"),
                                                                        KeyElement("$")
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        side: .leading,
                                                        upper: "%",
                                                        lower: "5",
                                                        virtual: .number5,
                                                        unit: KeyUnit(
                                                                primary: KeyElement("5"),
                                                                members: [
                                                                        KeyElement("5"),
                                                                        KeyElement("%"),
                                                                        KeyElement("％", extras: [.init(PresetConstant.fullWidth, alignment: .top)]),
                                                                        KeyElement("‰")
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        side: .leading,
                                                        upper: "……",
                                                        lower: "6",
                                                        virtual: .number6,
                                                        unit: KeyUnit(
                                                                primary: KeyElement("6"),
                                                                members: [
                                                                        KeyElement("6"),
                                                                        KeyElement("……"),
                                                                        KeyElement("…")
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        side: .trailing,
                                                        upper: "&",
                                                        lower: "7",
                                                        virtual: .number7,
                                                        unit: KeyUnit(
                                                                primary: KeyElement("7"),
                                                                members: [
                                                                        KeyElement("7"),
                                                                        KeyElement("&"),
                                                                        KeyElement("＆", extras: [.init(PresetConstant.fullWidth, alignment: .top)]),
                                                                        KeyElement("§")
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        side: .trailing,
                                                        upper: "*",
                                                        lower: "8",
                                                        virtual: .number8,
                                                        unit: KeyUnit(
                                                                primary: KeyElement("8"),
                                                                members: [
                                                                        KeyElement("8"),
                                                                        KeyElement("*"),
                                                                        KeyElement("＊", extras: [.init(PresetConstant.fullWidth, alignment: .top)])
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        side: .trailing,
                                                        upper: "（",
                                                        lower: "9",
                                                        virtual: .number9,
                                                        unit: KeyUnit(
                                                                primary: KeyElement("9"),
                                                                members: [
                                                                        KeyElement("9"),
                                                                        KeyElement("（"),
                                                                        KeyElement("(", extras: [.init(PresetConstant.halfWidth, alignment: .top)])
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        side: .trailing,
                                                        upper: "）",
                                                        lower: "0",
                                                        virtual: .number0,
                                                        unit: KeyUnit(
                                                                primary: KeyElement("0"),
                                                                members: [
                                                                        KeyElement("0"),
                                                                        KeyElement("）"),
                                                                        KeyElement(")", extras: [.init(PresetConstant.halfWidth, alignment: .top)])
                                                                ]
                                                        )
                                                )
                                        }
                                        LargePadUpperLowerInputKey(
                                                side: .trailing,
                                                upper: "——",
                                                lower: "-",
                                                unit: KeyUnit(
                                                        primary: KeyElement("-"),
                                                        members: [
                                                                KeyElement("-"),
                                                                KeyElement("——"),
                                                                KeyElement("⸺", extras: [.init("2E3A", alignment: .bottom)])
                                                        ]
                                                )
                                        )
                                        LargePadUpperLowerInputKey(
                                                side: .trailing,
                                                upper: "+",
                                                lower: "=",
                                                unit: KeyUnit(
                                                        primary: KeyElement("="),
                                                        members: [
                                                                KeyElement("="),
                                                                KeyElement("+"),
                                                                KeyElement("＋", extras: [.init(PresetConstant.fullWidth, alignment: .top)]),
                                                                KeyElement("＝", extras: [.init(PresetConstant.fullWidth, alignment: .top)])
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
                                        LargePadExpansibleInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("『"), members: [KeyElement("『"), KeyElement("「")]))
                                        LargePadExpansibleInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("』"), members: [KeyElement("』"), KeyElement("」")]))
                                        LargePadExpansibleInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("｜"), members: [KeyElement("｜"), KeyElement("|", extras: [.init(PresetConstant.halfWidth, alignment: .top)])]))
                                } else {
                                        LargePadUpperLowerInputKey(side: .trailing, upper: "『", lower: "「", unit: KeyUnit(primary: KeyElement("「"), members: [KeyElement("「"), KeyElement("『")]))
                                        LargePadUpperLowerInputKey(side: .trailing, upper: "』", lower: "」", unit: KeyUnit(primary: KeyElement("」"), members: [KeyElement("」"), KeyElement("』")]))
                                        LargePadUpperLowerInputKey(side: .trailing, upper: "｜", lower: "、", unit: KeyUnit(primary: KeyElement("、"), members: [KeyElement("、"), KeyElement("｜"), KeyElement("|", extras: [.init(PresetConstant.halfWidth, alignment: .top)]), KeyElement("､", extras: [.init(PresetConstant.halfWidth, alignment: .top)])]))
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
                                        LargePadExpansibleInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("："), members: [KeyElement("："), KeyElement(":", extras: [.init(PresetConstant.halfWidth, alignment: .top)])]))
                                        LargePadExpansibleInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("\""), members: [KeyElement("\""), KeyElement("\u{201D}", extras: [.init("右", alignment: .top), .init("201D", alignment: .bottom)]), KeyElement("\u{201C}", extras: [.init("左", alignment: .top), .init("201C", alignment: .bottom)])]))
                                } else {
                                        LargePadUpperLowerInputKey(side: .trailing, upper: "：", lower: "；", unit: KeyUnit(primary: KeyElement("；"), members: [KeyElement("；"), KeyElement("："), KeyElement(";", extras: [.init(PresetConstant.halfWidth, alignment: .top)]), KeyElement(":", extras: [.init(PresetConstant.halfWidth, alignment: .top)])]))
                                        LargePadUpperLowerInputKey(
                                                side: .trailing,
                                                upper: "\"",
                                                lower: "'",
                                                unit: KeyUnit(
                                                        primary: KeyElement("'"),
                                                        members: [
                                                                KeyElement("'"),
                                                                KeyElement("\""),
                                                                KeyElement("\u{2019}", extras: [.init("右", alignment: .top), .init("2019", alignment: .bottom)]),
                                                                KeyElement("\u{2018}", extras: [.init("左", alignment: .top), .init("2018", alignment: .bottom)])
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
                                        LargePadExpansibleInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("《"), members: [KeyElement("《"), KeyElement("〈"), KeyElement("<"), KeyElement("＜", extras: [.init(PresetConstant.fullWidth, alignment: .top)])]))
                                        LargePadExpansibleInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("》"), members: [KeyElement("》"), KeyElement("〉"), KeyElement(">"), KeyElement("＞", extras: [.init(PresetConstant.fullWidth, alignment: .top)])]))
                                        LargePadExpansibleInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("？"), members: [KeyElement("？"), KeyElement("?", extras: [.init(PresetConstant.halfWidth, alignment: .top)])]))
                                } else {
                                        LargePadUpperLowerInputKey(side: .trailing, upper: "《", lower: "，", unit: KeyUnit(primary: KeyElement("，"), members: [KeyElement("，"), KeyElement("《")]))
                                        LargePadUpperLowerInputKey(side: .trailing, upper: "》", lower: "。", unit: KeyUnit(primary: KeyElement("。"), members: [KeyElement("。"), KeyElement("》")]))
                                        LargePadUpperLowerInputKey(side: .trailing, upper: "？", lower: "/", unit: KeyUnit(primary: KeyElement("/"), members: [KeyElement("/"), KeyElement("？"), KeyElement("／", extras: [.init(PresetConstant.fullWidth, alignment: .top)])]))
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
