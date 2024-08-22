import SwiftUI
import CommonExtensions

/// Candidate Romanization(Jyutping) Comment Label
struct RightCommentLabel: View {
        init(comment: String, toneStyle: ToneDisplayStyle, shouldModifyToneColor: Bool) {
                self.comment = comment
                self.toneStyle = toneStyle
                self.shouldModifyToneColor = shouldModifyToneColor
        }
        private let comment: String
        private let toneStyle: ToneDisplayStyle
        private let shouldModifyToneColor: Bool
        var body: some View {
                switch toneStyle {
                case .normal where shouldModifyToneColor:
                        ModifiedToneColorCommentView(comment: comment)
                case .normal:
                        Text(verbatim: comment).font(.comment)
                case .noTones:
                        Text(verbatim: comment.filter(\.isLowercaseBasicLatinLetter)).font(.comment)
                case .superscript:
                        ModifiedCommentView(alignment: .firstTextBaseline, comment: comment, shouldModifyToneColor: shouldModifyToneColor)
                case .subscript:
                        ModifiedCommentView(alignment: .lastTextBaseline, comment: comment, shouldModifyToneColor: shouldModifyToneColor)
                }
        }
}

private struct ModifiedToneColorCommentView: View {
        let comment: String
        var body: some View {
                let syllables = comment.split(separator: Character.space).map({ text -> Syllable in
                        let phone = text.filter(\.isLowercaseBasicLatinLetter)
                        let tone = text.filter(\.isCantoneseToneDigit)
                        return Syllable(phone: phone, tone: tone)
                })
                HStack(spacing: 0) {
                        ForEach(syllables.indices, id: \.self) { index in
                                let syllable = syllables[index]
                                let leadingText: String = (index == 0) ? syllable.phone : (String.space + syllable.phone)
                                Text(verbatim: leadingText)
                                Text(verbatim: syllable.tone).opacity(0.66)
                        }
                }
                .font(.comment)
        }
}
private struct ModifiedCommentView: View {
        let alignment: VerticalAlignment
        let comment: String
        let shouldModifyToneColor: Bool
        var body: some View {
                let syllables = comment.split(separator: Character.space).map({ text -> Syllable in
                        let phone = text.filter(\.isLowercaseBasicLatinLetter)
                        let tone = text.filter(\.isCantoneseToneDigit)
                        return Syllable(phone: phone, tone: tone)
                })
                HStack(alignment: alignment, spacing: 0) {
                        ForEach(syllables.indices, id: \.self) { index in
                                let syllable = syllables[index]
                                let leadingText: String = (index == 0) ? syllable.phone : (String.space + syllable.phone)
                                Text(verbatim: leadingText)
                                Text(verbatim: syllable.tone).font(.commentTone).opacity(shouldModifyToneColor ? 0.66 : 1)
                        }
                }
                .font(.comment)
        }
}
private struct Syllable {
        let phone: String
        let tone: String
}
