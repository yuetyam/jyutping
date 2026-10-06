import SwiftUI
import CoreIME

struct LargePadABCKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        if context.keyboardCase.isUppercased {
                                HStack(spacing: 0 ) {
                                        LargePadInstantInputKey("~")
                                        Group {
                                                LargePadExpansibleInputKey(
                                                        side: .leading,
                                                        unit: KeyUnit(
                                                                primary: KeyElement("!"),
                                                                members: [
                                                                        KeyElement("!"),
                                                                        KeyElement("¡")
                                                                ]
                                                        )
                                                )
                                                LargePadInstantInputKey("@")
                                                LargePadInstantInputKey("#")
                                                LargePadExpansibleInputKey(
                                                        side: .leading,
                                                        unit: KeyUnit(
                                                                primary: KeyElement("$"),
                                                                members: [
                                                                        KeyElement("$"),
                                                                        KeyElement("€"),
                                                                        KeyElement("£"),
                                                                        KeyElement("¥"),
                                                                        KeyElement("₩"),
                                                                        KeyElement("₽"),
                                                                        KeyElement("¢")
                                                                ]
                                                        )
                                                )
                                                LargePadExpansibleInputKey(
                                                        side: .leading,
                                                        unit: KeyUnit(
                                                                primary: KeyElement("%"),
                                                                members: [
                                                                        KeyElement("%"),
                                                                        KeyElement("‰")
                                                                ]
                                                        )
                                                )
                                                LargePadInstantInputKey("^")
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
                                                LargePadExpansibleInputKey(
                                                        side: .trailing,
                                                        unit: KeyUnit(
                                                                primary: KeyElement("*"),
                                                                members: [
                                                                        KeyElement("*"),
                                                                        KeyElement("•"),
                                                                        KeyElement("×"),
                                                                ]
                                                        )
                                                )
                                                LargePadInstantInputKey("(")
                                                LargePadInstantInputKey(")")
                                        }
                                        LargePadInstantInputKey("_")
                                        LargePadInstantInputKey("+")
                                        LargePadBackspaceKey(widthUnitTimes: 1.5)
                                }
                        } else {
                                HStack(spacing: 0 ) {
                                        LargePadUpperLowerInputKey(
                                                side: .leading,
                                                upper: "~",
                                                lower: "`",
                                                unit: KeyUnit(
                                                        primary: KeyElement("`"),
                                                        members: [
                                                                KeyElement("`"),
                                                                KeyElement("~")
                                                        ]
                                                )
                                        )
                                        Group {
                                                LargePadUpperLowerInputKey(
                                                        side: .leading,
                                                        upper: "!",
                                                        lower: "1",
                                                        virtual: .number1,
                                                        unit: KeyUnit(
                                                                primary: KeyElement("1"),
                                                                members: [
                                                                        KeyElement("1"),
                                                                        KeyElement("!"),
                                                                        KeyElement("¡")
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        side: .leading,
                                                        upper: "@",
                                                        lower: "2",
                                                        virtual: .number2,
                                                        unit: KeyUnit(
                                                                primary: KeyElement("2"),
                                                                members: [
                                                                        KeyElement("2"),
                                                                        KeyElement("@")
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        side: .leading,
                                                        upper: "#",
                                                        lower: "3",
                                                        virtual: .number3,
                                                        unit: KeyUnit(
                                                                primary: KeyElement("3"),
                                                                members: [
                                                                        KeyElement("3"),
                                                                        KeyElement("#")
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        side: .leading,
                                                        upper: "$",
                                                        lower: "4",
                                                        virtual: .number4,
                                                        unit: KeyUnit(
                                                                primary: KeyElement("4"),
                                                                members: [
                                                                        KeyElement("4"),
                                                                        KeyElement("$")
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        side: .leading,
                                                        upper: "%",
                                                        lower: "5",
                                                        virtual: .number5,
                                                        unit: KeyUnit(
                                                                primary: KeyElement("5"),
                                                                members: [
                                                                        KeyElement("5"),
                                                                        KeyElement("%"),
                                                                        KeyElement("‰")
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        side: .leading,
                                                        upper: "^",
                                                        lower: "6",
                                                        virtual: .number6,
                                                        unit: KeyUnit(
                                                                primary: KeyElement("6"),
                                                                members: [
                                                                        KeyElement("6"),
                                                                        KeyElement("^")
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        side: .trailing,
                                                        upper: "&",
                                                        lower: "7",
                                                        virtual: .number7,
                                                        unit: KeyUnit(
                                                                primary: KeyElement("7"),
                                                                members: [
                                                                        KeyElement("7"),
                                                                        KeyElement("&"),
                                                                        KeyElement("§")
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        side: .trailing,
                                                        upper: "*",
                                                        lower: "8",
                                                        virtual: .number8,
                                                        unit: KeyUnit(
                                                                primary: KeyElement("8"),
                                                                members: [
                                                                        KeyElement("8"),
                                                                        KeyElement("*"),
                                                                        KeyElement("•")
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        side: .trailing,
                                                        upper: "(",
                                                        lower: "9",
                                                        virtual: .number9,
                                                        unit: KeyUnit(
                                                                primary: KeyElement("9"),
                                                                members: [
                                                                        KeyElement("9"),
                                                                        KeyElement("(")
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        side: .trailing,
                                                        upper: ")",
                                                        lower: "0",
                                                        virtual: .number0,
                                                        unit: KeyUnit(
                                                                primary: KeyElement("0"),
                                                                members: [
                                                                        KeyElement("0"),
                                                                        KeyElement(")")
                                                                ]
                                                        )
                                                )
                                        }
                                        LargePadUpperLowerInputKey(
                                                side: .trailing,
                                                upper: "_",
                                                lower: "-",
                                                unit: KeyUnit(
                                                        primary: KeyElement("-"),
                                                        members: [
                                                                KeyElement("-"),
                                                                KeyElement("_")
                                                        ]
                                                )
                                        )
                                        LargePadUpperLowerInputKey(
                                                side: .trailing,
                                                upper: "+",
                                                lower: "=",
                                                unit: KeyUnit(
                                                        primary: KeyElement("="),
                                                        members: [
                                                                KeyElement("="),
                                                                KeyElement("+")
                                                        ]
                                                )
                                        )
                                        LargePadBackspaceKey(widthUnitTimes: 1.5)
                                }
                        }
                        HStack(spacing: 0 ) {
                                LargePadTabKey(widthUnitTimes: 1.5)
                                Group {
                                        LargePadLetterInputKey(.letterQ)
                                        LargePadLetterInputKey(.letterW)
                                        LargePadExpansibleInputKey(
                                                side: .leading,
                                                virtual: .letterE,
                                                unit:
                                                        KeyUnit(
                                                                primary: KeyElement("e"),
                                                                members: [
                                                                        KeyElement("e"),
                                                                        KeyElement("ē"),
                                                                        KeyElement("é"),
                                                                        KeyElement("ě"),
                                                                        KeyElement("è"),
                                                                        KeyElement("ë")
                                                                ]
                                                        )
                                        )
                                        LargePadLetterInputKey(.letterR)
                                        LargePadLetterInputKey(.letterT)
                                        LargePadLetterInputKey(.letterY)
                                        LargePadExpansibleInputKey(
                                                side: .trailing,
                                                virtual: .letterU,
                                                unit:
                                                        KeyUnit(
                                                                primary: KeyElement("u"),
                                                                members: [
                                                                        KeyElement("u"),
                                                                        KeyElement("ū"),
                                                                        KeyElement("ú"),
                                                                        KeyElement("ǔ"),
                                                                        KeyElement("ù"),
                                                                        KeyElement("ü")
                                                                ]
                                                        )
                                        )
                                        LargePadExpansibleInputKey(
                                                side: .trailing,
                                                virtual: .letterI,
                                                unit:
                                                        KeyUnit(
                                                                primary: KeyElement("i"),
                                                                members: [
                                                                        KeyElement("i"),
                                                                        KeyElement("ī"),
                                                                        KeyElement("í"),
                                                                        KeyElement("ǐ"),
                                                                        KeyElement("ì"),
                                                                        KeyElement("ï")
                                                                ]
                                                        )
                                        )
                                        LargePadExpansibleInputKey(
                                                side: .trailing,
                                                virtual: .letterO,
                                                unit:
                                                        KeyUnit(
                                                                primary: KeyElement("o"),
                                                                members: [
                                                                        KeyElement("o"),
                                                                        KeyElement("ō"),
                                                                        KeyElement("ó"),
                                                                        KeyElement("ǒ"),
                                                                        KeyElement("ò"),
                                                                        KeyElement("ö")
                                                                ]
                                                        )
                                        )
                                        LargePadLetterInputKey(.letterP)
                                }
                                if context.keyboardCase.isUppercased {
                                        LargePadInstantInputKey("{")
                                        LargePadInstantInputKey("}")
                                        LargePadInstantInputKey("|")
                                } else {
                                        LargePadUpperLowerInputKey(side: .trailing, upper: "{", lower: "[", unit: KeyUnit(primary: KeyElement("["), members: [KeyElement("["), KeyElement("{")]))
                                        LargePadUpperLowerInputKey(side: .trailing, upper: "}", lower: "]", unit: KeyUnit(primary: KeyElement("]"), members: [KeyElement("]"), KeyElement("}")]))
                                        LargePadUpperLowerInputKey(side: .trailing, upper: "|", lower: "\\", unit: KeyUnit(primary: KeyElement("\\"), members: [KeyElement("\\"), KeyElement("|")]))
                                }
                        }
                        HStack(spacing: 0) {
                                LargePadCapsLockKey(widthUnitTimes: 1.75)
                                Group {
                                        LargePadExpansibleInputKey(
                                                side: .leading,
                                                virtual: .letterA,
                                                unit:
                                                        KeyUnit(
                                                                primary: KeyElement("a"),
                                                                members: [
                                                                        KeyElement("a"),
                                                                        KeyElement("ā"),
                                                                        KeyElement("á"),
                                                                        KeyElement("ǎ"),
                                                                        KeyElement("à"),
                                                                        KeyElement("ä")
                                                                ]
                                                        )
                                        )
                                        LargePadLetterInputKey(.letterS)
                                        LargePadLetterInputKey(.letterD)
                                        LargePadLetterInputKey(.letterF)
                                        LargePadLetterInputKey(.letterG)
                                        LargePadLetterInputKey(.letterH)
                                        LargePadLetterInputKey(.letterJ)
                                        LargePadLetterInputKey(.letterK)
                                        LargePadLetterInputKey(.letterL)
                                }
                                if context.keyboardCase.isUppercased {
                                        LargePadInstantInputKey(":")
                                        LargePadExpansibleInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("\""), members: [KeyElement("\""), KeyElement("\u{201D}", extras: [.init("201D", alignment: .bottom)]), KeyElement("\u{201C}", extras: [.init("201C", alignment: .bottom)])]))
                                } else {
                                        LargePadUpperLowerInputKey(side: .trailing, upper: ":", lower: ";", unit: KeyUnit(primary: KeyElement(";"), members: [KeyElement(";"), KeyElement(":")]))
                                        LargePadUpperLowerInputKey(
                                                side: .trailing,
                                                upper: "\"",
                                                lower: "'",
                                                unit: KeyUnit(
                                                        primary: KeyElement("'"),
                                                        members: [
                                                                KeyElement("'"),
                                                                KeyElement("\""),
                                                                KeyElement("\u{2019}", extras: [.init("2019", alignment: .bottom)]),
                                                                KeyElement("\u{2018}", extras: [.init("2018", alignment: .bottom)])
                                                        ]
                                                )
                                        )
                                }
                                LargePadReturnKey(widthUnitTimes: 1.75)
                        }
                        HStack(spacing: 0) {
                                LargePadShiftKey(side: .leading, coefficient: 2.25)
                                Group {
                                        LargePadLetterInputKey(.letterZ)
                                        LargePadLetterInputKey(.letterX)
                                        LargePadLetterInputKey(.letterC)
                                        LargePadExpansibleInputKey(
                                                side: .leading,
                                                virtual: .letterV,
                                                unit:
                                                        KeyUnit(
                                                                primary: KeyElement("v"),
                                                                members: [
                                                                        KeyElement("v"),
                                                                        KeyElement("ǖ"),
                                                                        KeyElement("ǘ"),
                                                                        KeyElement("ǚ"),
                                                                        KeyElement("ǜ"),
                                                                        KeyElement("ü")
                                                                ]
                                                        )
                                        )
                                        LargePadLetterInputKey(.letterB)
                                        LargePadLetterInputKey(.letterN)
                                        LargePadLetterInputKey(.letterM)
                                }
                                if context.keyboardCase.isUppercased {
                                        LargePadInstantInputKey("<")
                                        LargePadInstantInputKey(">")
                                        LargePadExpansibleInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("?"), members: [KeyElement("?"), KeyElement("¿")]))
                                } else {
                                        LargePadUpperLowerInputKey(side: .trailing, upper: "<", lower: ",", unit: KeyUnit(primary: KeyElement(","), members: [KeyElement(","), KeyElement("<")]))
                                        LargePadUpperLowerInputKey(side: .trailing, upper: ">", lower: ".", unit: KeyUnit(primary: KeyElement("."), members: [KeyElement("."), KeyElement(">")]))
                                        LargePadUpperLowerInputKey(side: .trailing, upper: "?", lower: "/", unit: KeyUnit(primary: KeyElement("/"), members: [KeyElement("/"), KeyElement("?"), KeyElement("¿")]))
                                }
                                LargePadShiftKey(side: .trailing, coefficient: 2.25)
                        }
                        HStack(spacing: 0) {
                                if context.needsGlobeKey {
                                        LargePadGlobeKey(widthUnitTimes: 2.125)
                                } else {
                                        LargePadTransformKey(destination: .numeric, side: .leading, coefficient: 2.125)
                                }
                                LargePadTransformKey(destination: .numeric, side: .leading, coefficient: 2.125)
                                LargePadSpaceKey()
                                LargePadTransformKey(destination: .numeric, side: .trailing, coefficient: 2.125)
                                LargePadDismissKey(widthUnitTimes: 2.125)
                        }
                }
        }
}
