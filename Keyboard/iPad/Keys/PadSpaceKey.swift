import SwiftUI
import CommonExtensions

/// Space bar with double-tap recognition and hold-to-drag cursor movement.
///
/// Taps send space operations on release. A 400 ms hold enables cursor dragging, and successive taps use a 300 ms second-tap window.
struct PadSpaceKey: View {

        /// Keyboard properties and handlers.
        @EnvironmentObject private var context: KeyboardViewController

        /// Retrieves the current system color scheme (light or dark mode) from the environment.
        @Environment(\.colorScheme) private var colorScheme

        /// Monotonic clock used to measure interaction deadlines independently of timer scheduling.
        private let clock = ContinuousClock()

        /// Button press state reported by PressButtonStyle; may end when sliding outside the key.
        @State private var isTouching: Bool = false

        /// Whether the current hold has enabled cursor dragging and suppressed the release's space operation.
        @State private var isLongPressEngaged: Bool = false

        /// Deadline for enabling cursor dragging during the current press.
        @State private var longPressDeadline: ContinuousClock.Instant?

        /// Horizontal translation at the last cursor operation; each subsequent operation requires more than 10 points of movement.
        @State private var previousDraggingDistance: CGFloat = 0

        /// Whether a preceding tap is awaiting a second tap; the window pauses while the key is pressed.
        @State private var isInTheMediumOfDoubleTapping: Bool = false

        /// Deadline for expiring a pending second tap while the key is released.
        @State private var doubleTappingDeadline: ContinuousClock.Instant?

        /// Renders the dedicated background and current space-key label, replacing the label with cursor arrows during a long press.
        ///
        /// Press-down provides audio feedback. A simultaneous drag handles cursor movement and release operations.
        /// One task sleeps until the active interaction deadline, returns immediately on cancellation, and performs no timed work while idle.
        var body: some View {
                let interactionDeadline = isTouching ? longPressDeadline : doubleTappingDeadline
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius)
                                        .fill(isTouching ? colorScheme.activeInputKeyColor : colorScheme.inputKeyColor)
                                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                        .padding(context.keyboardInterface.keyShapeInsets)
                                Text(isLongPressEngaged ? PresetConstant.spaceKeyLongPressHint : context.spaceKeyForm.attributedText)
                        }
                        .frame(height: context.heightUnit)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PressButtonStyle($isTouching) {
                        let now = clock.now
                        if let deadline = doubleTappingDeadline, now >= deadline {
                                isInTheMediumOfDoubleTapping = false
                        }
                        // Suspend second-tap expiry during the press, even if the previous expiry task has not resumed yet.
                        doubleTappingDeadline = nil
                        longPressDeadline = now.advanced(by: .milliseconds(400))
                        previousDraggingDistance = 0
                        AudioFeedback.modified()
                        isLongPressEngaged = false
                })
                .simultaneousGesture(DragGesture(minimumDistance: 0)
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
                                longPressDeadline = nil
                                previousDraggingDistance = 0
                                if isLongPressEngaged {
                                        isLongPressEngaged = false
                                } else if isInTheMediumOfDoubleTapping {
                                        isInTheMediumOfDoubleTapping = false
                                        context.operate(.doubleSpace)
                                } else {
                                        isInTheMediumOfDoubleTapping = true
                                        context.operate(.space)
                                }
                                doubleTappingDeadline = isInTheMediumOfDoubleTapping ? clock.now.advanced(by: .milliseconds(300)) : nil
                        }
                )
                .task(id: interactionDeadline) {
                        guard let deadline = interactionDeadline else { return }
                        do {
                                try await clock.sleep(until: deadline)
                        } catch {
                                return
                        }
                        guard Task.isCancelled.negative else { return }
                        if isTouching {
                                guard longPressDeadline == deadline, isLongPressEngaged.negative else { return }
                                AudioFeedback.modified()
                                isLongPressEngaged = true
                        } else if doubleTappingDeadline == deadline {
                                doubleTappingDeadline = nil
                                isInTheMediumOfDoubleTapping = false
                        }
                }
        }
}
