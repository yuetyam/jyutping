import SwiftUI

struct TenKeyKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        if context.inputStage.isBuffering {
                                CandidateScrollBar().environmentObject(context)
                        } else {
                                ToolBar().environmentObject(context)
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
                                                TenKeyNumericKey().environmentObject(context)
                                                TenKeySpaceKey().environmentObject(context)
                                        }
                                }
                                VStack(spacing: 0) {
                                        TenKeyBackspaceKey().environmentObject(context)
                                        TenKeyPunctationKey().environmentObject(context)
                                        TenKeyReturnKey().environmentObject(context)
                                }
                        }
                }
        }
}

struct TenKeyPunctationKey: View {

        @EnvironmentObject private var context: KeyboardViewController

        @Environment(\.colorScheme) private var colorScheme
        private var keyColor: Color {
                switch colorScheme {
                case .light:
                        return .lightEmphatic
                case .dark:
                        return .darkEmphatic
                @unknown default:
                        return .lightEmphatic
                }
        }
        private var activeKeyColor: Color {
                switch colorScheme {
                case .light:
                        return .light
                case .dark:
                        return .dark
                @unknown default:
                        return .light
                }
        }

        @GestureState private var isTouching: Bool = false

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(isTouching ? activeKeyColor : keyColor)
                                .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                .padding(3)
                        Text(verbatim: "#@$")
                }
                .frame(width: context.widthUnit * 2, height: context.heightUnit)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                if !tapped {
                                        AudioFeedback.modified()
                                        context.triggerHapticFeedback()
                                        tapped = true
                                }
                        }
                        .onEnded { _ in
                                context.updateKeyboardForm(to: .numeric)
                         }
                )
        }
}
