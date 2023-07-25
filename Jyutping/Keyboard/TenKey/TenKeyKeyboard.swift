import SwiftUI

struct TenKeyKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        if context.inputStage.isBuffering {
                                CandidateScrollBar()
                        } else {
                                ToolBar()
                        }
                        HStack(spacing: 0) {
                                VStack(spacing: 0) {
                                        HStack(spacing: 0) {
                                                TenKeySidebar().environmentObject(context)
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
                                                TenKeyNavigateKey(destination: .tenKeyNumeric)
                                                TenKeySpaceKey()
                                        }
                                }
                                VStack(spacing: 0) {
                                        TenKeyBackspaceKey()
                                        TenKeyNavigateKey(destination: .numeric)
                                        TenKeyReturnKey()
                                }
                        }
                }
        }
}
