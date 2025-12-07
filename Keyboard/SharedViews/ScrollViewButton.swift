import SwiftUI

// https://danielsaidi.com/blog/2022/11/16/using-complex-gestures-in-a-scroll-view

struct ScrollViewButton<Label: View>: View {

        /// Button for ScrollView
        /// - Parameters:
        ///   - longPressTime: Long-press delay in milliseconds
        ///   - longPressAction: Long-press action
        ///   - endAction: Ending action
        ///   - releaseAction: Releasing action
        ///   - label: View
        init(
                longPressTime: UInt64 = 400, // 0.4s
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

        /// Button Style
        /// - Parameters:
        ///   - longPressTime: Long-press delay in milliseconds
        ///   - longPressAction: Long-press action
        ///   - endAction: Ending action
        init(
                longPressTime: UInt64,
                longPressAction: @escaping () -> Void,
                endAction: @escaping () -> Void
        ) {
                self.longPressTime = longPressTime
                self.longPressAction = longPressAction
                self.endAction = endAction
        }

        private let longPressTime: UInt64
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
                Task {
                        try await Task.sleep(for: .milliseconds(longPressTime))

                        // TODO: Better way to compare?
                        if date == longPressDate {
                                longPressAction()
                        }
                }
        }
}
