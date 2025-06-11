import SwiftUI
import CoreIME

// TODO: Rename to InputModeSwitch

/// Toggle InputMethodMode
struct CantoneseABCSwitch: View {

        /// is ABC mode selected
        let isSwitched: Bool

        @Environment(\.colorScheme) private var colorScheme

        private let partWidth: CGFloat = 36
        private let height: CGFloat = 26

        var body: some View {
                let selectedColor: Color = switch colorScheme {
                case .light: .light
                case .dark: .dark
                @unknown default: .light
                }
                HStack(spacing: 0) {
                        Text(verbatim: Options.characterStandard.isSimplified ? "粤" : "粵")
                                .font(isSwitched ? .footnote : .body)
                                .frame(width: partWidth, height: height)
                                .background(isSwitched ? Color.clear : selectedColor, in: Capsule())
                                .shadow(color: isSwitched ? Color.clear : Color.shadowGray, radius: 0.5)
                        Text(verbatim: "A")
                                .font(isSwitched ? .body : .footnote)
                                .frame(width: partWidth, height: height)
                                .background(isSwitched ? selectedColor : Color.clear, in: Capsule())
                                .shadow(color: isSwitched ? Color.shadowGray : Color.clear, radius: 0.5)
                }
                .background(Material.thin, in: Capsule())
        }
}
