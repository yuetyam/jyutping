import SwiftUI

struct TenKeyNumericKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        HStack(spacing: 0) {
                                VStack(spacing: 0) {
                                        HStack(spacing: 0) {
                                                TenKeySymbolsBar().environmentObject(context)
                                                VStack(spacing: 0) {
                                                        HStack(spacing: 0) {
                                                                TenKeyNumberKey(key: "1")
                                                                TenKeyNumberKey(key: "2")
                                                                TenKeyNumberKey(key: "3")
                                                        }
                                                        HStack(spacing: 0) {
                                                                TenKeyNumberKey(key: "4")
                                                                TenKeyNumberKey(key: "5")
                                                                TenKeyNumberKey(key: "6")
                                                        }
                                                        HStack(spacing: 0) {
                                                                TenKeyNumberKey(key: "7")
                                                                TenKeyNumberKey(key: "8")
                                                                TenKeyNumberKey(key: "9")
                                                        }
                                                }
                                        }
                                        HStack(spacing: 0) {
                                                TenKeyNavigateKey(destination: .alphabet)
                                                TenKeyNumberKey(key: ".")
                                                TenKeyNumberKey(key: "0")
                                                TenKeySpaceKey()
                                        }
                                }
                                VStack(spacing: 0) {
                                        TenKeyBackspaceKey()
                                        TenKeyNumberKey(key: ".")
                                        TenKeyReturnKey()
                                }
                        }
                }
        }
}
