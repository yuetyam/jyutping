import SwiftUI

/// ABC mode keyboard
struct SymbolicKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        if Options.needsNumberRow {
                                ABCNumberRow()
                        }
                        HStack(spacing: 0) {
                                SymbolInputKey("[")
                                SymbolInputKey("]")
                                SymbolInputKey("{")
                                SymbolInputKey("}")
                                SymbolInputKey("#")
                                EnhancedInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("%"), members: [KeyElement("%"), KeyElement("‰")]))
                                SymbolInputKey("^")
                                SymbolInputKey("*")
                                SymbolInputKey("+")
                                EnhancedInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("="), members: [KeyElement("="), KeyElement("≠"), KeyElement("≈")]))
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
                                TransformKey(destination: .numeric, coefficient: 1.35)
                                Spacer().frame(minWidth: 0)
                                SymbolInputKey("…")
                                SymbolInputKey("©")
                                SymbolInputKey("®")
                                SymbolInputKey("℗")
                                SymbolInputKey("™")
                                SymbolInputKey("℠")
                                EnhancedInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(
                                                primary: KeyElement("\u{0027}"),
                                                members: [
                                                        KeyElement("\u{0027}", extras: [.init("0027", alignment: .bottom)]),
                                                        KeyElement("\u{2019}", extras: [.init("2019", alignment: .bottom)]),
                                                        KeyElement("\u{2018}", extras: [.init("2018", alignment: .bottom)]),
                                                        KeyElement("\u{0060}", extras: [.init("0060", alignment: .bottom)])
                                                ]
                                        )
                                )
                                Spacer().frame(minWidth: 0)
                                BackspaceKey()
                        }
                        switch (context.keyboardInterface.isPadFloating, context.needsGlobeKey) {
                        case (true, true):
                                HStack(spacing: 0) {
                                        GlobeKey()
                                        TransformKey(destination: .primary, coefficient: 1.5)
                                        SharedBottomKeys.comma
                                        SpaceKey()
                                        SharedBottomKeys.period
                                        EnterReturnKey()
                                }
                        case (true, false):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .primary, coefficient: 2)
                                        SharedBottomKeys.comma
                                        SpaceKey()
                                        SharedBottomKeys.period
                                        EnterReturnKey()
                                }
                        case (false, true):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .primary, coefficient: 1.5)
                                        GlobeKey()
                                        SharedBottomKeys.comma
                                        SpaceKey()
                                        SharedBottomKeys.period
                                        EnterReturnKey()
                                }
                        case (false, false):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .primary, coefficient: 2)
                                        SharedBottomKeys.comma
                                        SpaceKey()
                                        SharedBottomKeys.period
                                        EnterReturnKey()
                                }
                        }
                }
        }
}
