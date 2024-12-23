import SwiftUI
import CoreIME
import CommonExtensions

struct RomanizationLabel: View {

        init(candidate: Candidate, toneStyle: CommentToneStyle) {
                self.shouldDisplayRomanization = candidate.isCantonese
                self.romanization = candidate.romanization
                self.toneStyle = toneStyle
        }

        private let shouldDisplayRomanization: Bool
        private let romanization: String
        private let toneStyle: CommentToneStyle

        private func attributed() -> AttributedString {
                let offset: CGFloat = {
                        switch toneStyle {
                        case .normal:
                                return 0
                        case .superscript:
                                return 2
                        case .subscript:
                                return -2
                        case .noTones:
                                return 0
                        }
                }()
                let blocks = romanization.components(separatedBy: .decimalDigits).filter(\.isNotEmpty)
                let tones = romanization.tones.map({ String($0) })
                var stack: AttributedString = AttributedString()
                for (index, element) in blocks.enumerated() {
                        var phone = AttributedString(element)
                        let toneText: String = tones.fetch(index) ?? "?"
                        var tone = AttributedString(toneText)
                        phone.font = .romanization
                        tone.font = .tone
                        tone.baselineOffset = offset
                        stack += phone
                        stack += tone
                }
                return stack
        }

        var body: some View {
                switch toneStyle {
                case .normal:
                        Text(verbatim: shouldDisplayRomanization ? romanization : String.space)
                                .font(.romanization)
                                .minimumScaleFactor(0.2)
                                .lineLimit(1)
                case .superscript, .subscript:
                        if shouldDisplayRomanization {
                                Text(attributed())
                                        .minimumScaleFactor(0.2)
                                        .lineLimit(1)
                        } else {
                                Text(verbatim: String.space).font(.romanization)
                        }
                case .noTones:
                        Text(verbatim: shouldDisplayRomanization ? romanization.removedTones() : String.space)
                                .font(.romanization)
                                .minimumScaleFactor(0.2)
                                .lineLimit(1)
                }
        }
}
