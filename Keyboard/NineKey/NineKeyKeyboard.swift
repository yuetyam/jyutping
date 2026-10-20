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
                                        switch (context.isRunningOnPhone, context.needsGlobeKey) {
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
                                        TailoredNavigateKey(destination: context.preferredNumericForm.isDedicatedNumbers ? .numeric : .symbolic)
                                        TailoredEnterKey()
                                }
                        }
                }
        }
}
