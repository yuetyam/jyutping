import SwiftUI
import CoreIME

/// Toggle Cantonese/ABC InputMethodMode
@available(iOS, deprecated: 26.0, message: "Use InputModeSwitch instead")
@available(iOSApplicationExtension, deprecated: 26.0, message: "Use InputModeSwitch instead")
struct LegacyInputModeSwitch: View {

        /// is ABC mode selected
        let isSwitched: Bool

        @Environment(\.colorScheme) private var colorScheme

        private let height: CGFloat = 26
        private let partialWidth: CGFloat = 36
        private let totalWidth: CGFloat = 64

        var body: some View {
                ZStack {
                        Color.clear
                        ZStack(alignment: .leading) {
                                Color.clear
                                Text(verbatim: Options.characterStandard.isSimplified ? "粤" : "粵")
                                        .font(isSwitched ? .mini : .staticBody)
                                        .frame(width: partialWidth, height: height)
                                        .background(isSwitched ? Color.clear : colorScheme.inputKeyColor, in: .capsule)
                        }
                        ZStack(alignment: .trailing) {
                                Color.clear
                                Text(verbatim: "A")
                                        .font(isSwitched ? .staticBody : .mini)
                                        .frame(width: partialWidth, height: height)
                                        .background(isSwitched ? colorScheme.inputKeyColor : Color.clear, in: .capsule)
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

        /// is ABC mode selected
        let isSwitched: Bool

        @Environment(\.colorScheme) private var colorScheme

        private let height: CGFloat = 26
        private let partialWidth: CGFloat = 36
        private let totalWidth: CGFloat = 64

        var body: some View {
                ZStack {
                        Color.clear
                        ZStack(alignment: .leading) {
                                Color.clear
                                ZStack {
                                        Capsule()
                                                .fill(isSwitched ? Color.clear : colorScheme.inputKeyColor)
                                                .shadow(color: isSwitched ? Color.clear : Color.shadowGray, radius: 0.5)
                                        Text(verbatim: Options.characterStandard.isSimplified ? "粤" : "粵")
                                                .font(isSwitched ? .mini : .staticBody)
                                }
                                .frame(width: partialWidth, height: height)
                        }
                        ZStack(alignment: .trailing) {
                                Color.clear
                                ZStack {
                                        Capsule()
                                                .fill(isSwitched ? colorScheme.inputKeyColor : Color.clear)
                                                .shadow(color: isSwitched ? Color.clear : Color.shadowGray, radius: 0.5)
                                        Text(verbatim: "A")
                                                .font(isSwitched ? .staticBody : .mini)
                                }
                                .frame(width: partialWidth, height: height)
                        }
                }
                .frame(width: totalWidth, height: height)
                .background(Material.thin, in: .capsule)
        }
}

private extension Font {
        static let mini: Font = Font.system(size: 14)
}
