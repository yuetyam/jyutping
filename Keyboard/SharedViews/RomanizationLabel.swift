import SwiftUI
import CoreIME
import CommonExtensions

struct RomanizationLabel: View {

        var body: some View {
                Text(attributed())
                        .minimumScaleFactor(0.2)
                        .lineLimit(1)
        }

        init(romanization: String?, toneStyle: CommentToneStyle, compatibleMode: Bool) {
                self.romanization = romanization
                self.toneStyle = toneStyle
                self.compatibleMode = compatibleMode
        }

        private let romanization: String?
        private let toneStyle: CommentToneStyle
        private let compatibleMode: Bool

        private func attributed() -> AttributedString {
                guard let romanization else { return AttributedString.space }
                let syllables = romanization.split(separator: Character.space)
                let phones = syllables.map({ $0.filter(\.isLowercaseBasicLatinLetter) })
                let tones = syllables.map({ $0.filter(\.isCantoneseToneDigit) })
                let toneOffset = toneStyle.toneOffset
                var stack: AttributedString = AttributedString()
                for (index, element) in phones.enumerated() {
                        if index != 0 {
                                stack += AttributedString.space
                        }
                        var phone = AttributedString(compatibleMode ? element.compatibleTransformed : element)
                        phone.font = .romanization
                        stack += phone
                        if (toneStyle != .noTones), let toneText = tones.fetch(index) {
                                var tone = AttributedString(toneText)
                                tone.font = .tone
                                tone.baselineOffset = toneOffset
                                stack += tone
                        }
                }
                return stack
        }
}

private extension AttributedString {
        static let space: AttributedString = AttributedString(String.space)
}

private extension CommentToneStyle {
        var toneOffset: CGFloat {
                switch self {
                case .normal: 0
                case .superscript: 2
                case .subscript: -2
                case .noTones: 0
                }
        }
}
