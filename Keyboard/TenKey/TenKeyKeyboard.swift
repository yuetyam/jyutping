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
                        HStack(spacing: 0) {
                                VStack(spacing: 0) {
                                        HStack(spacing: 0) {
                                                TenKeySidebar()
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
                                        HStack(spacing: 0) {
                                                TenKeyNavigateKey(destination: context.numericLayout.isNumberKeyPad ? .tenKeyNumeric : .numeric)
                                                if context.needsInputModeSwitchKey {
                                                        TenKeyGlobeKey()
                                                }
                                                TenKeySpaceKey()
                                        }
                                }
                                VStack(spacing: 0) {
                                        TenKeyBackspaceKey()
                                        TenKeyNavigateKey(destination: context.numericLayout.isNumberKeyPad ? .numeric : .symbolic)
                                        TenKeyReturnKey()
                                }
                        }
                }
        }
}
