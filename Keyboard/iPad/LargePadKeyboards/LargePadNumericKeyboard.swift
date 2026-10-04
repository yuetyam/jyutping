import SwiftUI
import CoreIME

struct LargePadNumericKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        HStack(spacing: 0 ) {
                                LargePadInstantInputKey("`")
                                Group {
                                        LargePadInstantInputKey("1", virtual: .number1)
                                        LargePadInstantInputKey("2", virtual: .number2)
                                        LargePadInstantInputKey("3", virtual: .number3)
                                        LargePadInstantInputKey("4", virtual: .number4)
                                        LargePadInstantInputKey("5", virtual: .number5)
                                        LargePadInstantInputKey("6", virtual: .number6)
                                        LargePadInstantInputKey("7", virtual: .number7)
                                        LargePadInstantInputKey("8", virtual: .number8)
                                        LargePadInstantInputKey("9", virtual: .number9)
                                        LargePadExpansibleInputKey(side: .trailing, virtual: .number0, unit: KeyUnit(primary: KeyElement("0"), members: [KeyElement("0"), KeyElement("°")]))
                                }
                                LargePadInstantInputKey("<")
                                LargePadInstantInputKey(">")
                                LargePadBackspaceKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0 ) {
                                LargePadTabKey(widthUnitTimes: 1.5)
                                Group {
                                        LargePadInstantInputKey("[")
                                        LargePadInstantInputKey("]")
                                        LargePadInstantInputKey("{")
                                        LargePadInstantInputKey("}")
                                        LargePadInstantInputKey("#")
                                        LargePadExpansibleInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("%"), members: [KeyElement("%"), KeyElement("‰")]))
                                        LargePadInstantInputKey("^")
                                        LargePadInstantInputKey("*")
                                        LargePadInstantInputKey("+")
                                        LargePadExpansibleInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("="), members: [KeyElement("="), KeyElement("≠"), KeyElement("≈")]))
                                }
                                LargePadInstantInputKey("\\")
                                LargePadInstantInputKey("|")
                                LargePadInstantInputKey("~")
                        }
                        HStack(spacing: 0) {
                                LargePadCapsLockKey(widthUnitTimes: 1.75).hidden()
                                Group {
                                        LargePadExpansibleInputKey(
                                                side: .leading,
                                                unit: KeyUnit(
                                                        primary: KeyElement("-"),
                                                        members: [
                                                                KeyElement("-"),
                                                                KeyElement("\u{2013}", extras: [.init("2013", alignment: .bottom)]),
                                                                KeyElement("\u{2014}", extras: [.init("2014", alignment: .bottom)]),
                                                                KeyElement("•")
                                                        ]
                                                )
                                        )
                                        LargePadInstantInputKey("/")
                                        LargePadInstantInputKey(":")
                                        LargePadInstantInputKey(";")
                                        LargePadInstantInputKey("(")
                                        LargePadInstantInputKey(")")
                                        LargePadExpansibleInputKey(
                                                side: .trailing,
                                                unit: KeyUnit(
                                                        primary: KeyElement("$"),
                                                        members: [
                                                                KeyElement("$"),
                                                                KeyElement("₩"),
                                                                KeyElement("₽"),
                                                                KeyElement("¢")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                side: .trailing,
                                                unit: KeyUnit(
                                                        primary: KeyElement("&"),
                                                        members: [
                                                                KeyElement("&"),
                                                                KeyElement("§")
                                                        ]
                                                )
                                        )
                                        LargePadInstantInputKey("@")
                                }
                                LargePadInstantInputKey("£")
                                LargePadInstantInputKey("¥")
                                LargePadReturnKey(widthUnitTimes: 1.75)
                        }
                        HStack(spacing: 0) {
                                LargePadShiftKey(side: .leading, coefficient: 2.25).hidden()
                                Group {
                                        LargePadInstantInputKey("z").hidden()
                                        LargePadInstantInputKey("…")
                                        LargePadInstantInputKey(".")
                                        LargePadInstantInputKey(",")
                                        LargePadExpansibleInputKey(
                                                side: .leading,
                                                unit: KeyUnit(
                                                        primary: KeyElement("?"),
                                                        members: [
                                                                KeyElement("?"),
                                                                KeyElement("¿")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                side: .trailing,
                                                unit: KeyUnit(
                                                        primary: KeyElement("!"),
                                                        members: [
                                                                KeyElement("!"),
                                                                KeyElement("¡")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                side: .trailing,
                                                unit: KeyUnit(
                                                        primary: KeyElement("'"),
                                                        members: [
                                                                KeyElement("'", extras: [.init("0027", alignment: .bottom)]),
                                                                KeyElement("\u{2019}", extras: [.init("2019", alignment: .bottom)]),
                                                                KeyElement("\u{2018}", extras: [.init("2018", alignment: .bottom)])
                                                        ]
                                                )
                                        )
                                }
                                LargePadExpansibleInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(
                                                primary: KeyElement("\""),
                                                members: [
                                                        KeyElement("\"", extras: [.init("0022", alignment: .bottom)]),
                                                        KeyElement("\u{201D}", extras: [.init("201D", alignment: .bottom)]),
                                                        KeyElement("\u{201C}", extras: [.init("201C", alignment: .bottom)])
                                                ]
                                        )
                                )
                                LargePadInstantInputKey("_")
                                LargePadInstantInputKey("€")
                                LargePadShiftKey(side: .trailing, coefficient: 2.25).hidden()
                        }
                        HStack(spacing: 0) {
                                if context.needsInputModeSwitchKey {
                                        LargePadGlobeKey(widthUnitTimes: 2.125)
                                } else {
                                        LargePadTransformKey(destination: .primary, side: .leading, coefficient: 2.125)
                                }
                                LargePadTransformKey(destination: .primary, side: .leading, coefficient: 2.125)
                                LargePadSpaceKey()
                                LargePadTransformKey(destination: .primary, side: .trailing, coefficient: 2.125)
                                LargePadDismissKey(widthUnitTimes: 2.125)
                        }
                }
        }
}
