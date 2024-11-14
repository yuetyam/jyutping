import SwiftUI

struct PadCangjieKeyboard: View {

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
                                        PadCangjieInputKey("q")
                                        PadCangjieInputKey("w")
                                        PadCangjieInputKey("e")
                                        PadCangjieInputKey("r")
                                        PadCangjieInputKey("t")
                                        PadCangjieInputKey("y")
                                        PadCangjieInputKey("u")
                                        PadCangjieInputKey("i")
                                        PadCangjieInputKey("o")
                                        PadCangjieInputKey("p")
                                }
                                PadBackspaceKey(widthUnitTimes: 1)
                        }
                        HStack(spacing: 0) {
                                PlaceholderKey()
                                Group {
                                        PadCangjieInputKey("a")
                                        PadCangjieInputKey("s")
                                        PadCangjieInputKey("d")
                                        PadCangjieInputKey("f")
                                        PadCangjieInputKey("g")
                                        PadCangjieInputKey("h")
                                        PadCangjieInputKey("j")
                                        PadCangjieInputKey("k")
                                        PadCangjieInputKey("l")
                                }
                                PadReturnKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0) {
                                PadShiftKey(widthUnitTimes: 1).hidden()
                                Group {
                                        PadCangjieInputKey("z")
                                        PadCangjieInputKey("x")
                                        PadCangjieInputKey("c")
                                        PadCangjieInputKey("v")
                                        PadCangjieInputKey("b")
                                        PadCangjieInputKey("n")
                                        PadCangjieInputKey("m")
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
