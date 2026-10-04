import SwiftUI

struct PadCantoneseSymbolicKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        HStack(spacing: 0 ) {
                                Group {
                                        PadExpansibleInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("^"), members: [KeyElement("^"), KeyElement("＾", extras: [.init(PresetConstant.fullWidth, alignment: .top)])]))
                                        PadExpansibleInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("_"), members: [KeyElement("_"), KeyElement("＿", extras: [.init(PresetConstant.fullWidth, alignment: .top)])]))
                                        PadExpansibleInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("｜"), members: [KeyElement("｜"), KeyElement("|", extras: [.init(PresetConstant.halfWidth, alignment: .top)])]))
                                        PadExpansibleInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("\\"), members: [KeyElement("\\"), KeyElement("＼", extras: [.init(PresetConstant.fullWidth, alignment: .top)])]))
                                        PadExpansibleInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("<"), members: [KeyElement("<"), KeyElement("＜", extras: [.init(PresetConstant.fullWidth, alignment: .top)])]))
                                        PadExpansibleInputKey(side: .leading, unit: KeyUnit(primary: KeyElement(">"), members: [KeyElement(">"), KeyElement("＞", extras: [.init(PresetConstant.fullWidth, alignment: .top)])]))
                                        PadExpansibleInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("{"), members: [KeyElement("{"), KeyElement("｛", extras: [.init(PresetConstant.fullWidth, alignment: .top)])]))
                                        PadExpansibleInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("}"), members: [KeyElement("}"), KeyElement("｝", extras: [.init(PresetConstant.fullWidth, alignment: .top)])]))
                                        PadExpansibleInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement(","), members: [KeyElement(","), KeyElement("，", extras: [.init(PresetConstant.fullWidth, alignment: .top)])]))
                                        PadExpansibleInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("."), members: [KeyElement("."), KeyElement("．", extras: [.init(PresetConstant.fullWidth, alignment: .top)]), KeyElement("…")]))
                                }
                                PadBackspaceKey(widthUnitTimes: 1)
                        }
                        HStack(spacing: 0) {
                                Spacer()
                                Group {
                                        PadExpansibleInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("&"), members: [KeyElement("&"), KeyElement("＆", extras: [.init(PresetConstant.fullWidth, alignment: .top)]), KeyElement("§")]))
                                        PadExpansibleInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("¥"), members: [KeyElement("¥"), KeyElement("￥", extras: [.init(PresetConstant.fullWidth, alignment: .top)])]))
                                        PadExpansibleInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("€"), members: [KeyElement("€"), KeyElement("£")]))
                                        PadExpansibleInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("*"), members: [KeyElement("*"), KeyElement("＊", extras: [.init(PresetConstant.fullWidth, alignment: .top)]), KeyElement("×")]))
                                        PadExpansibleInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("【"), members: [KeyElement("【"), KeyElement("〔"), KeyElement("［"), KeyElement("[", extras: [.init(PresetConstant.halfWidth, alignment: .top)])]))
                                        PadExpansibleInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("】"), members: [KeyElement("】"), KeyElement("〕"), KeyElement("］"), KeyElement("]", extras: [.init(PresetConstant.halfWidth, alignment: .top)])]))
                                        PadExpansibleInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("『"), members: [KeyElement("『"), KeyElement("「")]))
                                        PadExpansibleInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("』"), members: [KeyElement("』"), KeyElement("」")]))
                                        PadExpansibleInputKey(
                                                side: .trailing,
                                                unit: KeyUnit(
                                                        primary: KeyElement("\""),
                                                        members: [
                                                                KeyElement("\"", extras: [.init("0022", alignment: .bottom)]),
                                                                KeyElement("\u{201D}", extras: [.init("右", alignment: .top), .init("201D", alignment: .bottom)]),
                                                                KeyElement("\u{201C}", extras: [.init("左", alignment: .top), .init("201C", alignment: .bottom)]),
                                                                KeyElement("\u{FF02}", extras: [.init(PresetConstant.fullWidth, alignment: .top), .init("FF02", alignment: .bottom)])
                                                        ]
                                                )
                                        )
                                }
                                PadReturnKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0) {
                                PadTransformKey(destination: .numeric, coefficient: 1)
                                Group {
                                        PadExpansibleInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("§"), members: [KeyElement("§"), KeyElement("&")]))
                                        PadExpansibleInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("\u{2014}"), members: [KeyElement("\u{2014}", extras: [.init("2014", alignment: .bottom)]), KeyElement("-")]))
                                        PadExpansibleInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("+"), members: [KeyElement("+"), KeyElement("＋", extras: [.init(PresetConstant.fullWidth, alignment: .top)])]))
                                        PadExpansibleInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("="), members: [KeyElement("="), KeyElement("＝", extras: [.init(PresetConstant.fullWidth, alignment: .top)])]))
                                        PadExpansibleInputKey(
                                                side: .leading,
                                                unit: KeyUnit(
                                                        primary: KeyElement("·"),
                                                        members: [
                                                                KeyElement("·", extras: [.init("間隔號", alignment: .top), .init("00B7", alignment: .bottom)]),
                                                                KeyElement("•", extras: [.init("項目符號", alignment: .top), .init("2022", alignment: .bottom)]),
                                                                KeyElement("\u{2027}", extras: [.init("連字點", alignment: .top), .init("2027", alignment: .bottom)]),
                                                                KeyElement("\u{FF65}", extras: [.init("半寬中點", alignment: .top), .init("FF65", alignment: .bottom)]),
                                                                KeyElement("\u{30FB}", extras: [.init("全寬中點", alignment: .top), .init("30FB", alignment: .bottom)])
                                                        ]
                                                )
                                        )
                                        PadExpansibleInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("《"), members: [KeyElement("《"), KeyElement("〈")]))
                                        PadExpansibleInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("》"), members: [KeyElement("》"), KeyElement("〉")]))
                                        PadExpansibleInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("！"), members: [KeyElement("！"), KeyElement("!", extras: [.init(PresetConstant.halfWidth, alignment: .top)])]))
                                        PadExpansibleInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("？"), members: [KeyElement("？"), KeyElement("?", extras: [.init(PresetConstant.halfWidth, alignment: .top)])]))
                                }
                                PadTransformKey(destination: .numeric, coefficient: 1)
                        }
                        HStack(spacing: 0) {
                                if context.needsInputModeSwitchKey {
                                        PadGlobeKey(widthUnitTimes: 1.5)
                                } else {
                                        PadTransformKey(destination: .primary, coefficient: 1.5)
                                }
                                PadTransformKey(destination: .primary, coefficient: 1.5)
                                PadSpaceKey()
                                PadTransformKey(destination: .primary, coefficient: 1.5)
                                PadDismissKey(widthUnitTimes: 1.5)
                        }
                }
        }
}
