import SwiftUI
import CoreIME

struct CantoneseABCSwitch: View {

        let isCantoneseSelected: Bool

        @Environment(\.colorScheme) private var colorScheme

        private let partWidth: CGFloat = 36
        private let partHeight: CGFloat = 26
        private let cornerRadius: CGFloat = 5

        private var cantoneseLabelText: String { Options.characterStandard.isSimplified ? "粤" : "粵" }

        var body: some View {
                let textBackColor: Color = {
                        switch colorScheme {
                        case .light:
                                return .light
                        case .dark:
                                return .dark
                        @unknown default:
                                return .light
                        }
                }()
                let backColor: Color = {
                        switch colorScheme {
                        case .light:
                                return .lightEmphatic
                        case .dark:
                                return .darkEmphatic
                        @unknown default:
                                return .lightEmphatic
                        }
                }()
                HStack(spacing: 0) {
                        Text(verbatim: cantoneseLabelText)
                                .font(isCantoneseSelected ? .body : .footnote)
                                .frame(width: partWidth, height: partHeight)
                                .background(isCantoneseSelected ? textBackColor : Color.clear, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                        Text(verbatim: "A")
                                .font(isCantoneseSelected ? .footnote : .body)
                                .frame(width: partWidth, height: partHeight)
                                .background(isCantoneseSelected ? Color.clear : textBackColor, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                }
                .background(backColor, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        }
}
