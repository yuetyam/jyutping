import SwiftUI

struct EditingPanel: View {

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

        @GestureState private var isClearingClipboard: Bool = false
        @GestureState private var isPasting: Bool = false
        @GestureState private var isMovingCursorBackward: Bool = false
        @GestureState private var isMovingCursorForward: Bool = false
        @GestureState private var isJumpingToHead: Bool = false
        @GestureState private var isJumpingToTail: Bool = false
        @GestureState private var isNavigatingBack: Bool = false
        @GestureState private var isBackspacing: Bool = false
        @GestureState private var isClearingText: Bool = false
        @GestureState private var isReturning: Bool = false

        @State private var backwardBuffer: Int = 0
        @State private var forwardBuffer: Int = 0
        @State private var backspaceBuffer: Int = 0
        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

        var body: some View {
                HStack(spacing: 0) {
                        VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                        ZStack {
                                                Color.interactiveClear
                                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                        .fill(isClearingClipboard ? activeKeyColor : keyColor)
                                                        .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                                        .padding(.vertical, 6)
                                                        .padding(.horizontal, 3)
                                                VStack(spacing: 4) {
                                                        Image(systemName: "clipboard")
                                                        Text(verbatim: "清空剪帖板").font(.caption2)
                                                }
                                        }
                                        .frame(maxWidth: .infinity)
                                        .contentShape(Rectangle())
                                        .gesture(DragGesture(minimumDistance: 0)
                                                .updating($isClearingClipboard) { _, tapped, _ in
                                                        if !tapped {
                                                                AudioFeedback.modified()
                                                                context.triggerHapticFeedback()
                                                                tapped = true
                                                        }
                                                }
                                                .onEnded { _ in
                                                        context.operate(.clearClipboard)
                                                }
                                        )
                                        ZStack {
                                                Color.interactiveClear
                                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                        .fill(isPasting ? activeKeyColor : keyColor)
                                                        .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                                        .padding(.vertical, 6)
                                                        .padding(.horizontal, 3)
                                                VStack(spacing: 4) {
                                                        Image(systemName: "doc.on.clipboard")
                                                        Text(verbatim: "帖上").font(.caption2)
                                                }
                                                .opacity(UIPasteboard.general.hasStrings ? 1 : 0.5)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .contentShape(Rectangle())
                                        .gesture(DragGesture(minimumDistance: 0)
                                                .updating($isPasting) { _, tapped, _ in
                                                        if !tapped {
                                                                AudioFeedback.inputed()
                                                                context.triggerHapticFeedback()
                                                                tapped = true
                                                        }
                                                }
                                                .onEnded { _ in
                                                        context.operate(.paste)
                                                }
                                        )
                                }
                                .frame(maxHeight: .infinity)
                                HStack(spacing: 0) {
                                        ZStack {
                                                Color.interactiveClear
                                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                        .fill(isMovingCursorBackward ? activeKeyColor : keyColor)
                                                        .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                                        .padding(.vertical, 6)
                                                        .padding(.horizontal, 3)
                                                Image(systemName: "arrow.backward")
                                        }
                                        .frame(maxWidth: .infinity)
                                        .contentShape(Rectangle())
                                        .gesture(DragGesture(minimumDistance: 0)
                                                .updating($isMovingCursorBackward) { _, tapped, _ in
                                                        if !tapped {
                                                                AudioFeedback.modified()
                                                                context.triggerHapticFeedback()
                                                                context.operate(.moveCursorBackward)
                                                                tapped = true
                                                        }
                                                }
                                                .onEnded { _ in
                                                        backwardBuffer = 0
                                                }
                                        )
                                        .onReceive(timer) { _ in
                                                guard isMovingCursorBackward else { return }
                                                if backwardBuffer > 3 {
                                                        AudioFeedback.modified()
                                                        context.triggerHapticFeedback()
                                                        context.operate(.moveCursorBackward)
                                                } else {
                                                        backwardBuffer += 1
                                                }
                                        }
                                        ZStack {
                                                Color.interactiveClear
                                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                        .fill(isMovingCursorForward ? activeKeyColor : keyColor)
                                                        .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                                        .padding(.vertical, 6)
                                                        .padding(.horizontal, 3)
                                                Image(systemName: "arrow.forward")
                                        }
                                        .frame(maxWidth: .infinity)
                                        .contentShape(Rectangle())
                                        .gesture(DragGesture(minimumDistance: 0)
                                                .updating($isMovingCursorForward) { _, tapped, _ in
                                                        if !tapped {
                                                                AudioFeedback.modified()
                                                                context.triggerHapticFeedback()
                                                                context.operate(.moveCursorForward)
                                                                tapped = true
                                                        }
                                                }
                                                .onEnded { _ in
                                                        forwardBuffer = 0
                                                }
                                        )
                                        .onReceive(timer) { _ in
                                                guard isMovingCursorForward else { return }
                                                if forwardBuffer > 3 {
                                                        AudioFeedback.modified()
                                                        context.triggerHapticFeedback()
                                                        context.operate(.moveCursorForward)
                                                } else {
                                                        forwardBuffer += 1
                                                }
                                        }
                                }
                                .frame(maxHeight: .infinity)
                                HStack(spacing: 0) {
                                        ZStack {
                                                Color.interactiveClear
                                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                        .fill(isJumpingToHead ? activeKeyColor : keyColor)
                                                        .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                                        .padding(.vertical, 6)
                                                        .padding(.horizontal, 3)
                                                Image(systemName: "arrow.backward.to.line")
                                        }
                                        .frame(maxWidth: .infinity)
                                        .contentShape(Rectangle())
                                        .gesture(DragGesture(minimumDistance: 0)
                                                .updating($isJumpingToHead) { _, tapped, _ in
                                                        if !tapped {
                                                                AudioFeedback.modified()
                                                                context.triggerHapticFeedback()
                                                                tapped = true
                                                        }
                                                }
                                                .onEnded { _ in
                                                        context.operate(.jumpToHead)
                                                }
                                        )
                                        ZStack {
                                                Color.interactiveClear
                                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                        .fill(isJumpingToTail ? activeKeyColor : keyColor)
                                                        .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                                        .padding(.vertical, 6)
                                                        .padding(.horizontal, 3)
                                                Image(systemName: "arrow.forward.to.line")
                                        }
                                        .frame(maxWidth: .infinity)
                                        .contentShape(Rectangle())
                                        .gesture(DragGesture(minimumDistance: 0)
                                                .updating($isJumpingToTail) { _, tapped, _ in
                                                        if !tapped {
                                                                AudioFeedback.modified()
                                                                context.triggerHapticFeedback()
                                                                tapped = true
                                                        }
                                                }
                                                .onEnded { _ in
                                                        context.operate(.jumpToTail)
                                                }
                                        )
                                }
                                .frame(maxHeight: .infinity)
                        }
                        .frame(maxWidth: .infinity)
                        VStack(spacing: 0) {
                                ZStack {
                                        Color.interactiveClear
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                .fill(isNavigatingBack ? activeKeyColor : keyColor)
                                                .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                                .padding(.vertical, 6)
                                                .padding(.horizontal, 3)
                                        VStack(spacing: 4) {
                                                Image.upChevron.font(.title3)
                                                Text(verbatim: "返回").font(.caption2)
                                        }
                                }
                                .frame(maxHeight: .infinity)
                                .contentShape(Rectangle())
                                .gesture(DragGesture(minimumDistance: 0)
                                        .updating($isNavigatingBack) { _, tapped, _ in
                                                if !tapped {
                                                        AudioFeedback.modified()
                                                        context.triggerHapticFeedback()
                                                        tapped = true
                                                }
                                        }
                                        .onEnded { _ in
                                                context.updateKeyboardForm(to: context.previousKeyboardForm)
                                        }
                                )
                                ZStack {
                                        Color.interactiveClear
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                .fill(isBackspacing ? activeKeyColor : keyColor)
                                                .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                                .padding(.vertical, 6)
                                                .padding(.horizontal, 3)
                                        Image.backspace
                                }
                                .frame(maxHeight: .infinity)
                                .contentShape(Rectangle())
                                .gesture(DragGesture(minimumDistance: 0)
                                        .updating($isBackspacing) { _, tapped, _ in
                                                if !tapped {
                                                        AudioFeedback.deleted()
                                                        context.triggerHapticFeedback()
                                                        context.operate(.backspace)
                                                        tapped = true
                                                }
                                        }
                                        .onEnded { _ in
                                                backspaceBuffer = 0
                                        }
                                )
                                .onReceive(timer) { _ in
                                        guard isBackspacing else { return }
                                        if backspaceBuffer > 3 {
                                                AudioFeedback.deleted()
                                                context.triggerHapticFeedback()
                                                context.operate(.backspace)
                                        } else {
                                                backspaceBuffer += 1
                                        }
                                }
                                ZStack {
                                        Color.interactiveClear
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                .fill(isClearingText ? activeKeyColor : keyColor)
                                                .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                                .padding(.vertical, 6)
                                                .padding(.horizontal, 3)
                                        VStack(spacing: 4) {
                                                Image(systemName: "clear")
                                                Text(verbatim: "清空").font(.caption2)
                                        }
                                }
                                .frame(maxHeight: .infinity)
                                .contentShape(Rectangle())
                                .gesture(DragGesture(minimumDistance: 0)
                                        .updating($isClearingText) { _, tapped, _ in
                                                if !tapped {
                                                        AudioFeedback.deleted()
                                                        context.triggerHapticFeedback()
                                                        tapped = true
                                                }
                                        }
                                        .onEnded { _ in
                                                context.operate(.clearText)
                                        }
                                )
                                ZStack {
                                        Color.interactiveClear
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                .fill(isReturning ? activeKeyColor : keyColor)
                                                .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                                .padding(.vertical, 6)
                                                .padding(.horizontal, 3)
                                        Text(verbatim: context.returnKeyText)
                                }
                                .frame(maxHeight: .infinity)
                                .contentShape(Rectangle())
                                .gesture(DragGesture(minimumDistance: 0)
                                        .updating($isReturning) { _, tapped, _ in
                                                if !tapped {
                                                        AudioFeedback.modified()
                                                        context.triggerHapticFeedback()
                                                        tapped = true
                                                }
                                        }
                                        .onEnded { _ in
                                                context.operate(.return)
                                        }
                                )
                        }
                        .frame(width: 100)
                }
        }
}
