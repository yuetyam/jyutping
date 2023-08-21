import SwiftUI

struct SmallPadAlphabeticKeyboard: View {

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
                                        PadLetterInputKey("q")
                                        PadLetterInputKey("w")
                                        PadLetterInputKey("e")
                                        PadLetterInputKey("r")
                                        PadLetterInputKey("t")
                                        PadLetterInputKey("y")
                                        PadLetterInputKey("u")
                                        PadLetterInputKey("i")
                                        PadLetterInputKey("o")
                                        PadLetterInputKey("p")
                                }
                                PadBackspaceKey(widthUnitTimes: 1)
                        }
                        HStack(spacing: 0) {
                                PlaceholderKey()
                                Group {
                                        PadLetterInputKey("a")
                                        PadLetterInputKey("s")
                                        PadLetterInputKey("d")
                                        PadLetterInputKey("f")
                                        PadLetterInputKey("g")
                                        PadLetterInputKey("h")
                                        PadLetterInputKey("j")
                                        PadLetterInputKey("k")
                                        PadLetterInputKey("l")
                                }
                                PadReturnKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0) {
                                PadShiftKey(widthUnitTimes: 1)
                                Group {
                                        PadLetterInputKey("z")
                                        PadLetterInputKey("x")
                                        PadLetterInputKey("c")
                                        PadLetterInputKey("v")
                                        PadLetterInputKey("b")
                                        PadLetterInputKey("n")
                                        PadLetterInputKey("m")
                                }
                                if context.inputMethodMode.isABC {
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement(","), members: [KeyElement(","), KeyElement("!")]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("."), members: [KeyElement("."), KeyElement("?")]))
                                } else {
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("，"), members: [KeyElement("，"), KeyElement("！")]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("。"), members: [KeyElement("。"), KeyElement("？")]))
                                }
                                PadShiftKey(widthUnitTimes: 1)
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
                                PadDismissKey()
                        }
                }
        }
}
