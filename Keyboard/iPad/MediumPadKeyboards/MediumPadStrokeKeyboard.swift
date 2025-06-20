import SwiftUI
import CoreIME

struct MediumPadStrokeKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        CandidateBar()
                        HStack(spacing: 0 ) {
                                MediumPadTabKey(widthUnitTimes: 1)
                                Group {
                                        PadStrokeInputKey(.letterQ)
                                        PadStrokeInputKey(.letterW)
                                        PadStrokeInputKey(.letterE)
                                        PadStrokeInputKey(.letterR)
                                        PadStrokeInputKey(.letterT)
                                        PadStrokeInputKey(.letterY)
                                        PadStrokeInputKey(.letterU)
                                        PadStrokeInputKey(.letterI)
                                        PadStrokeInputKey(.letterO)
                                        PadStrokeInputKey(.letterP)
                                }
                                MediumPadBackspaceKey(widthUnitTimes: 1)
                        }
                        HStack(spacing: 0) {
                                MediumPadCapsLockKey(widthUnitTimes: 1.5)
                                Group {
                                        PadStrokeInputKey(.letterA)
                                        PadStrokeInputKey(.letterS)
                                        PadStrokeInputKey(.letterD)
                                        PadStrokeInputKey(.letterF)
                                        PadStrokeInputKey(.letterG)
                                        PadStrokeInputKey(.letterH)
                                        PadStrokeInputKey(.letterJ)
                                        PadStrokeInputKey(.letterK)
                                        PadStrokeInputKey(.letterL)
                                }
                                MediumPadReturnKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0) {
                                MediumPadShiftKey(keyLocale: .leading, widthUnitTimes: 1.75)
                                Group {
                                        PadStrokeInputKey(.letterZ)
                                        PadStrokeInputKey(.letterX)
                                        PadStrokeInputKey(.letterC)
                                        PadStrokeInputKey(.letterV)
                                        PadStrokeInputKey(.letterB)
                                        PadStrokeInputKey(.letterN)
                                        PadStrokeInputKey(.letterM)
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
                                MediumPadTransformKey(destination: .numeric, keyLocale: .leading, widthUnitTimes: 1.5)
                                PadSpaceKey()
                                MediumPadTransformKey(destination: .numeric, keyLocale: .trailing, widthUnitTimes: 1.5)
                                MediumPadDismissKey(widthUnitTimes: 1.5)
                        }
                }
        }
}
