import SwiftUI
import CommonExtensions

struct EditingPanelSpaceKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @GestureState private var isTouching: Bool = false
        @State private var isLongPressEngaged: Bool = false
        @State private var longPressBuffer: Int = 0
        @State private var previousDraggingDistance: CGFloat = 0

        @State private var isInTheMediumOfDoubleTapping: Bool = false
        @State private var doubleTappingBuffer: Int = 0

        var body: some View {
                let inset = context.keyboardInterface.editingKeyInset
                ZStack {
                        Color.interactiveClear
                        if #available(iOSApplicationExtension 26.0, *) {
                                Color.clear
                                        .glassEffect(isTouching ? .regular : .clear, in: .rect(cornerRadius: PresetConstant.ultraKeyCornerRadius))
                                        .shadow(color: isTouching ? colorScheme.glassShadow : Color.clear, radius: 0.5)
                                        .padding(isTouching ? (inset - 2) : inset)
                        } else {
                                RoundedRectangle(cornerRadius: PresetConstant.ultraKeyCornerRadius)
                                        .fill(isTouching ? colorScheme.activeActionKeyColor : colorScheme.actionKeyColor)
                                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                        .padding(isTouching ? (inset - 2) : inset)
                        }
                        if isLongPressEngaged {
                                Text(PresetConstant.spaceKeyLongPressHint)
                        } else {
                                Text("EditingPanel.Space").font(.staticBody)
                        }
                }
                .contentShape(.rect)
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, isTouchBegan, _ in
                                if isTouchBegan.negative {
                                        isTouchBegan = true
                                        AudioFeedback.modified()
                                        context.triggerHapticFeedback()
                                }
                        }
                        .onChanged { value in
                                guard isTouching else { return }
                                guard isLongPressEngaged else { return }
                                let currentDraggingDistance = value.translation.width
                                let extra = currentDraggingDistance - previousDraggingDistance
                                guard abs(extra) > 10 else { return }
                                previousDraggingDistance = currentDraggingDistance
                                AudioFeedback.modified()
                                context.triggerHapticFeedback()
                                context.operate(extra > 0 ? .moveCursorForward : .moveCursorBackward)
                        }
                        .onEnded { _ in
                                longPressBuffer = 0
                                previousDraggingDistance = 0
                                if isLongPressEngaged {
                                        isLongPressEngaged = false
                                } else if isInTheMediumOfDoubleTapping {
                                        doubleTappingBuffer = 0
                                        isInTheMediumOfDoubleTapping = false
                                        context.operate(.doubleSpace)
                                } else {
                                        doubleTappingBuffer = 0
                                        isInTheMediumOfDoubleTapping = true
                                        context.operate(.space)
                                }
                        }
                )
                .task {
                        while Task.isCancelled.negative {
                                try? await Task.sleep(for: .milliseconds(100)) // 0.1s
                                if isTouching {
                                        if longPressBuffer > 3 {
                                                if isLongPressEngaged.negative {
                                                        AudioFeedback.modified()
                                                        context.triggerHapticFeedback()
                                                        isLongPressEngaged = true
                                                }
                                        } else {
                                                longPressBuffer += 1
                                        }
                                } else if isInTheMediumOfDoubleTapping {
                                        if doubleTappingBuffer > 2 {
                                                doubleTappingBuffer = 0
                                                isInTheMediumOfDoubleTapping = false
                                        } else {
                                                doubleTappingBuffer += 1
                                        }
                                }
                        }
                }
        }
}
