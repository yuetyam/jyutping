import SwiftUI

struct ScrollViewButton<Label: View>: View {

        init(
                pressAction: @escaping () -> Void = {},
                endAction: @escaping () -> Void = {},
                releaseAction: @escaping () -> Void,
                label: @escaping () -> Label
        ) {
                self.releaseAction = releaseAction
                self.label = label
                self.style = ScrollViewButtonStyle(pressAction: pressAction, endAction: endAction)
        }

        private let releaseAction: () -> Void
        private let label: () -> Label
        private let style: ScrollViewButtonStyle

        var body: some View {
                Button(action: releaseAction, label: label)
                        .buttonStyle(style)
        }
}

struct ScrollViewButtonStyle: ButtonStyle {

        let pressAction: () -> Void
        let endAction: () -> Void

        func makeBody(configuration: Configuration) -> some View {
                configuration.label
                        .onChange(of: configuration.isPressed) { isPressed in
                                if isPressed {
                                        pressAction()
                                } else {
                                        endAction()
                                }
                        }
        }
}
