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
                                EnhancedInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("%"), members: [KeyElement("%"), KeyElement("‰")]))
                                SymbolInputKey("^")
                                SymbolInputKey("*")
                                SymbolInputKey("+")
                                EnhancedInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("="), members: [KeyElement("="), KeyElement("≠"), KeyElement("≈")]))
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
                                Spacer()
                                SymbolInputKey("…")
                                SymbolInputKey("©")
                                SymbolInputKey("®")
                                SymbolInputKey("℗")
                                SymbolInputKey("™")
                                SymbolInputKey("℠")
                                EnhancedInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(
                                                primary: KeyElement("\u{0027}"),
                                                members: [
                                                        KeyElement("\u{0027}", footer: "0027"),
                                                        KeyElement("\u{2019}", footer: "2019"),
                                                        KeyElement("\u{2018}", footer: "2018"),
                                                        KeyElement("\u{0060}", footer: "0060")
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
                                        TransformKey(destination: .alphabetic, widthUnitTimes: 2)
                                        SpaceKey()
                                        SharedBottomKeys.altPeriod
                                        ReturnKey()
                                }
                        case (true, false):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .alphabetic, widthUnitTimes: 2)
                                        SharedBottomKeys.comma
                                        SpaceKey()
                                        SharedBottomKeys.period
                                        ReturnKey()
                                }
                        case (false, true):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .alphabetic, widthUnitTimes: 2)
                                        GlobeKey()
                                        SpaceKey()
                                        SharedBottomKeys.altPeriod
                                        ReturnKey()
                                }
                        case (false, false):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .alphabetic, widthUnitTimes: 2)
                                        SharedBottomKeys.comma
                                        SpaceKey()
                                        SharedBottomKeys.period
                                        ReturnKey()
                                }
                        }
                }
        }
}
