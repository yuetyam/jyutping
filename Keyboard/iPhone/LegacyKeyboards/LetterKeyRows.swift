import SwiftUI
import CommonExtensions
import CoreIME

struct FirstLetterKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        LetterInputKey(.letterQ)
                        LetterInputKey(.letterW)
                        LetterInputKey(.letterE)
                        LetterInputKey(.letterR)
                        LetterInputKey(.letterT)
                        LetterInputKey(.letterY)
                        LetterInputKey(.letterU)
                        LetterInputKey(.letterI)
                        LetterInputKey(.letterO)
                        LetterInputKey(.letterP)
                }
        }
}
struct FirstEnhancedLetterKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        EnhancedInputKey(side: .leading, virtual: .letterQ, unit: KeyUnit(primary: KeyElement("q", extras: [.init("1", alignment: .topTrailing)]), members: [KeyElement("q"), KeyElement("1")]))
                        EnhancedInputKey(side: .leading, virtual: .letterW, unit: KeyUnit(primary: KeyElement("w", extras: [.init("2", alignment: .topTrailing)]), members: [KeyElement("w"), KeyElement("2")]))
                        EnhancedInputKey(side: .leading, virtual: .letterE, unit: KeyUnit(primary: KeyElement("e", extras: [.init("3", alignment: .topTrailing)]), members: [KeyElement("e"), KeyElement("3")]))
                        EnhancedInputKey(side: .leading, virtual: .letterR, unit: KeyUnit(primary: KeyElement("r", extras: [.init("4", alignment: .topTrailing)]), members: [KeyElement("r"), KeyElement("4")]))
                        EnhancedInputKey(side: .leading, virtual: .letterT, unit: KeyUnit(primary: KeyElement("t", extras: [.init("5", alignment: .topTrailing)]), members: [KeyElement("t"), KeyElement("5")]))
                        EnhancedInputKey(side: .leading, virtual: .letterY, unit: KeyUnit(primary: KeyElement("y", extras: [.init("6", alignment: .topTrailing)]), members: [KeyElement("y"), KeyElement("6")]))
                        EnhancedInputKey(side: .trailing, virtual: .letterU, unit: KeyUnit(primary: KeyElement("u", extras: [.init("7", alignment: .topTrailing)]), members: [KeyElement("u"), KeyElement("7")]))
                        EnhancedInputKey(side: .trailing, virtual: .letterI, unit: KeyUnit(primary: KeyElement("i", extras: [.init("8", alignment: .topTrailing)]), members: [KeyElement("i"), KeyElement("8")]))
                        EnhancedInputKey(side: .trailing, virtual: .letterO, unit: KeyUnit(primary: KeyElement("o", extras: [.init("9", alignment: .topTrailing)]), members: [KeyElement("o"), KeyElement("9")]))
                        EnhancedInputKey(side: .trailing, virtual: .letterP, unit: KeyUnit(primary: KeyElement("p", extras: [.init("0", alignment: .topTrailing)]), members: [KeyElement("p"), KeyElement("0")]))
                }
        }
}

