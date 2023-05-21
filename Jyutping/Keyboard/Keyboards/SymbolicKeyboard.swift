import SwiftUI

struct SymbolicKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar().environmentObject(context)
                        HStack(spacing: 0 ) {
                                InputKey(key: KeyUnit(primary: KeyElement("["))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("]"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("{"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("}"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("#"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("%"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("^"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("*"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("+"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("="))).environmentObject(context)

                        }
                        HStack(spacing: 0) {
                                InputKey(key: KeyUnit(primary: KeyElement("_"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("\\"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("|"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("~"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("<"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement(">"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("$"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("$"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("$"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("•"))).environmentObject(context)
                        }
                        HStack(spacing: 0) {
                                NumericSymbolicSwitchKey().environmentObject(context)
                                PlaceHolderKey()
                                InputKey(key: KeyUnit(primary: KeyElement(".")), widthUnitTimes: 1.3).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement(",")), widthUnitTimes: 1.3).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("?")), widthUnitTimes: 1.3).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("!")), widthUnitTimes: 1.3).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("'")), widthUnitTimes: 1.3).environmentObject(context)
                                PlaceHolderKey()
                                BackspaceKey().environmentObject(context)
                        }
                        HStack(spacing: 0) {
                                AlphabeticKey().environmentObject(context)
                                CommaKey().environmentObject(context)
                                SpaceKey().environmentObject(context)
                                PeriodKey().environmentObject(context)
                                ReturnKey().environmentObject(context)
                        }
                }
        }
}
