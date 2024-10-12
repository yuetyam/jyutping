import SwiftUI

struct GlobeKey: View {

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
                let width: CGFloat = context.widthUnit
                let height: CGFloat = context.heightUnit
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(keyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 3)
                        Image(systemName: "globe")
                        GlobeButton()
                }
                .frame(width: width, height: height)
        }
}

private struct GlobeButton: UIViewRepresentable {

        @EnvironmentObject private var controller: KeyboardViewController

        func makeUIView(context: Context) -> UIButton {
                let button = UIButton()
                button.addTarget(controller, action: #selector(controller.handleInputModeList(from:with:)), for: .allTouchEvents)
                button.addTarget(controller, action: #selector(controller.globeKeyFeedback), for: .touchDown)
                return button
        }
        func updateUIView(_ uiView: UIViewType, context: Context) {}
}
