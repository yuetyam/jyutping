import SwiftUI

struct StrokeKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        if context.inputStage.isBuffering {
                                CandidateScrollBar()
                        } else {
                                ToolBar()
                        }
                        HStack(spacing: 0 ) {
                                StrokeInputKey("q")
                                StrokeInputKey("w")
                                StrokeInputKey("e")
                                StrokeInputKey("r")
                                StrokeInputKey("t")
                                StrokeInputKey("y")
                                StrokeInputKey("u")
                                StrokeInputKey("i")
                                StrokeInputKey("o")
                                StrokeInputKey("p")
                        }
                        HStack(spacing: 0) {
                                HiddenKey(key: .letterA)
                                Group {
                                        StrokeInputKey("a")
                                        StrokeInputKey("s")
                                        StrokeInputKey("d")
                                        StrokeInputKey("f")
                                        StrokeInputKey("g")
                                        StrokeInputKey("h")
                                        StrokeInputKey("j")
                                        StrokeInputKey("k")
                                        StrokeInputKey("l")
                                }
                                HiddenKey(key: .letterL)
                        }
                        HStack(spacing: 0) {
                                ShiftKey()
                                HiddenKey(key: .letterZ)
                                Group {
                                        StrokeInputKey("z")
                                        StrokeInputKey("x")
                                        StrokeInputKey("c")
                                        StrokeInputKey("v")
                                        StrokeInputKey("b")
                                        StrokeInputKey("n")
                                        StrokeInputKey("m")
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
