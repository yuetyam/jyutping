import SwiftUI
import CoreIME

struct TenKeyKeyboard: View {

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
                                                                TenKeySpecialKey()
                                                                TenKeyInputKey(key: .ABC)
                                                                TenKeyInputKey(key: .DEF)
                                                        }
                                                        HStack(spacing: 0) {
                                                                TenKeyInputKey(key: .GHI)
                                                                TenKeyInputKey(key: .JKL)
                                                                TenKeyInputKey(key: .MNO)
                                                        }
                                                        HStack(spacing: 0) {
                                                                TenKeyInputKey(key: .PQRS)
                                                                TenKeyInputKey(key: .TUV)
                                                                TenKeyInputKey(key: .WXYZ)
                                                        }
                                                }
                                        }
                                        switch (context.isRunningOnPhone, context.needsInputModeSwitchKey) {
                                        case (true, true):
                                                HStack(spacing: 0) {
                                                        TenKeyNavigateKey(destination: context.preferredNumericForm)
                                                        TenKeyGlobeKey()
                                                        TenKeySpaceKey()
                                                }
                                        case (true, false):
                                                HStack(spacing: 0) {
                                                        TenKeyNavigateKey(destination: context.preferredNumericForm)
                                                        TenKeySpaceKey()
                                                }
                                        case (false, true) where context.keyboardInterface.isPadFloating:
                                                HStack(spacing: 0) {
                                                        TenKeyGlobeKey()
                                                        TenKeyNavigateKey(destination: context.preferredNumericForm)
                                                        TenKeySpaceKey()
                                                }
                                        case (false, true):
                                                HStack(spacing: 0) {
                                                        TenKeyGlobeKey()
                                                        TenKeyNavigateKey(destination: context.preferredNumericForm)
                                                        TenKeySpaceKey()
                                                }
                                        case (false, false):
                                                HStack(spacing: 0) {
                                                        TenKeyNavigateKey(destination: context.preferredNumericForm)
                                                        TenKeySpaceKey()
                                                }
                                        }
                                }
                                VStack(spacing: 0) {
                                        TenKeyBackspaceKey()
                                        TenKeyNavigateKey(destination: context.preferredNumericForm == .numeric ? .symbolic : .numeric)
                                        TenKeyReturnKey()
                                }
                        }
                }
        }
}
