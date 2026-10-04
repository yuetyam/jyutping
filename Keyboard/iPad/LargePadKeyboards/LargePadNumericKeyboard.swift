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
                                        LargePadInstantInputKey("1", event: .number1)
                                        LargePadInstantInputKey("2", event: .number2)
                                        LargePadInstantInputKey("3", event: .number3)
                                        LargePadInstantInputKey("4", event: .number4)
                                        LargePadInstantInputKey("5", event: .number5)
                                        LargePadInstantInputKey("6", event: .number6)
                                        LargePadInstantInputKey("7", event: .number7)
                                        LargePadInstantInputKey("8", event: .number8)
                                        LargePadInstantInputKey("9", event: .number9)
                                        LargePadExpansibleInputKey(keyLocale: .trailing, event: .number0, keyModel: KeyUnit(primary: KeyElement("0"), members: [KeyElement("0"), KeyElement("°")]))
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
                                        LargePadExpansibleInputKey(keyLocale: .leading, keyModel: KeyUnit(primary: KeyElement("%"), members: [KeyElement("%"), KeyElement("‰")]))
                                        LargePadInstantInputKey("^")
                                        LargePadInstantInputKey("*")
                                        LargePadInstantInputKey("+")
                                        LargePadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyUnit(primary: KeyElement("="), members: [KeyElement("="), KeyElement("≠"), KeyElement("≈")]))
                                }
                                LargePadInstantInputKey("\\")
                                LargePadInstantInputKey("|")
                                LargePadInstantInputKey("~")
                        }
                        HStack(spacing: 0) {
                                LargePadCapsLockKey(widthUnitTimes: 1.75).hidden()
                                Group {
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("-"),
                                                        members: [
                                                                KeyElement("-"),
                                                                KeyElement("\u{2013}", extras: [.init("2013", alignment: .bottomTrailing)]),
                                                                KeyElement("\u{2014}", extras: [.init("2014", alignment: .bottomTrailing)]),
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
                                                keyLocale: .trailing,
                                                keyModel: KeyUnit(
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
                                                keyLocale: .trailing,
                                                keyModel: KeyUnit(
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
                                                keyLocale: .leading,
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("?"),
                                                        members: [
                                                                KeyElement("?"),
                                                                KeyElement("¿")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("!"),
                                                        members: [
                                                                KeyElement("!"),
                                                                KeyElement("¡")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                keyModel: KeyUnit(
                                                        primary: KeyElement("'"),
                                                        members: [
                                                                KeyElement("'", extras: [.init("0027", alignment: .bottomTrailing)]),
                                                                KeyElement("\u{2019}", extras: [.init("2019", alignment: .bottomTrailing)]),
                                                                KeyElement("\u{2018}", extras: [.init("2018", alignment: .bottomTrailing)])
                                                        ]
                                                )
                                        )
                                }
                                LargePadExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyUnit(
                                                primary: KeyElement("\""),
                                                members: [
                                                        KeyElement("\"", extras: [.init("0022", alignment: .bottomTrailing)]),
                                                        KeyElement("\u{201D}", extras: [.init("201D", alignment: .bottomTrailing)]),
                                                        KeyElement("\u{201C}", extras: [.init("201C", alignment: .bottomTrailing)])
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
