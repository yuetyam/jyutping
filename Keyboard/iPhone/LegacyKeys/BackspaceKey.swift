import SwiftUI
import CommonExtensions

/// A legacy-styled backspace key with hold-to-repeat and swipe-to-clear behavior.
struct BackspaceKey: View {

        /// Creates a legacy-styled backspace key.
        ///
        /// - Parameter coefficient: Multiplier applied to the keyboard's width unit.
        init(coefficient: CGFloat = 1.35) {
                self.coefficient = coefficient
        }

        /// Multiplier applied to the keyboard's width unit.
        private let coefficient: CGFloat

        /// Keyboard properties and handlers.
        @EnvironmentObject private var context: KeyboardViewController

        /// Retrieves the current system color scheme (light or dark mode) from the environment.
        @Environment(\.colorScheme) private var colorScheme

        /// Monotonic clock used to measure interaction deadlines independently of task scheduling.
        private let clock = ContinuousClock()

        /// Button press state reported by `PressButtonStyle`.
        @State private var isTouching: Bool = false

        /// Deadline for the next repeat deletion during the current press.
        @State private var repeatDeadline: ContinuousClock.Instant?

        /// Renders the backspace symbol and pressed background using the selected appearance style and keyboard geometry.
        ///
        /// `PressButtonStyle` performs the first deletion with audio and haptic feedback on press-down. Repeat deletion begins after a 400 ms hold and continues at 100 ms intervals.
        /// One task sleeps until the active repeat deadline, returns immediately on cancellation, and verifies the press and deadline before deleting; no timed work runs while idle.
        /// Ending the drag clears the repeat deadline. Releasing more than 44 points left or up also sends the clear-buffer operation with audio and haptic feedback.
        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * coefficient
                let keyHeight: CGFloat = context.heightUnit
                let keyColor = colorScheme.actionKeyBackground(style: context.appearanceStyle, isInteracting: isTouching)
                let insets = context.keyboardInterface.keyShapeInsets
                let interactionDeadline = isTouching ? repeatDeadline : nil
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                RoundedRectangle(cornerRadius: PresetConstant.keyCornerRadius)
                                        .fill(keyColor)
                                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                        .padding(insets)
                                Image.backspace.symbolVariant(isTouching ? .fill : .none).font(.symbol)
                        }
                        .frame(width: keyWidth, height: keyHeight)
                }
                .buttonStyle(PressButtonStyle($isTouching) {
                        repeatDeadline = clock.now.advanced(by: .milliseconds(400))
                        context.performAudioFeedback(.delete)
                        context.triggerHapticFeedback()
                        context.operate(.backspace)
                })
                .simultaneousGesture(DragGesture(minimumDistance: 0)
                        .onEnded { value in
                                repeatDeadline = nil
                                guard (value.translation.width < -44) || (value.translation.height < -44) else { return }
                                context.performAudioFeedback(.delete)
                                context.triggerHapticFeedback()
                                context.operate(.clearBuffer)
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
                        guard isTouching, repeatDeadline == deadline else { return }
                        context.performAudioFeedback(.delete)
                        context.triggerHapticFeedback()
                        context.operate(.backspace)
                        repeatDeadline = clock.now.advanced(by: .milliseconds(100))
                }
        }
}
