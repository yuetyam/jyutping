import SwiftUI
import CoreIME

struct PadCangjieKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        CandidateBar()
                        HStack(spacing: 0 ) {
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
                                PadBackspaceKey(widthUnitTimes: 1)
                        }
                        HStack(spacing: 0) {
                                Spacer()
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
                                PadReturnKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0) {
                                PadShiftKey(widthUnitTimes: 1).hidden()
                                Group {
                                        PadCangjieInputKey(.letterZ)
                                        PadCangjieInputKey(.letterX)
                                        PadCangjieInputKey(.letterC)
                                        PadCangjieInputKey(.letterV)
                                        PadCangjieInputKey(.letterB)
                                        PadCangjieInputKey(.letterN)
                                        PadCangjieInputKey(.letterM)
                                }
                                PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("，"), members: [KeyElement("，"), KeyElement("！")])).hidden()
                                PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("。"), members: [KeyElement("。"), KeyElement("？")])).hidden()
                                PadShiftKey(widthUnitTimes: 1).hidden()
                        }
                        HStack(spacing: 0) {
                                if context.needsInputModeSwitchKey {
                                        PadGlobeKey(widthUnitTimes: 1.5)
                                } else {
                                        PadTransformKey(destination: .numeric, widthUnitTimes: 1.5)
                                }
                                PadTransformKey(destination: .numeric, widthUnitTimes: 1.5)
                                PadSpaceKey()
                                PadTransformKey(destination: .numeric, widthUnitTimes: 1.5)
                                PadDismissKey(widthUnitTimes: 1.5)
                        }
                }
        }
}
