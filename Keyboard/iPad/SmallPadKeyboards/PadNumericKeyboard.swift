import SwiftUI

/// ABC mode keyboard on iPad
struct PadNumericKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        HStack(spacing: 0 ) {
                                Group {
                                        PadSymbolInputKey("1")
                                        PadSymbolInputKey("2")
                                        PadSymbolInputKey("3")
                                        PadSymbolInputKey("4")
                                        PadSymbolInputKey("5")
                                        PadSymbolInputKey("6")
                                        PadSymbolInputKey("7")
                                        PadSymbolInputKey("8")
                                        PadSymbolInputKey("9")
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("0"), members: [KeyElement("0"), KeyElement("°")]))
                                }
                                PadBackspaceKey(widthUnitTimes: 1)
                        }
                        HStack(spacing: 0) {
                                Spacer()
                                Group {
                                        PadCompleteInputKey(keyLocale: .leading, upper: "¥", keyModel: KeyModel(primary: KeyElement("@"), members: [KeyElement("@"), KeyElement("¥")]))
                                        PadCompleteInputKey(keyLocale: .leading, upper: "€", keyModel: KeyModel(primary: KeyElement("#"), members: [KeyElement("#"), KeyElement("€")]))
                                        PadCompleteInputKey(keyLocale: .leading, upper: "£", keyModel: KeyModel(primary: KeyElement("$"), members: [KeyElement("$"), KeyElement("£")]))
                                        PadCompleteInputKey(keyLocale: .leading, upper: "_", keyModel: KeyModel(primary: KeyElement("&"), members: [KeyElement("&"), KeyElement("_")]))
                                        PadCompleteInputKey(keyLocale: .leading, upper: "^", keyModel: KeyModel(primary: KeyElement("*"), members: [KeyElement("*"), KeyElement("^")]))
                                        PadCompleteInputKey(keyLocale: .trailing, upper: "[", keyModel: KeyModel(primary: KeyElement("("), members: [KeyElement("("), KeyElement("[")]))
                                        PadCompleteInputKey(keyLocale: .trailing, upper: "]", keyModel: KeyModel(primary: KeyElement(")"), members: [KeyElement(")"), KeyElement("]")]))
                                        PadCompleteInputKey(keyLocale: .trailing, upper: "{", keyModel: KeyModel(primary: KeyElement("'"), members: [KeyElement("'"), KeyElement("{"), KeyElement("\u{2019}", footer: "2019"), KeyElement("\u{2018}", footer: "2018"), KeyElement("\u{0060}", footer: "0060")]))
                                        PadCompleteInputKey(keyLocale: .trailing, upper: "}", keyModel: KeyModel(primary: KeyElement("\""), members: [KeyElement("\""), KeyElement("}"), KeyElement("\u{201D}", footer: "201D"), KeyElement("\u{201C}", footer: "201C")]))
                                }
                                PadReturnKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0) {
                                PadTransformKey(destination: .symbolic, widthUnitTimes: 1)
                                Group {
                                        PadCompleteInputKey(keyLocale: .leading, upper: "§", keyModel: KeyModel(primary: KeyElement("%"), members: [KeyElement("%"), KeyElement("§")]))
                                        PadCompleteInputKey(keyLocale: .leading, upper: "|", keyModel: KeyModel(primary: KeyElement("-"), members: [KeyElement("-"), KeyElement("|")]))
                                        PadCompleteInputKey(keyLocale: .leading, upper: "~", keyModel: KeyModel(primary: KeyElement("+"), members: [KeyElement("+"), KeyElement("~")]))
                                        PadCompleteInputKey(keyLocale: .leading, upper: "…", keyModel: KeyModel(primary: KeyElement("="), members: [KeyElement("="), KeyElement("…")]))
                                        PadCompleteInputKey(keyLocale: .leading, upper: "\\", keyModel: KeyModel(primary: KeyElement("/"), members: [KeyElement("/"), KeyElement("\\")]))
                                        PadCompleteInputKey(keyLocale: .trailing, upper: "<", keyModel: KeyModel(primary: KeyElement(";"), members: [KeyElement(";"), KeyElement("<")]))
                                        PadCompleteInputKey(keyLocale: .trailing, upper: ">", keyModel: KeyModel(primary: KeyElement(":"), members: [KeyElement(":"), KeyElement(">")]))
                                }
                                PadUpperLowerInputKey(keyLocale: .trailing, upper: "!", lower: ",", keyModel: KeyModel(primary: KeyElement(","), members: [KeyElement(","), KeyElement("!"), KeyElement("¡")]))
                                PadUpperLowerInputKey(keyLocale: .trailing, upper: "?", lower: ".", keyModel: KeyModel(primary: KeyElement("."), members: [KeyElement("."), KeyElement("?"), KeyElement("¿")]))
                                PadTransformKey(destination: .symbolic, widthUnitTimes: 1)
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
