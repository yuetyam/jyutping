import SwiftUI
import CoreIME

struct ABCKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        if Options.needsNumberRow {
                                ABCNumberRow()
                        }
                        switch Options.inputKeyStyle {
                        case .clear:
                                FirstInputKeyRow()
                        case .numbers, .numbersAndSymbols:
                                FirstEnhancedInputKeyRow()
                        }
                        HStack(spacing: 0) {
                                HiddenKey(key: .letterA)
                                switch Options.inputKeyStyle {
                                case .clear, .numbers:
                                        SecondInputKeyRow()
                                case .numbersAndSymbols:
                                        SecondEnhancedInputKeyRow()
                                }
                                HiddenKey(key: .letterL)
                        }
                        HStack(spacing: 0) {
                                ShiftKey()
                                HiddenKey(key: .letterZ)
                                switch Options.inputKeyStyle {
                                case .clear, .numbers:
                                        ThirdInputKeyRow()
                                case .numbersAndSymbols:
                                        ThirdEnhancedInputKeyRow()
                                }
                                HiddenKey(key: .backspace)
                                BackspaceKey()
                        }
                        switch (context.keyboardInterface.isPadFloating, context.needsInputModeSwitchKey) {
                        case (true, true):
                                if #available(iOSApplicationExtension 26.0, *) {
                                        HStack(spacing: 0) {
                                                TransformKey(destination: .numeric, widthUnitTimes: 2)
                                                ABCLeftKey()
                                                SpaceKey()
                                                ABCRightKey()
                                                ReturnKey()
                                        }
                                } else {
                                        HStack(spacing: 0) {
                                                GlobeKey()
                                                TransformKey(destination: .numeric, widthUnitTimes: 2)
                                                SpaceKey()
                                                ABCRightAlternativeKey()
                                                ReturnKey()
                                        }
                                }
                        case (true, false):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .numeric, widthUnitTimes: 2)
                                        ABCLeftKey()
                                        SpaceKey()
                                        ABCRightKey()
                                        ReturnKey()
                                }
                        case (false, true):
                                HStack(spacing: 0) {
                                        TransformKey(destination: context.preferredNumericForm, widthUnitTimes: 2)
                                        GlobeKey()
                                        SpaceKey()
                                        ABCRightAlternativeKey()
                                        ReturnKey()
                                }
                        case (false, false):
                                HStack(spacing: 0) {
                                        TransformKey(destination: context.preferredNumericForm, widthUnitTimes: 2)
                                        ABCLeftKey()
                                        SpaceKey()
                                        ABCRightKey()
                                        ReturnKey()
                                }
                        }
                }
        }
}

private struct FirstInputKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        LetterInputKey(.letterQ)
                        LetterInputKey(.letterW)
                        EnhancedInputKey(
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
                        LetterInputKey(.letterR)
                        LetterInputKey(.letterT)
                        LetterInputKey(.letterY)
                        EnhancedInputKey(
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
                        EnhancedInputKey(
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
                        EnhancedInputKey(
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
                        LetterInputKey(.letterP)
                }
        }
}
private struct FirstEnhancedInputKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        EnhancedInputKey(keyLocale: .leading, event: .letterQ, keyModel: KeyModel(primary: KeyElement("q", header: "1"), members: [KeyElement("q"), KeyElement("1")]))
                        EnhancedInputKey(keyLocale: .leading, event: .letterW, keyModel: KeyModel(primary: KeyElement("w", header: "2"), members: [KeyElement("w"), KeyElement("2")]))
                        EnhancedInputKey(
                                keyLocale: .leading,
                                event: .letterE,
                                keyModel:
                                        KeyModel(
                                                primary: KeyElement("e", header: "3"),
                                                members: [
                                                        KeyElement("e"),
                                                        KeyElement("3"),
                                                        KeyElement("ē"),
                                                        KeyElement("é"),
                                                        KeyElement("ě"),
                                                        KeyElement("è"),
                                                        KeyElement("ë")
                                                ]
                                        )
                        )
                        EnhancedInputKey(keyLocale: .leading, event: .letterR, keyModel: KeyModel(primary: KeyElement("r", header: "4"), members: [KeyElement("r"), KeyElement("4")]))
                        EnhancedInputKey(keyLocale: .leading, event: .letterT, keyModel: KeyModel(primary: KeyElement("t", header: "5"), members: [KeyElement("t"), KeyElement("5")]))
                        EnhancedInputKey(keyLocale: .leading, event: .letterY, keyModel: KeyModel(primary: KeyElement("y", header: "6"), members: [KeyElement("y"), KeyElement("6")]))
                        EnhancedInputKey(
                                keyLocale: .trailing,
                                event: .letterU,
                                keyModel:
                                        KeyModel(
                                                primary: KeyElement("u", header: "7"),
                                                members: [
                                                        KeyElement("u"),
                                                        KeyElement("7"),
                                                        KeyElement("ū"),
                                                        KeyElement("ú"),
                                                        KeyElement("ǔ"),
                                                        KeyElement("ù"),
                                                        KeyElement("ü")
                                                ]
                                        )
                        )
                        EnhancedInputKey(
                                keyLocale: .trailing,
                                event: .letterI,
                                keyModel:
                                        KeyModel(
                                                primary: KeyElement("i", header: "8"),
                                                members: [
                                                        KeyElement("i"),
                                                        KeyElement("8"),
                                                        KeyElement("ī"),
                                                        KeyElement("í"),
                                                        KeyElement("ǐ"),
                                                        KeyElement("ì"),
                                                        KeyElement("ï")
                                                ]
                                        )
                        )
                        EnhancedInputKey(
                                keyLocale: .trailing,
                                event: .letterO,
                                keyModel:
                                        KeyModel(
                                                primary: KeyElement("o", header: "9"),
                                                members: [
                                                        KeyElement("o"),
                                                        KeyElement("9"),
                                                        KeyElement("ō"),
                                                        KeyElement("ó"),
                                                        KeyElement("ǒ"),
                                                        KeyElement("ò"),
                                                        KeyElement("ö")
                                                ]
                                        )
                        )
                        EnhancedInputKey(keyLocale: .trailing, event: .letterP, keyModel: KeyModel(primary: KeyElement("p", header: "0"), members: [KeyElement("p"), KeyElement("0")]))
                }
        }
}

