import SwiftUI
import CoreIME

struct MediumPadTripleStrokeKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        if context.inputStage.isBuffering {
                                CandidateBar()
                        } else {
                                ToolBar()
                        }
                        HStack(spacing: 0 ) {
                                MediumPadTabKey(widthUnitTimes: 1)
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
                                MediumPadBackspaceKey(widthUnitTimes: 1)
                        }
                        HStack(spacing: 0) {
                                MediumPadCapsLockKey(widthUnitTimes: 1.5)
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
                                MediumPadReturnKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0) {
                                MediumPadShiftKey(keyLocale: .leading, widthUnitTimes: 1.75)
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
                                MediumPadShiftKey(keyLocale: .trailing, widthUnitTimes: 1.25)
                        }
                        HStack(spacing: 0) {
                                if context.needsInputModeSwitchKey {
                                        MediumPadGlobeKey(widthUnitTimes: 1.5)
                                } else {
                                        MediumPadTransformKey(destination: .numeric, keyLocale: .leading, widthUnitTimes: 1.5)
                                }
                                MediumPadLeftKey(widthUnitTimes: 1.5)
                                PadSpaceKey()
                                MediumPadRightKey(widthUnitTimes: 1.5)
                                MediumPadDismissKey(widthUnitTimes: 1.5)
                        }
                }
        }
}
