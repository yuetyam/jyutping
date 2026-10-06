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
                                        PadExpansibleInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("0"), members: [KeyElement("0"), KeyElement("°")]))
                                }
                                MediumPadBackspaceKey(widthUnitTimes: 1)
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
                                MediumPadReturnKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0) {
                                MediumPadTransformKey(destination: .symbolic, side: .leading, coefficient: 1.75)
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
                                MediumPadTransformKey(destination: .symbolic, side: .trailing, coefficient: 1.25)
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
