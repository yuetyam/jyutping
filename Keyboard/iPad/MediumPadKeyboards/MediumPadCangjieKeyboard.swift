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
                                MediumPadShiftKey(side: .leading, coefficient: 1.75)
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
                                MediumPadShiftKey(side: .trailing, coefficient: 1.25)
                        }
                        HStack(spacing: 0) {
                                if context.needsInputModeSwitchKey {
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
