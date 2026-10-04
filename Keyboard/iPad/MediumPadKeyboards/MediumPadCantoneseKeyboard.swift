import SwiftUI
import CoreIME

struct MediumPadCantoneseKeyboard: View {

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
                                        PadPullableInputKey(virtual: .letterQ, upper: "1", lower: "q")
                                        PadPullableInputKey(virtual: .letterW, upper: "2", lower: "w")
                                        PadPullableInputKey(virtual: .letterE, upper: "3", lower: "e")
                                        PadPullableInputKey(virtual: .letterR, upper: "4", lower: "r")
                                        PadPullableInputKey(virtual: .letterT, upper: "5", lower: "t")
                                        PadPullableInputKey(virtual: .letterY, upper: "6", lower: "y")
                                        PadPullableInputKey(virtual: .letterU, upper: "7", lower: "u")
                                        PadPullableInputKey(virtual: .letterI, upper: "8", lower: "i")
                                        PadPullableInputKey(virtual: .letterO, upper: "9", lower: "o")
                                        PadPullableInputKey(virtual: .letterP, upper: "0", lower: "p")
                                }
                                MediumPadBackspaceKey(widthUnitTimes: 1)
                        }
                        HStack(spacing: 0) {
                                MediumPadCapsLockKey(widthUnitTimes: 1.5)
                                Group {
                                        PadPullableInputKey(virtual: .letterA, upper: "@", lower: "a")
                                        PadPullableInputKey(virtual: .letterS, upper: "#", lower: "s")
                                        PadPullableInputKey(virtual: .letterD, upper: "$", lower: "d")
                                        PadPullableInputKey(virtual: .letterF, upper: "/", lower: "f")
                                        PadPullableInputKey(virtual: .letterG, upper: "（", lower: "g")
                                        PadPullableInputKey(virtual: .letterH, upper: "）", lower: "h")
                                        PadPullableInputKey(virtual: .letterJ, upper: "「", lower: "j")
                                        PadPullableInputKey(virtual: .letterK, upper: "」", lower: "k")
                                        PadPullableInputKey(virtual: .letterL, upper: "'", lower: "l")
                                }
                                MediumPadReturnKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0) {
                                MediumPadShiftKey(side: .leading, coefficient: 1.75)
                                Group {
                                        PadPullableInputKey(virtual: .letterZ, upper: "%", lower: "z")
                                        PadPullableInputKey(virtual: .letterX, upper: "-", lower: "x")
                                        PadPullableInputKey(virtual: .letterC, upper: "～", lower: "c")
                                        PadPullableInputKey(virtual: .letterV, upper: "…", lower: "v")
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
                                MediumPadShiftKey(side: .trailing, coefficient: 1.25)
                        }
                        HStack(spacing: 0) {
                                if context.needsInputModeSwitchKey {
                                        MediumPadGlobeKey(widthUnitTimes: 1.5)
                                } else {
                                        MediumPadTransformKey(destination: .numeric, side: .leading, coefficient: 1.5)
                                }
                                MediumPadLeftKey(widthUnitTimes: 1.5)
                                PadSpaceKey()
                                MediumPadRightKey(widthUnitTimes: 1.5)
                                MediumPadDismissKey(widthUnitTimes: 1.5)
                        }
                }
        }
}
