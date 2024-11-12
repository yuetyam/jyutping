import SwiftUI

struct PadGlobeKey: View {

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

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * widthUnitTimes
                let keyHeight: CGFloat = context.heightUnit
                let isLandscape: Bool = context.keyboardInterface.isPadLandscape
                let verticalPadding: CGFloat = isLandscape ? 7 : 5
                let horizontalPadding: CGFloat = isLandscape ? 7 : 5
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(keyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(.vertical, verticalPadding)
                                .padding(.horizontal, horizontalPadding)
                        Image(systemName: "globe")
                        PadGlobeButton()
                }
                .frame(width: keyWidth, height: keyHeight)
        }
}

private struct PadGlobeButton: UIViewRepresentable {

        @EnvironmentObject private var controller: KeyboardViewController

        func makeUIView(context: Context) -> UIButton {
                let button = UIButton()
                button.addTarget(controller, action: #selector(controller.handleInputModeList(from:with:)), for: .allTouchEvents)
                button.addTarget(controller, action: #selector(controller.globeKeyFeedback), for: .touchDown)
                return button
        }
        func updateUIView(_ uiView: UIViewType, context: Context) {}
}
