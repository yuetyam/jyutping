import SwiftUI
import CommonExtensions

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct EditingPanelGlassMoveForwardKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @GestureState private var isTouching: Bool = false
        @State private var buffer: Int = 0

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        Color.clear
                                .glassEffect(isTouching ? .regular : .clear, in: RoundedRectangle(cornerRadius: PresetConstant.ultraKeyCornerRadius, style: .continuous))
                                .shadow(color: isTouching ? colorScheme.glassShadow : Color.clear, radius: 0.5)
                                .padding(isTouching ? 2 : 4)
                        Image(systemName: "arrow.forward")
                }
                .contentShape(.rect)
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, isTouchBegan, _ in
                                if isTouchBegan.negative {
                                        isTouchBegan = true
                                        AudioFeedback.modified()
                                        context.triggerHapticFeedback()
                                        context.operate(.moveCursorForward)
                                }
                        }
                        .onEnded { _ in
                                buffer = 0
                        }
                )
                .task {
                        while Task.isCancelled.negative {
                                try? await Task.sleep(for: .milliseconds(100)) // 0.1s
                                if isTouching {
                                        if buffer > 3 {
                                                AudioFeedback.modified()
                                                context.triggerHapticFeedback()
                                                context.operate(.moveCursorForward)
                                        } else {
                                                buffer += 1
                                        }
                                }
                        }
                }
        }
}

struct EditingPanelMoveForwardKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @GestureState private var isTouching: Bool = false
        @State private var buffer: Int = 0

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: PresetConstant.ultraKeyCornerRadius, style: .continuous)
                                .fill(isTouching ? colorScheme.activeActionKeyColor : colorScheme.actionKeyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(isTouching ? 2 : 4)
                        Image(systemName: "arrow.forward")
                }
                .contentShape(.rect)
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, isTouchBegan, _ in
                                if isTouchBegan.negative {
                                        isTouchBegan = true
                                        AudioFeedback.modified()
                                        context.triggerHapticFeedback()
                                        context.operate(.moveCursorForward)
                                }
                        }
                        .onEnded { _ in
                                buffer = 0
                        }
                )
                .task {
                        while Task.isCancelled.negative {
                                try? await Task.sleep(for: .milliseconds(100)) // 0.1s
                                if isTouching {
                                        if buffer > 3 {
                                                AudioFeedback.modified()
                                                context.triggerHapticFeedback()
                                                context.operate(.moveCursorForward)
                                        } else {
                                                buffer += 1
                                        }
                                }
                        }
                }
        }
}
