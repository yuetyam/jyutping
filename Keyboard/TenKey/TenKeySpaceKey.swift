import SwiftUI
import CommonExtensions

struct TenKeySpaceKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @GestureState private var isTouching: Bool = false
        @State private var isLongPressEngaged: Bool = false
        @State private var longPressBuffer: Int = 0
        @State private var previousDraggingDistance: CGFloat = 0

        @State private var isInTheMediumOfDoubleTapping: Bool = false
        @State private var doubleTappingBuffer: Int = 0

        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous)
                                .fill(isTouching ? colorScheme.activeInputKeyColor : colorScheme.inputKeyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(3)
                        Text(isLongPressEngaged ? PresetConstant.spaceKeyLongPressHint : context.spaceKeyForm.attributedText)
                }
                .frame(height: context.heightUnit)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                guard tapped.negative else { return }
                                AudioFeedback.modified()
                                context.triggerHapticFeedback()
                                tapped = true
                        }
                        .onChanged { value in
                                guard isTouching else { return }
                                guard isLongPressEngaged else { return }
                                let currentDraggingDistance = value.translation.width
                                let extra = currentDraggingDistance - previousDraggingDistance
                                guard abs(extra) > 10 else { return }
                                previousDraggingDistance = currentDraggingDistance
                                if context.inputStage.isBuffering {
                                        // TODO: Dragging in markedText
                                        context.operate(.clearBuffer)
                                } else {
                                        AudioFeedback.modified()
                                        context.triggerHapticFeedback()
                                        context.operate(extra > 0 ? .moveCursorForward : .moveCursorBackward)
                                }
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
                .onReceive(timer) { _ in
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
