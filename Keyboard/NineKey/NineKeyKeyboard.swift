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
                                                GlassNineKeyNavigateKey(destination: context.preferredNumericForm)
                                                GlassNineKeyGlobeKey()
                                                NineKeySpaceKey()
                                        }
                                case (true, false):
                                        HStack(spacing: 0) {
                                                GlassNineKeyNavigateKey(destination: context.preferredNumericForm)
                                                NineKeySpaceKey()
                                        }
                                case (false, true) where context.keyboardInterface.isPadFloating:
                                        HStack(spacing: 0) {
                                                GlassNineKeyGlobeKey()
                                                GlassNineKeyNavigateKey(destination: context.preferredNumericForm)
                                                NineKeySpaceKey()
                                        }
                                case (false, true):
                                        HStack(spacing: 0) {
                                                GlassNineKeyGlobeKey()
                                                GlassNineKeyNavigateKey(destination: context.preferredNumericForm)
                                                NineKeySpaceKey()
                                        }
                                case (false, false):
                                        HStack(spacing: 0) {
                                                GlassNineKeyNavigateKey(destination: context.preferredNumericForm)
                                                NineKeySpaceKey()
                                        }
                                }
                        }
                        VStack(spacing: 0) {
                                GlassNineKeyBackspaceKey()
                                GlassNineKeyNavigateKey(destination: context.preferredNumericForm.isNineKeyNumeric ? .numeric : .symbolic)
                                NineKeyReturnKey()
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
                                                NineKeyNavigateKey(destination: context.preferredNumericForm)
                                                NineKeyGlobeKey()
                                                NineKeySpaceKey()
                                        }
                                case (true, false):
                                        HStack(spacing: 0) {
                                                NineKeyNavigateKey(destination: context.preferredNumericForm)
                                                NineKeySpaceKey()
                                        }
                                case (false, true) where context.keyboardInterface.isPadFloating:
                                        HStack(spacing: 0) {
                                                NineKeyGlobeKey()
                                                NineKeyNavigateKey(destination: context.preferredNumericForm)
                                                NineKeySpaceKey()
                                        }
                                case (false, true):
                                        HStack(spacing: 0) {
                                                NineKeyGlobeKey()
                                                NineKeyNavigateKey(destination: context.preferredNumericForm)
                                                NineKeySpaceKey()
                                        }
                                case (false, false):
                                        HStack(spacing: 0) {
                                                NineKeyNavigateKey(destination: context.preferredNumericForm)
                                                NineKeySpaceKey()
                                        }
                                }
                        }
                        VStack(spacing: 0) {
                                NineKeyBackspaceKey()
                                NineKeyNavigateKey(destination: context.preferredNumericForm.isNineKeyNumeric ? .numeric : .symbolic)
                                NineKeyReturnKey()
                        }
                }
        }
}
