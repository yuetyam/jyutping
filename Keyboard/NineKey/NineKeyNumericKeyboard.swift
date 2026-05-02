import SwiftUI
import CoreIME

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassNineKeyNumericKeyboard: View {
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
                                                                GlassNineKeyNumberKey(.number1)
                                                                GlassNineKeyNumberKey(.number2)
                                                                GlassNineKeyNumberKey(.number3)
                                                        }
                                                        HStack(spacing: 0) {
                                                                GlassNineKeyNumberKey(.number4)
                                                                GlassNineKeyNumberKey(.number5)
                                                                GlassNineKeyNumberKey(.number6)
                                                        }
                                                        HStack(spacing: 0) {
                                                                GlassNineKeyNumberKey(.number7)
                                                                GlassNineKeyNumberKey(.number8)
                                                                GlassNineKeyNumberKey(.number9)
                                                        }
                                                }
                                        }
                                        HStack(spacing: 0) {
                                                GlassNineKeyNavigateKey(destination: .alphabetic)
                                                GlassNineKeyNumberDotKey()
                                                GlassNineKeyNumberKey(.number0)
                                                NineKeySpaceKey()
                                        }
                                }
                                VStack(spacing: 0) {
                                        GlassNineKeyBackspaceKey()
                                        GlassNineKeyNavigateKey(destination: .numeric)
                                        NineKeyReturnKey()
                                }
                        }
                }
        }
}

@available(iOS, introduced: 16.0, deprecated: 26.0, message: "Use GlassNineKeyNumericKeyboard instead")
@available(iOSApplicationExtension, introduced: 16.0, deprecated: 26.0, message: "Use GlassNineKeyNumericKeyboard instead")
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
