import SwiftUI

struct PadCantoneseKeyboard: View {

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
                                        PadPullableInputKey(upper: "1", lower: "q")
                                        PadPullableInputKey(upper: "2", lower: "w")
                                        PadPullableInputKey(upper: "3", lower: "e")
                                        PadPullableInputKey(upper: "4", lower: "r")
                                        PadPullableInputKey(upper: "5", lower: "t")
                                        PadPullableInputKey(upper: "6", lower: "y")
                                        PadPullableInputKey(upper: "7", lower: "u")
                                        PadPullableInputKey(upper: "8", lower: "i")
                                        PadPullableInputKey(upper: "9", lower: "o")
                                        PadPullableInputKey(upper: "0", lower: "p")
                                }
                                PadBackspaceKey(widthUnitTimes: 1)
                        }
                        HStack(spacing: 0) {
                                PlaceholderKey()
                                Group {
                                        PadPullableInputKey(upper: "@", lower: "a")
                                        PadPullableInputKey(upper: "#", lower: "s")
                                        PadPullableInputKey(upper: "$", lower: "d")
                                        PadPullableInputKey(upper: "/", lower: "f")
                                        PadPullableInputKey(upper: "（", lower: "g")
                                        PadPullableInputKey(upper: "）", lower: "h")
                                        PadPullableInputKey(upper: "「", lower: "j")
                                        PadPullableInputKey(upper: "」", lower: "k")
                                        PadPullableInputKey(upper: "'", lower: "l")
                                }
                                PadReturnKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0) {
                                PadShiftKey(widthUnitTimes: 1)
                                Group {
                                        PadPullableInputKey(upper: "%", lower: "z")
                                        PadPullableInputKey(upper: "-", lower: "x")
                                        PadPullableInputKey(upper: "～", lower: "c")
                                        PadPullableInputKey(upper: "…", lower: "v")
                                        PadPullableInputKey(upper: "、", lower: "b")
                                        PadPullableInputKey(upper: "；", lower: "n")
                                        PadPullableInputKey(upper: "：", lower: "m")
                                }
                                if context.keyboardCase.isUppercased {
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("！"), members: [KeyElement("！"), KeyElement("!", header: "半形")]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("？"), members: [KeyElement("？"), KeyElement("?", header: "半形")]))
                                } else {
                                        PadUpperLowerInputKey(keyLocale: .trailing, upper: "！", lower: "，", keyModel: KeyModel(primary: KeyElement("，"), members: [KeyElement("，"), KeyElement("！"), KeyElement(",", header: "半形"), KeyElement("!", header: "半形")]))
                                        PadUpperLowerInputKey(keyLocale: .trailing, upper: "？", lower: "。", keyModel: KeyModel(primary: KeyElement("。"), members: [KeyElement("。"), KeyElement("？"), KeyElement(".", header: "半形"), KeyElement("?", header: "半形")]))
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
                                PadRightKey(widthUnitTimes: 1.5)
                                PadDismissKey(widthUnitTimes: 1.5)
                        }
                }
        }
}
