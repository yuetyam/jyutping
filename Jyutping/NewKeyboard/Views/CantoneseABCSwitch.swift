import SwiftUI
import CoreIME

struct CantoneseABCSwitch: View {

        let isCantoneseSelected: Bool

        @Environment(\.colorScheme) private var colorScheme

        private let partWidth: CGFloat = 36
        private let partHeight: CGFloat = 26
        private let cornerRadius: CGFloat = 5

        private var cantoneseLabelText: String {
                return (Options.characterStandard == .simplified) ? "粤" : "粵"
        }

        var body: some View {
                let textBackColor: Color = {
                        switch colorScheme {
                        case .light:
                                return .white
                        case .dark:
                                return .black
                        @unknown default:
                                return .white
                        }
                }()
                let backColor: Color = {
                        switch colorScheme {
                        case .light:
                                return .lightEmphatic
                        case .dark:
                                return .darkThick
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
