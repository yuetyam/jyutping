import SwiftUI
import CommonExtensions
import CoreIME

struct ShiftKey: View {

        /// Create a Shift key
        /// - Parameter coefficient: Multiplier to the `widthUnit`
        init(coefficient: CGFloat = 1.3) {
                self.coefficient = coefficient
        }
        private let coefficient: CGFloat

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        /// From idle to the very first touch
        @State private var isInteracted: Bool = false

        @State private var isTouching: Bool = false
        @State private var isLongPressEngaged: Bool = false
        @State private var longPressBuffer: Int = 0

        @State private var previousKeyboardCase: KeyboardCase = .lowercased
        @State private var isInTheMediumOfDoubleTapping: Bool = false
        @State private var doubleTappingBuffer: Int = 0

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * coefficient
                let keyHeight: CGFloat = context.heightUnit
                let keyboardInterface = context.keyboardInterface
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                RoundedRectangle(cornerRadius: PresetConstant.keyCornerRadius)
                                        .fill(isTouching ? colorScheme.activeActionKeyColor : colorScheme.actionKeyColor)
                                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                        .padding(keyboardInterface.keyShapeInsets)
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
                        longPressBuffer = 0
                        doubleTappingBuffer = 0
                        AudioFeedback.modified()
                        context.triggerHapticFeedback()
                        isLongPressEngaged = false
                        if isInteracted.negative {
                                isInteracted = true
                        }
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
                .task(id: isInteracted) {
                        guard isInteracted else { return }
                        while Task.isCancelled.negative {
                                try? await Task.sleep(for: .milliseconds(100)) // 0.1s
                                if isTouching {
                                        if longPressBuffer > 3 {
                                                if isLongPressEngaged.negative {
                                                        isLongPressEngaged = true
                                                        isInTheMediumOfDoubleTapping = false
                                                        AudioFeedback.modified()
                                                        context.triggerHapticFeedback()
                                                        context.operate(.doubleShift)
                                                }
                                        } else {
                                                longPressBuffer += 1
                                        }
                                } else if isInTheMediumOfDoubleTapping {
                                        if doubleTappingBuffer >= 3 {
                                                doubleTappingBuffer = 0
                                                isInTheMediumOfDoubleTapping = false
                                        } else {
                                                doubleTappingBuffer += 1
                                        }
                                }
                        }
                }
        }
}
