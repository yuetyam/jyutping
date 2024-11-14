import SwiftUI
import CommonExtensions

struct LargePadShiftKey: View {

        let keyLocale: HorizontalEdge
        let widthUnitTimes: CGFloat

        @EnvironmentObject private var context: KeyboardViewController

        @Environment(\.colorScheme) private var colorScheme
        private var keyColor: Color {
                switch colorScheme {
                case .light:
                        return .lightEmphatic
                case .dark:
                        return .darkEmphatic
                @unknown default:
                        return .lightEmphatic
                }
        }
        private var activeKeyColor: Color {
                switch colorScheme {
                case .light:
                        return .light
                case .dark:
                        return .dark
                @unknown default:
                        return .light
                }
        }

        @GestureState private var isTouching: Bool = false
        @State private var previousKeyboardCase: KeyboardCase = .lowercased
        @State private var isInTheMediumOfDoubleTapping: Bool = false
        @State private var doubleTappingBuffer: Int = 0
        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * widthUnitTimes
                let keyHeight: CGFloat = context.heightUnit
                let isLandscape: Bool = context.keyboardInterface.isPadLandscape
                let verticalPadding: CGFloat = isLandscape ? 5 : 4
                let horizontalPadding: CGFloat = isLandscape ? 5 : 4
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(context.keyboardCase.isLowercased ? keyColor : activeKeyColor)
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
                        .padding(.vertical, verticalPadding + 7)
                        .padding(.horizontal, horizontalPadding + 7)
                        ZStack(alignment: keyLocale.isLeading ? .bottomLeading : .bottomTrailing) {
                                Color.clear
                                Text(verbatim: "shift")
                        }
                        .padding(.vertical, verticalPadding + 7)
                        .padding(.horizontal, horizontalPadding + 7)
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
