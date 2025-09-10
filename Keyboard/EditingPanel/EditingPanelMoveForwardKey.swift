import SwiftUI
import CommonExtensions

struct EditingPanelMoveForwardKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @GestureState private var isTouching: Bool = false
        @State private var buffer: Int = 0
        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous)
                                .fill(isTouching ? colorScheme.activeActionKeyColor : colorScheme.actionKeyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(4)
                        Image(systemName: "arrow.forward")
                }
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                guard tapped.negative else { return }
                                AudioFeedback.modified()
                                context.triggerHapticFeedback()
                                context.operate(.moveCursorForward)
                                tapped = true
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
