import SwiftUI
import CoreIME

struct MediumPadABCKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        HStack(spacing: 0 ) {
                                MediumPadTabKey(widthUnitTimes: 1)
                                Group {
                                        PadPullableInputKey(event: .letterQ, upper: "1", lower: "q")
                                        PadPullableInputKey(event: .letterW, upper: "2", lower: "w")
                                        PadCompleteInputKey(
                                                keyLocale: .leading,
                                                event: .letterE,
                                                upper: "3",
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
                                        PadPullableInputKey(event: .letterR, upper: "4", lower: "r")
                                        PadPullableInputKey(event: .letterT, upper: "5", lower: "t")
                                        PadPullableInputKey(event: .letterY, upper: "6", lower: "y")
                                        PadCompleteInputKey(
                                                keyLocale: .trailing,
                                                event: .letterU,
                                                upper: "7",
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
                                        PadCompleteInputKey(
                                                keyLocale: .trailing,
                                                event: .letterI,
                                                upper: "8",
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
                                        PadCompleteInputKey(
                                                keyLocale: .trailing,
                                                event: .letterO,
                                                upper: "9",
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
                                        PadPullableInputKey(event: .letterP, upper: "0", lower: "p")
                                }
                                MediumPadBackspaceKey(widthUnitTimes: 1)
                        }
                        HStack(spacing: 0) {
                                MediumPadCapsLockKey(widthUnitTimes: 1.5)
                                Group {
                                        PadCompleteInputKey(
                                                keyLocale: .leading,
                                                event: .letterA,
                                                upper: "@",
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
                                        PadPullableInputKey(event: .letterS, upper: "#", lower: "s")
                                        PadPullableInputKey(event: .letterD, upper: "$", lower: "d")
                                        PadPullableInputKey(event: .letterF, upper: "&", lower: "f")
                                        PadPullableInputKey(event: .letterG, upper: "*", lower: "g")
                                        PadPullableInputKey(event: .letterH, upper: "(", lower: "h")
                                        PadPullableInputKey(event: .letterJ, upper: ")", lower: "j")
                                        PadPullableInputKey(event: .letterK, upper: "'", lower: "k")
                                        PadPullableInputKey(event: .letterL, upper: "\"", lower: "l")
                                }
                                MediumPadReturnKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0) {
                                MediumPadShiftKey(keyLocale: .leading, widthUnitTimes: 1.75)
                                Group {
                                        PadPullableInputKey(event: .letterZ, upper: "%", lower: "z")
                                        PadPullableInputKey(event: .letterX, upper: "-", lower: "x")
                                        PadPullableInputKey(event: .letterC, upper: "+", lower: "c")
                                        PadCompleteInputKey(
                                                keyLocale: .leading,
                                                event: .letterV,
                                                upper: "=",
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
                                        PadPullableInputKey(event: .letterB, upper: "/", lower: "b")
                                        PadPullableInputKey(event: .letterN, upper: ";", lower: "n")
                                        PadPullableInputKey(event: .letterM, upper: ":", lower: "m")
                                }
                                if context.keyboardCase.isUppercased {
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("!"), members: [KeyElement("!"), KeyElement("'"), KeyElement("¡")]))
                                        PadExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("?"), members: [KeyElement("?"), KeyElement("\""), KeyElement("…"), KeyElement("¿")]))
                                } else {
                                        PadUpperLowerInputKey(keyLocale: .trailing, upper: "!", lower: ",", keyModel: KeyModel(primary: KeyElement(","), members: [KeyElement(","), KeyElement("!"), KeyElement("'"), KeyElement("¡")]))
                                        PadUpperLowerInputKey(keyLocale: .trailing, upper: "?", lower: ".", keyModel: KeyModel(primary: KeyElement("."), members: [KeyElement("."), KeyElement("?"), KeyElement("\""), KeyElement("…"), KeyElement("¿")]))
                                }
                                MediumPadShiftKey(keyLocale: .trailing, widthUnitTimes: 1.25)
                        }
                        HStack(spacing: 0) {
                                if context.needsInputModeSwitchKey {
                                        MediumPadGlobeKey(widthUnitTimes: 1.5)
                                } else {
                                        MediumPadTransformKey(destination: .numeric, keyLocale: .leading, widthUnitTimes: 1.5)
                                }
                                MediumPadTransformKey(destination: .numeric, keyLocale: .leading, widthUnitTimes: 1.5)
                                PadSpaceKey()
                                MediumPadTransformKey(destination: .numeric, keyLocale: .trailing, widthUnitTimes: 1.5)
                                MediumPadDismissKey(widthUnitTimes: 1.5)
                        }
                }
        }
}
