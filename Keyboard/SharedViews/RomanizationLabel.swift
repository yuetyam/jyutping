import SwiftUI
import CoreIME
import CommonExtensions

struct RomanizationLabel: View {

        var body: some View {
                Text(attributed(hasRomanization))
                        .minimumScaleFactor(0.2)
                        .lineLimit(1)
        }

        // TODO: Maybe use {romanization: String?} instead?
        init(candidate: Candidate, toneStyle: CommentToneStyle, compatibleMode: Bool) {
                self.hasRomanization = candidate.isCantonese
                self.romanization = candidate.romanization
                self.toneStyle = toneStyle
                self.compatibleMode = compatibleMode
        }

        private let hasRomanization: Bool
        private let romanization: String
        private let toneStyle: CommentToneStyle
        private let compatibleMode: Bool

        private func attributed(_ hasRomanization: Bool) -> AttributedString {
                guard hasRomanization else { return AttributedString.space }
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

// TODO: Maybe we should use a database or a dictionary to query it
private extension String {
        var compatibleTransformed: String {
                guard self != "jyu" else { return "yu" }
                guard !hasPrefix("jyu") else { return "yue" + dropFirst(3) }
                var modified: String = hasSuffix("oeng") ? (dropLast(4) + "eung") : self
                guard !hasPrefix("j") else { return "y" + modified.dropFirst() }
                modified = modified.replacingOccurrences(of: "^(.+)yu", with: "$1ue", options: .regularExpression)
                if modified.hasPrefix("z") {
                        return "zh" + modified.dropFirst()
                } else if modified.hasPrefix("c") {
                        return "ch" + modified.dropFirst()
                } else if modified.hasPrefix("s") {
                        return "sh" + modified.dropFirst()
                } else {
                        return modified
                }
        }
}

/*
private extension StringProtocol {
        var altTransformed: String {
                replacingOccurrences(of: "^jyu$", with: "yu", options: .regularExpression)
                .replacingOccurrences(of: "jyu", with: "yue", options: .anchored)
                .replacingOccurrences(of: "(.+)yu", with: "$1ue", options: .regularExpression)
                .replacingOccurrences(of: "j", with: "y", options: .anchored)
                .replacingOccurrences(of: "^(z|c|s)", with: "$1h", options: .regularExpression)
                .replacingOccurrences(of: "oeng", with: "eung", options: [.anchored, .backwards])
        }
}
*/
