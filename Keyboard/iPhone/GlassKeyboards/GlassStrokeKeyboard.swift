import SwiftUI
import CoreIME

/// Stroke (compact) keyboard with glass-styled keys and an optional number row.
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassStrokeKeyboard: View {
        @EnvironmentObject private var context: KeyboardViewController
        var body: some View {
                VStack(spacing: 0) {
                        CandidateBar()
                        if Options.needsNumberRow {
                                CantoneseGlassNumberRow()
                        }
                        HStack(spacing: 0) {
                                GlassStrokeInputKey(.letterQ)
                                GlassStrokeInputKey(.letterW)
                                GlassStrokeInputKey(.letterE)
                                GlassStrokeInputKey(.letterR)
                                GlassStrokeInputKey(.letterT)
                                GlassStrokeInputKey(.letterY)
                                GlassStrokeInputKey(.letterU)
                                GlassStrokeInputKey(.letterI)
                                GlassStrokeInputKey(.letterO)
                                GlassStrokeInputKey(.letterP)
                        }
                        HStack(spacing: 0) {
                                HiddenKey(key: .letterA)
                                Group {
                                        GlassStrokeInputKey(.letterA)
                                        GlassStrokeInputKey(.letterS)
                                        GlassStrokeInputKey(.letterD)
                                        GlassStrokeInputKey(.letterF)
                                        GlassStrokeInputKey(.letterG)
                                        GlassStrokeInputKey(.letterH)
                                        GlassStrokeInputKey(.letterJ)
                                        GlassStrokeInputKey(.letterK)
                                        GlassStrokeInputKey(.letterL)
                                }
                                HiddenKey(key: .letterL)
                        }
                        HStack(spacing: 0) {
                                GlassShiftKey()
                                HiddenKey(key: .letterZ)
                                Group {
                                        GlassStrokeInputKey(.letterZ)
                                        GlassStrokeInputKey(.letterX)
                                        GlassStrokeInputKey(.letterC)
                                        GlassStrokeInputKey(.letterV)
                                        GlassStrokeInputKey(.letterB)
                                        GlassStrokeInputKey(.letterN)
                                        GlassStrokeInputKey(.letterM)
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
