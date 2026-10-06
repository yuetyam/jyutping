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
                                        PadExpansibleInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("0"), members: [KeyElement("0"), KeyElement("°")]))
                                }
                                PadBackspaceKey(widthUnitTimes: 1)
                        }
                        HStack(spacing: 0) {
                                Spacer()
                                Group {
                                        PadAdvancedInputKey(side: .leading, upper: "¥", unit: KeyUnit(primary: KeyElement("@"), members: [KeyElement("@"), KeyElement("¥")]))
                                        PadAdvancedInputKey(side: .leading, upper: "€", unit: KeyUnit(primary: KeyElement("#"), members: [KeyElement("#"), KeyElement("€")]))
                                        PadAdvancedInputKey(side: .leading, upper: "£", unit: KeyUnit(primary: KeyElement("$"), members: [KeyElement("$"), KeyElement("£")]))
                                        PadAdvancedInputKey(side: .leading, upper: "_", unit: KeyUnit(primary: KeyElement("&"), members: [KeyElement("&"), KeyElement("_")]))
                                        PadAdvancedInputKey(side: .leading, upper: "^", unit: KeyUnit(primary: KeyElement("*"), members: [KeyElement("*"), KeyElement("^"), KeyElement("×")]))
                                        PadAdvancedInputKey(side: .trailing, upper: "[", unit: KeyUnit(primary: KeyElement("("), members: [KeyElement("("), KeyElement("[")]))
                                        PadAdvancedInputKey(side: .trailing, upper: "]", unit: KeyUnit(primary: KeyElement(")"), members: [KeyElement(")"), KeyElement("]")]))
                                        PadAdvancedInputKey(side: .trailing, upper: "{", unit: KeyUnit(primary: KeyElement("'"), members: [KeyElement("'"), KeyElement("{"), KeyElement("\u{2019}", extras: [.init("2019", alignment: .bottom)]), KeyElement("\u{2018}", extras: [.init("2018", alignment: .bottom)]), KeyElement("\u{0060}", extras: [.init("0060", alignment: .bottom)])]))
                                        PadAdvancedInputKey(side: .trailing, upper: "}", unit: KeyUnit(primary: KeyElement("\""), members: [KeyElement("\""), KeyElement("}"), KeyElement("\u{201D}", extras: [.init("201D", alignment: .bottom)]), KeyElement("\u{201C}", extras: [.init("201C", alignment: .bottom)])]))
                                }
                                PadReturnKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0) {
                                PadTransformKey(destination: .symbolic, coefficient: 1)
                                Group {
                                        PadAdvancedInputKey(side: .leading, upper: "§", unit: KeyUnit(primary: KeyElement("%"), members: [KeyElement("%"), KeyElement("§")]))
                                        PadAdvancedInputKey(side: .leading, upper: "|", unit: KeyUnit(primary: KeyElement("-"), members: [KeyElement("-"), KeyElement("|")]))
                                        PadAdvancedInputKey(side: .leading, upper: "~", unit: KeyUnit(primary: KeyElement("+"), members: [KeyElement("+"), KeyElement("~")]))
                                        PadAdvancedInputKey(side: .leading, upper: "…", unit: KeyUnit(primary: KeyElement("="), members: [KeyElement("="), KeyElement("…")]))
                                        PadAdvancedInputKey(side: .leading, upper: "\\", unit: KeyUnit(primary: KeyElement("/"), members: [KeyElement("/"), KeyElement("\\")]))
                                        PadAdvancedInputKey(side: .trailing, upper: "<", unit: KeyUnit(primary: KeyElement(";"), members: [KeyElement(";"), KeyElement("<")]))
                                        PadAdvancedInputKey(side: .trailing, upper: ">", unit: KeyUnit(primary: KeyElement(":"), members: [KeyElement(":"), KeyElement(">")]))
                                }
                                PadUpperLowerInputKey(side: .trailing, upper: "!", lower: ",", unit: KeyUnit(primary: KeyElement(","), members: [KeyElement(","), KeyElement("!"), KeyElement("¡")]))
                                PadUpperLowerInputKey(side: .trailing, upper: "?", lower: ".", unit: KeyUnit(primary: KeyElement("."), members: [KeyElement("."), KeyElement("?"), KeyElement("¿")]))
                                PadTransformKey(destination: .symbolic, coefficient: 1)
                        }
                        HStack(spacing: 0) {
                                if context.needsGlobeKey {
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
