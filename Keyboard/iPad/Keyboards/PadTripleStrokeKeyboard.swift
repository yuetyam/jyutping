import SwiftUI

/// Cantonese SaamPing Layout. 粵拼三拼鍵盤佈局
struct PadTripleStrokeKeyboard: View {

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
                                        PadCompleteInputKey(keyLocale: .leading, upper: "1", keyModel: KeyModel(primary: KeyElement("aa"), members: [KeyElement("aa"), KeyElement("q")]))
                                        PadPullableInputKey(upper: "2", lower: "w")
                                        PadPullableInputKey(upper: "3", lower: "e")
                                        PadCompleteInputKey(keyLocale: .leading, upper: "4", keyModel: KeyModel(primary: KeyElement("oe", header: "eo"), members: [KeyElement("oe"), KeyElement("r"), KeyElement("eo")]))
                                        PadPullableInputKey(upper: "5", lower: "t")
                                        PadCompleteInputKey(keyLocale: .leading, upper: "6", keyModel: KeyModel(primary: KeyElement("yu"), members: [KeyElement("yu"), KeyElement("y")]))
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
                                        PadCompleteInputKey(keyLocale: .leading, upper: "%", keyModel: KeyModel(primary: KeyElement("z", header: "1"), members: [KeyElement("z"), KeyElement("1", footer: "陰平")]))
                                        PadCompleteInputKey(keyLocale: .leading, upper: "-", keyModel: KeyModel(primary: KeyElement("gw", header: "2"), members: [KeyElement("gw"), KeyElement("2", footer: "陰上"), KeyElement("x"), KeyElement("kw")]))
                                        PadCompleteInputKey(keyLocale: .leading, upper: "～", keyModel: KeyModel(primary: KeyElement("c", header: "3"), members: [KeyElement("c"), KeyElement("3", footer: "陰去")]))
                                        PadCompleteInputKey(keyLocale: .leading, upper: "…", keyModel: KeyModel(primary: KeyElement("ng", header: "4"), members: [KeyElement("ng"), KeyElement("4", footer: "陽平"), KeyElement("v")]))
                                        PadCompleteInputKey(keyLocale: .trailing, upper: "、", keyModel: KeyModel(primary: KeyElement("b", header: "5"), members: [KeyElement("b"), KeyElement("5", footer: "陽上")]))
                                        PadCompleteInputKey(keyLocale: .trailing, upper: "：", keyModel: KeyModel(primary: KeyElement("n", header: "6"), members: [KeyElement("n"), KeyElement("6", footer: "陽去")]))
                                        PadCompleteInputKey(keyLocale: .trailing, upper: "：", keyModel: KeyModel(primary: KeyElement("m"), members: [KeyElement("m"), KeyElement("kw")]))
                                }
                                if context.keyboardCase.isUppercased {
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("！"), members: [KeyElement("！"), KeyElement("!", header: PresetConstant.halfWidth)]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("？"), members: [KeyElement("？"), KeyElement("?", header: PresetConstant.halfWidth)]))
                                } else {
                                        PadUpperLowerInputKey(keyLocale: .trailing, upper: "！", lower: "，", keyModel: KeyModel(primary: KeyElement("，"), members: [KeyElement("，"), KeyElement("！"), KeyElement(",", header: PresetConstant.halfWidth), KeyElement("!", header: PresetConstant.halfWidth)]))
                                        PadUpperLowerInputKey(
                                                keyLocale: .trailing,
                                                upper: "？",
                                                lower: "。",
                                                keyModel: KeyModel(
                                                        primary: KeyElement("。"),
                                                        members: [
                                                                KeyElement("。"),
                                                                KeyElement("？"),
                                                                KeyElement("｡", header: PresetConstant.halfWidth),
                                                                KeyElement("?", header: PresetConstant.halfWidth),
                                                                KeyElement(".", header: "英文半寬"),
                                                                KeyElement("．", header: "英文全寬")
                                                        ]
                                                )
                                        )
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
