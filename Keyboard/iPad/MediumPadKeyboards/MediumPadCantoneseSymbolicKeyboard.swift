import SwiftUI

struct MediumPadCantoneseSymbolicKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        HStack(spacing: 0 ) {
                                MediumPadTabKey(widthUnitTimes: 1)
                                Group {
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyUnit(primary: KeyElement("^"), members: [KeyElement("^"), KeyElement("＾", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyUnit(primary: KeyElement("_"), members: [KeyElement("_"), KeyElement("＿", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyUnit(primary: KeyElement("｜"), members: [KeyElement("｜"), KeyElement("|", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyUnit(primary: KeyElement("\\"), members: [KeyElement("\\"), KeyElement("＼", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyUnit(primary: KeyElement("<"), members: [KeyElement("<"), KeyElement("＜", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyUnit(primary: KeyElement(">"), members: [KeyElement(">"), KeyElement("＞", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyUnit(primary: KeyElement("{"), members: [KeyElement("{"), KeyElement("｛", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyUnit(primary: KeyElement("}"), members: [KeyElement("}"), KeyElement("｝", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyUnit(primary: KeyElement(","), members: [KeyElement(","), KeyElement("，", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyUnit(primary: KeyElement("."), members: [KeyElement("."), KeyElement("．", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]), KeyElement("…")]))
                                }
                                MediumPadBackspaceKey(widthUnitTimes: 1)
                        }
                        HStack(spacing: 0) {
                                Spacer()
                                Group {
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyUnit(primary: KeyElement("&"), members: [KeyElement("&"), KeyElement("＆", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]), KeyElement("§")]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyUnit(primary: KeyElement("¥"), members: [KeyElement("¥"), KeyElement("￥", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyUnit(primary: KeyElement("€"), members: [KeyElement("€"), KeyElement("£")]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyUnit(primary: KeyElement("*"), members: [KeyElement("*"), KeyElement("＊", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]), KeyElement("×")]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyUnit(primary: KeyElement("【"), members: [KeyElement("【"), KeyElement("〔"), KeyElement("［"), KeyElement("[", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyUnit(primary: KeyElement("】"), members: [KeyElement("】"), KeyElement("〕"), KeyElement("］"), KeyElement("]", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyUnit(primary: KeyElement("『"), members: [KeyElement("『"), KeyElement("「")]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyUnit(primary: KeyElement("』"), members: [KeyElement("』"), KeyElement("」")]))
                                        PadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("\""),
                                                        members: [
                                                                KeyElement("\"", extras: [.init("0022", alignment: .bottomTrailing)]),
                                                                KeyElement("\u{201D}", extras: [.init("右", alignment: .topTrailing), .init("201D", alignment: .bottomTrailing)]),
                                                                KeyElement("\u{201C}", extras: [.init("左", alignment: .topTrailing), .init("201C", alignment: .bottomTrailing)]),
                                                                KeyElement("\u{FF02}", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing), .init("FF02", alignment: .bottomTrailing)])
                                                        ]
                                                )
                                        )
                                }
                                MediumPadReturnKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0) {
                                MediumPadTransformKey(destination: .numeric, side: .leading, coefficient: 1.75)
                                Group {
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyUnit(primary: KeyElement("§"), members: [KeyElement("§"), KeyElement("&")]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyUnit(primary: KeyElement("\u{2014}"), members: [KeyElement("\u{2014}", extras: [.init("2014", alignment: .bottomTrailing)]), KeyElement("-")]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyUnit(primary: KeyElement("+"), members: [KeyElement("+"), KeyElement("＋", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyUnit(primary: KeyElement("="), members: [KeyElement("="), KeyElement("＝", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)])]))
                                        PadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("·"),
                                                        members: [
                                                                KeyElement("·", extras: [.init("間隔號", alignment: .topTrailing), .init("00B7", alignment: .bottomTrailing)]),
                                                                KeyElement("•", extras: [.init("項目符號", alignment: .topTrailing), .init("2022", alignment: .bottomTrailing)]),
                                                                KeyElement("\u{2027}", extras: [.init("連字點", alignment: .topTrailing), .init("2027", alignment: .bottomTrailing)]),
                                                                KeyElement("\u{FF65}", extras: [.init("半寬中點", alignment: .topTrailing), .init("FF65", alignment: .bottomTrailing)]),
                                                                KeyElement("\u{30FB}", extras: [.init("全寬中點", alignment: .topTrailing), .init("30FB", alignment: .bottomTrailing)])
                                                        ]
                                                )
                                        )
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyUnit(primary: KeyElement("《"), members: [KeyElement("《"), KeyElement("〈")]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyUnit(primary: KeyElement("》"), members: [KeyElement("》"), KeyElement("〉")]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyUnit(primary: KeyElement("！"), members: [KeyElement("！"), KeyElement("!", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyUnit(primary: KeyElement("？"), members: [KeyElement("？"), KeyElement("?", extras: [.init(PresetConstant.halfWidth, alignment: .topTrailing)])]))
                                }
                                MediumPadTransformKey(destination: .numeric, side: .trailing, coefficient: 1.25)
                        }
                        HStack(spacing: 0) {
                                if context.needsInputModeSwitchKey {
                                        MediumPadGlobeKey(widthUnitTimes: 1.5)
                                } else {
                                        MediumPadTransformKey(destination: .primary, side: .leading, coefficient: 1.5)
                                }
                                MediumPadTransformKey(destination: .primary, side: .leading, coefficient: 1.5)
                                PadSpaceKey()
                                MediumPadTransformKey(destination: .primary, side: .trailing, coefficient: 1.5)
                                MediumPadDismissKey(widthUnitTimes: 1.5)
                        }
                }
        }
}
