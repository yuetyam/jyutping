import SwiftUI
import CoreIME
import CommonExtensions

struct PadTripleStrokeKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        if context.inputStage.isBuffering {
                                CandidateBar()
                        } else {
                                ToolBar()
                        }
                        HStack(spacing: 0 ) {
                                Group {
                                        PadCompleteInputKey(keyLocale: .leading, upper: "1", keyModel: KeyModel(primary: KeyElement("aa"), members: [KeyElement("aa"), KeyElement("q")]))
                                        PadPullableInputKey(event: .letterW, upper: "2", lower: "w")
                                        PadPullableInputKey(event: .letterE, upper: "3", lower: "e")
                                        PadCompleteInputKey(keyLocale: .leading, upper: "4", keyModel: KeyModel(primary: KeyElement("oe", footer: "eo"), members: [KeyElement("oe"), KeyElement("r"), KeyElement("eo")]))
                                        PadPullableInputKey(event: .letterT, upper: "5", lower: "t")
                                        PadCompleteInputKey(keyLocale: .leading, upper: "6", keyModel: KeyModel(primary: KeyElement("yu"), members: [KeyElement("yu"), KeyElement("y")]))
                                        PadPullableInputKey(event: .letterU, upper: "7", lower: "u")
                                        PadPullableInputKey(event: .letterI, upper: "8", lower: "i")
                                        PadPullableInputKey(event: .letterO, upper: "9", lower: "o")
                                        PadPullableInputKey(event: .letterP, upper: "0", lower: "p")
                                }
                                PadBackspaceKey(widthUnitTimes: 1)
                        }
                        HStack(spacing: 0) {
                                Spacer()
                                Group {
                                        PadPullableInputKey(event: .letterA, upper: "@", lower: "a")
                                        PadPullableInputKey(event: .letterS, upper: "#", lower: "s")
                                        PadPullableInputKey(event: .letterD, upper: "$", lower: "d")
                                        PadPullableInputKey(event: .letterF, upper: "/", lower: "f")
                                        PadCompleteInputKey(keyLocale: .leading, event: .letterG, upper: "（", keyModel: KeyModel(primary: KeyElement("g"), members: [KeyElement("g"), KeyElement("gw")]))
                                        PadPullableInputKey(event: .letterH, upper: "）", lower: "h")
                                        PadPullableInputKey(event: .letterJ, upper: "「", lower: "j")
                                        PadCompleteInputKey(keyLocale: .trailing, event: .letterK, upper: "」", keyModel: KeyModel(primary: KeyElement("k"), members: [KeyElement("k"), KeyElement("kw")]))
                                        PadPullableInputKey(event: .letterL, upper: "'", lower: "l")
                                }
                                PadReturnKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0) {
                                PadShiftKey(widthUnitTimes: 1)
                                Group {
                                        PadPullableInputKey(event: .letterZ, upper: "%", lower: "z")
                                        PadCompleteInputKey(keyLocale: .leading, upper: "-", keyModel: KeyModel(primary: KeyElement("gw", footer: "kw"), members: [KeyElement("gw"), KeyElement("x"), KeyElement("kw")]))
                                        PadPullableInputKey(event: .letterC, upper: "～", lower: "c")
                                        PadCompleteInputKey(keyLocale: .leading, upper: "…", keyModel: KeyModel(primary: KeyElement("ng"), members: [KeyElement("ng"), KeyElement("v")]))
                                        PadPullableInputKey(event: .letterB, upper: "、", lower: "b")
                                        PadPullableInputKey(event: .letterN, upper: "；", lower: "n")
                                        PadPullableInputKey(event: .letterM, upper: "：", lower: "m")
                                }
                                if context.keyboardCase.isUppercased {
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("！"), members: [KeyElement("！"), KeyElement("!", header: PresetConstant.halfWidth)]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("？"), members: [KeyElement("？"), KeyElement("?", header: PresetConstant.halfWidth)]))
                                } else {
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
                                }
                                PadShiftKey(widthUnitTimes: 1)
                        }
                        HStack(spacing: 0) {
                                if context.needsInputModeSwitchKey {
                                        PadGlobeKey(widthUnitTimes: 1.5)
                                } else {
                                        PadTransformKey(destination: .numeric, widthUnitTimes: 1.5)
                                }
                                PadLeftKey(widthUnitTimes: 1.5)
                                PadSpaceKey()
                                PadRightKey(widthUnitTimes: 1.5)
                                PadDismissKey(widthUnitTimes: 1.5)
                        }
                }
        }
}
