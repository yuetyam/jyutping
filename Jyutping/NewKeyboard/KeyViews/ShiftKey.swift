import SwiftUI

struct ShiftKey: View {

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
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(isTouching ? activeKeyColor : keyColor)
                                .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 3)
                        switch context.keyboardType {
                        case .abc(.capsLocked), .cantonese(.capsLocked), .saamPing(.capsLocked):
                                Image(systemName: "capslock.fill")
                        case .abc(.uppercased), .cantonese(.uppercased), .saamPing(.uppercased):
                                Image(systemName: "shift.fill")
                        default:
                                Image(systemName: "shift")
                        }
                }
                .frame(width: context.widthUnit * 1.25, height: context.heightUnit)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, touched, _ in
                                if !touched {
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
