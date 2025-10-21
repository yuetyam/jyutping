import SwiftUI
import Combine
import CommonExtensions

struct PadSpaceKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        private var keyColor: Color {
                switch colorScheme {
                case .light:
                        return .lightInput
                case .dark:
                        return .darkInput
                @unknown default:
                        return .lightInput
                }
        }
        private var keyActiveColor: Color {
                switch colorScheme {
                case .light:
                        return .activeLightInput
                case .dark:
                        return .activeDarkInput
                @unknown default:
                        return .activeLightInput
                }
        }

        @GestureState private var isTouching: Bool = false
        @State private var isLongPressEngaged: Bool = false
        @State private var longPressBuffer: Int = 0
        @State private var previousDraggingDistance: CGFloat = 0

        @State private var isInTheMediumOfDoubleTapping: Bool = false
        @State private var doubleTappingBuffer: Int = 0

        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

        var body: some View {
                // let keyWidth: CGFloat = context.widthUnit * widthUnitTimes
                let keyHeight: CGFloat = context.heightUnit
                let isLandscape: Bool = context.keyboardInterface.isPadLandscape
                let verticalPadding: CGFloat = isLandscape ? 7 : 5
                let horizontalPadding: CGFloat = isLandscape ? 7 : 5
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous)
                                .fill(isTouching ? keyActiveColor : keyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(.vertical, verticalPadding)
                                .padding(.horizontal, horizontalPadding)
                        Text(isLongPressEngaged ? PresetConstant.spaceKeyLongPressHint : context.spaceKeyForm.attributedText)
                }
                .frame(height: keyHeight)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                guard tapped.negative else { return }
                                AudioFeedback.modified()
                                tapped = true
                        }
                        .onChanged { value in
                                guard isTouching && isLongPressEngaged else { return }
                                let currentDraggingDistance = value.translation.width
                                let extra = currentDraggingDistance - previousDraggingDistance
                                guard abs(extra) > 10 else { return }
                                previousDraggingDistance = currentDraggingDistance
                                if context.inputStage.isBuffering {
                                        // TODO: Dragging in markedText
                                        context.operate(.clearBuffer)
                                } else {
                                        AudioFeedback.modified()
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
