import SwiftUI

struct StrokeKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        if context.inputStage.isBuffering {
                                CandidateBar()
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
                        switch (context.keyboardInterface.isPadFloating, context.needsInputModeSwitchKey) {
                        case (true, true):
                                HStack(spacing: 0) {
                                        GlobeKey()
                                        TransformKey(destination: .numeric, widthUnitTimes: 2)
                                        SpaceKey()
                                        RightKey()
                                        ReturnKey()
                                }
                        case (true, false):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .numeric, widthUnitTimes: 2)
                                        LeftKey()
                                        SpaceKey()
                                        RightKey()
                                        ReturnKey()
                                }
                        case (false, true):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .numeric, widthUnitTimes: 2)
                                        GlobeKey()
                                        SpaceKey()
                                        RightKey()
                                        ReturnKey()
                                }
                        case (false, false):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .numeric, widthUnitTimes: 2)
                                        LeftKey()
                                        SpaceKey()
                                        RightKey()
                                        ReturnKey()
                                }
                        }
                }
        }
}
