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
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyUnit(primary: KeyElement("0"), members: [KeyElement("0"), KeyElement("°")]))
                                }
                                PadBackspaceKey(widthUnitTimes: 1)
                        }
                        HStack(spacing: 0) {
                                Spacer()
                                Group {
                                        PadAdvancedInputKey(keyLocale: .leading, upper: "¥", keyModel: KeyUnit(primary: KeyElement("@"), members: [KeyElement("@"), KeyElement("¥")]))
                                        PadAdvancedInputKey(keyLocale: .leading, upper: "€", keyModel: KeyUnit(primary: KeyElement("#"), members: [KeyElement("#"), KeyElement("€")]))
                                        PadAdvancedInputKey(keyLocale: .leading, upper: "£", keyModel: KeyUnit(primary: KeyElement("$"), members: [KeyElement("$"), KeyElement("£")]))
                                        PadAdvancedInputKey(keyLocale: .leading, upper: "_", keyModel: KeyUnit(primary: KeyElement("&"), members: [KeyElement("&"), KeyElement("_")]))
                                        PadAdvancedInputKey(keyLocale: .leading, upper: "^", keyModel: KeyUnit(primary: KeyElement("*"), members: [KeyElement("*"), KeyElement("^"), KeyElement("×")]))
                                        PadAdvancedInputKey(keyLocale: .trailing, upper: "[", keyModel: KeyUnit(primary: KeyElement("("), members: [KeyElement("("), KeyElement("[")]))
                                        PadAdvancedInputKey(keyLocale: .trailing, upper: "]", keyModel: KeyUnit(primary: KeyElement(")"), members: [KeyElement(")"), KeyElement("]")]))
                                        PadAdvancedInputKey(keyLocale: .trailing, upper: "{", keyModel: KeyUnit(primary: KeyElement("'"), members: [KeyElement("'"), KeyElement("{"), KeyElement("\u{2019}", extras: [.init("2019", alignment: .bottomTrailing)]), KeyElement("\u{2018}", extras: [.init("2018", alignment: .bottomTrailing)]), KeyElement("\u{0060}", extras: [.init("0060", alignment: .bottomTrailing)])]))
                                        PadAdvancedInputKey(keyLocale: .trailing, upper: "}", keyModel: KeyUnit(primary: KeyElement("\""), members: [KeyElement("\""), KeyElement("}"), KeyElement("\u{201D}", extras: [.init("201D", alignment: .bottomTrailing)]), KeyElement("\u{201C}", extras: [.init("201C", alignment: .bottomTrailing)])]))
                                }
                                PadReturnKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0) {
                                PadTransformKey(destination: .symbolic, coefficient: 1)
                                Group {
                                        PadAdvancedInputKey(keyLocale: .leading, upper: "§", keyModel: KeyUnit(primary: KeyElement("%"), members: [KeyElement("%"), KeyElement("§")]))
                                        PadAdvancedInputKey(keyLocale: .leading, upper: "|", keyModel: KeyUnit(primary: KeyElement("-"), members: [KeyElement("-"), KeyElement("|")]))
                                        PadAdvancedInputKey(keyLocale: .leading, upper: "~", keyModel: KeyUnit(primary: KeyElement("+"), members: [KeyElement("+"), KeyElement("~")]))
                                        PadAdvancedInputKey(keyLocale: .leading, upper: "…", keyModel: KeyUnit(primary: KeyElement("="), members: [KeyElement("="), KeyElement("…")]))
                                        PadAdvancedInputKey(keyLocale: .leading, upper: "\\", keyModel: KeyUnit(primary: KeyElement("/"), members: [KeyElement("/"), KeyElement("\\")]))
                                        PadAdvancedInputKey(keyLocale: .trailing, upper: "<", keyModel: KeyUnit(primary: KeyElement(";"), members: [KeyElement(";"), KeyElement("<")]))
                                        PadAdvancedInputKey(keyLocale: .trailing, upper: ">", keyModel: KeyUnit(primary: KeyElement(":"), members: [KeyElement(":"), KeyElement(">")]))
                                }
                                PadUpperLowerInputKey(keyLocale: .trailing, upper: "!", lower: ",", keyModel: KeyUnit(primary: KeyElement(","), members: [KeyElement(","), KeyElement("!"), KeyElement("¡")]))
                                PadUpperLowerInputKey(keyLocale: .trailing, upper: "?", lower: ".", keyModel: KeyUnit(primary: KeyElement("."), members: [KeyElement("."), KeyElement("?"), KeyElement("¿")]))
                                PadTransformKey(destination: .symbolic, coefficient: 1)
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
