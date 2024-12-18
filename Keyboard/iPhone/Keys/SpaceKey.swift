import SwiftUI
import CommonExtensions

struct SpaceKey: View {

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
        @State private var startPoint: CGPoint = .zero

        @State private var isInTheMediumOfDoubleTapping: Bool = false
        @State private var doubleTappingBuffer: Int = 0

        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * 4
                let keyHeight: CGFloat = context.heightUnit
                let isPhoneLandscape: Bool = context.keyboardInterface.isPhoneLandscape
                let verticalPadding: CGFloat = isPhoneLandscape ? 3 : 6
                let horizontalPadding: CGFloat = isPhoneLandscape ? 6 : 3
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(isTouching ? activeKeyColor : keyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(.vertical, verticalPadding)
                                .padding(.horizontal, horizontalPadding)
                        Text(isLongPressEngaged ? PresetConstant.spaceKeyLongPressHint : context.spaceKeyForm.attributedText)
                }
                .frame(width: keyWidth, height: keyHeight)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { value, touched, transaction in
                                if touched.negative {
                                        AudioFeedback.modified()
                                        context.triggerHapticFeedback()
                                        touched = true
                                        startPoint = value.startLocation
                                } else if isLongPressEngaged {
                                        let distance = value.location.x - startPoint.x
                                        guard abs(distance) > 10 else { return }
                                        startPoint = value.location
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
                                startPoint = .zero
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
