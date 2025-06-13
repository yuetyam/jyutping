import SwiftUI

struct TenKeyGlobeKey: View {

        @EnvironmentObject private var context: KeyboardViewController

        @Environment(\.colorScheme) private var colorScheme

        private var keyColor: Color {
                switch colorScheme {
                case .light:
                        return .lightAction
                case .dark:
                        return .darkAction
                @unknown default:
                        return .lightAction
                }
        }

        var body: some View {
                let width: CGFloat = context.tenKeyWidthUnit
                let height: CGFloat = context.heightUnit
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous)
                                .fill(keyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(3)
                        Image(systemName: "globe")
                        TenKeyGlobeButton()
                }
                .frame(width: width, height: height)
        }
}

private struct TenKeyGlobeButton: UIViewRepresentable {

        @EnvironmentObject private var controller: KeyboardViewController

        func makeUIView(context: Context) -> UIButton {
                let button = UIButton()
                button.addTarget(controller, action: #selector(controller.handleInputModeList(from:with:)), for: .allTouchEvents)
                button.addTarget(controller, action: #selector(controller.globeKeyFeedback), for: .touchDown)
                return button
        }
        func updateUIView(_ uiView: UIViewType, context: Context) {}
}
