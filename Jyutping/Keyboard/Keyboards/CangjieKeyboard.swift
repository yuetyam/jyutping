import SwiftUI

struct CangjieKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        if context.inputStage.isBuffering {
                                if #available(iOSApplicationExtension 17.0, *) {
                                        CandidateScrollBar()
                                                .overlay(alignment: .topLeading) {
                                                        Text(verbatim: context.iOS17BufferText).font(.caption2).foregroundStyle(Color.secondary)
                                                }
                                } else {
                                        CandidateScrollBar()
                                }
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
                                NumericKey()
                                CommaKey()
                                SpaceKey()
                                PeriodKey()
                                ReturnKey()
                        }
                }
        }
}
