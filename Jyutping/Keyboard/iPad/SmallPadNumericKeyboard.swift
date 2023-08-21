import SwiftUI

/// ABC mode keyboard on iPad
struct SmallPadNumericKeyboard: View {

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
                                PlaceholderKey()
                                Group {
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("@"), members: [KeyElement("@"), KeyElement("¥")]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("#"), members: [KeyElement("#"), KeyElement("€")]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("$"), members: [KeyElement("$"), KeyElement("£")]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("&"), members: [KeyElement("&"), KeyElement("_")]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("*"), members: [KeyElement("*"), KeyElement("^")]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("("), members: [KeyElement("("), KeyElement("[")]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement(")"), members: [KeyElement(")"), KeyElement("]")]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("'"), members: [KeyElement("'"), KeyElement("{")]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("\""), members: [KeyElement("\""), KeyElement("}")]))
                                }
                                PadReturnKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0) {
                                PadTransformKey(destination: .symbolic, widthUnitTimes: 1)
                                Group {
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("%"), members: [KeyElement("%"), KeyElement("§")]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("-"), members: [KeyElement("-"), KeyElement("|")]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("+"), members: [KeyElement("+"), KeyElement("~")]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("="), members: [KeyElement("="), KeyElement("…")]))
                                        PadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("/"), members: [KeyElement("/"), KeyElement("\\")]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement(";"), members: [KeyElement(";"), KeyElement("<")]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement(":"), members: [KeyElement(":"), KeyElement(">")]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement(","), members: [KeyElement(","), KeyElement("!")]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("."), members: [KeyElement("."), KeyElement("?")]))
                                }
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
                                PadDismissKey()
                        }
                }
        }
}
