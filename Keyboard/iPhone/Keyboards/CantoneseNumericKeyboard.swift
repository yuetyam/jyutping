import SwiftUI

struct CantoneseNumericKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        HStack(spacing: 0) {
                                ExpansibleInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("1"),
                                                           members: [
                                                                KeyElement("1"),
                                                                KeyElement("１", header: Constant.fullWidth),
                                                                KeyElement("壹"),
                                                                KeyElement("¹", header: "上標"),
                                                                KeyElement("₁", header: "下標"),
                                                                KeyElement("①")
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("2"),
                                                           members: [
                                                                KeyElement("2"),
                                                                KeyElement("２", header: Constant.fullWidth),
                                                                KeyElement("貳"),
                                                                KeyElement("²", header: "上標"),
                                                                KeyElement("₂", header: "下標"),
                                                                KeyElement("②")
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("3"),
                                                           members: [
                                                                KeyElement("3"),
                                                                KeyElement("３", header: Constant.fullWidth),
                                                                KeyElement("叁"),
                                                                KeyElement("³", header: "上標"),
                                                                KeyElement("₃", header: "下標"),
                                                                KeyElement("③")
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("4"),
                                                           members: [
                                                                KeyElement("4"),
                                                                KeyElement("４", header: Constant.fullWidth),
                                                                KeyElement("肆"),
                                                                KeyElement("⁴", header: "上標"),
                                                                KeyElement("₄", header: "下標"),
                                                                KeyElement("④")
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("5"),
                                                           members: [
                                                                KeyElement("5"),
                                                                KeyElement("５", header: Constant.fullWidth),
                                                                KeyElement("伍"),
                                                                KeyElement("⁵", header: "上標"),
                                                                KeyElement("₅", header: "下標"),
                                                                KeyElement("⑤")
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("6"),
                                                           members: [
                                                                KeyElement("6"),
                                                                KeyElement("６", header: Constant.fullWidth),
                                                                KeyElement("陸"),
                                                                KeyElement("⁶", header: "上標"),
                                                                KeyElement("₆", header: "下標"),
                                                                KeyElement("⑥")
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("7"),
                                                           members: [
                                                                KeyElement("7"),
                                                                KeyElement("７", header: Constant.fullWidth),
                                                                KeyElement("柒"),
                                                                KeyElement("⁷", header: "上標"),
                                                                KeyElement("₇", header: "下標"),
                                                                KeyElement("⑦")
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("8"),
                                                           members: [
                                                                KeyElement("8"),
                                                                KeyElement("８", header: Constant.fullWidth),
                                                                KeyElement("捌"),
                                                                KeyElement("⁸", header: "上標"),
                                                                KeyElement("₈", header: "下標"),
                                                                KeyElement("⑧")
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("9"),
                                                           members: [
                                                                KeyElement("9"),
                                                                KeyElement("９", header: Constant.fullWidth),
                                                                KeyElement("玖"),
                                                                KeyElement("⁹", header: "上標"),
                                                                KeyElement("₉", header: "下標"),
                                                                KeyElement("⑨")
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("0"),
                                                           members: [
                                                                KeyElement("0"),
                                                                KeyElement("０", header: Constant.fullWidth),
                                                                KeyElement("零"),
                                                                KeyElement("⁰", header: "上標"),
                                                                KeyElement("₀", header: "下標"),
                                                                KeyElement("⓪"),
                                                                KeyElement("拾"),
                                                                KeyElement("°", header: "度")
                                                           ])
                                )
                        }
                        HStack(spacing: 0) {
                                ExpansibleInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("-"),
                                                           members: [
                                                                KeyElement("-"),
                                                                KeyElement("－", header: Constant.fullWidth, footer: "FF0D"),
                                                                KeyElement("—", footer: "2014"),
                                                                KeyElement("–", footer: "2013"),
                                                                KeyElement("•", footer: "2022")
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("/"),
                                                           members: [
                                                                KeyElement("/"),
                                                                KeyElement("／", header: Constant.fullWidth),
                                                                KeyElement("\\"),
                                                                KeyElement("÷")
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("："),
                                                           members: [
                                                                KeyElement("："),
                                                                KeyElement(":", header: Constant.halfWidth)
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("；"),
                                                           members: [
                                                                KeyElement("；"),
                                                                KeyElement(";", header: Constant.halfWidth)
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("（"),
                                                           members: [
                                                                KeyElement("（"),
                                                                KeyElement("(", header: Constant.halfWidth)
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("）"),
                                                           members: [
                                                                KeyElement("）"),
                                                                KeyElement(")", header: Constant.halfWidth)
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("$"),
                                                           members: [
                                                                KeyElement("$"),
                                                                KeyElement("€"),
                                                                KeyElement("£"),
                                                                KeyElement("¥"),
                                                                KeyElement("₩"),
                                                                KeyElement("₽"),
                                                                KeyElement("¢")
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("@"),
                                                           members: [
                                                                KeyElement("@"),
                                                                KeyElement("＠", header: Constant.fullWidth)
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("「"),
                                                           members: [
                                                                KeyElement("「"),
                                                                KeyElement("『"),
                                                                KeyElement("\u{0022}", footer: "0022"),
                                                                KeyElement("\u{201C}", footer: "201C"),
                                                                KeyElement("\u{2018}", footer: "2018"),
                                                                KeyElement("﹁", header: Constant.verticalText),
                                                                KeyElement("﹃", header: Constant.verticalText)
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("」"),
                                                           members: [
                                                                KeyElement("」"),
                                                                KeyElement("』"),
                                                                KeyElement("\u{0022}", footer: "0022"),
                                                                KeyElement("\u{201D}", footer: "201D"),
                                                                KeyElement("\u{2019}", footer: "2019"),
                                                                KeyElement("﹂", header: Constant.verticalText),
                                                                KeyElement("﹄", header: Constant.verticalText)
                                                           ])
                                )
                        }
                        HStack(spacing: 0) {
                                TransformKey(destination: .symbolic, widthUnitTimes: 1.3)
                                PlaceholderKey()
                                ExpansibleInputKey(
                                        keyLocale: .leading,
                                        widthUnitTimes: 1.2,
                                        keyModel: KeyModel(primary: KeyElement("。"),
                                                           members: [
                                                                KeyElement("。"),
                                                                KeyElement("｡", header: Constant.halfWidth),
                                                                KeyElement("⋯", footer: "22EF"),
                                                                KeyElement("⋯⋯", footer: "22EF*2"),
                                                                KeyElement("…", footer: "2026"),
                                                                KeyElement("……", footer: "2026*2")
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .leading,
                                        widthUnitTimes: 1.2,
                                        keyModel: KeyModel(primary: KeyElement("，"),
                                                           members: [
                                                                KeyElement("，"),
                                                                KeyElement(",", header: Constant.halfWidth)
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .leading,
                                        widthUnitTimes: 1.2,
                                        keyModel: KeyModel(primary: KeyElement("、"),
                                                           members: [
                                                                KeyElement("、"),
                                                                KeyElement("､", header: Constant.halfWidth)
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
                                        widthUnitTimes: 1.2,
                                        keyModel: KeyModel(primary: KeyElement("？"),
                                                           members: [
                                                                KeyElement("？"),
                                                                KeyElement("?", header: Constant.halfWidth)
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
                                        widthUnitTimes: 1.2,
                                        keyModel: KeyModel(primary: KeyElement("！"),
                                                           members: [
                                                                KeyElement("！"),
                                                                KeyElement("!", header: Constant.halfWidth)
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
                                        widthUnitTimes: 1.2,
                                        keyModel: KeyModel(primary: KeyElement("."),
                                                           members: [
                                                                KeyElement("."),
                                                                KeyElement("．", header: Constant.fullWidth, footer: "FF0E"),
                                                                KeyElement("…", footer: "2026")
                                                           ])
                                )
                                PlaceholderKey()
                                BackspaceKey()
                        }
                        switch (context.keyboardInterface.isPadFloating, context.needsInputModeSwitchKey) {
                        case (true, true):
                                HStack(spacing: 0) {
                                        GlobeKey()
                                        TransformKey(destination: .alphabetic, widthUnitTimes: 2)
                                        SpaceKey()
                                        RightKey()
                                        ReturnKey()
                                }
                        case (true, false):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .alphabetic, widthUnitTimes: 2)
                                        LeftKey()
                                        SpaceKey()
                                        RightKey()
                                        ReturnKey()
                                }
                        case (false, true):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .alphabetic, widthUnitTimes: 2)
                                        GlobeKey()
                                        SpaceKey()
                                        RightKey()
                                        ReturnKey()
                                }
                        case (false, false):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .alphabetic, widthUnitTimes: 2)
                                        LeftKey()
                                        SpaceKey()
                                        RightKey()
                                        ReturnKey()
                                }
                        }
                }
        }
}
