import SwiftUI

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
        @State private var isInTheMediumOfDoubleTapping: Bool = false
        @State private var doubleTappingBuffer: Int = 0
        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

        var body: some View {
                let keyImageName: String = {
                        switch context.keyboardCase {
                        case .lowercased:
                                return "shift"
                        case .uppercased:
                                return "shift.fill"
                        case .capsLocked:
                                return "capslock.fill"
                        }
                }()
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(context.keyboardCase.isLowercased ? keyColor : activeKeyColor)
                                .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                .padding(4)
                        ZStack(alignment: keyLocale.isLeading ? .topLeading : .topTrailing) {
                                Color.clear
                                Image(systemName: keyImageName)
                                        .padding(12)
                        }
                        ZStack(alignment: keyLocale.isLeading ? .bottomLeading : .bottomTrailing) {
                                Color.clear
                                Text(verbatim: "shift")
                                        .padding(12)
                        }
                }
                .frame(width: context.widthUnit * widthUnitTimes, height: context.heightUnit)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, touched, _ in
                                if !touched {
                                        AudioFeedback.modified()
                                        touched = true
                                }
                        }
                        .onEnded { _ in
                                if isInTheMediumOfDoubleTapping {
                                        context.operate(.doubleShift)
                                } else {
                                        isInTheMediumOfDoubleTapping = true
                                        context.operate(.shift)
                                }
                        }
                )
                .onReceive(timer) { _ in
                        if isInTheMediumOfDoubleTapping {
                                if doubleTappingBuffer > 2 {
                                        doubleTappingBuffer = 0
                                        isInTheMediumOfDoubleTapping = false
                                } else {
                                        doubleTappingBuffer += 1
                                }
                        }
                }
        }
}
