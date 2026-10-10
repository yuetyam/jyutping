import SwiftUI
import CoreIME

/// Pinyin (compact) keyboard with glass-styled keys and an optional number row.
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassPinyinKeyboard: View {
        @EnvironmentObject private var context: KeyboardViewController
        var body: some View {
                VStack(spacing: 0) {
                        CandidateBar()
                        if Options.needsNumberRow {
                                CantoneseGlassNumberRow()
                        }
                        HStack(spacing: 0) {
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
                        HStack(spacing: 0) {
                                HiddenKey(key: .letterA)
                                Group {
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
                                HiddenKey(key: .letterL)
                        }
                        HStack(spacing: 0) {
                                GlassShiftKey()
                                HiddenKey(key: .letterZ)
                                Group {
                                        GlassLetterInputKey(.letterZ)
                                        GlassLetterInputKey(.letterX)
                                        GlassLetterInputKey(.letterC)
                                        GlassPinyinSpecialLetterKey()
                                        GlassLetterInputKey(.letterB)
                                        GlassLetterInputKey(.letterN)
                                        GlassLetterInputKey(.letterM)
                                }
                                HiddenKey(key: .backspace)
                                GlassBackspaceKey()
                        }
                        HStack(spacing: 0) {
                                GlassTransformKey(context.preferredNumericForm)
                                GlassLeftKey()
                                SpaceKey()
                                GlassRightKey()
                                GlassEnterKey()
                        }
                }
        }
}
