import SwiftUI

// https://danielsaidi.com/blog/2022/11/16/using-complex-gestures-in-a-scroll-view

@available(*, unavailable)
struct ScrollViewGestureButton<Label: View>: View {

        init(
                pressAction: @escaping () -> Void = {},
                doubleTapTimeout: TimeInterval = 0.3,
                doubleTapAction: @escaping () -> Void = {},
                longPressTime: TimeInterval = 0.4,
                longPressAction: @escaping () -> Void = {},
                endAction: @escaping () -> Void = {},
                releaseAction: @escaping () -> Void = {},
                label: @escaping () -> Label
        ) {
                self.style = ScrollViewGestureButtonStyle(
                        pressAction: pressAction,
                        doubleTapTimeout: doubleTapTimeout,
                        doubleTapAction: doubleTapAction,
                        longPressTime: longPressTime,
                        longPressAction: longPressAction,
                        endAction: endAction)
                self.releaseAction = releaseAction
                self.label = label
        }

        private let releaseAction: () -> Void
        private let label: () -> Label
        private let style: ScrollViewGestureButtonStyle

        var body: some View {
                Button(action: releaseAction, label: label)
                        .buttonStyle(style)
        }
}

private struct ScrollViewGestureButtonStyle: ButtonStyle {

        init(
                pressAction: @escaping () -> Void,
                doubleTapTimeout: TimeInterval,
                doubleTapAction: @escaping () -> Void,
                longPressTime: TimeInterval,
                longPressAction: @escaping () -> Void,
                endAction: @escaping () -> Void
        ) {
                self.pressAction = pressAction
                self.doubleTapTimeout = doubleTapTimeout
                self.doubleTapAction = doubleTapAction
                self.longPressTime = longPressTime
                self.longPressAction = longPressAction
                self.endAction = endAction
        }

        private let doubleTapTimeout: TimeInterval
        private let longPressTime: TimeInterval

        private let pressAction: () -> Void
        private let doubleTapAction: () -> Void
        private let longPressAction: () -> Void
        private let endAction: () -> Void

        @State private var doubleTapDate: Date = .now
        @State private var longPressDate: Date = .now

        func makeBody(configuration: Configuration) -> some View {
                configuration.label
                        .onChange(of: configuration.isPressed) { isPressed in
                                longPressDate = .now
                                if isPressed {
                                        pressAction()
                                        doubleTapDate = tryTriggerDoubleTap() ? .distantPast : .now
                                        tryTriggerLongPressAfterDelay(triggered: longPressDate)
                                } else {
                                        endAction()
                                }
                        }
        }

        private func tryTriggerDoubleTap() -> Bool {
                let interval = Date.now.timeIntervalSince(doubleTapDate)
                guard interval < doubleTapTimeout else { return false }
                doubleTapAction()
                return true
        }
        private func tryTriggerLongPressAfterDelay(triggered date: Date) {
                DispatchQueue.main.asyncAfter(deadline: .now() + longPressTime) {
                        if date == longPressDate {
                                longPressAction()
                        }
                }
        }
}
