import SwiftUI
import CoreIME

/// Cantonese Triple-Stroke Layout. 粵拼三拼鍵盤佈局
struct TripleStrokeKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        if context.inputStage.isBuffering {
                                CandidateBar()
                        } else {
                                ToolBar()
                        }
                        if Options.needsNumberRow {
                                NumberRow()
                        }
                        HStack(spacing: 0 ) {
                                ExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("aa", header: "1"), members: [KeyElement("aa"), KeyElement("1"), KeyElement("q")]))
                                ExpansibleInputKey(keyLocale: .leading, event: .letterW, keyModel: KeyModel(primary: KeyElement("w", header: "2"), members: [KeyElement("w"), KeyElement("2")]))
                                ExpansibleInputKey(keyLocale: .leading, event: .letterE, keyModel: KeyModel(primary: KeyElement("e", header: "3"), members: [KeyElement("e"), KeyElement("3")]))
                                ExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("oe", header: "4", footer: "eo"), members: [KeyElement("oe"), KeyElement("4"), KeyElement("r"), KeyElement("eo")]))
                                ExpansibleInputKey(keyLocale: .leading, event: .letterT, keyModel: KeyModel(primary: KeyElement("t", header: "5"), members: [KeyElement("t"), KeyElement("5")]))
                                ExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("yu", header: "6"), members: [KeyElement("yu"), KeyElement("6"), KeyElement("y")]))
                                ExpansibleInputKey(keyLocale: .trailing, event: .letterU, keyModel: KeyModel(primary: KeyElement("u", header: "7"), members: [KeyElement("u"), KeyElement("7")]))
                                ExpansibleInputKey(keyLocale: .trailing, event: .letterI, keyModel: KeyModel(primary: KeyElement("i", header: "8"), members: [KeyElement("i"), KeyElement("8")]))
                                ExpansibleInputKey(keyLocale: .trailing, event: .letterO, keyModel: KeyModel(primary: KeyElement("o", header: "9"), members: [KeyElement("o"), KeyElement("9")]))
                                ExpansibleInputKey(keyLocale: .trailing, event: .letterP, keyModel: KeyModel(primary: KeyElement("p", header: "0"), members: [KeyElement("p"), KeyElement("0")]))
                        }
                        HStack(spacing: 0) {
                                HiddenKey(key: .letterA)
                                Group {
                                        LetterInputKey(.letterA)
                                        LetterInputKey(.letterS)
                                        LetterInputKey(.letterD)
                                        LetterInputKey(.letterF)
                                        ExpansibleInputKey(keyLocale: .leading, event: .letterG, keyModel: KeyModel(primary: KeyElement("g"), members: [KeyElement("g"), KeyElement("gw")]))
                                        LetterInputKey(.letterH)
                                        LetterInputKey(.letterJ)
                                        ExpansibleInputKey(keyLocale: .trailing, event: .letterK, keyModel: KeyModel(primary: KeyElement("k"), members: [KeyElement("k"), KeyElement("kw")]))
                                        LetterInputKey(.letterL)
                                }
                                HiddenKey(key: .letterL)
                        }
                        HStack(spacing: 0) {
                                ShiftKey()
                                HiddenKey(key: .letterZ)
                                Group {
                                        LetterInputKey(.letterZ)
                                        ExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("gw", footer: "kw"), members: [KeyElement("gw"), KeyElement("x"), KeyElement("kw")]))
                                        LetterInputKey(.letterC)
                                        ExpansibleInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("ng"), members: [KeyElement("ng"), KeyElement("v")]))
                                        LetterInputKey(.letterB)
                                        LetterInputKey(.letterN)
                                        ExpansibleInputKey(keyLocale: .trailing, event: .letterM, keyModel: KeyModel(primary: KeyElement("m"), members: [KeyElement("m"), KeyElement("kw")]))
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
