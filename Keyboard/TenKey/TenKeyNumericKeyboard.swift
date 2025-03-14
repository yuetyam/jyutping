import SwiftUI

struct TenKeyNumericKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        HStack(spacing: 0) {
                                VStack(spacing: 0) {
                                        HStack(spacing: 0) {
                                                TenKeySymbolSidebar()
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
                                        if context.needsInputModeSwitchKey {
                                                HStack(spacing: 0) {
                                                        TenKeyGlobeKey()
                                                        TenKeyNavigateKey(destination: .alphabetic)
                                                        TenKeyNumberKey(key: "0")
                                                        TenKeyNumberKey(key: ".")
                                                }
                                        } else {
                                                HStack(spacing: 0) {
                                                        TenKeyNavigateKey(destination: .alphabetic)
                                                        TenKeyNumberKey(key: ".")
                                                        TenKeyNumberKey(key: "0")
                                                        TenKeySpaceKey()
                                                }
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
