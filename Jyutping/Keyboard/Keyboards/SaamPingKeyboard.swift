import SwiftUI

struct SaamPingKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        if context.inputStage.isBuffering {
                                CandidateScrollBar()
                        } else {
                                ToolBar()
                        }
                        HStack(spacing: 0 ) {
                                DualLettersInputKey("aa")
                                LetterInputKey("w")
                                LetterInputKey("e")
                                DualLettersInputKey("oe")
                                LetterInputKey("t")
                                DualLettersInputKey("yu")
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
                                        DualLettersInputKey("gw")
                                        LetterInputKey("c")
                                        DualLettersInputKey("ng")
                                        LetterInputKey("b")
                                        LetterInputKey("n")
                                        LetterInputKey("m")
                                }
                                HiddenKey(key: .backspace)
                                BackspaceKey()
                        }
                        HStack(spacing: 0) {
                                if context.needsInputModeSwitchKey {
                                        TransformKey(destination: .numeric, widthUnitTimes: 1.5)
                                        GlobeKey()
                                        SpaceKey()
                                        RightKey()
                                        ReturnKey()
                                } else {
                                        TransformKey(destination: .numeric, widthUnitTimes: 1.5)
                                        LeftKey()
                                        SpaceKey()
                                        RightKey()
                                        ReturnKey()
                                }
                        }
                }
        }
}
