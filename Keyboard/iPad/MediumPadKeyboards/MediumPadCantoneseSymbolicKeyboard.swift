import SwiftUI

struct MediumPadCantoneseSymbolicKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        HStack(spacing: 0 ) {
                                MediumPadTabKey(widthUnitTimes: 1)
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
                                MediumPadBackspaceKey(widthUnitTimes: 1)
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
                                MediumPadReturnKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0) {
                                MediumPadTransformKey(destination: .numeric, side: .leading, coefficient: 1.75)
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
                                MediumPadTransformKey(destination: .numeric, side: .trailing, coefficient: 1.25)
                        }
                        HStack(spacing: 0) {
                                if context.needsGlobeKey {
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
