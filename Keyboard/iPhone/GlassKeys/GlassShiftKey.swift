import SwiftUI
import CommonExtensions
import CoreIME

/// A glass-styled Shift key with double-tap and hold-to-toggle caps lock.
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassShiftKey: View {

        /// Creates a glass-styled Shift key.
        ///
        /// - Parameter coefficient: Multiplier applied to the keyboard's width unit.
        init(coefficient: CGFloat = 1.3) {
                self.coefficient = coefficient
        }

        /// Multiplier applied to the keyboard's width unit.
        private let coefficient: CGFloat


        /// Keyboard properties and handlers.
        @EnvironmentObject private var context: KeyboardViewController

        /// Retrieves the current system color scheme (light or dark mode) from the environment.
        @Environment(\.colorScheme) private var colorScheme

        /// Monotonic clock used to measure interaction deadlines independently of timer scheduling.
        private let clock = ContinuousClock()

        /// Button press state reported by `PressButtonStyle`.
        @State private var isTouching: Bool = false

        /// Deadline for toggling caps lock once during the current press.
        @State private var longPressDeadline: ContinuousClock.Instant?

        /// Keyboard case before the preceding press, used to recognize an intervening case reset.
        @State private var previousKeyboardCase: KeyboardCase = .lowercased

        /// Whether a preceding press is awaiting a second tap; expiry pauses while the key is pressed.
        @State private var isInTheMediumOfDoubleTapping: Bool = false

        /// Deadline for expiring a pending second tap while the key is released.
        @State private var doubleTappingDeadline: ContinuousClock.Instant?

        /// Renders the current Shift symbol; pressing highlights and enlarges the glass key.
        ///
        /// Press-down switches case with audio and haptic feedback. A 400 ms hold toggles caps lock, and successive taps use a 300 ms second-tap window after release.
        /// One task sleeps until the active interaction deadline, returns immediately on cancellation, and performs no timed work while idle.
        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * coefficient
                let keyHeight: CGFloat = context.heightUnit
                let insets = context.keyboardInterface.keyShapeInsets
                let interactionDeadline = isTouching ? longPressDeadline : doubleTappingDeadline
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                ZStack {
                                        Color.clear
                                        switch context.keyboardCase {
                                        case .lowercased: Image.shiftLowercased
                                        case .uppercased: Image.shiftUppercased
                                        case .capsLocked: Image.shiftCapsLocked
                                        }
                                }
                                .font(.symbol)
                                .glassEffect(isTouching ? .regular : .clear, in: .rect(cornerRadius: PresetConstant.keyCornerRadius))
                                .shadow(color: isTouching ? colorScheme.glassShadow : Color.clear, radius: 0.5)
                                .padding(isTouching ? insets.plused(-2) : insets)
                        }
                        .frame(width: keyWidth, height: keyHeight)
                }
                .buttonStyle(PressButtonStyle($isTouching) {
                        let now = clock.now
                        if let deadline = doubleTappingDeadline, now >= deadline {
                                isInTheMediumOfDoubleTapping = false
                        }
                        // Suspend second-tap expiry during the press, even if the previous expiry task has not resumed yet.
                        doubleTappingDeadline = nil
                        longPressDeadline = now.advanced(by: .milliseconds(400))
                        AudioFeedback.modified()
                        context.triggerHapticFeedback()
                        let currentKeyboardCase = context.keyboardCase
                        let didKeyboardCaseSwitchBack: Bool = (currentKeyboardCase == previousKeyboardCase)
                        let shouldPerformDoubleTapping: Bool = isInTheMediumOfDoubleTapping && didKeyboardCaseSwitchBack.negative
                        previousKeyboardCase = currentKeyboardCase
                        if shouldPerformDoubleTapping {
                                isInTheMediumOfDoubleTapping = false
                                context.operate(.doubleShift)
                        } else {
                                isInTheMediumOfDoubleTapping = true
                                context.operate(.shift)
                        }
                })
                .onChange(of: isTouching) { _, touching in
                        guard touching.negative else { return }
                        longPressDeadline = nil
                        doubleTappingDeadline = isInTheMediumOfDoubleTapping ? clock.now.advanced(by: .milliseconds(300)) : nil
                }
                .task(id: interactionDeadline) {
                        guard let deadline = interactionDeadline else { return }
                        do {
                                try await clock.sleep(until: deadline)
                        } catch {
                                return
                        }
                        guard Task.isCancelled.negative else { return }
                        if isTouching {
                                guard longPressDeadline == deadline else { return }
                                longPressDeadline = nil
                                isInTheMediumOfDoubleTapping = false
                                AudioFeedback.modified()
                                context.triggerHapticFeedback()
                                context.operate(.doubleShift)
                        } else if doubleTappingDeadline == deadline {
                                doubleTappingDeadline = nil
                                isInTheMediumOfDoubleTapping = false
                        }
                }
        }
}
