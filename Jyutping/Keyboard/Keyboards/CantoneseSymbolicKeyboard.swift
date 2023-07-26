import SwiftUI

struct CantoneseSymbolicKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        HStack(spacing: 0) {
                                SymbolInputKey("［")
                                SymbolInputKey("］")
                                SymbolInputKey("｛")
                                SymbolInputKey("｝")
                                SymbolInputKey("#")
                                SymbolInputKey("%")
                                SymbolInputKey("^")
                                SymbolInputKey("*")
                                SymbolInputKey("+")
                                SymbolInputKey("=")
                        }
                        HStack(spacing: 0) {
                                SymbolInputKey("_")
                                SymbolInputKey("—")
                                SymbolInputKey("\\")
                                SymbolInputKey("｜")
                                SymbolInputKey("～")
                                SymbolInputKey("《")
                                SymbolInputKey("》")
                                SymbolInputKey("¥")
                                SymbolInputKey("&")
                                SymbolInputKey("\u{00B7}")
                        }
                        HStack(spacing: 0) {
                                TransformKey(destination: .numeric, widthUnitTimes: 1.3)
                                PlaceholderKey()
                                SymbolInputKey("…", widthUnitTimes: 1.2)
                                SymbolInputKey("，", widthUnitTimes: 1.2)
                                SymbolInputKey("\u{00A9}", widthUnitTimes: 1.2)
                                SymbolInputKey("？", widthUnitTimes: 1.2)
                                SymbolInputKey("！", widthUnitTimes: 1.2)
                                SymbolInputKey("'", widthUnitTimes: 1.2)
                                PlaceholderKey()
                                BackspaceKey()
                        }
                        HStack(spacing: 0) {
                                TransformKey(destination: .alphabetic, widthUnitTimes: 1.5)
                                CommaKey()
                                SpaceKey()
                                PeriodKey()
                                ReturnKey()
                        }
                }
        }
}
