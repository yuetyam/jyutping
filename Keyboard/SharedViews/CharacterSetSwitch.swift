import SwiftUI

@available(iOS, deprecated: 26.0, message: "Use CharacterSetSwitch instead")
@available(iOSApplicationExtension, deprecated: 26.0, message: "Use CharacterSetSwitch instead")
struct LegacyCharacterSetSwitch: View {

        let isMutilatedMode: Bool

        @Environment(\.colorScheme) private var colorScheme

        private let height: CGFloat = 26
        private let partialWidth: CGFloat = 28
        private let totalWidth: CGFloat = 50

        var body: some View {
                ZStack {
                        Color.clear
                        ZStack(alignment: .leading) {
                                Color.clear
                                Text(verbatim: "繁")
                                        .font(isMutilatedMode ? .small : .large)
                                        .frame(width: partialWidth, height: height)
                                        .background(isMutilatedMode ? Color.clear : colorScheme.inputKeyColor, in: .capsule)
                        }
                        ZStack(alignment: .trailing) {
                                Color.clear
                                Text(verbatim: "简")
                                        .font(isMutilatedMode ? .large : .small)
                                        .frame(width: partialWidth, height: height)
                                        .background(isMutilatedMode ? colorScheme.inputKeyColor : Color.clear, in: .capsule)
                        }
                }
                .frame(width: totalWidth, height: height)
                .background(colorScheme.activeInputKeyColor, in: .capsule)
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct CharacterSetSwitch: View {

        let isMutilatedMode: Bool

        @Environment(\.colorScheme) private var colorScheme

        private let height: CGFloat = 26
        private let partialWidth: CGFloat = 28
        private let totalWidth: CGFloat = 50

        var body: some View {
                ZStack {
                        Color.clear
                        ZStack(alignment: .leading) {
                                Color.clear
                                ZStack {
                                        Capsule()
                                                .fill(isMutilatedMode ? Color.clear : colorScheme.inputKeyColor)
                                                .shadow(color: isMutilatedMode ? Color.clear : Color.shadowGray, radius: 0.5)
                                        Text(verbatim: "繁")
                                                .font(isMutilatedMode ? .small : .large)
                                }
                                .frame(width: partialWidth, height: height)
                        }
                        ZStack(alignment: .trailing) {
                                Color.clear
                                ZStack {
                                        Capsule()
                                                .fill(isMutilatedMode ? colorScheme.inputKeyColor : Color.clear)
                                                .shadow(color: isMutilatedMode ? Color.clear : Color.shadowGray, radius: 0.5)
                                        Text(verbatim: "简")
                                                .font(isMutilatedMode ? .large : .small)
                                }
                                .frame(width: partialWidth, height: height)
                        }
                }
                .frame(width: totalWidth, height: height)
                .background(Material.thin, in: .capsule)
        }
}

private extension Font {
        static let large: Font = Font.system(size: 16)
        static let small: Font = Font.system(size: 12)
}
