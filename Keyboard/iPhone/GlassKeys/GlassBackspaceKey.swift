import SwiftUI
import CommonExtensions

/// A glass-styled backspace key with hold-to-repeat and swipe-to-clear behavior.
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassBackspaceKey: View {

        /// Creates a glass-styled backspace key.
        ///
        /// - Parameter coefficient: Multiplier applied to the keyboard's width unit.
        init(coefficient: CGFloat = 1.3) {
                self.coefficient = coefficient
        }

        /// Multiplier applied to the keyboard's width unit.
        private let coefficient: CGFloat


        /// Keyboard properties and handlers.
        @EnvironmentObject private var context: KeyboardViewController

        /// Retrieves the current system color scheme for the pressed-key shadow.
        @Environment(\.colorScheme) private var colorScheme

        /// Monotonic clock used to measure interaction deadlines independently of timer scheduling.
        private let clock = ContinuousClock()

        /// Button press state reported by `PressButtonStyle`.
        @State private var isTouching: Bool = false

        /// Deadline for the next repeat deletion during the current press.
        @State private var repeatDeadline: ContinuousClock.Instant?

        /// Renders the backspace symbol using the current keyboard interface's key insets; pressing highlights and enlarges the glass key.
        ///
        /// PressButtonStyle performs the first deletion with audio and haptic feedback on press-down. Repeat deletion begins after a 400 ms hold and continues at 100 ms intervals.
        /// One task sleeps until the active interaction deadline, returns immediately on cancellation, and performs no timed work while idle.
        /// Releasing a drag more than 44 points left or up sends the clear-buffer operation with audio and haptic feedback.
        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * coefficient
                let keyHeight: CGFloat = context.heightUnit
                let insets = context.keyboardInterface.keyShapeInsets
                let interactionDeadline = isTouching ? repeatDeadline : nil
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                ZStack {
                                        Color.clear
                                        Image.backspace.symbolVariant(isTouching ? .fill : .none).font(.symbol)
                                }
                                .glassEffect(isTouching ? .regular : .clear, in: .rect(cornerRadius: PresetConstant.keyCornerRadius))
                                .shadow(color: isTouching ? colorScheme.glassShadow : Color.clear, radius: 0.5)
                                .padding(isTouching ? insets.plused(-2): insets)
                        }
                        .frame(width: keyWidth, height: keyHeight)
                }
                .buttonStyle(PressButtonStyle($isTouching) {
                        repeatDeadline = clock.now.advanced(by: .milliseconds(400))
                        AudioFeedback.deleted()
                        context.triggerHapticFeedback()
                        context.operate(.backspace)
                })
                .simultaneousGesture(DragGesture(minimumDistance: 0)
                        .onEnded { value in
                                repeatDeadline = nil
                                guard (value.translation.width < -44) || (value.translation.height < -44) else { return }
                                AudioFeedback.deleted()
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
                        AudioFeedback.deleted()
                        context.triggerHapticFeedback()
                        context.operate(.backspace)
                        repeatDeadline = clock.now.advanced(by: .milliseconds(100))
                }
        }
}
