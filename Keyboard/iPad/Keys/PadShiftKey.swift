import SwiftUI
import CommonExtensions
import CoreIME

struct PadShiftKey: View {

        let widthUnitTimes: CGFloat

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        private var backColor: Color {
                if #available(iOSApplicationExtension 26.0, *) {
                        return isTouching ? colorScheme.activeActionKeyColor : colorScheme.actionKeyColor
                } else {
                        return context.keyboardCase.isLowercased ? colorScheme.actionKeyColor : colorScheme.activeActionKeyColor
                }
        }

        /// From idle to the first touch
        @State private var isInteracted: Bool = false

        @State private var isTouching: Bool = false
        @State private var isLongPressEngaged: Bool = false
        @State private var longPressBuffer: Int = 0

        @State private var previousKeyboardCase: KeyboardCase = .lowercased
        @State private var isInTheMediumOfDoubleTapping: Bool = false
        @State private var doubleTappingBuffer: Int = 0

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * widthUnitTimes
                let keyHeight: CGFloat = context.heightUnit
                let keyboardInterface = context.keyboardInterface
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius)
                                        .fill(backColor)
                                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                        .padding(keyboardInterface.keyShapeInsets)
                                switch context.keyboardCase {
                                case .lowercased: Image.shiftLowercased.font(.title3)
                                case .uppercased: Image.shiftUppercased.font(.title3)
                                case .capsLocked: Image.shiftCapsLocked.font(.title3)
                                }
                        }
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
