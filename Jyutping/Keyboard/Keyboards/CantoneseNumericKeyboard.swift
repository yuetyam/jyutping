import SwiftUI

struct CantoneseNumericKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        HStack(spacing: 0) {
                                SymbolInputKey("1")
                                SymbolInputKey("2")
                                SymbolInputKey("3")
                                SymbolInputKey("4")
                                SymbolInputKey("5")
                                SymbolInputKey("6")
                                SymbolInputKey("7")
                                SymbolInputKey("8")
                                SymbolInputKey("9")
                                SymbolInputKey("0")
                        }
                        HStack(spacing: 0) {
                                SymbolInputKey("-")
                                SymbolInputKey("/")
                                SymbolInputKey("：")
                                SymbolInputKey("；")
                                SymbolInputKey("（")
                                SymbolInputKey("）")
                                SymbolInputKey("$")
                                SymbolInputKey("@")
                                SymbolInputKey("「")
                                SymbolInputKey("」")
                        }
                        HStack(spacing: 0) {
                                NumericSymbolicSwitchKey()
                                PlaceholderKey()
                                SymbolInputKey("。", widthUnitTimes: 1.2)
                                SymbolInputKey("，", widthUnitTimes: 1.2)
                                SymbolInputKey("、", widthUnitTimes: 1.2)
                                SymbolInputKey("？", widthUnitTimes: 1.2)
                                SymbolInputKey("！", widthUnitTimes: 1.2)
                                SymbolInputKey(".", widthUnitTimes: 1.2)
                                PlaceholderKey()
                                BackspaceKey()
                        }
                        HStack(spacing: 0) {
                                AlphabeticKey()
                                CommaKey()
                                SpaceKey()
                                PeriodKey()
                                ReturnKey()
                        }
                }
        }
}
