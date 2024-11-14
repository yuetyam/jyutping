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
                                PlaceholderKey()
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
                                MediumPadTransformKey(destination: .numeric, keyLocale: .leading, widthUnitTimes: 1.75)
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
                                MediumPadTransformKey(destination: .numeric, keyLocale: .trailing, widthUnitTimes: 1.25)
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
