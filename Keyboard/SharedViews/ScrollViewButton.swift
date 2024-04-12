import SwiftUI

// https://danielsaidi.com/blog/2022/11/16/using-complex-gestures-in-a-scroll-view

struct ScrollViewButton<Label: View>: View {

        init(
                longPressTime: TimeInterval = 0.4,
                longPressAction: @escaping () -> Void = {},
                endAction: @escaping () -> Void = {},
                releaseAction: @escaping () -> Void,
                label: @escaping () -> Label
        ) {
                self.releaseAction = releaseAction
                self.label = label
                self.style = ScrollViewButtonStyle(
                        longPressTime: longPressTime,
                        longPressAction: longPressAction,
                        endAction: endAction)
        }

        private let releaseAction: () -> Void
        private let label: () -> Label
        private let style: ScrollViewButtonStyle

        var body: some View {
                Button(action: releaseAction, label: label)
                        .buttonStyle(style)
        }
}

private struct ScrollViewButtonStyle: ButtonStyle {

        init(
                longPressTime: TimeInterval,
                longPressAction: @escaping () -> Void,
                endAction: @escaping () -> Void
        ) {
                self.longPressTime = longPressTime
                self.longPressAction = longPressAction
                self.endAction = endAction
        }

        private let longPressTime: TimeInterval
        private let longPressAction: () -> Void
        private let endAction: () -> Void

        @State private var longPressDate: Date = .now

        func makeBody(configuration: Configuration) -> some View {
                configuration.label
                        .onChange(of: configuration.isPressed) { isPressed in
                                longPressDate = .now
                                if isPressed {
                                        tryTriggerLongPressAfterDelay(triggered: longPressDate)
                                } else {
                                        endAction()
                                }
                        }
        }

        private func tryTriggerLongPressAfterDelay(triggered date: Date) {
                DispatchQueue.main.asyncAfter(deadline: .now() + longPressTime) {
                        if date == longPressDate {
                                longPressAction()
                        }
                }
        }
}
