import SwiftUI
import CoreIME

/// Cangjie (compact) keyboard with glass-styled keys and an optional number row.
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassCangjieKeyboard: View {
        @EnvironmentObject private var context: KeyboardViewController
        var body: some View {
                VStack(spacing: 0) {
                        CandidateBar()
                        if Options.needsNumberRow {
                                CantoneseGlassNumberRow()
                        }
                        HStack(spacing: 0) {
                                GlassCangjieInputKey(.letterQ)
                                GlassCangjieInputKey(.letterW)
                                GlassCangjieInputKey(.letterE)
                                GlassCangjieInputKey(.letterR)
                                GlassCangjieInputKey(.letterT)
                                GlassCangjieInputKey(.letterY)
                                GlassCangjieInputKey(.letterU)
                                GlassCangjieInputKey(.letterI)
                                GlassCangjieInputKey(.letterO)
                                GlassCangjieInputKey(.letterP)
                        }
                        HStack(spacing: 0) {
                                HiddenKey(key: .letterA)
                                Group {
                                        GlassCangjieInputKey(.letterA)
                                        GlassCangjieInputKey(.letterS)
                                        GlassCangjieInputKey(.letterD)
                                        GlassCangjieInputKey(.letterF)
                                        GlassCangjieInputKey(.letterG)
                                        GlassCangjieInputKey(.letterH)
                                        GlassCangjieInputKey(.letterJ)
                                        GlassCangjieInputKey(.letterK)
                                        GlassCangjieInputKey(.letterL)
                                }
                                HiddenKey(key: .letterL)
                        }
                        HStack(spacing: 0) {
                                GlassShiftKey()
                                HiddenKey(key: .letterZ)
                                Group {
                                        GlassCangjieInputKey(.letterZ)
                                        GlassCangjieInputKey(.letterX)
                                        GlassCangjieInputKey(.letterC)
                                        GlassCangjieInputKey(.letterV)
                                        GlassCangjieInputKey(.letterB)
                                        GlassCangjieInputKey(.letterN)
                                        GlassCangjieInputKey(.letterM)
                                }
                                HiddenKey(key: .backspace)
                                GlassBackspaceKey()
                        }
                        HStack(spacing: 0) {
                                GlassTransformKey(context.preferredNumericForm)
                                SpaceKey()
                                GlassEnterKey()
                        }
                }
        }
}
