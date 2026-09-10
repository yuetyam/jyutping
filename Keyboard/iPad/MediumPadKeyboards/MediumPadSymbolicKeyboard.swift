import SwiftUI

struct MediumPadSymbolicKeyboard: View {

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
                                Spacer()
                                Group {
                                        PadSymbolInputKey("¥")
                                        PadSymbolInputKey("€")
                                        PadSymbolInputKey("£")
                                        PadSymbolInputKey("_")
                                        PadSymbolInputKey("^")
                                        PadSymbolInputKey("[")
                                        PadSymbolInputKey("]")
                                        PadSymbolInputKey("{")
                                        PadSymbolInputKey("}")
                                }
                                MediumPadReturnKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0) {
                                MediumPadTransformKey(destination: .numeric, side: .leading, coefficient: 1.75)
                                Group {
                                        PadSymbolInputKey("§")
                                        PadSymbolInputKey("|")
                                        PadSymbolInputKey("~")
                                        PadSymbolInputKey("…")
                                        PadSymbolInputKey("\\")
                                        PadSymbolInputKey("<")
                                        PadSymbolInputKey(">")
                                        PadSymbolInputKey("!")
                                        PadSymbolInputKey("?")
                                }
                                MediumPadTransformKey(destination: .numeric, side: .trailing, coefficient: 1.25)
                        }
                        HStack(spacing: 0) {
                                if context.needsInputModeSwitchKey {
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
