import SwiftUI

struct MediumPadNumericKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        HStack(spacing: 0 ) {
                                MediumPadTabKey(widthUnitTimes: 1)
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
                                MediumPadBackspaceKey(widthUnitTimes: 1)
                        }
                        HStack(spacing: 0) {
                                PlaceholderKey()
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
                                MediumPadReturnKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0) {
                                MediumPadTransformKey(destination: .symbolic, keyLocale: .leading, widthUnitTimes: 1.75)
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
                                MediumPadTransformKey(destination: .symbolic, keyLocale: .trailing, widthUnitTimes: 1.25)
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
