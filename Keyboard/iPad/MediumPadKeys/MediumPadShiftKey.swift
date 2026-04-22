import SwiftUI
import CommonExtensions
import CoreIME

struct MediumPadShiftKey: View {

        let keyLocale: HorizontalEdge
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

        @GestureState private var isTouching: Bool = false
        @State private var previousKeyboardCase: KeyboardCase = .lowercased
        @State private var isInTheMediumOfDoubleTapping: Bool = false
        @State private var doubleTappingBuffer: Int = 0

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * widthUnitTimes
                let keyHeight: CGFloat = context.heightUnit
                let isLandscape: Bool = context.keyboardInterface.isPadLandscape
                let verticalPadding: CGFloat = isLandscape ? 7 : 5
                let horizontalPadding: CGFloat = isLandscape ? 7 : 5
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous)
                                .fill(backColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(.vertical, verticalPadding)
                                .padding(.horizontal, horizontalPadding)
                        ZStack(alignment: keyLocale.isLeading ? .topLeading : .topTrailing) {
                                Color.clear
                                switch context.keyboardCase {
                                case .lowercased:
                                        Image.shiftLowercased
                                case .uppercased:
                                        Image.shiftUppercased
                                case .capsLocked:
                                        Image.shiftCapsLocked
                                }
                        }
                        .padding(.vertical, verticalPadding + 5)
                        .padding(.horizontal, horizontalPadding + 5)
                        ZStack(alignment: keyLocale.isLeading ? .bottomLeading : .bottomTrailing) {
                                Color.clear
                                Text(verbatim: "shift").font(.footnote)
                        }
                        .padding(.vertical, verticalPadding + 5)
                        .padding(.horizontal, horizontalPadding + 5)
                }
                .frame(width: keyWidth, height: keyHeight)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, touched, _ in
                                if touched.negative {
                                        AudioFeedback.modified()
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
                .task {
                        while Task.isCancelled.negative {
                                try? await Task.sleep(for: .milliseconds(100)) // 0.1s
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
}
