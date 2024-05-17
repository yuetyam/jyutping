import SwiftUI
import CommonExtensions

/// Candidate Romanization(Jyutping) Comment Label
struct CommentLabel: View {
        init(_ comment: String, toneStyle: ToneDisplayStyle, toneColor: Color, shouldModifyToneColor: Bool) {
                self.comment = comment
                self.toneStyle = toneStyle
                self.toneColor = toneColor
                self.shouldModifyToneColor = shouldModifyToneColor
        }
        private let comment: String
        private let toneStyle: ToneDisplayStyle
        private let toneColor: Color
        private let shouldModifyToneColor: Bool
        var body: some View {
                switch toneStyle {
                case .normal where shouldModifyToneColor:
                        ModifiedToneColorCommentView(comment: comment, toneColor: toneColor)
                case .normal:
                        Text(verbatim: comment).font(.comment)
                case .noTones:
                        Text(verbatim: comment.filter(\.isLowercaseBasicLatinLetter)).font(.comment)
                case .superscript:
                        ModifiedCommentView(alignment: .top, comment: comment, toneColor: toneColor)
                case .subscript:
                        ModifiedCommentView(alignment: .bottom, comment: comment, toneColor: toneColor)
                }
        }
}

private struct ModifiedToneColorCommentView: View {
        let comment: String
        let toneColor: Color
        var body: some View {
                let syllables = comment.split(separator: Character.space).map({ text -> Syllable in
                        let phone = text.filter(\.isLowercaseBasicLatinLetter)
                        let tone = text.filter(\.isCantoneseToneDigit)
                        return Syllable(phone: phone, tone: tone)
                })
                HStack(spacing: 0) {
                        ForEach(0..<syllables.count, id: \.self) { index in
                                let syllable = syllables[index]
                                let leadingText: String = (index == 0) ? syllable.phone : (String.space + syllable.phone)
                                Text(verbatim: leadingText)
                                Text(verbatim: syllable.tone).foregroundStyle(toneColor)
                        }
                }
                .font(.comment)
        }
}
private struct ModifiedCommentView: View {
        let alignment: VerticalAlignment
        let comment: String
        let toneColor: Color
        var body: some View {
                let syllables = comment.split(separator: Character.space).map({ text -> Syllable in
                        let phone = text.filter(\.isLowercaseBasicLatinLetter)
                        let tone = text.filter(\.isCantoneseToneDigit)
                        return Syllable(phone: phone, tone: tone)
                })
                HStack(alignment: alignment, spacing: 0) {
                        ForEach(0..<syllables.count, id: \.self) { index in
                                let syllable = syllables[index]
                                let leadingText: String = (index == 0) ? syllable.phone : (String.space + syllable.phone)
                                Text(verbatim: leadingText)
                                Text(verbatim: syllable.tone)
                                        .font(.commentTone)
                                        .foregroundStyle(toneColor)
                        }
                }
                .font(.comment)
        }
}
private struct Syllable {
        let phone: String
        let tone: String
}
