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
                                MediumPadShiftKey(side: .leading, coefficient: 1.75)
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
                                if context.needsGlobeKey {
                                        MediumPadGlobeKey(widthUnitTimes: 1.5)
                                } else {
                                        MediumPadTransformKey(destination: .numeric, side: .leading, coefficient: 1.5)
                                }
                                MediumPadTransformKey(destination: .numeric, side: .leading, coefficient: 1.5)
                                PadSpaceKey()
                                MediumPadTransformKey(destination: .numeric, side: .trailing, coefficient: 1.5)
                                MediumPadDismissKey(widthUnitTimes: 1.5)
                        }
                }
        }
}
