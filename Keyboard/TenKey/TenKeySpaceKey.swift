import SwiftUI
import CommonExtensions

struct TenKeySpaceKey: View {

        @EnvironmentObject private var context: KeyboardViewController

        @Environment(\.colorScheme) private var colorScheme
        private var keyColor: Color {
                switch colorScheme {
                case .light:
                        return .light
                case .dark:
                        return .dark
                @unknown default:
                        return .light
                }
        }
        private var activeKeyColor: Color {
                switch colorScheme {
                case .light:
                        return .lightEmphatic
                case .dark:
                        return .darkEmphatic
                @unknown default:
                        return .lightEmphatic
                }
        }

        @GestureState private var isTouching: Bool = false
        @State private var isLongPressEngaged: Bool = false
        @State private var longPressBuffer: Int = 0
        private static var previousDraggingDistance: CGFloat = 0

        @State private var isInTheMediumOfDoubleTapping: Bool = false
        @State private var doubleTappingBuffer: Int = 0

        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(isTouching ? activeKeyColor : keyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(3)
                        Text(isLongPressEngaged ? PresetConstant.spaceKeyLongPressHint : context.spaceKeyForm.attributedText)
                }
                .frame(height: context.heightUnit)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { value, touched, transaction in
                                if touched.negative {
                                        AudioFeedback.modified()
                                        context.triggerHapticFeedback()
                                        touched = true
                                        Self.previousDraggingDistance = 0
                                } else if isLongPressEngaged {
                                        let distance = value.translation.width
                                        let extra = distance - Self.previousDraggingDistance
                                        guard abs(extra) > 10 else { return }
                                        Self.previousDraggingDistance = distance
                                        if context.inputStage.isBuffering {
                                                // TODO: Dragging in markedText
                                                context.operate(.clearBuffer)
                                        } else {
                                                AudioFeedback.modified()
                                                context.triggerHapticFeedback()
                                                context.operate(extra > 0 ? .moveCursorForward : .moveCursorBackward)
                                        }
                                }
                        }
                        .onEnded { value in
                                Self.previousDraggingDistance = 0
                                longPressBuffer = 0
                                if isLongPressEngaged {
                                        isLongPressEngaged = false
                                } else {
                                        if isInTheMediumOfDoubleTapping {
                                                doubleTappingBuffer = 0
                                                isInTheMediumOfDoubleTapping = false
                                                context.operate(.doubleSpace)
                                        } else {
                                                doubleTappingBuffer = 0
                                                isInTheMediumOfDoubleTapping = true
                                                context.operate(.space)
                                        }
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
