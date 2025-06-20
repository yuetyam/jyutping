import SwiftUI
import CoreIME

struct MediumPadCangjieKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        CandidateBar()
                        HStack(spacing: 0 ) {
                                MediumPadTabKey(widthUnitTimes: 1)
                                Group {
                                        PadCangjieInputKey(.letterQ)
                                        PadCangjieInputKey(.letterW)
                                        PadCangjieInputKey(.letterE)
                                        PadCangjieInputKey(.letterR)
                                        PadCangjieInputKey(.letterT)
                                        PadCangjieInputKey(.letterY)
                                        PadCangjieInputKey(.letterU)
                                        PadCangjieInputKey(.letterI)
                                        PadCangjieInputKey(.letterO)
                                        PadCangjieInputKey(.letterP)
                                }
                                MediumPadBackspaceKey(widthUnitTimes: 1)
                        }
                        HStack(spacing: 0) {
                                MediumPadCapsLockKey(widthUnitTimes: 1.5)
                                Group {
                                        PadCangjieInputKey(.letterA)
                                        PadCangjieInputKey(.letterS)
                                        PadCangjieInputKey(.letterD)
                                        PadCangjieInputKey(.letterF)
                                        PadCangjieInputKey(.letterG)
                                        PadCangjieInputKey(.letterH)
                                        PadCangjieInputKey(.letterJ)
                                        PadCangjieInputKey(.letterK)
                                        PadCangjieInputKey(.letterL)
                                }
                                MediumPadReturnKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0) {
                                MediumPadShiftKey(keyLocale: .leading, widthUnitTimes: 1.75)
                                Group {
                                        PadCangjieInputKey(.letterZ)
                                        PadCangjieInputKey(.letterX)
                                        PadCangjieInputKey(.letterC)
                                        PadCangjieInputKey(.letterV)
                                        PadCangjieInputKey(.letterB)
                                        PadCangjieInputKey(.letterN)
                                        PadCangjieInputKey(.letterM)
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
