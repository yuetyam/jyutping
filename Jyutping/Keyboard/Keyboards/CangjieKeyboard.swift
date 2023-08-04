import SwiftUI

struct CangjieKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        if context.inputStage.isBuffering {
                                CandidateScrollBar()
                        } else {
                                ToolBar()
                        }
                        HStack(spacing: 0 ) {
                                CangjieInputKey("q")
                                CangjieInputKey("w")
                                CangjieInputKey("e")
                                CangjieInputKey("r")
                                CangjieInputKey("t")
                                CangjieInputKey("y")
                                CangjieInputKey("u")
                                CangjieInputKey("i")
                                CangjieInputKey("o")
                                CangjieInputKey("p")
                        }
                        HStack(spacing: 0) {
                                HiddenKey(key: .letterA)
                                Group {
                                        CangjieInputKey("a")
                                        CangjieInputKey("s")
                                        CangjieInputKey("d")
                                        CangjieInputKey("f")
                                        CangjieInputKey("g")
                                        CangjieInputKey("h")
                                        CangjieInputKey("j")
                                        CangjieInputKey("k")
                                        CangjieInputKey("l")
                                }
                                HiddenKey(key: .letterL)
                        }
                        HStack(spacing: 0) {
                                ShiftKey()
                                HiddenKey(key: .letterZ)
                                Group {
                                        CangjieInputKey("z")
                                        CangjieInputKey("x")
                                        CangjieInputKey("c")
                                        CangjieInputKey("v")
                                        CangjieInputKey("b")
                                        CangjieInputKey("n")
                                        CangjieInputKey("m")
                                }
                                HiddenKey(key: .backspace)
                                BackspaceKey()
                        }
                        HStack(spacing: 0) {
                                if context.needsInputModeSwitchKey {
                                        TransformKey(destination: .numeric, widthUnitTimes: 1.5)
                                        GlobeKey()
                                        SpaceKey()
                                        CommaKey()
                                        ReturnKey()
                                } else {
                                        TransformKey(destination: .numeric, widthUnitTimes: 1.5)
                                        CommaKey()
                                        SpaceKey()
                                        PeriodKey()
                                        ReturnKey()
                                }
                        }
                }
        }
}
