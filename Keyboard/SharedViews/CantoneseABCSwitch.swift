import SwiftUI
import CoreIME

/// Toggle InputMethodMode
@available(iOS, introduced: 15.0, deprecated: 26.0, message: "Use InputModeSwitch instead")
@available(iOSApplicationExtension, introduced: 15.0, deprecated: 26.0, message: "Use InputModeSwitch instead")
struct CantoneseABCSwitch: View {

        /// is ABC mode selected
        let isSwitched: Bool

        @Environment(\.colorScheme) private var colorScheme

        private let partialWidth: CGFloat = 36
        private let height: CGFloat = 26

        var body: some View {
                let selectedColor: Color = switch colorScheme {
                case .light: .lightInput
                case .dark: .darkInput
                @unknown default: .lightInput
                }
                let backColor: Color = switch colorScheme {
                case .light: .activeLightInput
                case .dark: .activeDarkInput
                @unknown default: .activeLightInput
                }
                HStack(spacing: 0) {
                        Text(verbatim: Options.characterStandard.isSimplified ? "粤" : "粵")
                                .font(isSwitched ? .footnote : .body)
                                .frame(width: partialWidth, height: height)
                                .background(isSwitched ? Color.clear : selectedColor, in: .capsule)
                        Text(verbatim: "A")
                                .font(isSwitched ? .body : .footnote)
                                .frame(width: partialWidth, height: height)
                                .background(isSwitched ? selectedColor : Color.clear, in: .capsule)
                }
                .background(backColor, in: .capsule)
        }
}

/// Toggle Cantonese/ABC InputMethodMode
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct InputModeSwitch: View {

        /// is ABC mode selected
        let isSwitched: Bool

        @Environment(\.colorScheme) private var colorScheme

        private let partialWidth: CGFloat = 36
        private let height: CGFloat = 26

        var body: some View {
                let selectedColor: Color = switch colorScheme {
                case .light: .lightInput
                case .dark: .darkInput
                @unknown default: .lightInput
                }
                HStack(spacing: 0) {
                        Text(verbatim: Options.characterStandard.isSimplified ? "粤" : "粵")
                                .font(isSwitched ? .footnote : .body)
                                .frame(width: partialWidth, height: height)
                                .background(isSwitched ? Color.clear : selectedColor, in: .capsule)
                                .shadow(color: isSwitched ? Color.clear : Color.shadowGray, radius: 0.5)
                        Text(verbatim: "A")
                                .font(isSwitched ? .body : .footnote)
                                .frame(width: partialWidth, height: height)
                                .background(isSwitched ? selectedColor : Color.clear, in: .capsule)
                                .shadow(color: isSwitched ? Color.shadowGray : Color.clear, radius: 0.5)
                }
                .background(Material.thin, in: .capsule)
        }
}
