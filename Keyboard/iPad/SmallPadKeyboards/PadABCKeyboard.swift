import SwiftUI
import CoreIME

struct PadABCKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        HStack(spacing: 0 ) {
                                Group {
                                        PadPullableInputKey(virtual: .letterQ, upper: "1", lower: "q")
                                        PadPullableInputKey(virtual: .letterW, upper: "2", lower: "w")
                                        PadAdvancedInputKey(
                                                side: .leading,
                                                virtual: .letterE,
                                                upper: "3",
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
                                        PadPullableInputKey(virtual: .letterR, upper: "4", lower: "r")
                                        PadPullableInputKey(virtual: .letterT, upper: "5", lower: "t")
                                        PadPullableInputKey(virtual: .letterY, upper: "6", lower: "y")
                                        PadAdvancedInputKey(
                                                side: .trailing,
                                                virtual: .letterU,
                                                upper: "7",
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
                                        PadAdvancedInputKey(
                                                side: .trailing,
                                                virtual: .letterI,
                                                upper: "8",
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
                                        PadAdvancedInputKey(
                                                side: .trailing,
                                                virtual: .letterO,
                                                upper: "9",
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
                                        PadPullableInputKey(virtual: .letterP, upper: "0", lower: "p")
                                }
                                PadBackspaceKey(widthUnitTimes: 1)
                        }
                        HStack(spacing: 0) {
                                Spacer()
                                Group {
                                        PadAdvancedInputKey(
                                                side: .leading,
                                                virtual: .letterA,
                                                upper: "@",
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
                                        PadPullableInputKey(virtual: .letterS, upper: "#", lower: "s")
                                        PadPullableInputKey(virtual: .letterD, upper: "$", lower: "d")
                                        PadPullableInputKey(virtual: .letterF, upper: "&", lower: "f")
                                        PadPullableInputKey(virtual: .letterG, upper: "*", lower: "g")
                                        PadPullableInputKey(virtual: .letterH, upper: "(", lower: "h")
                                        PadPullableInputKey(virtual: .letterJ, upper: ")", lower: "j")
                                        PadPullableInputKey(virtual: .letterK, upper: "'", lower: "k")
                                        PadPullableInputKey(virtual: .letterL, upper: "\"", lower: "l")
                                }
                                PadReturnKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0) {
                                PadShiftKey()
                                Group {
                                        PadPullableInputKey(virtual: .letterZ, upper: "%", lower: "z")
                                        PadPullableInputKey(virtual: .letterX, upper: "-", lower: "x")
                                        PadPullableInputKey(virtual: .letterC, upper: "+", lower: "c")
                                        PadAdvancedInputKey(
                                                side: .leading,
                                                virtual: .letterV,
                                                upper: "=",
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
                                        PadPullableInputKey(virtual: .letterB, upper: "/", lower: "b")
                                        PadPullableInputKey(virtual: .letterN, upper: ";", lower: "n")
                                        PadPullableInputKey(virtual: .letterM, upper: ":", lower: "m")
                                }
                                if context.keyboardCase.isUppercased {
                                        PadExpansibleInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("!"), members: [KeyElement("!"), KeyElement("'"), KeyElement("¡")]))
                                        PadExpansibleInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("?"), members: [KeyElement("?"), KeyElement("\""), KeyElement("…"), KeyElement("¿")]))
                                } else {
                                        PadUpperLowerInputKey(side: .trailing, upper: "!", lower: ",", unit: KeyUnit(primary: KeyElement(","), members: [KeyElement(","), KeyElement("!"), KeyElement("'"), KeyElement("¡")]))
                                        PadUpperLowerInputKey(side: .trailing, upper: "?", lower: ".", unit: KeyUnit(primary: KeyElement("."), members: [KeyElement("."), KeyElement("?"), KeyElement("\""), KeyElement("…"), KeyElement("¿")]))
                                }
                                PadShiftKey()
                        }
                        HStack(spacing: 0) {
                                if context.needsInputModeSwitchKey {
                                        PadGlobeKey(widthUnitTimes: 1.5)
                                } else {
                                        PadTransformKey(destination: .numeric, coefficient: 1.5)
                                }
                                PadTransformKey(destination: .numeric, coefficient: 1.5)
                                PadSpaceKey()
                                PadTransformKey(destination: .numeric, coefficient: 1.5)
                                PadDismissKey(widthUnitTimes: 1.5)
                        }
                }
        }
}
