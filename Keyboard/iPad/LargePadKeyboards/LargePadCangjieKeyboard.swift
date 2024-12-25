import SwiftUI

struct LargePadCangjieKeyboard: View {

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
                                                keyModel: KeyModel(
                                                        primary: KeyElement("～"),
                                                        members: [
                                                                KeyElement("～"),
                                                                KeyElement("~", header: PresetConstant.halfWidth),
                                                                KeyElement("≈")
                                                        ]
                                                )
                                        )
                                        Group {
                                                LargePadExpansibleInputKey(
                                                        keyLocale: .leading,
                                                        keyModel: KeyModel(
                                                                primary: KeyElement("！"),
                                                                members: [
                                                                        KeyElement("！"),
                                                                        KeyElement("!", header: PresetConstant.halfWidth)
                                                                ]
                                                        )
                                                )
                                                LargePadExpansibleInputKey(
                                                        keyLocale: .leading,
                                                        keyModel: KeyModel(
                                                                primary: KeyElement("@"),
                                                                members: [
                                                                        KeyElement("@"),
                                                                        KeyElement("＠", header: PresetConstant.fullWidth)
                                                                ]
                                                        )
                                                )
                                                LargePadExpansibleInputKey(
                                                        keyLocale: .leading,
                                                        keyModel: KeyModel(
                                                                primary: KeyElement("#"),
                                                                members: [
                                                                        KeyElement("#"),
                                                                        KeyElement("＃", header: PresetConstant.fullWidth)
                                                                ]
                                                        )
                                                )
                                                LargePadExpansibleInputKey(
                                                        keyLocale: .leading,
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
                                                        keyLocale: .leading,
                                                        keyModel: KeyModel(
                                                                primary: KeyElement("%"),
                                                                members: [
                                                                        KeyElement("%"),
                                                                        KeyElement("％", header: PresetConstant.fullWidth),
                                                                        KeyElement("‰")
                                                                ]
                                                        )
                                                )
                                                LargePadExpansibleInputKey(
                                                        keyLocale: .leading,
                                                        keyModel: KeyModel(
                                                                primary: KeyElement("……"),
                                                                members: [
                                                                        KeyElement("……"),
                                                                        KeyElement("…")
                                                                ]
                                                        )
                                                )
                                                LargePadExpansibleInputKey(
                                                        keyLocale: .trailing,
                                                        keyModel: KeyModel(
                                                                primary: KeyElement("&"),
                                                                members: [
                                                                        KeyElement("&"),
                                                                        KeyElement("＆", header: PresetConstant.fullWidth),
                                                                        KeyElement("§")
                                                                ]
                                                        )
                                                )
                                                LargePadExpansibleInputKey(
                                                        keyLocale: .trailing,
                                                        keyModel: KeyModel(
                                                                primary: KeyElement("*"),
                                                                members: [
                                                                        KeyElement("*"),
                                                                        KeyElement("＊", header: PresetConstant.fullWidth)
                                                                ]
                                                        )
                                                )
                                                LargePadExpansibleInputKey(
                                                        keyLocale: .trailing,
                                                        keyModel: KeyModel(
                                                                primary: KeyElement("（"),
                                                                members: [
                                                                        KeyElement("（"),
                                                                        KeyElement("(", header: PresetConstant.halfWidth)
                                                                ]
                                                        )
                                                )
                                                LargePadExpansibleInputKey(
                                                        keyLocale: .trailing,
                                                        keyModel: KeyModel(
                                                                primary: KeyElement("）"),
                                                                members: [
                                                                        KeyElement("）"),
                                                                        KeyElement(")", header: PresetConstant.halfWidth)
                                                                ]
                                                        )
                                                )
                                        }
                                        LargePadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("——"),
                                                        members: [
                                                                KeyElement("——"),
                                                                KeyElement("⸺", footer: "2E3A")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("+"),
                                                        members: [
                                                                KeyElement("+"),
                                                                KeyElement("＋", header: PresetConstant.fullWidth)
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
                                                keyModel: KeyModel(
                                                        primary: KeyElement("·"),
                                                        members: [
                                                                KeyElement("·", header: "間隔號", footer: "00B7"),
                                                                KeyElement("～"),
                                                                KeyElement("~", header: PresetConstant.halfWidth),
                                                                KeyElement("`", header: "重音符", footer: "0060"),
                                                                KeyElement("•", header: "項目符號", footer: "2022"),
                                                                KeyElement("‧", header: "連字點", footer: "2027"),
                                                                KeyElement("･", header: "半寬中點", footer: "FF65"),
                                                                KeyElement("・", header: "全寬中點", footer: "30FB")
                                                        ]
                                                )
                                        )
                                        Group {
                                                LargePadUpperLowerInputKey(
                                                        keyLocale: .leading,
                                                        upper: "！",
                                                        lower: "1",
                                                        keyModel: KeyModel(
                                                                primary: KeyElement("1"),
                                                                members: [
                                                                        KeyElement("1"),
                                                                        KeyElement("！"),
                                                                        KeyElement("!", header: PresetConstant.halfWidth)
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        keyLocale: .leading,
                                                        upper: "@",
                                                        lower: "2",
                                                        keyModel: KeyModel(
                                                                primary: KeyElement("2"),
                                                                members: [
                                                                        KeyElement("2"),
                                                                        KeyElement("@"),
                                                                        KeyElement("＠", header: PresetConstant.fullWidth)
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        keyLocale: .leading,
                                                        upper: "#",
                                                        lower: "3",
                                                        keyModel: KeyModel(
                                                                primary: KeyElement("3"),
                                                                members: [
                                                                        KeyElement("3"),
                                                                        KeyElement("#"),
                                                                        KeyElement("＃", header: PresetConstant.fullWidth)
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        keyLocale: .leading,
                                                        upper: "$",
                                                        lower: "4",
                                                        keyModel: KeyModel(
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
                                                        keyModel: KeyModel(
                                                                primary: KeyElement("5"),
                                                                members: [
                                                                        KeyElement("5"),
                                                                        KeyElement("%"),
                                                                        KeyElement("％", header: PresetConstant.fullWidth),
                                                                        KeyElement("‰")
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        keyLocale: .leading,
                                                        upper: "……",
                                                        lower: "6",
                                                        keyModel: KeyModel(
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
                                                        keyModel: KeyModel(
                                                                primary: KeyElement("7"),
                                                                members: [
                                                                        KeyElement("7"),
                                                                        KeyElement("&"),
                                                                        KeyElement("＆", header: PresetConstant.fullWidth),
                                                                        KeyElement("§")
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        keyLocale: .trailing,
                                                        upper: "*",
                                                        lower: "8",
                                                        keyModel: KeyModel(
                                                                primary: KeyElement("8"),
                                                                members: [
                                                                        KeyElement("8"),
                                                                        KeyElement("*"),
                                                                        KeyElement("＊", header: PresetConstant.fullWidth)
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        keyLocale: .trailing,
                                                        upper: "（",
                                                        lower: "9",
                                                        keyModel: KeyModel(
                                                                primary: KeyElement("9"),
                                                                members: [
                                                                        KeyElement("9"),
                                                                        KeyElement("（"),
                                                                        KeyElement("(", header: PresetConstant.halfWidth)
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        keyLocale: .trailing,
                                                        upper: "）",
                                                        lower: "0",
                                                        keyModel: KeyModel(
                                                                primary: KeyElement("0"),
                                                                members: [
                                                                        KeyElement("0"),
                                                                        KeyElement("）"),
                                                                        KeyElement(")", header: PresetConstant.halfWidth)
                                                                ]
                                                        )
                                                )
                                        }
                                        LargePadUpperLowerInputKey(
                                                keyLocale: .trailing,
                                                upper: "——",
                                                lower: "-",
                                                keyModel: KeyModel(
                                                        primary: KeyElement("-"),
                                                        members: [
                                                                KeyElement("-"),
                                                                KeyElement("——"),
                                                                KeyElement("⸺", footer: "2E3A")
                                                        ]
                                                )
                                        )
                                        LargePadUpperLowerInputKey(
                                                keyLocale: .trailing,
                                                upper: "+",
                                                lower: "=",
                                                keyModel: KeyModel(
                                                        primary: KeyElement("="),
                                                        members: [
                                                                KeyElement("="),
                                                                KeyElement("+"),
                                                                KeyElement("＋", header: PresetConstant.fullWidth),
                                                                KeyElement("＝", header: PresetConstant.fullWidth)
                                                        ]
                                                )
                                        )
                                        LargePadBackspaceKey(widthUnitTimes: 1.5)
                                }
                        }
                        HStack(spacing: 0 ) {
                                LargePadTabKey(widthUnitTimes: 1.5)
                                Group {
                                        LargePadCangjieInputKey("q")
                                        LargePadCangjieInputKey("w")
                                        LargePadCangjieInputKey("e")
                                        LargePadCangjieInputKey("r")
                                        LargePadCangjieInputKey("t")
                                        LargePadCangjieInputKey("y")
                                        LargePadCangjieInputKey("u")
                                        LargePadCangjieInputKey("i")
                                        LargePadCangjieInputKey("o")
                                        LargePadCangjieInputKey("p")
                                }
                                if context.keyboardCase.isUppercased {
                                        LargePadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("『"), members: [KeyElement("『"), KeyElement("「")]))
                                        LargePadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("』"), members: [KeyElement("』"), KeyElement("」")]))
                                        LargePadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("｜"), members: [KeyElement("｜"), KeyElement("|", header: PresetConstant.halfWidth)]))
                                } else {
                                        LargePadUpperLowerInputKey(keyLocale: .trailing, upper: "『", lower: "「", keyModel: KeyModel(primary: KeyElement("「"), members: [KeyElement("「"), KeyElement("『")]))
                                        LargePadUpperLowerInputKey(keyLocale: .trailing, upper: "』", lower: "」", keyModel: KeyModel(primary: KeyElement("」"), members: [KeyElement("」"), KeyElement("』")]))
                                        LargePadUpperLowerInputKey(keyLocale: .trailing, upper: "｜", lower: "、", keyModel: KeyModel(primary: KeyElement("、"), members: [KeyElement("、"), KeyElement("｜"), KeyElement("|", header: PresetConstant.halfWidth), KeyElement("､", header: PresetConstant.halfWidth)]))
                                }
                        }
                        HStack(spacing: 0) {
                                LargePadCapsLockKey(widthUnitTimes: 1.75)
                                Group {
                                        LargePadCangjieInputKey("a")
                                        LargePadCangjieInputKey("s")
                                        LargePadCangjieInputKey("d")
                                        LargePadCangjieInputKey("f")
                                        LargePadCangjieInputKey("g")
                                        LargePadCangjieInputKey("h")
                                        LargePadCangjieInputKey("j")
                                        LargePadCangjieInputKey("k")
                                        LargePadCangjieInputKey("l")
                                }
                                if context.keyboardCase.isUppercased {
                                        LargePadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("："), members: [KeyElement("："), KeyElement(":", header: PresetConstant.halfWidth)]))
                                        LargePadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("\""), members: [KeyElement("\""), KeyElement("\u{201D}", header: "右", footer: "201D"), KeyElement("\u{201C}", header: "左", footer: "201C")]))
                                } else {
                                        LargePadUpperLowerInputKey(keyLocale: .trailing, upper: "：", lower: "；", keyModel: KeyModel(primary: KeyElement("；"), members: [KeyElement("；"), KeyElement("："), KeyElement(";", header: PresetConstant.halfWidth), KeyElement(":", header: PresetConstant.halfWidth)]))
                                        LargePadUpperLowerInputKey(
                                                keyLocale: .trailing,
                                                upper: "\"",
                                                lower: "'",
                                                keyModel: KeyModel(
                                                        primary: KeyElement("'"),
                                                        members: [
                                                                KeyElement("'"),
                                                                KeyElement("\""),
                                                                KeyElement("\u{2019}", header: "右", footer: "2019"),
                                                                KeyElement("\u{2018}", header: "左", footer: "2018")
                                                        ]
                                                )
                                        )
                                }
                                LargePadReturnKey(widthUnitTimes: 1.75)
                        }
                        HStack(spacing: 0) {
                                LargePadShiftKey(keyLocale: .leading, widthUnitTimes: 2.25)
                                Group {
                                        LargePadCangjieInputKey("z")
                                        LargePadCangjieInputKey("x")
                                        LargePadCangjieInputKey("c")
                                        LargePadCangjieInputKey("v")
                                        LargePadCangjieInputKey("b")
                                        LargePadCangjieInputKey("n")
                                        LargePadCangjieInputKey("m")
                                }
                                if context.keyboardCase.isUppercased {
                                        LargePadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("《"), members: [KeyElement("《"), KeyElement("〈"), KeyElement("<"), KeyElement("＜", header: PresetConstant.fullWidth)]))
                                        LargePadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("》"), members: [KeyElement("》"), KeyElement("〉"), KeyElement(">"), KeyElement("＞", header: PresetConstant.fullWidth)]))
                                        LargePadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("？"), members: [KeyElement("？"), KeyElement("?", header: PresetConstant.halfWidth)]))
                                } else {
                                        LargePadUpperLowerInputKey(keyLocale: .trailing, upper: "《", lower: "，", keyModel: KeyModel(primary: KeyElement("，"), members: [KeyElement("，"), KeyElement("《")]))
                                        LargePadUpperLowerInputKey(keyLocale: .trailing, upper: "》", lower: "。", keyModel: KeyModel(primary: KeyElement("。"), members: [KeyElement("。"), KeyElement("》")]))
                                        LargePadUpperLowerInputKey(keyLocale: .trailing, upper: "？", lower: "/", keyModel: KeyModel(primary: KeyElement("/"), members: [KeyElement("/"), KeyElement("？"), KeyElement("／", header: PresetConstant.fullWidth)]))
                                }
                                LargePadShiftKey(keyLocale: .trailing, widthUnitTimes: 2.25)
                        }
                        HStack(spacing: 0) {
                                if context.needsInputModeSwitchKey {
                                        LargePadGlobeKey(widthUnitTimes: 2.125)
                                } else {
                                        LargePadTransformKey(destination: .numeric, keyLocale: .leading, widthUnitTimes: 2.125)
                                }
                                LargePadTransformKey(destination: .numeric, keyLocale: .leading, widthUnitTimes: 2.125)
                                LargePadSpaceKey()
                                LargePadTransformKey(destination: .numeric, keyLocale: .trailing, widthUnitTimes: 2.125)
                                LargePadDismissKey(widthUnitTimes: 2.125)
                        }
                }
        }
}
