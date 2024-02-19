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
                                ExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("%"), members: [KeyElement("%"), KeyElement("‰")]))
                                SymbolInputKey("^")
                                SymbolInputKey("*")
                                SymbolInputKey("+")
                                ExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("="), members: [KeyElement("="), KeyElement("≠"), KeyElement("≈")]))
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
                                ExpansibleInputKey(keyLocale: .leading, widthUnitTimes: 1.3, keyModel: KeyModel(primary: KeyElement("."), members: [KeyElement("."), KeyElement("…")]))
                                SymbolInputKey(",", widthUnitTimes: 1.3)
                                ExpansibleInputKey(keyLocale: .leading, widthUnitTimes: 1.3, keyModel: KeyModel(primary: KeyElement("?"), members: [KeyElement("?"), KeyElement("¿")]))
                                ExpansibleInputKey(keyLocale: .trailing, widthUnitTimes: 1.3, keyModel: KeyModel(primary: KeyElement("!"), members: [KeyElement("!"), KeyElement("¡")]))
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
                                        widthUnitTimes: 1.3,
                                        keyModel: KeyModel(primary: KeyElement("\u{0027}"),
                                                           members: [
                                                                KeyElement("\u{0027}", footer: "0027"),
                                                                KeyElement("\u{2019}", footer: "2019"),
                                                                KeyElement("\u{2018}", footer: "2018"),
                                                                KeyElement("\u{0060}", footer: "0060")
                                                           ])
                                )
                                PlaceholderKey()
                                BackspaceKey()
                        }
                        switch (context.keyboardInterface.isPadFloating, context.needsInputModeSwitchKey) {
                        case (true, true):
                                HStack(spacing: 0) {
                                        GlobeKey()
                                        TransformKey(destination: .alphabetic, widthUnitTimes: 2)
                                        SpaceKey()
                                        RightKey()
                                        ReturnKey()
                                }
                        case (true, false):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .alphabetic, widthUnitTimes: 2)
                                        LeftKey()
                                        SpaceKey()
                                        RightKey()
                                        ReturnKey()
                                }
                        case (false, true):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .alphabetic, widthUnitTimes: 2)
                                        GlobeKey()
                                        SpaceKey()
                                        RightKey()
                                        ReturnKey()
                                }
                        case (false, false):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .alphabetic, widthUnitTimes: 2)
                                        LeftKey()
                                        SpaceKey()
                                        RightKey()
                                        ReturnKey()
                                }
                        }
                }
        }
}
