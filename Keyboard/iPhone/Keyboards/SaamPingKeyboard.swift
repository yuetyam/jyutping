import SwiftUI

struct SaamPingKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        if context.inputStage.isBuffering {
                                CandidateScrollBar()
                        } else {
                                ToolBar()
                        }
                        HStack(spacing: 0 ) {
                                ExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("aa"), members: [KeyElement("aa"), KeyElement("q")]))
                                LetterInputKey("w")
                                LetterInputKey("e")
                                ExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("oe", header: "eo"), members: [KeyElement("oe"), KeyElement("r"), KeyElement("eo")]))
                                LetterInputKey("t")
                                ExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("yu"), members: [KeyElement("yu"), KeyElement("y")]))
                                LetterInputKey("u")
                                LetterInputKey("i")
                                LetterInputKey("o")
                                LetterInputKey("p")
                        }
                        HStack(spacing: 0) {
                                HiddenKey(key: .letterA)
                                Group {
                                        LetterInputKey("a")
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
                                        ExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("z", header: "1"), members: [KeyElement("z"), KeyElement("1", footer: "陰平")]))
                                        ExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("gw", header: "2"), members: [KeyElement("gw"), KeyElement("2", footer: "陰上"), KeyElement("x"), KeyElement("kw")]))
                                        ExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("c", header: "3"), members: [KeyElement("c"), KeyElement("3", footer: "陰去")]))
                                        ExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("ng", header: "4"), members: [KeyElement("ng"), KeyElement("4", footer: "陽平"), KeyElement("v")]))
                                        ExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("b", header: "5"), members: [KeyElement("b"), KeyElement("5", footer: "陽上")]))
                                        ExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("n", header: "6"), members: [KeyElement("n"), KeyElement("6", footer: "陽去")]))
                                        ExpansibleInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("m"), members: [KeyElement("m"), KeyElement("kw")]))
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
