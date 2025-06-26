import SwiftUI
import CoreIME

struct PadCantoneseKeyboard: View {

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
                                        PadPullableInputKey(event: .letterQ, upper: "1", lower: "q")
                                        PadPullableInputKey(event: .letterW, upper: "2", lower: "w")
                                        PadPullableInputKey(event: .letterE, upper: "3", lower: "e")
                                        PadPullableInputKey(event: .letterR, upper: "4", lower: "r")
                                        PadPullableInputKey(event: .letterT, upper: "5", lower: "t")
                                        PadPullableInputKey(event: .letterY, upper: "6", lower: "y")
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
                                        PadPullableInputKey(event: .letterH, upper: "（", lower: "g")
                                        PadPullableInputKey(event: .letterH, upper: "）", lower: "h")
                                        PadPullableInputKey(event: .letterJ, upper: "「", lower: "j")
                                        PadPullableInputKey(event: .letterK, upper: "」", lower: "k")
                                        PadPullableInputKey(event: .letterL, upper: "'", lower: "l")
                                }
                                PadReturnKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0) {
                                PadShiftKey(widthUnitTimes: 1)
                                Group {
                                        PadPullableInputKey(event: .letterZ, upper: "%", lower: "z")
                                        PadPullableInputKey(event: .letterX, upper: "-", lower: "x")
                                        PadPullableInputKey(event: .letterC, upper: "～", lower: "c")
                                        PadPullableInputKey(event: .letterV, upper: "…", lower: "v")
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
                                PadTransformKey(destination: .numeric, widthUnitTimes: 1.5)
                                PadSpaceKey()
                                PadRightKey(widthUnitTimes: 1.5)
                                PadDismissKey(widthUnitTimes: 1.5)
                        }
                }
        }
}
