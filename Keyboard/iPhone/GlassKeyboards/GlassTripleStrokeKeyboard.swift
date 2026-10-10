import SwiftUI
import CoreIME

/// Cantonese Triple-Stroke Layout with glass-styled keys. 粵拼三拼鍵盤佈局
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassTripleStrokeKeyboard: View {
        @EnvironmentObject private var context: KeyboardViewController
        var body: some View {
                VStack(spacing: 0) {
                        if context.inputStage.isBuffering {
                                CandidateBar()
                        } else {
                                ToolBar()
                        }
                        if Options.needsNumberRow {
                                CantoneseGlassNumberRow()
                        }
                        switch Options.inputKeyStyle {
                        case .clear:
                                FirstKeyRow()
                        case .numbers, .symbols:
                                FirstEnhancedKeyRow()
                        }
                        HStack(spacing: 0) {
                                HiddenKey(key: .letterA)
                                switch Options.inputKeyStyle {
                                case .clear, .numbers:
                                        SecondKeyRow()
                                case .symbols:
                                        SecondEnhancedKeyRow()
                                }
                                HiddenKey(key: .letterL)
                        }
                        HStack(spacing: 0) {
                                GlassShiftKey()
                                HiddenKey(key: .letterZ)
                                switch Options.inputKeyStyle {
                                case .clear, .numbers:
                                        ThirdKeyRow()
                                case .symbols:
                                        ThirdEnhancedKeyRow()
                                }
                                HiddenKey(key: .backspace)
                                GlassBackspaceKey()
                        }
                        GlassCantoneseBottomKeyRow()
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct FirstKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        GlassEnhancedInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("aa"), members: [KeyElement("aa"), KeyElement("q")]))
                        GlassLetterInputKey(.letterW)
                        GlassLetterInputKey(.letterE)
                        GlassEnhancedInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("oe", extras: [.init("eo", alignment: .bottomTrailing)]), members: [KeyElement("oe"), KeyElement("r"), KeyElement("eo")]))
                        GlassLetterInputKey(.letterT)
                        GlassEnhancedInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("yu"), members: [KeyElement("yu"), KeyElement("y")]))
                        GlassLetterInputKey(.letterU)
                        GlassLetterInputKey(.letterI)
                        GlassLetterInputKey(.letterO)
                        GlassLetterInputKey(.letterP)
                }
        }
}
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct FirstEnhancedKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        GlassEnhancedInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("aa", extras: [.init("1", alignment: .topTrailing)]), members: [KeyElement("aa"), KeyElement("1"), KeyElement("q")]))
                        GlassEnhancedInputKey(side: .leading, virtual: .letterW, unit: KeyUnit(primary: KeyElement("w", extras: [.init("2", alignment: .topTrailing)]), members: [KeyElement("w"), KeyElement("2")]))
                        GlassEnhancedInputKey(side: .leading, virtual: .letterE, unit: KeyUnit(primary: KeyElement("e", extras: [.init("3", alignment: .topTrailing)]), members: [KeyElement("e"), KeyElement("3")]))
                        GlassEnhancedInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("oe", extras: [.init("4", alignment: .topTrailing), .init("eo", alignment: .bottomTrailing)]), members: [KeyElement("oe"), KeyElement("4"), KeyElement("r"), KeyElement("eo")]))
                        GlassEnhancedInputKey(side: .leading, virtual: .letterT, unit: KeyUnit(primary: KeyElement("t", extras: [.init("5", alignment: .topTrailing)]), members: [KeyElement("t"), KeyElement("5")]))
                        GlassEnhancedInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("yu", extras: [.init("6", alignment: .topTrailing)]), members: [KeyElement("yu"), KeyElement("6"), KeyElement("y")]))
                        GlassEnhancedInputKey(side: .trailing, virtual: .letterU, unit: KeyUnit(primary: KeyElement("u", extras: [.init("7", alignment: .topTrailing)]), members: [KeyElement("u"), KeyElement("7")]))
                        GlassEnhancedInputKey(side: .trailing, virtual: .letterI, unit: KeyUnit(primary: KeyElement("i", extras: [.init("8", alignment: .topTrailing)]), members: [KeyElement("i"), KeyElement("8")]))
                        GlassEnhancedInputKey(side: .trailing, virtual: .letterO, unit: KeyUnit(primary: KeyElement("o", extras: [.init("9", alignment: .topTrailing)]), members: [KeyElement("o"), KeyElement("9")]))
                        GlassEnhancedInputKey(side: .trailing, virtual: .letterP, unit: KeyUnit(primary: KeyElement("p", extras: [.init("0", alignment: .topTrailing)]), members: [KeyElement("p"), KeyElement("0")]))
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct SecondKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        GlassLetterInputKey(.letterA)
                        GlassLetterInputKey(.letterS)
                        GlassLetterInputKey(.letterD)
                        GlassLetterInputKey(.letterF)
                        GlassEnhancedInputKey(side: .leading, virtual: .letterG, unit: KeyUnit(primary: KeyElement("g"), members: [KeyElement("g"), KeyElement("gw")]))
                        GlassLetterInputKey(.letterH)
                        GlassLetterInputKey(.letterJ)
                        GlassEnhancedInputKey(side: .trailing, virtual: .letterK, unit: KeyUnit(primary: KeyElement("k"), members: [KeyElement("k"), KeyElement("kw")]))
                        GlassLetterInputKey(.letterL)
                }
        }
}
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct SecondEnhancedKeyRow: View {
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
                        GlassEnhancedInputKey(side: .leading, virtual: .letterG, unit: KeyUnit(primary: KeyElement("g", extras: [.init("（", alignment: .topTrailing)]), members: [KeyElement("g"), KeyElement("（"), KeyElement("gw")]))
                        GlassEnhancedInputKey(side: .trailing, virtual: .letterH, unit: KeyUnit(primary: KeyElement("h", extras: [.init("）", alignment: .topTrailing)]), members: [KeyElement("h"), KeyElement("）")]))
                        GlassEnhancedInputKey(side: .trailing, virtual: .letterJ, unit: KeyUnit(primary: KeyElement("j", extras: [.init("「", alignment: .topTrailing)]), members: [KeyElement("j"), KeyElement("「")]))
                        GlassEnhancedInputKey(side: .trailing, virtual: .letterK, unit: KeyUnit(primary: KeyElement("k", extras: [.init("」", alignment: .topTrailing)]), members: [KeyElement("k"), KeyElement("」"), KeyElement("kw")]))
                        GlassEnhancedInputKey(
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

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct ThirdKeyRow: View {
        var body: some View {
                HStack(spacing: 0 ) {
                        GlassLetterInputKey(.letterZ)
                        GlassEnhancedInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("gw", extras: [.init("kw", alignment: .bottomTrailing)]), members: [KeyElement("gw"), KeyElement("x"), KeyElement("kw")]))
                        GlassLetterInputKey(.letterC)
                        GlassEnhancedInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("ng"), members: [KeyElement("ng"), KeyElement("v")]))
                        GlassLetterInputKey(.letterB)
                        GlassLetterInputKey(.letterN)
                        GlassLetterInputKey(.letterM)
                }
        }
}
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct ThirdEnhancedKeyRow: View {
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
                        GlassEnhancedInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("gw", extras: [.init("-", alignment: .topTrailing), .init("kw", alignment: .bottomTrailing)]), members: [KeyElement("gw"), KeyElement("-"), KeyElement("x"), KeyElement("kw")]))
                        GlassEnhancedInputKey(side: .leading, virtual: .letterC, unit: KeyUnit(primary: KeyElement("c", extras: [.init("～", alignment: .topTrailing)]), members: [KeyElement("c"), KeyElement("～"), KeyElement("~", extras: [.init(PresetConstant.halfWidth, alignment: .top)])]))
                        GlassEnhancedInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("ng", extras: [.init("…", alignment: .topTrailing)]), members: [KeyElement("ng"), KeyElement("…"), KeyElement("v")]))
                        GlassEnhancedInputKey(side: .leading, virtual: .letterB, unit: KeyUnit(primary: KeyElement("b", extras: [.init("、", alignment: .topTrailing)]), members: [KeyElement("b"), KeyElement("、")]))
                        GlassEnhancedInputKey(side: .trailing, virtual: .letterN, unit: KeyUnit(primary: KeyElement("n", extras: [.init("；", alignment: .topTrailing)]), members: [KeyElement("n"), KeyElement("；")]))
                        GlassEnhancedInputKey(side: .trailing, virtual: .letterM, unit: KeyUnit(primary: KeyElement("m", extras: [.init("：", alignment: .topTrailing)]), members: [KeyElement("m"), KeyElement("：")]))
                }
        }
}
