import SwiftUI

struct MediumPadCantoneseSymbolicKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        HStack(spacing: 0 ) {
                                MediumPadTabKey(widthUnitTimes: 1)
                                Group {
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("^"), members: [KeyElement("^"), KeyElement("＾", header: PresetConstant.fullWidth)]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("_"), members: [KeyElement("_"), KeyElement("＿", header: PresetConstant.fullWidth)]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("｜"), members: [KeyElement("｜"), KeyElement("|", header: PresetConstant.halfWidth)]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("\\"), members: [KeyElement("\\"), KeyElement("＼", header: PresetConstant.fullWidth)]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("<"), members: [KeyElement("<"), KeyElement("＜", header: PresetConstant.fullWidth)]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement(">"), members: [KeyElement(">"), KeyElement("＞", header: PresetConstant.fullWidth)]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("{"), members: [KeyElement("{"), KeyElement("｛", header: PresetConstant.fullWidth)]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("}"), members: [KeyElement("}"), KeyElement("｝", header: PresetConstant.fullWidth)]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement(","), members: [KeyElement(","), KeyElement("，", header: PresetConstant.fullWidth)]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("."), members: [KeyElement("."), KeyElement("．", header: PresetConstant.fullWidth), KeyElement("…")]))
                                }
                                MediumPadBackspaceKey(widthUnitTimes: 1)
                        }
                        HStack(spacing: 0) {
                                Spacer()
                                Group {
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("&"), members: [KeyElement("&"), KeyElement("＆", header: PresetConstant.fullWidth), KeyElement("§")]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("¥"), members: [KeyElement("¥"), KeyElement("￥", header: PresetConstant.fullWidth)]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("€"), members: [KeyElement("€"), KeyElement("£")]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("*"), members: [KeyElement("*"), KeyElement("＊", header: PresetConstant.fullWidth)]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("【"), members: [KeyElement("【"), KeyElement("〔"), KeyElement("［"), KeyElement("[", header: PresetConstant.halfWidth)]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("】"), members: [KeyElement("】"), KeyElement("〕"), KeyElement("］"), KeyElement("]", header: PresetConstant.halfWidth)]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("『"), members: [KeyElement("『"), KeyElement("「")]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("』"), members: [KeyElement("』"), KeyElement("」")]))
                                        PadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("\""),
                                                        members: [
                                                                KeyElement("\"", footer: "0022"),
                                                                KeyElement("\u{201D}", header: "右", footer: "201D"),
                                                                KeyElement("\u{201C}", header: "左", footer: "201C"),
                                                                KeyElement("\u{FF02}", header: PresetConstant.fullWidth, footer: "FF02")
                                                        ]
                                                )
                                        )
                                }
                                MediumPadReturnKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0) {
                                MediumPadTransformKey(destination: .numeric, keyLocale: .leading, widthUnitTimes: 1.75)
                                Group {
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("§"), members: [KeyElement("§"), KeyElement("&")]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("\u{2014}"), members: [KeyElement("\u{2014}", footer: "2014"), KeyElement("-")]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("+"), members: [KeyElement("+"), KeyElement("＋", header: PresetConstant.fullWidth)]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("="), members: [KeyElement("="), KeyElement("＝", header: PresetConstant.fullWidth)]))
                                        PadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("·"),
                                                        members: [
                                                                KeyElement("·", header: "間隔號", footer: "00B7"),
                                                                KeyElement("•", header: "項目符號", footer: "2022"),
                                                                KeyElement("\u{2027}", header: "連字點", footer: "2027"),
                                                                KeyElement("\u{FF65}", header: "半寬中點", footer: "FF65"),
                                                                KeyElement("\u{30FB}", header: "全寬中點", footer: "30FB")
                                                        ]
                                                )
                                        )
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("《"), members: [KeyElement("《"), KeyElement("〈")]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("》"), members: [KeyElement("》"), KeyElement("〉")]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("！"), members: [KeyElement("！"), KeyElement("!", header: PresetConstant.halfWidth)]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("？"), members: [KeyElement("？"), KeyElement("?", header: PresetConstant.halfWidth)]))
                                }
                                MediumPadTransformKey(destination: .numeric, keyLocale: .trailing, widthUnitTimes: 1.25)
                        }
                        HStack(spacing: 0) {
                                if context.needsInputModeSwitchKey {
                                        MediumPadGlobeKey(widthUnitTimes: 1.5)
                                } else {
                                        MediumPadTransformKey(destination: .alphabetic, keyLocale: .leading, widthUnitTimes: 1.5)
                                }
                                MediumPadTransformKey(destination: .alphabetic, keyLocale: .leading, widthUnitTimes: 1.5)
                                PadSpaceKey()
                                MediumPadTransformKey(destination: .alphabetic, keyLocale: .trailing, widthUnitTimes: 1.5)
                                MediumPadDismissKey(widthUnitTimes: 1.5)
                        }
                }
        }
}
