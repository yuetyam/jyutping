import SwiftUI

struct PadStrokeKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        if context.inputStage.isBuffering {
                                CandidateScrollBar()
                        } else {
                                ToolBar()
                        }
                        HStack(spacing: 0 ) {
                                Group {
                                        PadStrokeInputKey("q")
                                        PadStrokeInputKey("w")
                                        PadStrokeInputKey("e")
                                        PadStrokeInputKey("r")
                                        PadStrokeInputKey("t")
                                        PadStrokeInputKey("y")
                                        PadStrokeInputKey("u")
                                        PadStrokeInputKey("i")
                                        PadStrokeInputKey("o")
                                        PadStrokeInputKey("p")
                                }
                                PadBackspaceKey(widthUnitTimes: 1)
                        }
                        HStack(spacing: 0) {
                                PlaceholderKey()
                                Group {
                                        PadStrokeInputKey("a")
                                        PadStrokeInputKey("s")
                                        PadStrokeInputKey("d")
                                        PadStrokeInputKey("f")
                                        PadStrokeInputKey("g")
                                        PadStrokeInputKey("h")
                                        PadStrokeInputKey("j")
                                        PadStrokeInputKey("k")
                                        PadStrokeInputKey("l")
                                }
                                PadReturnKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0) {
                                PadShiftKey(widthUnitTimes: 1).hidden()
                                Group {
                                        PadStrokeInputKey("z")
                                        PadStrokeInputKey("x")
                                        PadStrokeInputKey("c")
                                        PadStrokeInputKey("v")
                                        PadStrokeInputKey("b")
                                        PadStrokeInputKey("n")
                                        PadStrokeInputKey("m")
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
