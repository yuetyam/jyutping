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
                                                        keyLocale: .leading,
                                                        keyModel: KeyModel(
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
                                                        keyLocale: .leading,
                                                        keyModel: KeyModel(
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
                                                        keyLocale: .leading,
                                                        keyModel: KeyModel(
                                                                primary: KeyElement("%"),
                                                                members: [
                                                                        KeyElement("%"),
                                                                        KeyElement("‰")
                                                                ]
                                                        )
                                                )
                                                LargePadInstantInputKey("^")
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
                                                LargePadExpansibleInputKey(
                                                        keyLocale: .trailing,
                                                        keyModel: KeyModel(
                                                                primary: KeyElement("*"),
                                                                members: [
                                                                        KeyElement("*"),
                                                                        KeyElement("•")
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
                                                keyLocale: .leading,
                                                upper: "~",
                                                lower: "`",
                                                keyModel: KeyModel(
                                                        primary: KeyElement("`"),
                                                        members: [
                                                                KeyElement("`"),
                                                                KeyElement("~")
                                                        ]
                                                )
                                        )
                                        Group {
                                                LargePadUpperLowerInputKey(
                                                        keyLocale: .leading,
                                                        upper: "!",
                                                        lower: "1",
                                                        event: .number1,
                                                        keyModel: KeyModel(
                                                                primary: KeyElement("1"),
                                                                members: [
                                                                        KeyElement("1"),
                                                                        KeyElement("!"),
                                                                        KeyElement("¡")
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        keyLocale: .leading,
                                                        upper: "@",
                                                        lower: "2",
                                                        event: .number2,
                                                        keyModel: KeyModel(
                                                                primary: KeyElement("2"),
                                                                members: [
                                                                        KeyElement("2"),
                                                                        KeyElement("@")
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        keyLocale: .leading,
                                                        upper: "#",
                                                        lower: "3",
                                                        event: .number3,
                                                        keyModel: KeyModel(
                                                                primary: KeyElement("3"),
                                                                members: [
                                                                        KeyElement("3"),
                                                                        KeyElement("#")
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        keyLocale: .leading,
                                                        upper: "$",
                                                        lower: "4",
                                                        event: .number4,
                                                        keyModel: KeyModel(
                                                                primary: KeyElement("4"),
                                                                members: [
                                                                        KeyElement("4"),
                                                                        KeyElement("$")
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        keyLocale: .leading,
                                                        upper: "%",
                                                        lower: "5",
                                                        event: .number5,
                                                        keyModel: KeyModel(
                                                                primary: KeyElement("5"),
                                                                members: [
                                                                        KeyElement("5"),
                                                                        KeyElement("%"),
                                                                        KeyElement("‰")
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        keyLocale: .leading,
                                                        upper: "^",
                                                        lower: "6",
                                                        event: .number6,
                                                        keyModel: KeyModel(
                                                                primary: KeyElement("6"),
                                                                members: [
                                                                        KeyElement("6"),
                                                                        KeyElement("^")
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        keyLocale: .trailing,
                                                        upper: "&",
                                                        lower: "7",
                                                        event: .number7,
                                                        keyModel: KeyModel(
                                                                primary: KeyElement("7"),
                                                                members: [
                                                                        KeyElement("7"),
                                                                        KeyElement("&"),
                                                                        KeyElement("§")
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        keyLocale: .trailing,
                                                        upper: "*",
                                                        lower: "8",
                                                        event: .number8,
                                                        keyModel: KeyModel(
                                                                primary: KeyElement("8"),
                                                                members: [
                                                                        KeyElement("8"),
                                                                        KeyElement("*"),
                                                                        KeyElement("•")
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        keyLocale: .trailing,
                                                        upper: "(",
                                                        lower: "9",
                                                        event: .number9,
                                                        keyModel: KeyModel(
                                                                primary: KeyElement("9"),
                                                                members: [
                                                                        KeyElement("9"),
                                                                        KeyElement("(")
                                                                ]
                                                        )
                                                )
                                                LargePadUpperLowerInputKey(
                                                        keyLocale: .trailing,
                                                        upper: ")",
                                                        lower: "0",
                                                        event: .number0,
                                                        keyModel: KeyModel(
                                                                primary: KeyElement("0"),
                                                                members: [
                                                                        KeyElement("0"),
                                                                        KeyElement(")")
                                                                ]
                                                        )
                                                )
                                        }
                                        LargePadUpperLowerInputKey(
                                                keyLocale: .trailing,
                                                upper: "_",
                                                lower: "-",
                                                keyModel: KeyModel(
                                                        primary: KeyElement("-"),
                                                        members: [
                                                                KeyElement("-"),
                                                                KeyElement("_")
                                                        ]
                                                )
                                        )
                                        LargePadUpperLowerInputKey(
                                                keyLocale: .trailing,
                                                upper: "+",
                                                lower: "=",
                                                keyModel: KeyModel(
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
                                                keyLocale: .leading,
                                                event: .letterE,
                                                keyModel:
                                                        KeyModel(
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
                                                keyLocale: .trailing,
                                                event: .letterU,
                                                keyModel:
                                                        KeyModel(
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
                                                keyLocale: .trailing,
                                                event: .letterI,
                                                keyModel:
                                                        KeyModel(
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
                                                keyLocale: .trailing,
                                                event: .letterO,
                                                keyModel:
                                                        KeyModel(
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
                                        LargePadUpperLowerInputKey(keyLocale: .trailing, upper: "{", lower: "[", keyModel: KeyModel(primary: KeyElement("["), members: [KeyElement("["), KeyElement("{")]))
                                        LargePadUpperLowerInputKey(keyLocale: .trailing, upper: "}", lower: "]", keyModel: KeyModel(primary: KeyElement("]"), members: [KeyElement("]"), KeyElement("}")]))
                                        LargePadUpperLowerInputKey(keyLocale: .trailing, upper: "|", lower: "\\", keyModel: KeyModel(primary: KeyElement("\\"), members: [KeyElement("\\"), KeyElement("|")]))
                                }
                        }
                        HStack(spacing: 0) {
                                LargePadCapsLockKey(widthUnitTimes: 1.75)
                                Group {
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                event: .letterA,
                                                keyModel:
                                                        KeyModel(
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
                                        LargePadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("\""), members: [KeyElement("\""), KeyElement("\u{201D}", footer: "201D"), KeyElement("\u{201C}", footer: "201C")]))
                                } else {
                                        LargePadUpperLowerInputKey(keyLocale: .trailing, upper: ":", lower: ";", keyModel: KeyModel(primary: KeyElement(";"), members: [KeyElement(";"), KeyElement(":")]))
                                        LargePadUpperLowerInputKey(
                                                keyLocale: .trailing,
                                                upper: "\"",
                                                lower: "'",
                                                keyModel: KeyModel(
                                                        primary: KeyElement("'"),
                                                        members: [
                                                                KeyElement("'"),
                                                                KeyElement("\""),
                                                                KeyElement("\u{2019}", footer: "2019"),
                                                                KeyElement("\u{2018}", footer: "2018")
                                                        ]
                                                )
                                        )
                                }
                                LargePadReturnKey(widthUnitTimes: 1.75)
                        }
                        HStack(spacing: 0) {
                                LargePadShiftKey(keyLocale: .leading, widthUnitTimes: 2.25)
                                Group {
                                        LargePadLetterInputKey(.letterZ)
                                        LargePadLetterInputKey(.letterX)
                                        LargePadLetterInputKey(.letterC)
                                        LargePadExpansibleInputKey(
                                                keyLocale: .leading,
                                                event: .letterV,
                                                keyModel:
                                                        KeyModel(
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
                                        LargePadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("?"), members: [KeyElement("?"), KeyElement("¿")]))
                                } else {
                                        LargePadUpperLowerInputKey(keyLocale: .trailing, upper: "<", lower: ",", keyModel: KeyModel(primary: KeyElement(","), members: [KeyElement(","), KeyElement("<")]))
                                        LargePadUpperLowerInputKey(keyLocale: .trailing, upper: ">", lower: ".", keyModel: KeyModel(primary: KeyElement("."), members: [KeyElement("."), KeyElement(">")]))
                                        LargePadUpperLowerInputKey(keyLocale: .trailing, upper: "?", lower: "/", keyModel: KeyModel(primary: KeyElement("/"), members: [KeyElement("/"), KeyElement("?"), KeyElement("¿")]))
                                }
                                LargePadShiftKey(keyLocale: .trailing, widthUnitTimes: 2.25)
                        }
                        HStack(spacing: 0) {
                                if context.needsInputModeSwitchKey {
                                        LargePadGlobeKey(widthUnitTimes: 2.125)
                                } else {
                                        LargePadTransformKey(destination: .numeric, keyLocale: .leading, widthUnitTimes: 2.125)
                                }
                                LargePadTransformKey(destination: .numeric, keyLocale: .leading, widthUnitTimes: 2.125)
                                LargePadSpaceKey()
                                LargePadTransformKey(destination: .numeric, keyLocale: .trailing, widthUnitTimes: 2.125)
                                LargePadDismissKey(widthUnitTimes: 2.125)
                        }
                }
        }
}
