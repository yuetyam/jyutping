import SwiftUI

struct ABCKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        HStack(spacing: 0 ) {
                                LetterInputKey("q")
                                LetterInputKey("w")
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
                                LetterInputKey("r")
                                LetterInputKey("t")
                                LetterInputKey("y")
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
                                LetterInputKey("p")
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
                                        LetterInputKey("s")
                                        LetterInputKey("d")
                                        LetterInputKey("f")
                                        LetterInputKey("g")
                                        LetterInputKey("h")
                                        LetterInputKey("j")
                                        LetterInputKey("k")
                                        LetterInputKey("l")
                                }
                                HiddenKey(key: .letterL)
                        }
                        HStack(spacing: 0) {
                                ShiftKey()
                                HiddenKey(key: .letterZ)
                                Group {
                                        LetterInputKey("z")
                                        LetterInputKey("x")
                                        LetterInputKey("c")
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
                                        LetterInputKey("b")
                                        LetterInputKey("n")
                                        LetterInputKey("m")
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
                                        TransformKey(destination: .numeric, widthUnitTimes: 2)
                                        GlobeKey()
                                        SpaceKey()
                                        RightKey()
                                        ReturnKey()
                                }
                        case (false, false):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .numeric, widthUnitTimes: 2)
                                        LeftKey()
                                        SpaceKey()
                                        RightKey()
                                        ReturnKey()
                                }
                        }
                }
        }
}
