import SwiftUI
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
                                                                NineKeyInputKey(key: .ABC)
                                                                NineKeyInputKey(key: .DEF)
                                                        }
                                                        HStack(spacing: 0) {
                                                                NineKeyInputKey(key: .GHI)
                                                                NineKeyInputKey(key: .JKL)
                                                                NineKeyInputKey(key: .MNO)
                                                        }
                                                        HStack(spacing: 0) {
                                                                NineKeyInputKey(key: .PQRS)
                                                                NineKeyInputKey(key: .TUV)
                                                                NineKeyInputKey(key: .WXYZ)
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
                                        NineKeyNavigateKey(destination: context.preferredNumericForm == .numeric ? .symbolic : .numeric)
                                        NineKeyReturnKey()
                                }
                        }
                }
        }
}
