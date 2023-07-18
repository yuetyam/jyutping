import SwiftUI

struct StrokeKeyboard: View {

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
                                NumericKey()
                                CommaKey()
                                SpaceKey()
                                PeriodKey()
                                ReturnKey()
                        }
                }
        }
}
