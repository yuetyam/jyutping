import SwiftUI

/// Toggle Cantonese/ABC InputMethodMode
@available(iOS, deprecated: 26.0, message: "Use InputModeSwitch instead")
@available(iOSApplicationExtension, deprecated: 26.0, message: "Use InputModeSwitch instead")
struct LegacyInputModeSwitch: View {

        let isCantoneseMode: Bool
        let isMutilatedMode: Bool

        @Environment(\.colorScheme) private var colorScheme

        private let height: CGFloat = 26
        private let partialWidth: CGFloat = 35
        private let totalWidth: CGFloat = 60

        var body: some View {
                ZStack {
                        Color.clear
                        ZStack(alignment: .leading) {
                                Color.clear
                                Text(verbatim: isMutilatedMode ? "粤" : "粵")
                                        .font(isCantoneseMode ? .staticBody : .mini)
                                        .frame(width: partialWidth, height: height)
                                        .background(isCantoneseMode ? colorScheme.inputKeyColor : Color.clear, in: .capsule)
                        }
                        ZStack(alignment: .trailing) {
                                Color.clear
                                Text(verbatim: "A")
                                        .font(isCantoneseMode ? .mini : .staticBody)
                                        .frame(width: partialWidth, height: height)
                                        .background(isCantoneseMode ? Color.clear : colorScheme.inputKeyColor, in: .capsule)
                        }
                }
                .frame(width: totalWidth, height: height)
                .background(colorScheme.activeInputKeyColor, in: .capsule)
        }
}

/// Toggle Cantonese/ABC InputMethodMode
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct InputModeSwitch: View {

        let isCantoneseMode: Bool
        let isMutilatedMode: Bool

        @Environment(\.colorScheme) private var colorScheme

        private let height: CGFloat = 26
        private let partialWidth: CGFloat = 35
        private let totalWidth: CGFloat = 60

        var body: some View {
                ZStack {
                        Color.clear
                        ZStack(alignment: .leading) {
                                Color.clear
                                ZStack {
                                        Capsule()
                                                .fill(isCantoneseMode ? colorScheme.inputKeyColor : Color.clear)
                                                .shadow(color: isCantoneseMode ? Color.clear : Color.shadowGray, radius: 0.5)
                                        Text(verbatim: isMutilatedMode ? "粤" : "粵")
                                                .font(isCantoneseMode ? .staticBody : .mini)
                                }
                                .frame(width: partialWidth, height: height)
                        }
                        ZStack(alignment: .trailing) {
                                Color.clear
                                ZStack {
                                        Capsule()
                                                .fill(isCantoneseMode ? Color.clear : colorScheme.inputKeyColor)
                                                .shadow(color: isCantoneseMode ? Color.clear : Color.shadowGray, radius: 0.5)
                                        Text(verbatim: "A")
                                                .font(isCantoneseMode ? .mini : .staticBody)
                                }
                                .frame(width: partialWidth, height: height)
                        }
                }
                .frame(width: totalWidth, height: height)
                .background(Material.thin, in: .capsule)
        }
}

private extension Font {
        static let mini: Font = Font.system(size: 13)
}
