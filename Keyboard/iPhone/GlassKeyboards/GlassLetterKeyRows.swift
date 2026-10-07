import SwiftUI
import CommonExtensions
import CoreIME

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassFirstLetterKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        GlassLetterInputKey(.letterQ)
                        GlassLetterInputKey(.letterW)
                        GlassLetterInputKey(.letterE)
                        GlassLetterInputKey(.letterR)
                        GlassLetterInputKey(.letterT)
                        GlassLetterInputKey(.letterY)
                        GlassLetterInputKey(.letterU)
                        GlassLetterInputKey(.letterI)
                        GlassLetterInputKey(.letterO)
                        GlassLetterInputKey(.letterP)
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassFirstEnhancedLetterKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        GlassEnhancedInputKey(side: .leading, virtual: .letterQ, unit: KeyUnit(primary: KeyElement("q", extras: [.init("1", alignment: .topTrailing)]), members: [KeyElement("q"), KeyElement("1")]))
                        GlassEnhancedInputKey(side: .leading, virtual: .letterW, unit: KeyUnit(primary: KeyElement("w", extras: [.init("2", alignment: .topTrailing)]), members: [KeyElement("w"), KeyElement("2")]))
                        GlassEnhancedInputKey(side: .leading, virtual: .letterE, unit: KeyUnit(primary: KeyElement("e", extras: [.init("3", alignment: .topTrailing)]), members: [KeyElement("e"), KeyElement("3")]))
                        GlassEnhancedInputKey(side: .leading, virtual: .letterR, unit: KeyUnit(primary: KeyElement("r", extras: [.init("4", alignment: .topTrailing)]), members: [KeyElement("r"), KeyElement("4")]))
                        GlassEnhancedInputKey(side: .leading, virtual: .letterT, unit: KeyUnit(primary: KeyElement("t", extras: [.init("5", alignment: .topTrailing)]), members: [KeyElement("t"), KeyElement("5")]))
                        GlassEnhancedInputKey(side: .leading, virtual: .letterY, unit: KeyUnit(primary: KeyElement("y", extras: [.init("6", alignment: .topTrailing)]), members: [KeyElement("y"), KeyElement("6")]))
                        GlassEnhancedInputKey(side: .trailing, virtual: .letterU, unit: KeyUnit(primary: KeyElement("u", extras: [.init("7", alignment: .topTrailing)]), members: [KeyElement("u"), KeyElement("7")]))
                        GlassEnhancedInputKey(side: .trailing, virtual: .letterI, unit: KeyUnit(primary: KeyElement("i", extras: [.init("8", alignment: .topTrailing)]), members: [KeyElement("i"), KeyElement("8")]))
                        GlassEnhancedInputKey(side: .trailing, virtual: .letterO, unit: KeyUnit(primary: KeyElement("o", extras: [.init("9", alignment: .topTrailing)]), members: [KeyElement("o"), KeyElement("9")]))
                        GlassEnhancedInputKey(side: .trailing, virtual: .letterP, unit: KeyUnit(primary: KeyElement("p", extras: [.init("0", alignment: .topTrailing)]), members: [KeyElement("p"), KeyElement("0")]))
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassSecondLetterKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        GlassLetterInputKey(.letterA)
                        GlassLetterInputKey(.letterS)
                        GlassLetterInputKey(.letterD)
                        GlassLetterInputKey(.letterF)
                        GlassLetterInputKey(.letterG)
                        GlassLetterInputKey(.letterH)
                        GlassLetterInputKey(.letterJ)
                        GlassLetterInputKey(.letterK)
                        GlassLetterInputKey(.letterL)
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassSecondEnhancedLetterKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        GlassEnhancedInputKey(side: .leading, virtual: .letterA, unit: KeyUnit(primary: KeyElement("a", extras: [.init("@", alignment: .topTrailing)]), members: [KeyElement("a"), KeyElement("@")]))
                        GlassEnhancedInputKey(side: .leading, virtual: .letterS, unit: KeyUnit(primary: KeyElement("s", extras: [.init("#", alignment: .topTrailing)]), members: [KeyElement("s"), KeyElement("#")]))
                        GlassEnhancedInputKey(side: .leading, virtual: .letterD, unit: KeyUnit(primary: KeyElement("d", extras: [.init("$", alignment: .topTrailing)]), members: [KeyElement("d"), KeyElement("$"), KeyElement("¥")]))
                        GlassEnhancedInputKey(
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
                        GlassEnhancedInputKey(side: .leading, virtual: .letterG, unit: KeyUnit(primary: KeyElement("g", extras: [.init("（", alignment: .topTrailing)]), members: [KeyElement("g"), KeyElement("（")]))
                        GlassEnhancedInputKey(side: .trailing, virtual: .letterH, unit: KeyUnit(primary: KeyElement("h", extras: [.init("）", alignment: .topTrailing)]), members: [KeyElement("h"), KeyElement("）")]))
                        GlassEnhancedInputKey(side: .trailing, virtual: .letterJ, unit: KeyUnit(primary: KeyElement("j", extras: [.init("「", alignment: .topTrailing)]), members: [KeyElement("j"), KeyElement("「")]))
                        GlassEnhancedInputKey(side: .trailing, virtual: .letterK, unit: KeyUnit(primary: KeyElement("k", extras: [.init("」", alignment: .topTrailing)]), members: [KeyElement("k"), KeyElement("」")]))
                        GlassEnhancedInputKey(
                                side: .trailing,
                                virtual: .letterL,
                                unit: KeyUnit(
                                        primary: KeyElement("l", extras: [.init("'", alignment: .topTrailing)]),
                                        members: [
                                                KeyElement("l"),
                                                KeyElement("'", extras: [.init("0027", alignment: .bottom)]),
                                                KeyElement("’", extras: [.init("右", alignment: .top), .init("2019", alignment: .bottom)]),
                                                KeyElement("‘", extras: [.init("左", alignment: .top), .init("2018", alignment: .bottom)]),
                                                KeyElement("\"", extras: [.init("0022", alignment: .bottom)]),
                                                KeyElement("”", extras: [.init("右", alignment: .top), .init("201D", alignment: .bottom)]),
                                                KeyElement("“", extras: [.init("左", alignment: .top), .init("201C", alignment: .bottom)])
                                        ]
                                )
                        )
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassThirdLetterKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        GlassLetterInputKey(.letterZ)
                        GlassLetterInputKey(.letterX)
                        GlassLetterInputKey(.letterC)
                        GlassLetterInputKey(.letterV)
                        GlassLetterInputKey(.letterB)
                        GlassLetterInputKey(.letterN)
                        GlassLetterInputKey(.letterM)
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassThirdEnhancedLetterKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        GlassEnhancedInputKey(
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
                        GlassEnhancedInputKey(side: .leading, virtual: .letterX, unit: KeyUnit(primary: KeyElement("x", extras: [.init("-", alignment: .topTrailing)]), members: [KeyElement("x"), KeyElement("-")]))
                        GlassEnhancedInputKey(side: .leading, virtual: .letterC, unit: KeyUnit(primary: KeyElement("c", extras: [.init("～", alignment: .topTrailing)]), members: [KeyElement("c"), KeyElement("～"), KeyElement("~", extras: [.init(PresetConstant.halfWidth, alignment: .top)])]))
                        GlassEnhancedInputKey(side: .leading, virtual: .letterV, unit: KeyUnit(primary: KeyElement("v", extras: [.init("…", alignment: .topTrailing)]), members: [KeyElement("v"), KeyElement("…")]))
                        GlassEnhancedInputKey(side: .leading, virtual: .letterB, unit: KeyUnit(primary: KeyElement("b", extras: [.init("、", alignment: .topTrailing)]), members: [KeyElement("b"), KeyElement("、")]))
                        GlassEnhancedInputKey(side: .trailing, virtual: .letterN, unit: KeyUnit(primary: KeyElement("n", extras: [.init("；", alignment: .topTrailing)]), members: [KeyElement("n"), KeyElement("；")]))
                        GlassEnhancedInputKey(side: .trailing, virtual: .letterM, unit: KeyUnit(primary: KeyElement("m", extras: [.init("：", alignment: .topTrailing)]), members: [KeyElement("m"), KeyElement("：")]))
                }
        }
}
