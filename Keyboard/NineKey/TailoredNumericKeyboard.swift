import SwiftUI
import CoreIME

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassTailoredNumericKeyboard: View {
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
                                                GlassSidebarPanel()
                                                VStack(spacing: 0) {
                                                        HStack(spacing: 0) {
                                                                GlassTailoredNumberKey(.number1)
                                                                GlassTailoredNumberKey(.number2)
                                                                GlassTailoredNumberKey(.number3)
                                                        }
                                                        HStack(spacing: 0) {
                                                                GlassTailoredNumberKey(.number4)
                                                                GlassTailoredNumberKey(.number5)
                                                                GlassTailoredNumberKey(.number6)
                                                        }
                                                        HStack(spacing: 0) {
                                                                GlassTailoredNumberKey(.number7)
                                                                GlassTailoredNumberKey(.number8)
                                                                GlassTailoredNumberKey(.number9)
                                                        }
                                                }
                                        }
                                        HStack(spacing: 0) {
                                                GlassTailoredNavigateKey(destination: .alphabetic)
                                                GlassTailoredNumberDotKey()
                                                GlassTailoredNumberKey(.number0)
                                                TailoredSpaceKey()
                                        }
                                }
                                VStack(spacing: 0) {
                                        GlassTailoredBackspaceKey()
                                        GlassTailoredNavigateKey(destination: .numeric)
                                        TailoredReturnKey()
                                }
                        }
                }
        }
}

struct TailoredNumericKeyboard: View {
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
                                                                TailoredNumberKey(.number1)
                                                                TailoredNumberKey(.number2)
                                                                TailoredNumberKey(.number3)
                                                        }
                                                        HStack(spacing: 0) {
                                                                TailoredNumberKey(.number4)
                                                                TailoredNumberKey(.number5)
                                                                TailoredNumberKey(.number6)
                                                        }
                                                        HStack(spacing: 0) {
                                                                TailoredNumberKey(.number7)
                                                                TailoredNumberKey(.number8)
                                                                TailoredNumberKey(.number9)
                                                        }
                                                }
                                        }
                                        HStack(spacing: 0) {
                                                TailoredNavigateKey(destination: .alphabetic)
                                                TailoredNumberDotKey()
                                                TailoredNumberKey(.number0)
                                                TailoredSpaceKey()
                                        }
                                }
                                VStack(spacing: 0) {
                                        TailoredBackspaceKey()
                                        TailoredNavigateKey(destination: .numeric)
                                        TailoredReturnKey()
                                }
                        }
                }
        }
}
