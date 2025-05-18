import SwiftUI
import CoreIME

struct PadStrokeKeyboard: View {

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
                                PadBackspaceKey(widthUnitTimes: 1)
                        }
                        HStack(spacing: 0) {
                                PlaceholderKey()
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
                                PadReturnKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0) {
                                PadShiftKey(widthUnitTimes: 1).hidden()
                                Group {
                                        PadStrokeInputKey(.letterZ)
                                        PadStrokeInputKey(.letterX)
                                        PadStrokeInputKey(.letterC)
                                        PadStrokeInputKey(.letterV)
                                        PadStrokeInputKey(.letterB)
                                        PadStrokeInputKey(.letterN)
                                        PadStrokeInputKey(.letterM)
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
