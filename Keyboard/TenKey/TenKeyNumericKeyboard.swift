import SwiftUI
import CoreIME

struct TenKeyNumericKeyboard: View {
        @EnvironmentObject private var context: KeyboardViewController
        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        if Options.needsNumberRow {
                                if context.inputMethodMode.isABC {
                                        ABCNumberRow()
                                } else {
                                        CantoneseNumberRow()
                                }
                        }
                        HStack(spacing: 0) {
                                VStack(spacing: 0) {
                                        HStack(spacing: 0) {
                                                SidebarPanel()
                                                VStack(spacing: 0) {
                                                        HStack(spacing: 0) {
                                                                TenKeyNumberKey(.number1)
                                                                TenKeyNumberKey(.number2)
                                                                TenKeyNumberKey(.number3)
                                                        }
                                                        HStack(spacing: 0) {
                                                                TenKeyNumberKey(.number4)
                                                                TenKeyNumberKey(.number5)
                                                                TenKeyNumberKey(.number6)
                                                        }
                                                        HStack(spacing: 0) {
                                                                TenKeyNumberKey(.number7)
                                                                TenKeyNumberKey(.number8)
                                                                TenKeyNumberKey(.number9)
                                                        }
                                                }
                                        }
                                        HStack(spacing: 0) {
                                                TenKeyNavigateKey(destination: .alphabetic)
                                                TenKeyNumberDotKey()
                                                TenKeyNumberKey(.number0)
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
