import SwiftUI

struct TenKeySidebar: View {

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
                ZStack {
                        RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous)
                                .fill(keyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                        if #available(iOSApplicationExtension 18.0, *) {
                                TenKeySidebarScrollViewIOS18()
                        } else if #available(iOSApplicationExtension 17.0, *) {
                                TenKeySidebarScrollViewIOS17()
                        } else {
                                TenKeySidebarScrollView()
                        }
                }
                .padding(3)
                .frame(width: context.tenKeyWidthUnit, height: context.heightUnit * 3)
        }
}
