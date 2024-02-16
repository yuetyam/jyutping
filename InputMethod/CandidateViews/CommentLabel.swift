import SwiftUI
import CoreIME
import CommonExtensions

struct CommentLabel: View {

        init(_ comment: String, candidateType: CandidateType, toneStyle: ToneDisplayStyle, toneColor: Color, shouldModifyToneColor: Bool) {
                self.comment = comment
                self.candidateType = candidateType
                self.toneStyle = toneStyle
                self.toneColor = toneColor
                self.shouldModifyToneColor = shouldModifyToneColor
        }

        private let comment: String
        private let candidateType: CandidateType
        private let toneStyle: ToneDisplayStyle
        private let toneColor: Color
        private let shouldModifyToneColor: Bool

        var body: some View {
                switch candidateType {
                case .cantonese:
                        switch toneStyle {
                        case .normal:
                                if shouldModifyToneColor {
                                        ModifiedCommentView(alignment: .center, comment: comment, toneColor: toneColor, shouldApplyToneFont: false)
                                } else {
                                        Text(verbatim: comment).font(.comment)
                                }
                        case .noTones:
                                Text(verbatim: comment.filter(\.isLowercaseBasicLatinLetter)).font(.comment)
                        case .superscript:
                                ModifiedCommentView(alignment: .top, comment: comment, toneColor: toneColor, shouldApplyToneFont: true)
                        case .subscript:
                                ModifiedCommentView(alignment: .bottom, comment: comment, toneColor: toneColor, shouldApplyToneFont: true)
                        }
                case .specialMark:
                        Text(verbatim: comment).font(.comment)
                case .emoji:
                        Text(verbatim: comment).font(.annotation)
                case .symbol:
                        Text(verbatim: comment).font(.annotation)
                case .compose:
                        Text(verbatim: comment).font(.comment)
                }
        }
}

private struct Syllable {
        let phone: String
        let tone: String
}

private struct ModifiedCommentView: View {
        let alignment: VerticalAlignment
        let comment: String
        let toneColor: Color
        let shouldApplyToneFont: Bool
        var body: some View {
                let syllables = comment.split(separator: " ").map({ text -> Syllable in
                        let phone = text.filter(\.isLowercaseBasicLatinLetter)
                        let tone = text.filter(\.isCantoneseToneDigit)
                        return Syllable(phone: phone, tone: tone)
                })
                HStack(alignment: alignment, spacing: 0) {
                        ForEach(0..<syllables.count, id: \.self) { index in
                                let syllable = syllables[index]
                                let leadingText: String = (index == 0) ? syllable.phone : (String.space + syllable.phone)
                                Text(verbatim: leadingText).font(.comment)
                                Text(verbatim: syllable.tone)
                                        .font(shouldApplyToneFont ? .commentTone : .comment)
                                        .foregroundStyle(toneColor)
                        }
                }
        }
}
