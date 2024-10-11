import SwiftUI

struct AlphabeticKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        if context.inputStage.isBuffering {
                                CandidateBar()
                        } else {
                                ToolBar()
                        }
                        HStack(spacing: 0 ) {
                                LetterInputKey("q")
                                LetterInputKey("w")
                                LetterInputKey("e")
                                LetterInputKey("r")
                                LetterInputKey("t")
                                LetterInputKey("y")
                                LetterInputKey("u")
                                LetterInputKey("i")
                                LetterInputKey("o")
                                LetterInputKey("p")
                        }
                        HStack(spacing: 0) {
                                HiddenKey(key: .letterA)
                                Group {
                                        LetterInputKey("a")
                                        LetterInputKey("s")
                                        LetterInputKey("d")
                                        LetterInputKey("f")
                                        LetterInputKey("g")
                                        LetterInputKey("h")
                                        LetterInputKey("j")
                                        LetterInputKey("k")
                                        LetterInputKey("l")
                                }
                                HiddenKey(key: .letterL)
                        }
                        HStack(spacing: 0) {
                                ShiftKey()
                                HiddenKey(key: .letterZ)
                                Group {
                                        LetterInputKey("z")
                                        LetterInputKey("x")
                                        LetterInputKey("c")
                                        LetterInputKey("v")
                                        LetterInputKey("b")
                                        LetterInputKey("n")
                                        LetterInputKey("m")
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
