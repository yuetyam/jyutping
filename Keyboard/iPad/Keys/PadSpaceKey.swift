import SwiftUI

struct PadSpaceKey: View {

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

        @State private var isInTheMediumOfDoubleTapping: Bool = false
        @State private var doubleTappingBuffer: Int = 0

        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(isTouching ? activeKeyColor : keyColor)
                                .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                .padding(5)
                        Text(verbatim: isLongPressEngaged ? Constant.spaceKeyLongPressHint : context.spaceKeyText.text)
                }
                .frame(height: context.heightUnit)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { value, touched, transaction in
                                if !touched {
                                        AudioFeedback.modified()
                                        context.triggerHapticFeedback()
                                        touched = true
                                        context.updateTouchedLocation(to: value.startLocation)
                                } else if isLongPressEngaged {
                                        let distance = value.location.x - context.touchedLocation.x
                                        guard abs(distance) > 10 else { return }
                                        context.updateTouchedLocation(to: value.location)
                                        if context.inputStage.isBuffering {
                                                // TODO: Dragging in markedText
                                                context.operate(.clearBuffer)
                                        } else {
                                                AudioFeedback.modified()
                                                context.triggerHapticFeedback()
                                                if distance > 0 {
                                                        context.operate(.moveCursorForward)
                                                } else {
                                                        context.operate(.moveCursorBackward)
                                                }
                                        }
                                }
                        }
                        .onEnded { value in
                                longPressBuffer = 0
                                context.updateTouchedLocation(to: .zero)
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
                                        if !isLongPressEngaged {
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
