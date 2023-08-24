import SwiftUI

struct LargePadCantoneseKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        if context.inputStage.isBuffering {
                                CandidateScrollBar()
                        } else {
                                ToolBar()
                        }
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
                                                        KeyElement("~", header: "半形"),
                                                        KeyElement("•", header: "Bullet", footer: "2022"),
                                                        KeyElement("‧", footer: "2027"),
                                                        KeyElement("・", header: "中點", footer: "30FB"),
                                                        KeyElement("`", header: "Backtick", footer: "0060")
                                                ]
                                        )
                                )
                                Group {
                                        PadSymbolInputKey("1")
                                        PadSymbolInputKey("2")
                                        PadSymbolInputKey("3")
                                        PadSymbolInputKey("4")
                                        PadSymbolInputKey("5")
                                        PadSymbolInputKey("6")
                                        PadSymbolInputKey("7")
                                        PadSymbolInputKey("8")
                                        PadSymbolInputKey("9")
                                        PadSymbolInputKey("0")
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
                                                        KeyElement("＋", header: "全形"),
                                                        KeyElement("＝", header: "全形")
                                                ]
                                        )
                                )
                                LargePadBackspaceKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0 ) {
                                TabKey(widthUnitTimes: 1.5)
                                Group {
                                        LargePadLetterInputKey("q")
                                        LargePadLetterInputKey("w")
                                        LargePadLetterInputKey("e")
                                        LargePadLetterInputKey("r")
                                        LargePadLetterInputKey("t")
                                        LargePadLetterInputKey("y")
                                        LargePadLetterInputKey("u")
                                        LargePadLetterInputKey("i")
                                        LargePadLetterInputKey("o")
                                        LargePadLetterInputKey("p")
                                }
                                LargePadUpperLowerInputKey(keyLocale: .trailing, upper: "『", lower: "「", keyModel: KeyModel(primary: KeyElement("「"), members: [KeyElement("「"), KeyElement("『")]))
                                LargePadUpperLowerInputKey(keyLocale: .trailing, upper: "』", lower: "」", keyModel: KeyModel(primary: KeyElement("」"), members: [KeyElement("」"), KeyElement("』")]))
                                LargePadUpperLowerInputKey(keyLocale: .trailing, upper: "｜", lower: "、", keyModel: KeyModel(primary: KeyElement("、"), members: [KeyElement("、"), KeyElement("｜"), KeyElement("|", header: "半形")]))
                        }
                        HStack(spacing: 0) {
                                CapsLockKey(widthUnitTimes: 1.75)
                                Group {
                                        LargePadLetterInputKey("a")
                                        LargePadLetterInputKey("s")
                                        LargePadLetterInputKey("d")
                                        LargePadLetterInputKey("f")
                                        LargePadLetterInputKey("g")
                                        LargePadLetterInputKey("h")
                                        LargePadLetterInputKey("j")
                                        LargePadLetterInputKey("k")
                                        LargePadLetterInputKey("l")
                                }
                                LargePadUpperLowerInputKey(keyLocale: .trailing, upper: "：", lower: "；", keyModel: KeyModel(primary: KeyElement("；"), members: [KeyElement("；"), KeyElement("：")]))
                                LargePadUpperLowerInputKey(keyLocale: .trailing, upper: "\"", lower: "'", keyModel: KeyModel(primary: KeyElement("'"), members: [KeyElement("'"), KeyElement("\"")]))
                                LargePadReturnKey(widthUnitTimes: 1.75)
                        }
                        HStack(spacing: 0) {
                                LargePadShiftKey(keyLocale: .leading, widthUnitTimes: 2.25)
                                Group {
                                        LargePadLetterInputKey("z")
                                        LargePadLetterInputKey("x")
                                        LargePadLetterInputKey("c")
                                        LargePadLetterInputKey("v")
                                        LargePadLetterInputKey("b")
                                        LargePadLetterInputKey("n")
                                        LargePadLetterInputKey("m")
                                }
                                LargePadUpperLowerInputKey(keyLocale: .trailing, upper: "《", lower: "，", keyModel: KeyModel(primary: KeyElement("，"), members: [KeyElement("，"), KeyElement("《")]))
                                LargePadUpperLowerInputKey(keyLocale: .trailing, upper: "》", lower: "。", keyModel: KeyModel(primary: KeyElement("。"), members: [KeyElement("。"), KeyElement("》")]))
                                LargePadUpperLowerInputKey(keyLocale: .trailing, upper: "？", lower: "/", keyModel: KeyModel(primary: KeyElement("/"), members: [KeyElement("/"), KeyElement("？"), KeyElement("／", header: "全形")]))
                                LargePadShiftKey(keyLocale: .trailing, widthUnitTimes: 2.25)
                        }
                        HStack(spacing: 0) {
                                if context.needsInputModeSwitchKey {
                                        LargePadGlobeKey(widthUnitTimes: 2.125)
                                } else {
                                        LargePadTransformKey(destination: .numeric, keyLocale: .leading, widthUnitTimes: 2.125)
                                }
                                LargePadTransformKey(destination: .numeric, keyLocale: .leading, widthUnitTimes: 2.125)
                                PadSpaceKey()
                                LargePadTransformKey(destination: .numeric, keyLocale: .trailing, widthUnitTimes: 2.125)
                                LargePadDismissKey(widthUnitTimes: 2.125)
                        }
                }
        }
}
