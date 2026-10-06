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
                                        PadAdvancedInputKey(side: .leading, upper: "1", unit: KeyUnit(primary: KeyElement("aa"), members: [KeyElement("aa"), KeyElement("q")]))
                                        PadPullableInputKey(virtual: .letterW, upper: "2", lower: "w")
                                        PadPullableInputKey(virtual: .letterE, upper: "3", lower: "e")
                                        PadAdvancedInputKey(side: .leading, upper: "4", unit: KeyUnit(primary: KeyElement("oe", extras: [.init("eo", alignment: .bottomTrailing)]), members: [KeyElement("oe"), KeyElement("r"), KeyElement("eo")]))
                                        PadPullableInputKey(virtual: .letterT, upper: "5", lower: "t")
                                        PadAdvancedInputKey(side: .leading, upper: "6", unit: KeyUnit(primary: KeyElement("yu"), members: [KeyElement("yu"), KeyElement("y")]))
                                        PadPullableInputKey(virtual: .letterU, upper: "7", lower: "u")
                                        PadPullableInputKey(virtual: .letterI, upper: "8", lower: "i")
                                        PadPullableInputKey(virtual: .letterO, upper: "9", lower: "o")
                                        PadPullableInputKey(virtual: .letterP, upper: "0", lower: "p")
                                }
                                PadBackspaceKey(widthUnitTimes: 1)
                        }
                        HStack(spacing: 0) {
                                Spacer()
                                Group {
                                        PadPullableInputKey(virtual: .letterA, upper: "@", lower: "a")
                                        PadPullableInputKey(virtual: .letterS, upper: "#", lower: "s")
                                        PadPullableInputKey(virtual: .letterD, upper: "$", lower: "d")
                                        PadPullableInputKey(virtual: .letterF, upper: "/", lower: "f")
                                        PadAdvancedInputKey(side: .leading, virtual: .letterG, upper: "（", unit: KeyUnit(primary: KeyElement("g"), members: [KeyElement("g"), KeyElement("gw")]))
                                        PadPullableInputKey(virtual: .letterH, upper: "）", lower: "h")
                                        PadPullableInputKey(virtual: .letterJ, upper: "「", lower: "j")
                                        PadAdvancedInputKey(side: .trailing, virtual: .letterK, upper: "」", unit: KeyUnit(primary: KeyElement("k"), members: [KeyElement("k"), KeyElement("kw")]))
                                        PadPullableInputKey(virtual: .letterL, upper: "'", lower: "l")
                                }
                                PadReturnKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0) {
                                PadShiftKey()
                                Group {
                                        PadPullableInputKey(virtual: .letterZ, upper: "%", lower: "z")
                                        PadAdvancedInputKey(side: .leading, upper: "-", unit: KeyUnit(primary: KeyElement("gw", extras: [.init("kw", alignment: .bottomTrailing)]), members: [KeyElement("gw"), KeyElement("x"), KeyElement("kw")]))
                                        PadPullableInputKey(virtual: .letterC, upper: "～", lower: "c")
                                        PadAdvancedInputKey(side: .leading, upper: "…", unit: KeyUnit(primary: KeyElement("ng"), members: [KeyElement("ng"), KeyElement("v")]))
                                        PadPullableInputKey(virtual: .letterB, upper: "、", lower: "b")
                                        PadPullableInputKey(virtual: .letterN, upper: "；", lower: "n")
                                        PadPullableInputKey(virtual: .letterM, upper: "：", lower: "m")
                                }
                                if context.keyboardCase.isUppercased {
                                        PadExpansibleInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("！"), members: [KeyElement("！"), KeyElement("!", extras: [.init(PresetConstant.halfWidth, alignment: .top)])]))
                                        PadExpansibleInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("？"), members: [KeyElement("？"), KeyElement("?", extras: [.init(PresetConstant.halfWidth, alignment: .top)])]))
                                } else {
                                        PadUpperLowerInputKey(side: .trailing, upper: "！", lower: "，", unit: KeyUnit(primary: KeyElement("，"), members: [KeyElement("，"), KeyElement("！"), KeyElement(",", extras: [.init(PresetConstant.halfWidth, alignment: .top)]), KeyElement("!", extras: [.init(PresetConstant.halfWidth, alignment: .top)])]))
                                        PadUpperLowerInputKey(
                                                side: .trailing,
                                                upper: "？",
                                                lower: "。",
                                                unit: KeyUnit(
                                                        primary: KeyElement("。"),
                                                        members: [
                                                                KeyElement("。"),
                                                                KeyElement("？"),
                                                                KeyElement("｡", extras: [.init(PresetConstant.halfWidth, alignment: .top)]),
                                                                KeyElement("?", extras: [.init(PresetConstant.halfWidth, alignment: .top)]),
                                                                KeyElement("."),
                                                                KeyElement("．", extras: [.init(PresetConstant.fullWidth, alignment: .top)]),
                                                        ]
                                                )
                                        )
                                }
                                PadShiftKey()
                        }
                        HStack(spacing: 0) {
                                if context.needsGlobeKey {
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
