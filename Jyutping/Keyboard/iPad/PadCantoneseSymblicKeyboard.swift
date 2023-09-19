import SwiftUI

struct PadCantoneseSymbolicKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        HStack(spacing: 0 ) {
                                Group {
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("^"), members: [KeyElement("^"), KeyElement("＾", header: "全寬")]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("_"), members: [KeyElement("_"), KeyElement("＿", header: "全寬")]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("｜"), members: [KeyElement("｜"), KeyElement("|", header: "半寬")]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("\\"), members: [KeyElement("\\"), KeyElement("＼", header: "全寬")]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("<"), members: [KeyElement("<"), KeyElement("＜", footer: "FF1C")]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement(">"), members: [KeyElement(">"), KeyElement("＞", footer: "FF1E")]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("{"), members: [KeyElement("{"), KeyElement("｛", header: "全寬")]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("}"), members: [KeyElement("}"), KeyElement("｝", header: "全寬")]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement(","), members: [KeyElement(","), KeyElement("，", header: "全寬")]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("."), members: [KeyElement("."), KeyElement("．", header: "全寬", footer: "FF0E"), KeyElement("…")]))
                                }
                                PadBackspaceKey(widthUnitTimes: 1)
                        }
                        HStack(spacing: 0) {
                                PlaceholderKey()
                                Group {
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("&"), members: [KeyElement("&"), KeyElement("＆", header: "全寬"), KeyElement("§")]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("¥"), members: [KeyElement("¥"), KeyElement("$")]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("€"), members: [KeyElement("€"), KeyElement("£")]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("*"), members: [KeyElement("*"), KeyElement("＊", header: "全寬")]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("【"), members: [KeyElement("【"), KeyElement("〔"), KeyElement("［"), KeyElement("[", header: "半寬")]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("】"), members: [KeyElement("】"), KeyElement("〕"), KeyElement("］"), KeyElement("]", header: "半寬")]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("『"), members: [KeyElement("『"), KeyElement("﹄", header: "縱書")]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("』"), members: [KeyElement("』"), KeyElement("﹃", header: "縱書")]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("\""), members: [KeyElement("\"", footer: "0022"), KeyElement("\u{201C}", footer: "201C"), KeyElement("\u{201D}", footer: "201D")]))
                                }
                                PadReturnKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0) {
                                PadTransformKey(destination: .numeric, widthUnitTimes: 1)
                                Group {
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("§"), members: [KeyElement("§"), KeyElement("&")]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("\u{2014}"), members: [KeyElement("\u{2014}", footer: "2014"), KeyElement("-")]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("+"), members: [KeyElement("+"), KeyElement("＋", header: "全寬")]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("="), members: [KeyElement("="), KeyElement("＝", header: "全寬")]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("·"), members: [KeyElement("·", header: "間隔號", footer: "00B7"), KeyElement("•", header: "Bullet", footer: "2022"), KeyElement("°", header: "度")]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("《"), members: [KeyElement("《"), KeyElement("〈"), KeyElement("＜")]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("》"), members: [KeyElement("》"), KeyElement("〉"), KeyElement("＞")]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("！"), members: [KeyElement("！"), KeyElement("!", header: "半寬")]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("？"), members: [KeyElement("？"), KeyElement("?", header: "半寬")]))
                                }
                                PadTransformKey(destination: .numeric, widthUnitTimes: 1)
                        }
                        HStack(spacing: 0) {
                                if context.needsInputModeSwitchKey {
                                        PadGlobeKey(widthUnitTimes: 1.5)
                                } else {
                                        PadTransformKey(destination: .alphabetic, widthUnitTimes: 1.5)
                                }
                                PadTransformKey(destination: .alphabetic, widthUnitTimes: 1.5)
                                PadSpaceKey()
                                PadTransformKey(destination: .alphabetic, widthUnitTimes: 1.5)
                                PadDismissKey(widthUnitTimes: 1.5)
                        }
                }
        }
}
