import SwiftUI
import CoreIME

struct NineKeyNumericKeyboard: View {
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
                                                                NineKeyNumberKey(.number1)
                                                                NineKeyNumberKey(.number2)
                                                                NineKeyNumberKey(.number3)
                                                        }
                                                        HStack(spacing: 0) {
                                                                NineKeyNumberKey(.number4)
                                                                NineKeyNumberKey(.number5)
                                                                NineKeyNumberKey(.number6)
                                                        }
                                                        HStack(spacing: 0) {
                                                                NineKeyNumberKey(.number7)
                                                                NineKeyNumberKey(.number8)
                                                                NineKeyNumberKey(.number9)
                                                        }
                                                }
                                        }
                                        HStack(spacing: 0) {
                                                NineKeyNavigateKey(destination: .alphabetic)
                                                NineKeyNumberDotKey()
                                                NineKeyNumberKey(.number0)
                                                NineKeySpaceKey()
                                        }
                                }
                                VStack(spacing: 0) {
                                        NineKeyBackspaceKey()
                                        NineKeyNavigateKey(destination: .numeric)
                                        NineKeyReturnKey()
                                }
                        }
                }
        }
}
