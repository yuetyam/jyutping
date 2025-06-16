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
                        UIGlobeButton()
                }
                .frame(width: width, height: height)
        }
}
