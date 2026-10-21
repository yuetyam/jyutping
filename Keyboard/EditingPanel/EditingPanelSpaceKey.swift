import SwiftUI
import CommonExtensions

/// Space bar for the editing panel, with double-tap recognition and hold-to-drag cursor movement.
///
/// Taps send space operations on release. A 400 ms hold enables cursor dragging, and successive taps use a 300 ms second-tap window.
struct EditingPanelSpaceKey: View {

        /// Supplies keyboard geometry, input and feedback handlers.
        @EnvironmentObject private var context: KeyboardViewController

        /// Selects the idle and pressed action-key colors for the current light or dark appearance.
        @Environment(\.colorScheme) private var colorScheme

        /// Monotonic clock used to schedule the hold threshold and second-tap expiry without idle polling.
        private let clock = ContinuousClock()

        /// Press state reported by `PressButtonStyle`, controlling the key highlight and active interaction deadline; may end when sliding outside the key.
        @State private var isTouching: Bool = false

        /// Whether the hold threshold has been reached, showing cursor arrows and suppressing the space operation on release.
        @State private var isLongPressEngaged: Bool = false

        /// Deadline set 400 ms after press-down to enable cursor dragging; cleared when the drag gesture ends.
        @State private var longPressDeadline: ContinuousClock.Instant?

        /// Horizontal translation at the last handled drag step; each subsequent step requires more than 10 points of movement.
        @State private var previousDraggingDistance: CGFloat = 0

        /// Whether a preceding tap is awaiting a second tap, whose release sends `.doubleSpace`; expiry pauses while the key is pressed.
        @State private var isInTheMediumOfDoubleTapping: Bool = false

        /// Deadline set 300 ms after a first tap's release; cleared on press-down to suspend expiry during the next press.
        @State private var doubleTappingDeadline: ContinuousClock.Instant?

        /// Renders the legacy background using the editing-key inset and ultra corner radius, displaying the localized space label or long-press cursor arrows.
        ///
        /// Pressing highlights the key and reduces the padding by two points.
        /// Press-down provides audio and haptic feedback. A simultaneous drag sends `.space` or `.doubleSpace` on release unless a long press was engaged.
        /// After the hold threshold, horizontal drag steps move the cursor.
        /// One task sleeps until the active hold or second-tap deadline, exits on cancellation, and checks that the deadline is still current before updating state.
        var body: some View {
                let interactionDeadline = isTouching ? longPressDeadline : doubleTappingDeadline
                let inset = context.keyboardInterface.editingKeyInset
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                RoundedRectangle(cornerRadius: PresetConstant.ultraKeyCornerRadius)
                                        .fill(colorScheme.actionKeyBackground(style: context.appearanceStyle, isInteracting: isTouching))
                                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                        .padding(isTouching ? (inset - 2) : inset)
                                if isLongPressEngaged {
                                        Text(PresetConstant.spaceKeyLongPressHint)
                                } else {
                                        Text("EditingPanel.Space").font(.staticBody)
                                }
                        }
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
                        context.performAudioFeedback(.modify)
                        context.triggerHapticFeedback()
                        isLongPressEngaged = false
                })
                .simultaneousGesture(DragGesture(minimumDistance: 0)
                        .onChanged { value in
                                guard isTouching else { return }
                                guard isLongPressEngaged else { return }
                                let currentDraggingDistance = value.translation.width
                                let extra = currentDraggingDistance - previousDraggingDistance
                                guard abs(extra) > 10 else { return }
                                previousDraggingDistance = currentDraggingDistance
                                context.performAudioFeedback(.modify)
                                context.triggerHapticFeedback()
                                context.operate(extra > 0 ? .moveCursorForward : .moveCursorBackward)
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
                                context.performAudioFeedback(.modify)
                                context.triggerHapticFeedback()
                                isLongPressEngaged = true
                        } else if doubleTappingDeadline == deadline {
                                doubleTappingDeadline = nil
                                isInTheMediumOfDoubleTapping = false
                        }
                }
        }
}
