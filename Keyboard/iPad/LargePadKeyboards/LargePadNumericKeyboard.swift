import SwiftUI

struct LargePadNumericKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        HStack(spacing: 0 ) {
                                LargePadInstantInputKey("`")
                                Group {
                                        LargePadInstantInputKey("1")
                                        LargePadInstantInputKey("2")
                                        LargePadInstantInputKey("3")
                                        LargePadInstantInputKey("4")
                                        LargePadInstantInputKey("5")
                                        LargePadInstantInputKey("6")
                                        LargePadInstantInputKey("7")
                                        LargePadInstantInputKey("8")
                                        LargePadInstantInputKey("9")
                                        LargePadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("0"), members: [KeyElement("0"), KeyElement("°")]))
                                }
                                LargePadInstantInputKey("<")
                                LargePadInstantInputKey(">")
                                LargePadBackspaceKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0 ) {
                                TabKey(widthUnitTimes: 1.5)
                                Group {
                                        LargePadInstantInputKey("[")
                                        LargePadInstantInputKey("]")
                                        LargePadInstantInputKey("{")
                                        LargePadInstantInputKey("}")
                                        LargePadInstantInputKey("#")
                                        LargePadExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("%"), members: [KeyElement("%"), KeyElement("‰")]))
                                        LargePadInstantInputKey("^")
                                        LargePadInstantInputKey("*")
                                        LargePadInstantInputKey("+")
                                        LargePadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("="), members: [KeyElement("="), KeyElement("≠"), KeyElement("≈")]))
                                }
                                LargePadInstantInputKey("\\")
                                LargePadInstantInputKey("|")
                                LargePadInstantInputKey("~")
                        }
                        HStack(spacing: 0) {
                                CapsLockKey(widthUnitTimes: 1.75).hidden()
                                Group {
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("-"),
                                                        members: [
                                                                KeyElement("-"),
                                                                KeyElement("\u{2013}", footer: "2013"),
                                                                KeyElement("\u{2014}", footer: "2014"),
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
                                                keyModel: KeyModel(
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
                                                keyModel: KeyModel(
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
                                LargePadShiftKey(keyLocale: .leading, widthUnitTimes: 2.25).hidden()
                                Group {
                                        LargePadInstantInputKey("z").hidden()
                                        LargePadInstantInputKey("…")
                                        LargePadInstantInputKey(".")
                                        LargePadInstantInputKey(",")
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("?"),
                                                        members: [
                                                                KeyElement("?"),
                                                                KeyElement("¿")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("!"),
                                                        members: [
                                                                KeyElement("!"),
                                                                KeyElement("¡")
                                                        ]
                                                )
                                        )
                                        LargePadExpansibleInputKey(
                                                keyLocale: .trailing,
                                                keyModel: KeyModel(
                                                        primary: KeyElement("'"),
                                                        members: [
                                                                KeyElement("'", footer: "0027"),
                                                                KeyElement("\u{2019}", footer: "2019"),
                                                                KeyElement("\u{2018}", footer: "2018")
                                                        ]
                                                )
                                        )
                                }
                                LargePadExpansibleInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(
                                                primary: KeyElement("\""),
                                                members: [
                                                        KeyElement("\"", footer: "0022"),
                                                        KeyElement("\u{201D}", footer: "201D"),
                                                        KeyElement("\u{201C}", footer: "201C")
                                                ]
                                        )
                                )
                                LargePadInstantInputKey("_")
                                LargePadInstantInputKey("€")
                                LargePadShiftKey(keyLocale: .trailing, widthUnitTimes: 2.25).hidden()
                        }
                        HStack(spacing: 0) {
                                if context.needsInputModeSwitchKey {
                                        LargePadGlobeKey(widthUnitTimes: 2.125)
                                } else {
                                        LargePadTransformKey(destination: .alphabetic, keyLocale: .leading, widthUnitTimes: 2.125)
                                }
                                LargePadTransformKey(destination: .alphabetic, keyLocale: .leading, widthUnitTimes: 2.125)
                                PadSpaceKey()
                                LargePadTransformKey(destination: .alphabetic, keyLocale: .trailing, widthUnitTimes: 2.125)
                                LargePadDismissKey(widthUnitTimes: 2.125)
                        }
                }
        }
}
