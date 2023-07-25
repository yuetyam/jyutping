import SwiftUI
import CoreIME
import CommonExtensions

struct RomanizationLabel: View {

        private struct Syllable {
                let phone: String
                let tone: String
        }

        private let shouldDisplayRomanization: Bool
        private let toneStyle: CommentToneStyle
        private let romanization: String
        private let syllables: [Syllable]

        init(candidate: Candidate, toneStyle: CommentToneStyle) {
                self.shouldDisplayRomanization = candidate.isCantonese
                self.toneStyle = toneStyle
                self.romanization = candidate.romanization
                self.syllables = {
                        let blocks = candidate.romanization.split(separator: Character.space)
                        let items: [Syllable] = blocks.map({ syllable -> Syllable in
                                let phone: String = syllable.filter({ !$0.isCantoneseToneDigit })
                                let tone: String = syllable.filter(\.isCased)
                                return Syllable(phone: phone, tone: tone)
                        })
                        return items
                }()
        }

        var body: some View {
                switch toneStyle {
                case .normal:
                        Text(verbatim: shouldDisplayRomanization ? romanization : String.space)
                                .minimumScaleFactor(0.2)
                                .lineLimit(1)
                                .font(.romanization)
                case .superscript:
                        if shouldDisplayRomanization {
                                HStack(alignment: .top, spacing: 0) {
                                        ForEach(0..<syllables.count, id: \.self) { index in
                                                let syllable = syllables[index]
                                                let leadingText: String = (index == 0) ? syllable.phone : (String.space + syllable.phone)
                                                Text(verbatim: leadingText)
                                                        .minimumScaleFactor(0.2)
                                                        .lineLimit(1)
                                                        .font(.romanization)
                                                Text(verbatim: syllable.tone).font(.tone)
                                        }
                                }
                        } else {
                                Text(verbatim: String.space).font(.romanization)
                        }
                case .subscript:
                        if shouldDisplayRomanization {
                                HStack(alignment: .bottom, spacing: 0) {
                                        ForEach(0..<syllables.count, id: \.self) { index in
                                                let syllable = syllables[index]
                                                let leadingText: String = (index == 0) ? syllable.phone : (String.space + syllable.phone)
                                                Text(verbatim: leadingText)
                                                        .minimumScaleFactor(0.2)
                                                        .lineLimit(1)
                                                        .font(.romanization)
                                                Text(verbatim: syllable.tone).font(.tone)
                                        }
                                }
                        } else {
                                Text(verbatim: String.space).font(.romanization)
                        }
                case .noTones:
                        Text(verbatim: shouldDisplayRomanization ? romanization.removedTones() : String.space)
                                .minimumScaleFactor(0.2)
                                .lineLimit(1)
                                .font(.romanization)
                }
        }
}
