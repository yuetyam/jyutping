import SwiftUI
import CommonExtensions

struct HeadlineLabel: View {
        init(title: LocalizedStringKey, titleFont: Font = .headline, icon: String, iconTint: Color = .accentColor) {
                self.title = title
                self.titleFont = titleFont
                self.icon = icon
                self.iconTint = iconTint
        }
        private let title: LocalizedStringKey
        private let titleFont: Font
        private let icon: String
        private let iconTint: Color
        var body: some View {
                HStack(spacing: 14) {
                        Image(systemName: icon)
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(iconTint)
                                .frame(width: 20)
                        Text(title)
                                .font(titleFont)
                }
        }
}
