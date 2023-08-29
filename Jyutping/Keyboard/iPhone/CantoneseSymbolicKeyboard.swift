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
                                                                KeyElement("[", header: "半形"),
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
                                                                KeyElement("]", header: "半形"),
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
                                                                KeyElement("{", header: "半形")
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("｝"),
                                                           members: [
                                                                KeyElement("｝"),
                                                                KeyElement("}", header: "半形")
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("#"),
                                                           members: [
                                                                KeyElement("#"),
                                                                KeyElement("＃", header: "全形")
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("%"),
                                                           members: [
                                                                KeyElement("%"),
                                                                KeyElement("％", header: "全形"),
                                                                KeyElement("‰")
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("^"),
                                                           members: [
                                                                KeyElement("^"),
                                                                KeyElement("＾", header: "全形"),
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("*"),
                                                           members: [
                                                                KeyElement("*"),
                                                                KeyElement("＊", header: "全形"),
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("+"),
                                                           members: [
                                                                KeyElement("+"),
                                                                KeyElement("＋", header: "全形"),
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("="),
                                                           members: [
                                                                KeyElement("="),
                                                                KeyElement("＝", header: "全形"),
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
                                                                KeyElement("＿", header: "全形"),
                                                           ])
                                )
                                SymbolInputKey("\u{2014}")
                                ExpansibleInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("\\"),
                                                           members: [
                                                                KeyElement("\\"),
                                                                KeyElement("＼", header: "全形"),
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("｜"),
                                                           members: [
                                                                KeyElement("｜"),
                                                                KeyElement("|", header: "半形"),
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("～"),
                                                           members: [
                                                                KeyElement("～"),
                                                                KeyElement("~", header: "半形"),
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("《"),
                                                           members: [
                                                                KeyElement("《"),
                                                                KeyElement("〈", footer: "3008"),
                                                                KeyElement("<", footer: "003C"),
                                                                KeyElement("＜", footer: "FF1C")
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("》"),
                                                           members: [
                                                                KeyElement("》"),
                                                                KeyElement("〉", footer: "3009"),
                                                                KeyElement(">", footer: "003E"),
                                                                KeyElement("＞", footer: "FF1E")
                                                           ])
                                )
                                SymbolInputKey("¥")
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("&"),
                                                           members: [
                                                                KeyElement("&"),
                                                                KeyElement("＆", header: "全形"),
                                                                KeyElement("§"),
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("\u{00B7}"),
                                                           members: [
                                                                KeyElement("\u{00B7}", header: "間隔", footer: "00B7"),
                                                                KeyElement("\u{2022}", header: "Bullet", footer: "2022"),
                                                                KeyElement("\u{00B0}", header: "度", footer: "00B0"),
                                                                KeyElement("\u{30FB}", header: "中點", footer: "30FB")
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
                                                                KeyElement(",", header: "半形")
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
                                                                KeyElement("?", header: "半形")
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
                                        widthUnitTimes: 1.2,
                                        keyModel: KeyModel(primary: KeyElement("！"),
                                                           members: [
                                                                KeyElement("！"),
                                                                KeyElement("!", header: "半形")
                                                           ])
                                )
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
                                        widthUnitTimes: 1.2,
                                        keyModel: KeyModel(primary: KeyElement("\u{0027}"),
                                                           members: [
                                                                KeyElement("\u{0027}", footer: "0027"),
                                                                KeyElement("\u{FF07}", header: "全形", footer: "FF07"),
                                                                KeyElement("\u{2018}", footer: "2018"),
                                                                KeyElement("\u{2019}", footer: "2019"),
                                                                KeyElement("\u{0060}", footer: "0060")
                                                           ])
                                )
                                PlaceholderKey()
                                BackspaceKey()
                        }
                        HStack(spacing: 0) {
                                TransformKey(destination: .alphabetic, widthUnitTimes: 1.5)
                                if context.needsInputModeSwitchKey {
                                        GlobeKey()
                                } else {
                                        LeftKey()
                                }
                                SpaceKey()
                                RightKey()
                                ReturnKey()
                        }
                }
        }
}
