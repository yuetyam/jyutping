import SwiftUI

struct CantoneseSymbolicKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        if Options.needsNumberRow {
                                NumberRow()
                        }
                        HStack(spacing: 0) {
                                EnhancedInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("［"),
                                                           members: [
                                                                KeyElement("［"),
                                                                KeyElement("[", header: PresetConstant.halfWidth),
                                                                KeyElement("【"),
                                                                KeyElement("〖"),
                                                                KeyElement("〔")
                                                           ])
                                )
                                EnhancedInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("］"),
                                                           members: [
                                                                KeyElement("］"),
                                                                KeyElement("]", header: PresetConstant.halfWidth),
                                                                KeyElement("】"),
                                                                KeyElement("〗"),
                                                                KeyElement("〕")
                                                           ])
                                )
                                EnhancedInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("｛"),
                                                           members: [
                                                                KeyElement("｛"),
                                                                KeyElement("{", header: PresetConstant.halfWidth)
                                                           ])
                                )
                                EnhancedInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("｝"),
                                                           members: [
                                                                KeyElement("｝"),
                                                                KeyElement("}", header: PresetConstant.halfWidth)
                                                           ])
                                )
                                EnhancedInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("#"),
                                                           members: [
                                                                KeyElement("#"),
                                                                KeyElement("＃", header: PresetConstant.fullWidth)
                                                           ])
                                )
                                EnhancedInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("%"),
                                                           members: [
                                                                KeyElement("%"),
                                                                KeyElement("％", header: PresetConstant.fullWidth),
                                                                KeyElement("‰")
                                                           ])
                                )
                                EnhancedInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("^"),
                                                           members: [
                                                                KeyElement("^"),
                                                                KeyElement("＾", header: PresetConstant.fullWidth),
                                                           ])
                                )
                                EnhancedInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("*"),
                                                           members: [
                                                                KeyElement("*"),
                                                                KeyElement("＊", header: PresetConstant.fullWidth),
                                                           ])
                                )
                                EnhancedInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("+"),
                                                           members: [
                                                                KeyElement("+"),
                                                                KeyElement("＋", header: PresetConstant.fullWidth),
                                                           ])
                                )
                                EnhancedInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("="),
                                                           members: [
                                                                KeyElement("="),
                                                                KeyElement("＝", header: PresetConstant.fullWidth),
                                                                KeyElement("≠"),
                                                                KeyElement("≈")
                                                           ])
                                )
                        }
                        HStack(spacing: 0) {
                                EnhancedInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("_"),
                                                           members: [
                                                                KeyElement("_"),
                                                                KeyElement("＿", header: PresetConstant.fullWidth),
                                                           ])
                                )
                                SymbolInputKey("\u{2014}")
                                EnhancedInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("\\"),
                                                           members: [
                                                                KeyElement("\\"),
                                                                KeyElement("＼", header: PresetConstant.fullWidth),
                                                           ])
                                )
                                EnhancedInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("｜"),
                                                           members: [
                                                                KeyElement("｜"),
                                                                KeyElement("|", header: PresetConstant.halfWidth),
                                                           ])
                                )
                                EnhancedInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("～"),
                                                           members: [
                                                                KeyElement("～"),
                                                                KeyElement("~", header: PresetConstant.halfWidth),
                                                           ])
                                )
                                EnhancedInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("《"),
                                                           members: [
                                                                KeyElement("《"),
                                                                KeyElement("〈"),
                                                                KeyElement("<", header: PresetConstant.halfWidth),
                                                                KeyElement("＜", header: PresetConstant.fullWidth)
                                                           ])
                                )
                                EnhancedInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("》"),
                                                           members: [
                                                                KeyElement("》"),
                                                                KeyElement("〉"),
                                                                KeyElement(">", header: PresetConstant.halfWidth),
                                                                KeyElement("＞", header: PresetConstant.fullWidth)
                                                           ])
                                )
                                EnhancedInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("¥"),
                                                           members: [
                                                                KeyElement("¥"),
                                                                KeyElement("￥", header: PresetConstant.fullWidth)
                                                           ])
                                )
                                EnhancedInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("&"),
                                                           members: [
                                                                KeyElement("&"),
                                                                KeyElement("＆", header: PresetConstant.fullWidth),
                                                                KeyElement("§"),
                                                           ])
                                )
                                EnhancedInputKey(
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
                                Spacer()
                                EnhancedInputKey(
                                        keyLocale: .leading,
                                        keyModel: KeyModel(primary: KeyElement("\u{2026}"),
                                                           members: [
                                                                KeyElement("\u{2026}", footer: "2026"),
                                                                KeyElement("\u{22EF}", footer: "22EF")
                                                           ])
                                )
                                SymbolInputKey("©")
                                SymbolInputKey("®")
                                SymbolInputKey("℗")
                                SymbolInputKey("™")
                                SymbolInputKey("℠")
                                EnhancedInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(primary: KeyElement("\u{0027}"),
                                                           members: [
                                                                KeyElement("\u{0027}", footer: "0027"),
                                                                KeyElement("\u{FF07}", header: PresetConstant.fullWidth, footer: "FF07"),
                                                                KeyElement("\u{2019}", header: "右", footer: "2019"),
                                                                KeyElement("\u{2018}", header: "左", footer: "2018"),
                                                                KeyElement("\u{0060}", header: "重音符", footer: "0060")
                                                           ])
                                )
                                Spacer()
                                BackspaceKey()
                        }
                        switch (context.keyboardInterface.isPadFloating, context.needsInputModeSwitchKey) {
                        case (true, true):
                                if #available(iOSApplicationExtension 26.0, *) {
                                        HStack(spacing: 0) {
                                                TransformKey(destination: .alphabetic, widthUnitTimes: 2)
                                                SharedBottomKeys.cantoneseComma
                                                SpaceKey()
                                                SharedBottomKeys.cantonesePeriod
                                                ReturnKey()
                                        }
                                } else {
                                        HStack(spacing: 0) {
                                                GlobeKey()
                                                TransformKey(destination: .alphabetic, widthUnitTimes: 2)
                                                SpaceKey()
                                                SharedBottomKeys.altCantoneseComma
                                                ReturnKey()
                                        }
                                }
                        case (true, false):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .alphabetic, widthUnitTimes: 2)
                                        SharedBottomKeys.cantoneseComma
                                        SpaceKey()
                                        SharedBottomKeys.cantonesePeriod
                                        ReturnKey()
                                }
                        case (false, true):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .alphabetic, widthUnitTimes: 2)
                                        GlobeKey()
                                        SpaceKey()
                                        SharedBottomKeys.altCantoneseComma
                                        ReturnKey()
                                }
                        case (false, false):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .alphabetic, widthUnitTimes: 2)
                                        SharedBottomKeys.cantoneseComma
                                        SpaceKey()
                                        SharedBottomKeys.cantonesePeriod
                                        ReturnKey()
                                }
                        }
                }
        }
}
