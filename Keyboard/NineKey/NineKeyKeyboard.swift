import SwiftUI
import CommonExtensions
import CoreIME

struct NineKeyKeyboard: View {
        @EnvironmentObject private var context: KeyboardViewController
        var body: some View {
                VStack(spacing: 0) {
                        if context.inputStage.isBuffering {
                                CandidateBar()
                        } else {
                                ToolBar()
                        }
                        if Options.needsNumberRow {
                                CantoneseNumberRow()
                        }
                        if #available(iOSApplicationExtension 26.0, *) {
                                GlassNineKeyCoreKeyboard()
                        } else {
                                LegacyNineKeyCoreKeyboard()
                        }
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct GlassNineKeyCoreKeyboard: View {
        @EnvironmentObject private var context: KeyboardViewController
        var body: some View {
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
                                switch (context.isRunningOnPhone, context.needsInputModeSwitchKey) {
                                case (true, true):
                                        HStack(spacing: 0) {
                                                GlassTailoredNavigateKey(destination: context.preferredNumericForm)
                                                GlassTailoredGlobeKey()
                                                TailoredSpaceKey()
                                        }
                                case (true, false):
                                        HStack(spacing: 0) {
                                                GlassTailoredNavigateKey(destination: context.preferredNumericForm)
                                                TailoredSpaceKey()
                                        }
                                case (false, true) where context.keyboardInterface.isPadFloating:
                                        HStack(spacing: 0) {
                                                GlassTailoredGlobeKey()
                                                GlassTailoredNavigateKey(destination: context.preferredNumericForm)
                                                TailoredSpaceKey()
                                        }
                                case (false, true):
                                        HStack(spacing: 0) {
                                                GlassTailoredGlobeKey()
                                                GlassTailoredNavigateKey(destination: context.preferredNumericForm)
                                                TailoredSpaceKey()
                                        }
                                case (false, false):
                                        HStack(spacing: 0) {
                                                GlassTailoredNavigateKey(destination: context.preferredNumericForm)
                                                TailoredSpaceKey()
                                        }
                                }
                        }
                        VStack(spacing: 0) {
                                GlassTailoredBackspaceKey()
                                GlassTailoredNavigateKey(destination: context.preferredNumericForm.isNineKeyNumeric ? .numeric : .symbolic)
                                TailoredReturnKey()
                        }
                }
        }
}

private struct LegacyNineKeyCoreKeyboard: View {
        @EnvironmentObject private var context: KeyboardViewController
        var body: some View {
                HStack(spacing: 0) {
                        VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                        SidebarPanel()
                                        VStack(spacing: 0) {
                                                HStack(spacing: 0) {
                                                        NineKeySpecialKey()
                                                        NineKeyInputKey(.ABC)
                                                        NineKeyInputKey(.DEF)
                                                }
                                                HStack(spacing: 0) {
                                                        NineKeyInputKey(.GHI)
                                                        NineKeyInputKey(.JKL)
                                                        NineKeyInputKey(.MNO)
                                                }
                                                HStack(spacing: 0) {
                                                        NineKeyInputKey(.PQRS)
                                                        NineKeyInputKey(.TUV)
                                                        NineKeyInputKey(.WXYZ)
                                                }
                                        }
                                }
                                switch (context.isRunningOnPhone, context.needsInputModeSwitchKey) {
                                case (true, true):
                                        HStack(spacing: 0) {
                                                TailoredNavigateKey(destination: context.preferredNumericForm)
                                                TailoredGlobeKey()
                                                TailoredSpaceKey()
                                        }
                                case (true, false):
                                        HStack(spacing: 0) {
                                                TailoredNavigateKey(destination: context.preferredNumericForm)
                                                TailoredSpaceKey()
                                        }
                                case (false, true) where context.keyboardInterface.isPadFloating:
                                        HStack(spacing: 0) {
                                                TailoredGlobeKey()
                                                TailoredNavigateKey(destination: context.preferredNumericForm)
                                                TailoredSpaceKey()
                                        }
                                case (false, true):
                                        HStack(spacing: 0) {
                                                TailoredGlobeKey()
                                                TailoredNavigateKey(destination: context.preferredNumericForm)
                                                TailoredSpaceKey()
                                        }
                                case (false, false):
                                        HStack(spacing: 0) {
                                                TailoredNavigateKey(destination: context.preferredNumericForm)
                                                TailoredSpaceKey()
                                        }
                                }
                        }
                        VStack(spacing: 0) {
                                TailoredBackspaceKey()
                                TailoredNavigateKey(destination: context.preferredNumericForm.isNineKeyNumeric ? .numeric : .symbolic)
                                TailoredReturnKey()
                        }
                }
        }
}
