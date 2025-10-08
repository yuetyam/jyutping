import SwiftUI
import CommonExtensions

struct ShiftKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @GestureState private var isTouching: Bool = false
        @State private var previousKeyboardCase: KeyboardCase = .lowercased
        @State private var isInTheMediumOfDoubleTapping: Bool = false
        @State private var doubleTappingBuffer: Int = 0
        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * 1.3
                let keyHeight: CGFloat = context.heightUnit
                let isPhoneLandscape: Bool = context.keyboardInterface.isPhoneLandscape
                let verticalPadding: CGFloat = isPhoneLandscape ? 3 : 6
                let horizontalPadding: CGFloat = isPhoneLandscape ? 6 : 3
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: PresetConstant.keyCornerRadius, style: .continuous)
                                .fill(isTouching ? colorScheme.activeActionKeyColor : colorScheme.actionKeyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(.vertical, verticalPadding)
                                .padding(.horizontal, horizontalPadding)
                        switch context.keyboardCase {
                        case .lowercased:
                                Image.shiftLowercased
                        case .uppercased:
                                Image.shiftUppercased
                        case .capsLocked:
                                Image.shiftCapsLocked
                        }
                }
                .font(.symbol)
                .frame(width: keyWidth, height: keyHeight)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, touched, _ in
                                if touched.negative {
                                        AudioFeedback.modified()
                                        context.triggerHapticFeedback()
                                        touched = true
                                }
                        }
                        .onEnded { _ in
                                let currentKeyboardCase: KeyboardCase = context.keyboardCase
                                let didKeyboardCaseSwitchBack: Bool = (currentKeyboardCase == previousKeyboardCase)
                                let shouldPerformDoubleTapping: Bool = isInTheMediumOfDoubleTapping && didKeyboardCaseSwitchBack.negative
                                doubleTappingBuffer = 0
                                previousKeyboardCase = currentKeyboardCase
                                if shouldPerformDoubleTapping {
                                        isInTheMediumOfDoubleTapping = false
                                        context.operate(.doubleShift)
                                } else {
                                        isInTheMediumOfDoubleTapping = true
                                        context.operate(.shift)
                                }
                        }
                )
                .onReceive(timer) { _ in
                        if isInTheMediumOfDoubleTapping {
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
