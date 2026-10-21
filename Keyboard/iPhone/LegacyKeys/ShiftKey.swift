import SwiftUI
import CommonExtensions
import CoreIME

/// A legacy-styled Shift key with double-tap and hold-to-toggle caps lock.
struct ShiftKey: View {

        /// Creates a legacy-styled Shift key.
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

        /// Deadline for toggling caps lock once during the current press.
        @State private var longPressDeadline: ContinuousClock.Instant?

        /// Keyboard case before the preceding press, used to recognize an intervening case reset.
        @State private var previousKeyboardCase: KeyboardCase = .lowercased

        /// Whether a preceding press is awaiting a second tap; expiry pauses while the key is pressed.
        @State private var isInTheMediumOfDoubleTapping: Bool = false

        /// Deadline for expiring a pending second tap while the key is released.
        @State private var doubleTappingDeadline: ContinuousClock.Instant?

        /// Renders the current Shift symbol using the selected appearance style and keyboard geometry.
        ///
        /// The classic appearance also highlights the key while uppercase or caps lock is active.
        /// Press-down switches case with audio and haptic feedback. A 400 ms hold toggles caps lock, and successive taps use a 300 ms second-tap window after release.
        /// A second tap toggles caps lock only if the keyboard case has not returned to its value before the preceding press.
        /// One task sleeps until the active interaction deadline, returns immediately on cancellation, and checks the deadline before acting; no timed work runs while idle.
        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * coefficient
                let keyHeight: CGFloat = context.heightUnit
                let appearanceStyle = context.appearanceStyle
                let isInteracting: Bool = switch appearanceStyle {
                case .classic: (isTouching || context.keyboardCase.isCapitalized)
                default: isTouching
                }
                let keyColor = colorScheme.actionKeyBackground(style: appearanceStyle, isInteracting: isInteracting)
                let insets = context.keyboardInterface.keyShapeInsets
                let interactionDeadline = isTouching ? longPressDeadline : doubleTappingDeadline
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                RoundedRectangle(cornerRadius: PresetConstant.keyCornerRadius)
                                        .fill(keyColor)
                                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                        .padding(insets)
                                switch context.keyboardCase {
                                case .lowercased: Image.shiftLowercased
                                case .uppercased: Image.shiftUppercased
                                case .capsLocked: Image.shiftCapsLocked
                                }
                        }
                        .font(.symbol)
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
