import SwiftUI

struct EditingPanelMoveForwardKey: View {

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
        @State private var buffer: Int = 0
        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(isTouching ? activeKeyColor : keyColor)
                                .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                .padding(4)
                        Image(systemName: "arrow.forward")
                        /*
                        VStack(spacing: 4) {
                                Image(systemName: "arrow.forward")
                                Text("EditingPanel.MoveForward").font(.caption2)
                        }
                        */
                }
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                if !tapped {
                                        AudioFeedback.modified()
                                        context.triggerHapticFeedback()
                                        context.operate(.moveCursorForward)
                                        tapped = true
                                }
                        }
                        .onEnded { _ in
                                buffer = 0
                        }
                )
                .onReceive(timer) { _ in
                        guard isTouching else { return }
                        if buffer > 3 {
                                AudioFeedback.modified()
                                context.triggerHapticFeedback()
                                context.operate(.moveCursorForward)
                        } else {
                                buffer += 1
                        }
                }
        }
}
