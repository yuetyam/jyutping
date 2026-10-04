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
                                        PadAdvancedInputKey(keyLocale: .leading, upper: "1", keyModel: KeyUnit(primary: KeyElement("aa"), members: [KeyElement("aa"), KeyElement("q")]))
                                        PadPullableInputKey(event: .letterW, upper: "2", lower: "w")
                                        PadPullableInputKey(event: .letterE, upper: "3", lower: "e")
                                        PadAdvancedInputKey(keyLocale: .leading, upper: "4", keyModel: KeyUnit(primary: KeyElement("oe", extras: [.init("eo", alignment: .bottomTrailing)]), members: [KeyElement("oe"), KeyElement("r"), KeyElement("eo")]))
                                        PadPullableInputKey(event: .letterT, upper: "5", lower: "t")
                                        PadAdvancedInputKey(keyLocale: .leading, upper: "6", keyModel: KeyUnit(primary: KeyElement("yu"), members: [KeyElement("yu"), KeyElement("y")]))
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
                                        PadAdvancedInputKey(keyLocale: .leading, event: .letterG, upper: "（", keyModel: KeyUnit(primary: KeyElement("g"), members: [KeyElement("g"), KeyElement("gw")]))
                                        PadPullableInputKey(event: .letterH, upper: "）", lower: "h")
                                        PadPullableInputKey(event: .letterJ, upper: "「", lower: "j")
                                        PadAdvancedInputKey(keyLocale: .trailing, event: .letterK, upper: "」", keyModel: KeyUnit(primary: KeyElement("k"), members: [KeyElement("k"), KeyElement("kw")]))
                                        PadPullableInputKey(event: .letterL, upper: "'", lower: "l")
                                }
                                PadReturnKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0) {
                                PadShiftKey()
                                Group {
                                        PadPullableInputKey(event: .letterZ, upper: "%", lower: "z")
                                        PadAdvancedInputKey(keyLocale: .leading, upper: "-", keyModel: KeyUnit(primary: KeyElement("gw", extras: [.init("kw", alignment: .bottomTrailing)]), members: [KeyElement("gw"), KeyElement("x"), KeyElement("kw")]))
                                        PadPullableInputKey(event: .letterC, upper: "～", lower: "c")
                                        PadAdvancedInputKey(keyLocale: .leading, upper: "…", keyModel: KeyUnit(primary: KeyElement("ng"), members: [KeyElement("ng"), KeyElement("v")]))
                                        PadPullableInputKey(event: .letterB, upper: "、", lower: "b")
                                        PadPullableInputKey(event: .letterN, upper: "；", lower: "n")
                                        PadPullableInputKey(event: .letterM, upper: "：", lower: "m")
                                }
                                if context.keyboardCase.isUppercased {
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyUnit(primary: KeyElement("！"), members: [KeyElement("！"), KeyElement("!", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyUnit(primary: KeyElement("？"), members: [KeyElement("？"), KeyElement("?", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])]))
                                } else {
                                        PadUpperLowerInputKey(keyLocale: .trailing, upper: "！", lower: "，", keyModel: KeyUnit(primary: KeyElement("，"), members: [KeyElement("，"), KeyElement("！"), KeyElement(",", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)]), KeyElement("!", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])]))
                                        PadUpperLowerInputKey(
                                                keyLocale: .trailing,
                                                upper: "？",
                                                lower: "。",
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("。"),
                                                        members: [
                                                                KeyElement("。"),
                                                                KeyElement("？"),
                                                                KeyElement("｡", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)]),
                                                                KeyElement("?", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)]),
                                                                KeyElement("."),
                                                                KeyElement("．", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                        ]
                                                )
                                        )
                                }
                                PadShiftKey()
                        }
                        HStack(spacing: 0) {
                                if context.needsInputModeSwitchKey {
                                        PadGlobeKey(widthUnitTimes: 1.5)
                                } else {
                                        PadTransformKey(destination: .numeric, coefficient: 1.5)
                                }
                                PadLeftKey(widthUnitTimes: 1.5)
                                PadSpaceKey()
                                PadRightKey(widthUnitTimes: 1.5)
                                PadDismissKey(widthUnitTimes: 1.5)
                        }
                }
        }
}