private struct SecondInputKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        EnhancedInputKey(
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
                        LetterInputKey(.letterS)
                        LetterInputKey(.letterD)
                        LetterInputKey(.letterF)
                        LetterInputKey(.letterG)
                        LetterInputKey(.letterH)
                        LetterInputKey(.letterJ)
                        LetterInputKey(.letterK)
                        LetterInputKey(.letterL)
                }
        }
}
private struct SecondEnhancedInputKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        EnhancedInputKey(
                                keyLocale: .leading,
                                event: .letterA,
                                keyModel:
                                        KeyModel(
                                                primary: KeyElement("a", header: "@"),
                                                members: [
                                                        KeyElement("a"),
                                                        KeyElement("@"),
                                                        KeyElement("ā"),
                                                        KeyElement("á"),
                                                        KeyElement("ǎ"),
                                                        KeyElement("à"),
                                                        KeyElement("ä")
                                                ]
                                        )
                        )
                        EnhancedInputKey(keyLocale: .leading, event: .letterS, keyModel: KeyModel(primary: KeyElement("s", header: "#"), members: [KeyElement("s"), KeyElement("#")]))
                        EnhancedInputKey(keyLocale: .leading, event: .letterD, keyModel: KeyModel(primary: KeyElement("d", header: "$"), members: [KeyElement("d"), KeyElement("$")]))
                        EnhancedInputKey(keyLocale: .leading, event: .letterF, keyModel: KeyModel(primary: KeyElement("f", header: "&"), members: [KeyElement("f"), KeyElement("&")]))
                        EnhancedInputKey(keyLocale: .leading, event: .letterG, keyModel: KeyModel(primary: KeyElement("g", header: "*"), members: [KeyElement("g"), KeyElement("*")]))
                        EnhancedInputKey(keyLocale: .trailing, event: .letterH, keyModel: KeyModel(primary: KeyElement("h", header: "("), members: [KeyElement("h"), KeyElement("(")]))
                        EnhancedInputKey(keyLocale: .trailing, event: .letterJ, keyModel: KeyModel(primary: KeyElement("j", header: ")"), members: [KeyElement("j"), KeyElement(")")]))
                        EnhancedInputKey(
                                keyLocale: .trailing,
                                event: .letterK,
                                keyModel: KeyModel(
                                        primary: KeyElement("k", header: "'"),
                                        members: [
                                                KeyElement("k"),
                                                KeyElement("'", footer: "0027"),
                                                KeyElement("’", footer: "2019"),
                                                KeyElement("‘", footer: "2018")
                                        ]
                                )
                        )
                        EnhancedInputKey(
                                keyLocale: .trailing,
                                event: .letterL,
                                keyModel: KeyModel(
                                        primary: KeyElement("l", header: "\""),
                                        members: [
                                                KeyElement("l"),
                                                KeyElement("\"", footer: "0022"),
                                                KeyElement("”", footer: "201D"),
                                                KeyElement("“", footer: "201C")
                                        ]
                                )
                        )
                }
        }
}

private struct ThirdInputKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        LetterInputKey(.letterZ)
                        LetterInputKey(.letterX)
                        LetterInputKey(.letterC)
                        EnhancedInputKey(
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
                        LetterInputKey(.letterB)
                        LetterInputKey(.letterN)
                        LetterInputKey(.letterM)
                }
        }
}
private struct ThirdEnhancedInputKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        EnhancedInputKey(keyLocale: .leading, event: .letterZ, keyModel: KeyModel(primary: KeyElement("z", header: "%"), members: [KeyElement("z"), KeyElement("%")]))
                        EnhancedInputKey(keyLocale: .leading, event: .letterX, keyModel: KeyModel(primary: KeyElement("x", header: "-"), members: [KeyElement("x"), KeyElement("-")]))
                        EnhancedInputKey(keyLocale: .leading, event: .letterC, keyModel: KeyModel(primary: KeyElement("c", header: "+"), members: [KeyElement("c"), KeyElement("+")]))
                        EnhancedInputKey(
                                keyLocale: .leading,
                                event: .letterV,
                                keyModel:
                                        KeyModel(
                                                primary: KeyElement("v", header: "="),
                                                members: [
                                                        KeyElement("v"),
                                                        KeyElement("="),
                                                        KeyElement("ǖ"),
                                                        KeyElement("ǘ"),
                                                        KeyElement("ǚ"),
                                                        KeyElement("ǜ"),
                                                        KeyElement("ü")
                                                ]
                                        )
                        )
                        EnhancedInputKey(keyLocale: .leading, event: .letterB, keyModel: KeyModel(primary: KeyElement("b", header: "/"), members: [KeyElement("b"), KeyElement("/")]))
                        EnhancedInputKey(keyLocale: .trailing, event: .letterN, keyModel: KeyModel(primary: KeyElement("n", header: ";"), members: [KeyElement("n"), KeyElement(";")]))
                        EnhancedInputKey(keyLocale: .trailing, event: .letterM, keyModel: KeyModel(primary: KeyElement("m", header: ":"), members: [KeyElement("m"), KeyElement(":")]))
                }
        }
}
