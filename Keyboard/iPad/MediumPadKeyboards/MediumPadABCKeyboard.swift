import SwiftUI

struct MediumPadABCKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        HStack(spacing: 0 ) {
                                MediumPadTabKey(widthUnitTimes: 1)
                                Group {
                                        PadPullableInputKey(upper: "1", lower: "q")
                                        PadPullableInputKey(upper: "2", lower: "w")
                                        PadPullableInputKey(upper: "3", lower: "e")
                                        PadPullableInputKey(upper: "4", lower: "r")
                                        PadPullableInputKey(upper: "5", lower: "t")
                                        PadPullableInputKey(upper: "6", lower: "y")
                                        PadPullableInputKey(upper: "7", lower: "u")
                                        PadPullableInputKey(upper: "8", lower: "i")
                                        PadPullableInputKey(upper: "9", lower: "o")
                                        PadPullableInputKey(upper: "0", lower: "p")
                                }
                                MediumPadBackspaceKey(widthUnitTimes: 1)
                        }
                        HStack(spacing: 0) {
                                MediumPadCapsLockKey(widthUnitTimes: 1.5)
                                Group {
                                        PadPullableInputKey(upper: "@", lower: "a")
                                        PadPullableInputKey(upper: "#", lower: "s")
                                        PadPullableInputKey(upper: "$", lower: "d")
                                        PadPullableInputKey(upper: "&", lower: "f")
                                        PadPullableInputKey(upper: "*", lower: "g")
                                        PadPullableInputKey(upper: "(", lower: "h")
                                        PadPullableInputKey(upper: ")", lower: "j")
                                        PadPullableInputKey(upper: "'", lower: "k")
                                        PadPullableInputKey(upper: "\"", lower: "l")
                                }
                                MediumPadReturnKey(widthUnitTimes: 1.5)
                        }
                        HStack(spacing: 0) {
                                MediumPadShiftKey(keyLocale: .leading, widthUnitTimes: 1.75)
                                Group {
                                        PadPullableInputKey(upper: "%", lower: "z")
                                        PadPullableInputKey(upper: "-", lower: "x")
                                        PadPullableInputKey(upper: "+", lower: "c")
                                        PadPullableInputKey(upper: "=", lower: "v")
                                        PadPullableInputKey(upper: "/", lower: "b")
                                        PadPullableInputKey(upper: ";", lower: "n")
                                        PadPullableInputKey(upper: ":", lower: "m")
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
