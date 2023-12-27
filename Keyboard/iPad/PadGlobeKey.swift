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
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(keyColor)
                                .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                .padding(5)
                        Image(systemName: "globe")
                        PadGlobeButton().frame(width: context.widthUnit, height: context.heightUnit)
                }
                .frame(width: context.widthUnit * widthUnitTimes, height: context.heightUnit)
        }
}

private struct PadGlobeButton: UIViewRepresentable {

        @EnvironmentObject private var controller: KeyboardViewController

        func makeUIView(context: Context) -> UIButton {
                let button = UIButton()
                button.addTarget(controller, action: #selector(controller.handleInputModeList(from:with:)), for: .allTouchEvents)
                return button
        }
        func updateUIView(_ uiView: UIViewType, context: Context) {}
}
