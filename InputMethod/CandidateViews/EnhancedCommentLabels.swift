import SwiftUI
import CommonExtensions

struct ModifiedToneColorCommentLabel: View {
        let syllable: String
        var body: some View {
                let phone = syllable.filter(\.isLowercaseBasicLatinLetter)
                let tone = syllable.filter(\.isCantoneseToneDigit)
                HStack(spacing: 0) {
                        Text(verbatim: phone)
                        Text(verbatim: tone).opacity(0.66)
                }
                .font(.comment)
                .lineLimit(1)
                .minimumScaleFactor(0.4)
        }
}

struct SuperscriptCommentLabel: View {
        let syllable: String
        let shouldModifyToneColor: Bool
        var body: some View {
                let phone = syllable.filter(\.isLowercaseBasicLatinLetter)
                let tone = syllable.filter(\.isCantoneseToneDigit)
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                        Text(verbatim: phone).font(.comment)
                        Text(verbatim: tone).font(.commentTone).opacity(shouldModifyToneColor ? 0.66 : 1)
                }
                .lineLimit(1)
                .minimumScaleFactor(0.4)
        }
}

struct SubscriptCommentLabel: View {
        let syllable: String
        let shouldModifyToneColor: Bool
        var body: some View {
                let phone = syllable.filter(\.isLowercaseBasicLatinLetter)
                let tone = syllable.filter(\.isCantoneseToneDigit)
                HStack(alignment: .lastTextBaseline, spacing: 0) {
                        Text(verbatim: phone).font(.comment)
                        Text(verbatim: tone).font(.commentTone).opacity(shouldModifyToneColor ? 0.66 : 1)
                }
                .lineLimit(1)
                .minimumScaleFactor(0.4)
        }
}
