import SwiftUI

/// ABC mode keyboard
struct SymbolicKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        HStack(spacing: 0) {
                                SymbolInputKey("[")
                                SymbolInputKey("]")
                                SymbolInputKey("{")
                                SymbolInputKey("}")
                                SymbolInputKey("#")
                                SymbolInputKey("%")
                                SymbolInputKey("^")
                                SymbolInputKey("*")
                                SymbolInputKey("+")
                                SymbolInputKey("=")
                        }
                        HStack(spacing: 0) {
                                SymbolInputKey("_")
                                SymbolInputKey("\\")
                                SymbolInputKey("|")
                                SymbolInputKey("~")
                                SymbolInputKey("<")
                                SymbolInputKey(">")
                                SymbolInputKey("€")
                                SymbolInputKey("£")
                                SymbolInputKey("¥")
                                SymbolInputKey("•")
                        }
                        HStack(spacing: 0) {
                                TransformKey(destination: .numeric, widthUnitTimes: 1.3)
                                PlaceholderKey()
                                SymbolInputKey(".", widthUnitTimes: 1.3)
                                SymbolInputKey(",", widthUnitTimes: 1.3)
                                SymbolInputKey("?", widthUnitTimes: 1.3)
                                SymbolInputKey("!", widthUnitTimes: 1.3)
                                SymbolInputKey("'", widthUnitTimes: 1.3)
                                PlaceholderKey()
                                BackspaceKey()
                        }
                        HStack(spacing: 0) {
                                if context.needsInputModeSwitchKey {
                                        TransformKey(destination: .alphabetic, widthUnitTimes: 1.5)
                                        GlobeKey()
                                        SpaceKey()
                                        CommaKey()
                                        ReturnKey()
                                } else {
                                        TransformKey(destination: .alphabetic, widthUnitTimes: 1.5)
                                        CommaKey()
                                        SpaceKey()
                                        PeriodKey()
                                        ReturnKey()
                                }
                        }
                }
        }
}
