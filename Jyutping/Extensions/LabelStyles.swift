import SwiftUI

struct IconTintLabelStyle: LabelStyle {

        init(_ color: Color) {
                self.color = color
        }
        private let color: Color

        func makeBody(configuration: Configuration) -> some View {
                Label(
                        title: { configuration.title },
                        icon: { configuration.icon.foregroundStyle(color) }
                )
        }
}
extension LabelStyle where Self == IconTintLabelStyle {
        static func iconTint(_ color: Color) -> Self {
                return IconTintLabelStyle(color)
        }
}

struct HeadlineLabelStyle: LabelStyle {

        init(iconColor: Color = .accentColor) {
                self.iconColor = iconColor
        }
        private let iconColor: Color

        func makeBody(configuration: Configuration) -> some View {
                Label(
                        title: { configuration.title.font(.headline) },
                        icon: { configuration.icon.foregroundStyle(iconColor) }
                )
        }
}
extension LabelStyle where Self == HeadlineLabelStyle {
        static func headline(iconColor: Color = .accentColor) -> Self {
                return HeadlineLabelStyle(iconColor: iconColor)
        }
}
