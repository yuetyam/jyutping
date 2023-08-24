import SwiftUI

/// ABC mode keyboard on iPad
struct SmallPadSymbolicKeyboard: View {

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
                                PadReturnKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0) {
                                PadTransformKey(destination: .numeric, widthUnitTimes: 1)
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
