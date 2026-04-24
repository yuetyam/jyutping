import SwiftUI
import CommonExtensions

struct HeadlineLabel: View {
        init(title: LocalizedStringKey, icon: String, iconTint: Color = .accentColor) {
                self.title = title
                self.icon = icon
                self.iconTint = iconTint
        }
        private let title: LocalizedStringKey
        private let icon: String
        private let iconTint: Color
        var body: some View {
                HStack(spacing: 14) {
                        Image(systemName: icon)
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(iconTint)
                                .frame(width: 20)
                        Text(title).font(.headline)
                }
        }
}
