import SwiftUI

struct CantoneseSymbolicKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        HStack(spacing: 0) {
                                ExpansibleInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("［"),
                                                           members: [
                                                                KeyElement("［"),
                                                                KeyElement("[", header: Constant.halfWidth),
                                                                KeyElement("【"),
                                                                KeyElement("〖"),
                                                                KeyElement("〔")
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("］"),
                                                           members: [
                                                                KeyElement("］"),
                                                                KeyElement("]", header: Constant.halfWidth),
                                                                KeyElement("】"),
                                                                KeyElement("〗"),
                                                                KeyElement("〕")
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("｛"),
                                                           members: [
                                                                KeyElement("｛"),
                                                                KeyElement("{", header: Constant.halfWidth)
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("｝"),
                                                           members: [
                                                                KeyElement("｝"),
                                                                KeyElement("}", header: Constant.halfWidth)
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("#"),
                                                           members: [
                                                                KeyElement("#"),
                                                                KeyElement("＃", header: Constant.fullWidth)
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("%"),
                                                           members: [
                                                                KeyElement("%"),
                                                                KeyElement("％", header: Constant.fullWidth),
                                                                KeyElement("‰")
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("^"),
                                                           members: [
                                                                KeyElement("^"),
                                                                KeyElement("＾", header: Constant.fullWidth),
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("*"),
                                                           members: [
                                                                KeyElement("*"),
                                                                KeyElement("＊", header: Constant.fullWidth),
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("+"),
                                                           members: [
                                                                KeyElement("+"),
                                                                KeyElement("＋", header: Constant.fullWidth),
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("="),
                                                           members: [
                                                                KeyElement("="),
                                                                KeyElement("＝", header: Constant.fullWidth),
                                                                KeyElement("≠"),
                                                                KeyElement("≈")
                                                           ])
                                )
                        }
                        HStack(spacing: 0) {
                                ExpansibleInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("_"),
                                                           members: [
                                                                KeyElement("_"),
                                                                KeyElement("＿", header: Constant.fullWidth),
                                                           ])
                                )
                                SymbolInputKey("\u{2014}")
                                ExpansibleInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("\\"),
                                                           members: [
                                                                KeyElement("\\"),
                                                                KeyElement("＼", header: Constant.fullWidth),
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("｜"),
                                                           members: [
                                                                KeyElement("｜"),
                                                                KeyElement("|", header: Constant.halfWidth),
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("～"),
                                                           members: [
                                                                KeyElement("～"),
                                                                KeyElement("~", header: Constant.halfWidth),
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("《"),
                                                           members: [
                                                                KeyElement("《"),
                                                                KeyElement("〈"),
                                                                KeyElement("<", header: Constant.halfWidth),
                                                                KeyElement("＜", header: Constant.fullWidth)
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("》"),
                                                           members: [
                                                                KeyElement("》"),
                                                                KeyElement("〉"),
                                                                KeyElement(">", header: Constant.halfWidth),
                                                                KeyElement("＞", header: Constant.fullWidth)
                                                           ])
                                )
                                SymbolInputKey("¥")
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("&"),
                                                           members: [
                                                                KeyElement("&"),
                                                                KeyElement("＆", header: Constant.fullWidth),
                                                                KeyElement("§"),
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("\u{00B7}"),
                                                           members: [
                                                                KeyElement("\u{00B7}", header: "間隔號", footer: "00B7"),
                                                                KeyElement("\u{2022}", header: "項目符號", footer: "2022"),
                                                                KeyElement("\u{00B0}", header: "度"),
                                                                KeyElement("\u{2027}", header: "連字點", footer: "2027"),
                                                                KeyElement("\u{FF65}", header: "半寬中點", footer: "FF65"),
                                                                KeyElement("\u{30FB}", header: "全寬中點", footer: "30FB")
                                                           ])
                                )
                        }
                        HStack(spacing: 0) {
                                TransformKey(destination: .numeric, widthUnitTimes: 1.3)
                                PlaceholderKey()
                                ExpansibleInputKey(
                                        keyLocale: .leading,
                                        widthUnitTimes: 1.2,
                                        keyModel: KeyModel(primary: KeyElement("\u{22EF}"),
                                                           members: [
                                                                KeyElement("\u{22EF}", footer: "22EF"),
                                                                KeyElement("\u{22EF}\u{22EF}", footer: "22EF*2"),
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
                                        keyModel: KeyModel(primary: KeyElement("©"),
                                                           members: [
                                                                KeyElement("©"),
                                                                KeyElement("®"),
                                                                KeyElement("™"),
                                                                KeyElement("\u{F8FF}")
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
                                        keyModel: KeyModel(primary: KeyElement("\u{0027}"),
                                                           members: [
                                                                KeyElement("\u{0027}", footer: "0027"),
                                                                KeyElement("\u{FF07}", header: Constant.fullWidth, footer: "FF07"),
                                                                KeyElement("\u{2019}", header: "右", footer: "2019"),
                                                                KeyElement("\u{2018}", header: "左", footer: "2018"),
                                                                KeyElement("\u{0060}", header: "重音符", footer: "0060")
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
