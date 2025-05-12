import SwiftUI
import CoreIME

struct ABCKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        HStack(spacing: 0 ) {
                                LetterInputKey(.letterQ)
                                LetterInputKey(.letterW)
                                ExpansibleInputKey(
                                        keyLocale: .leading,
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
                                LetterInputKey(.letterR)
                                LetterInputKey(.letterT)
                                LetterInputKey(.letterY)
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
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
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
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
                                ExpansibleInputKey(
                                        keyLocale: .trailing,
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
                                LetterInputKey(.letterP)
                        }
                        HStack(spacing: 0) {
                                HiddenKey(key: .letterA)
                                Group {
                                        ExpansibleInputKey(
                                                keyLocale: .leading,
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
                                        LetterInputKey(.letterS)
                                        LetterInputKey(.letterD)
                                        LetterInputKey(.letterF)
                                        LetterInputKey(.letterG)
                                        LetterInputKey(.letterH)
                                        LetterInputKey(.letterJ)
                                        LetterInputKey(.letterK)
                                        LetterInputKey(.letterL)
                                }
                                HiddenKey(key: .letterL)
                        }
                        HStack(spacing: 0) {
                                ShiftKey()
                                HiddenKey(key: .letterZ)
                                Group {
                                        LetterInputKey(.letterZ)
                                        LetterInputKey(.letterX)
                                        LetterInputKey(.letterC)
                                        ExpansibleInputKey(
                                                keyLocale: .leading,
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
                                        LetterInputKey(.letterB)
                                        LetterInputKey(.letterN)
                                        LetterInputKey(.letterM)
                                }
                                HiddenKey(key: .backspace)
                                BackspaceKey()
                        }
                        switch (context.keyboardInterface.isPadFloating, context.needsInputModeSwitchKey) {
                        case (true, true):
                                HStack(spacing: 0) {
                                        GlobeKey()
                                        TransformKey(destination: .numeric, widthUnitTimes: 2)
                                        SpaceKey()
                                        RightKey()
                                        ReturnKey()
                                }
                        case (true, false):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .numeric, widthUnitTimes: 2)
                                        LeftKey()
                                        SpaceKey()
                                        RightKey()
                                        ReturnKey()
                                }
                        case (false, true):
                                HStack(spacing: 0) {
                                        TransformKey(destination: context.preferredNumericForm, widthUnitTimes: 2)
                                        GlobeKey()
                                        SpaceKey()
                                        RightKey()
                                        ReturnKey()
                                }
                        case (false, false):
                                HStack(spacing: 0) {
                                        TransformKey(destination: context.preferredNumericForm, widthUnitTimes: 2)
                                        LeftKey()
                                        SpaceKey()
                                        RightKey()
                                        ReturnKey()
                                }
                        }
                }
        }
}
