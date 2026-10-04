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
                                TransformKey(destination: .numeric, coefficient: 1.3)
                                Spacer()
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
                                                        KeyElement("\u{0027}", extras: [.init("0027", alignment: .bottomTrailing)]),
                                                        KeyElement("\u{2019}", extras: [.init("2019", alignment: .bottomTrailing)]),
                                                        KeyElement("\u{2018}", extras: [.init("2018", alignment: .bottomTrailing)]),
                                                        KeyElement("\u{0060}", extras: [.init("0060", alignment: .bottomTrailing)])
                                                ]
                                        )
                                )
                                Spacer()
                                BackspaceKey()
                        }
                        switch (context.keyboardInterface.isPadFloating, context.needsInputModeSwitchKey) {
                        case (true, true):
                                HStack(spacing: 0) {
                                        GlobeKey()
                                        TransformKey(destination: .primary, coefficient: 2)
                                        SpaceKey()
                                        SharedBottomKeys.altPeriod
                                        ReturnKey()
                                }
                        case (true, false):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .primary, coefficient: 2)
                                        SharedBottomKeys.comma
                                        SpaceKey()
                                        SharedBottomKeys.period
                                        ReturnKey()
                                }
                        case (false, true):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .primary, coefficient: 2)
                                        GlobeKey()
                                        SpaceKey()
                                        SharedBottomKeys.altPeriod
                                        ReturnKey()
                                }
                        case (false, false):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .primary, coefficient: 2)
                                        SharedBottomKeys.comma
                                        SpaceKey()
                                        SharedBottomKeys.period
                                        ReturnKey()
                                }
                        }
                }
        }
}
