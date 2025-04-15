import SwiftUI
import CommonExtensions

struct RightStackRomanizationLabel: View {
        let romanization: String
        let toneStyle: ToneDisplayStyle
        let shallowTone: Bool
        let compatibleMode: Bool
        var body: some View {
                let syllables = romanization.split(separator: Character.space)
                let phones = syllables.map({ $0.filter(\.isLowercaseBasicLatinLetter) })
                let tones = syllables.map({ $0.filter(\.isCantoneseToneDigit) })
                HStack(alignment: toneStyle.commentAlignment, spacing: 0) {
                        ForEach(phones.indices, id: \.self) { index in
                                let phone: String = compatibleMode ? phones[index].compatibleTransformed : phones[index]
                                let leadingText: String = (index == 0) ? phone : (String.space + phone)
                                let toneText: String = (toneStyle == .noTones) ? String.empty : (tones.fetch(index) ?? String.empty)
                                Text(verbatim: leadingText)
                                Text(verbatim: toneText)
                                        .scaleEffect(toneStyle.toneScale, anchor: toneStyle.scaleAnchor)
                                        .opacity(shallowTone ? 0.66 : 1)
                        }
                }
                .font(.romanization)
        }
}

struct RomanizationLabel: View {
        let syllable: String
        let toneStyle: ToneDisplayStyle
        let shallowTone: Bool
        let compatibleMode: Bool
        var body: some View {
                let phone: String = syllable.filter(\.isLowercaseBasicLatinLetter)
                let phoneText: String = compatibleMode ? phone.compatibleTransformed : phone
                let toneText: String = (toneStyle == .noTones) ? String.empty : syllable.filter(\.isCantoneseToneDigit)
                HStack(alignment: toneStyle.commentAlignment, spacing: 0) {
                        Text(verbatim: phoneText)
                                .layoutPriority(1)
                        Text(verbatim: toneText)
                                .scaleEffect(toneStyle.toneScale, anchor: toneStyle.scaleAnchor)
                                .opacity(shallowTone ? 0.66 : 1)
                                .layoutPriority(1)
                }
                .font(.romanization)
                .minimumScaleFactor(0.4)
                .lineLimit(1)
        }
}

private extension ToneDisplayStyle {
        var commentAlignment: VerticalAlignment {
                switch self {
                case .normal: .center
                case .noTones: .center
                case .superscript: .top
                case .subscript: .bottom
                }
        }
        var toneScale: CGFloat {
                switch self {
                case .normal: 0.85
                case .noTones: 0.85
                case .superscript: 0.8
                case .subscript: 0.8
                }
        }
        var scaleAnchor: UnitPoint {
                switch self {
                case .normal: .leading
                case .noTones: .leading
                case .superscript: .topLeading
                case .subscript: .bottomLeading
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
