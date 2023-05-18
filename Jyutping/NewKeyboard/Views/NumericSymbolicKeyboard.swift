import SwiftUI

struct NumericSymbolicKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar().environmentObject(context)
                        HStack(spacing: 0 ) {
                                InputKey(key: KeyUnit(primary: KeyElement("1"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("2"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("3"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("4"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("5"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("6"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("7"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("8"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("9"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("0"))).environmentObject(context)

                        }
                        HStack(spacing: 0) {
                                InputKey(key: KeyUnit(primary: KeyElement("-"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("/"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement(":"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement(";"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("("))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement(")"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("$"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("&"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("@"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("\""))).environmentObject(context)
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