struct SecondLetterKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        LetterInputKey(.letterA)
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
struct SecondEnhancedLetterKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        EnhancedInputKey(side: .leading, virtual: .letterA, unit: KeyUnit(primary: KeyElement("a", extras: [.init("@", alignment: .topTrailing)]), members: [KeyElement("a"), KeyElement("@")]))
                        EnhancedInputKey(side: .leading, virtual: .letterS, unit: KeyUnit(primary: KeyElement("s", extras: [.init("#", alignment: .topTrailing)]), members: [KeyElement("s"), KeyElement("#")]))
                        EnhancedInputKey(side: .leading, virtual: .letterD, unit: KeyUnit(primary: KeyElement("d", extras: [.init("$", alignment: .topTrailing)]), members: [KeyElement("d"), KeyElement("$"), KeyElement("¥")]))
                        EnhancedInputKey(
                                side: .leading,
                                virtual: .letterF,
                                unit: KeyUnit(
                                        primary: KeyElement("f", extras: [.init("/", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("f"),
                                                KeyElement("/"),
                                                KeyElement("／", extras: [.init(PresetConstant.fullWidth, alignment: .top)]),
                                                KeyElement("\\"),
                                                KeyElement("＼", extras: [.init(PresetConstant.fullWidth, alignment: .top)])
                                        ]
                                )
                        )
                        EnhancedInputKey(side: .leading, virtual: .letterG, unit: KeyUnit(primary: KeyElement("g", extras: [.init("（", alignment: .topTrailing)]), members: [KeyElement("g"), KeyElement("（")]))
                        EnhancedInputKey(side: .trailing, virtual: .letterH, unit: KeyUnit(primary: KeyElement("h", extras: [.init("）", alignment: .topTrailing)]), members: [KeyElement("h"), KeyElement("）")]))
                        EnhancedInputKey(side: .trailing, virtual: .letterJ, unit: KeyUnit(primary: KeyElement("j", extras: [.init("「", alignment: .topTrailing)]), members: [KeyElement("j"), KeyElement("「")]))
                        EnhancedInputKey(side: .trailing, virtual: .letterK, unit: KeyUnit(primary: KeyElement("k", extras: [.init("」", alignment: .topTrailing)]), members: [KeyElement("k"), KeyElement("」")]))
                        EnhancedInputKey(
                                side: .trailing,
                                virtual: .letterL,
                                unit: KeyUnit(
                                        primary: KeyElement("l", extras: [.init("'", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("l"),
                                                KeyElement("'", extras: [.init("0027", alignment: .bottom)]),
                                                KeyElement("’", extras: [.init(PresetConstant.right, alignment: .top), .init("2019", alignment: .bottom)]),
                                                KeyElement("‘", extras: [.init(PresetConstant.left, alignment: .top), .init("2018", alignment: .bottom)]),
                                                KeyElement("\"", extras: [.init("0022", alignment: .bottom)]),
                                                KeyElement("”", extras: [.init(PresetConstant.right, alignment: .top), .init("201D", alignment: .bottom)]),
                                                KeyElement("“", extras: [.init(PresetConstant.left, alignment: .top), .init("201C", alignment: .bottom)])
                                        ]
                                )
                        )
                }
        }
}

struct ThirdLetterKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        LetterInputKey(.letterZ)
                        LetterInputKey(.letterX)
                        LetterInputKey(.letterC)
                        LetterInputKey(.letterV)
                        LetterInputKey(.letterB)
                        LetterInputKey(.letterN)
                        LetterInputKey(.letterM)
                }
        }
}
struct ThirdEnhancedLetterKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        EnhancedInputKey(
                                side: .leading,
                                virtual: .letterZ,
                                unit: KeyUnit(
                                        primary: KeyElement("z", extras: [.init("%", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("z"),
                                                KeyElement("%"),
                                                KeyElement("％", extras: [.init(PresetConstant.fullWidth, alignment: .top)]),
                                                KeyElement("‰")
                                        ]
                                )
                        )
                        EnhancedInputKey(side: .leading, virtual: .letterX, unit: KeyUnit(primary: KeyElement("x", extras: [.init("-", alignment: .topTrailing)]), members: [KeyElement("x"), KeyElement("-")]))
                        EnhancedInputKey(side: .leading, virtual: .letterC, unit: KeyUnit(primary: KeyElement("c", extras: [.init("～", alignment: .topTrailing)]), members: [KeyElement("c"), KeyElement("～"), KeyElement("~", extras: [.init(PresetConstant.halfWidth, alignment: .top)])]))
                        EnhancedInputKey(side: .leading, virtual: .letterV, unit: KeyUnit(primary: KeyElement("v", extras: [.init("…", alignment: .topTrailing)]), members: [KeyElement("v"), KeyElement("…")]))
                        EnhancedInputKey(side: .leading, virtual: .letterB, unit: KeyUnit(primary: KeyElement("b", extras: [.init("、", alignment: .topTrailing)]), members: [KeyElement("b"), KeyElement("、")]))
                        EnhancedInputKey(side: .trailing, virtual: .letterN, unit: KeyUnit(primary: KeyElement("n", extras: [.init("；", alignment: .topTrailing)]), members: [KeyElement("n"), KeyElement("；")]))
                        EnhancedInputKey(side: .trailing, virtual: .letterM, unit: KeyUnit(primary: KeyElement("m", extras: [.init("：", alignment: .topTrailing)]), members: [KeyElement("m"), KeyElement("：")]))
                }
        }
}
