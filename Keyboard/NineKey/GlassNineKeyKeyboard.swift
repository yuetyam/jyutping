import SwiftUI
import CommonExtensions
import CoreIME

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassNineKeyKeyboard: View {
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
                        HStack(spacing: 0) {
                                VStack(spacing: 0) {
                                        HStack(spacing: 0) {
                                                GlassSidebarPanel()
                                                VStack(spacing: 0) {
                                                        HStack(spacing: 0) {
                                                                GlassNineKeySpecialKey()
                                                                GlassNineKeyInputKey(.ABC)
                                                                GlassNineKeyInputKey(.DEF)
                                                        }
                                                        HStack(spacing: 0) {
                                                                GlassNineKeyInputKey(.GHI)
                                                                GlassNineKeyInputKey(.JKL)
                                                                GlassNineKeyInputKey(.MNO)
                                                        }
                                                        HStack(spacing: 0) {
                                                                GlassNineKeyInputKey(.PQRS)
                                                                GlassNineKeyInputKey(.TUV)
                                                                GlassNineKeyInputKey(.WXYZ)
                                                        }
                                                }
                                        }
                                        switch (context.isRunningOnPhone, context.needsGlobeKey) {
                                        case (true, true):
                                                HStack(spacing: 0) {
                                                        GlassTailoredNavigateKey(destination: context.preferredNumericForm)
                                                        GlassTailoredGlobeKey()
                                                        GlassTailoredSpaceKey()
                                                }
                                        case (true, false):
                                                HStack(spacing: 0) {
                                                        GlassTailoredNavigateKey(destination: context.preferredNumericForm)
                                                        GlassTailoredSpaceKey()
                                                }
                                        case (false, true) where context.keyboardInterface.isPadFloating:
                                                HStack(spacing: 0) {
                                                        GlassTailoredGlobeKey()
                                                        GlassTailoredNavigateKey(destination: context.preferredNumericForm)
                                                        GlassTailoredSpaceKey()
                                                }
                                        case (false, true):
                                                HStack(spacing: 0) {
                                                        GlassTailoredGlobeKey()
                                                        GlassTailoredNavigateKey(destination: context.preferredNumericForm)
                                                        GlassTailoredSpaceKey()
                                                }
                                        case (false, false):
                                                HStack(spacing: 0) {
                                                        GlassTailoredNavigateKey(destination: context.preferredNumericForm)
                                                        GlassTailoredSpaceKey()
                                                }
                                        }
                                }
                                VStack(spacing: 0) {
                                        GlassTailoredBackspaceKey()
                                        GlassTailoredNavigateKey(destination: context.preferredNumericForm.isDedicatedNumbers ? .numeric : .symbolic)
                                        GlassTailoredEnterKey()
                                }
                        }
                }
        }
}
