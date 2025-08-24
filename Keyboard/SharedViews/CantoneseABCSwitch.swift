import SwiftUI
import CoreIME

/// Toggle InputMethodMode
@available(iOS, introduced: 15.0, deprecated: 26.0, message: "Use InputModeSwitch instead")
@available(iOSApplicationExtension, introduced: 15.0, deprecated: 26.0, message: "Use InputModeSwitch instead")
struct CantoneseABCSwitch: View {

        /// is ABC mode selected
        let isSwitched: Bool

        @Environment(\.colorScheme) private var colorScheme

        private let partialWidth: CGFloat = 34
        private let height: CGFloat = 26

        var body: some View {
                HStack(spacing: 0) {
                        Text(verbatim: Options.characterStandard.isSimplified ? "粤" : "粵")
                                .font(isSwitched ? .footnote : .body)
                                .frame(width: partialWidth, height: height)
                                .background(isSwitched ? Color.clear : colorScheme.inputKeyColor, in: .capsule)
                        Text(verbatim: "A")
                                .font(isSwitched ? .body : .footnote)
                                .frame(width: partialWidth, height: height)
                                .background(isSwitched ? colorScheme.inputKeyColor : Color.clear, in: .capsule)
                }
                .frame(width: partialWidth * 2, height: height)
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

        private let partialWidth: CGFloat = 34
        private let height: CGFloat = 26

        var body: some View {
                HStack(spacing: 0) {
                        ZStack {
                                Capsule()
                                        .fill(isSwitched ? Color.clear : colorScheme.inputKeyColor)
                                        .shadow(color: isSwitched ? Color.clear : Color.shadowGray, radius: 0.5)
                                Text(verbatim: Options.characterStandard.isSimplified ? "粤" : "粵")
                                        .font(isSwitched ? .footnote : .body)
                        }
                        .frame(width: partialWidth, height: height)
                        ZStack {
                                Capsule()
                                        .fill(isSwitched ? colorScheme.inputKeyColor : Color.clear)
                                        .shadow(color: isSwitched ? Color.shadowGray : Color.clear, radius: 0.5)
                                Text(verbatim: "A")
                                        .font(isSwitched ? .body : .footnote)
                        }
                        .frame(width: partialWidth, height: height)
                }
                .frame(width: partialWidth * 2, height: height)
                .background(Material.thin, in: .capsule)
        }
}
