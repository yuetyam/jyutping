import SwiftUI

private struct Syllable {
        let phone: String
        let tone: String
}

private struct ModifiedCommentView: View {
        let alignment: VerticalAlignment
        let syllables: [Syllable]
        let foreColor: Color
        let shouldModifyColor: Bool
        let shouldApplyToneFont: Bool
        var body: some View {
                HStack(alignment: alignment, spacing: 0) {
                        ForEach(0..<syllables.count, id: \.self) { index in
                                let syllable = syllables[index]
                                let leadingText: String = (index == 0) ? syllable.phone : " \(syllable.phone)"
                                Text(verbatim: leadingText).font(.comment)
                                Text(verbatim: syllable.tone)
                                        .font(shouldApplyToneFont ? .commentTone : .comment)
                                        .foregroundColor(shouldModifyColor ? foreColor.opacity(0.67) : foreColor)
                        }
                        Spacer()
                }
        }
}

struct CommentLabel: View {

        init(_ comment: String, toneStyle: ToneDisplayStyle, toneColor: ToneDisplayColor, foreColor: Color) {
                self.comment = comment
                self.toneStyle = toneStyle
                self.toneColor = toneColor
                self.foreColor = foreColor
                self.syllables = {
                        let originalSyllables = comment.split(separator: " ")
                        let items: [Syllable] = originalSyllables.map { originalSyllableText -> Syllable in
                                let phone: String = String(originalSyllableText.dropLast())
                                let tone: String = String(originalSyllableText.last ?? "0")
                                return Syllable(phone: phone, tone: tone)
                        }
                        return items
                }()
                self.isLastTone = comment.last?.isTone ?? false
                self.shouldModifyColor = toneColor != .normal
        }

        private let comment: String
        private let toneStyle: ToneDisplayStyle
        private let toneColor: ToneDisplayColor
        private let foreColor: Color

        private let syllables: [Syllable]
        private let isLastTone: Bool
        private let shouldModifyColor: Bool

        var body: some View {
                switch toneStyle {
                case .normal:
                        if isLastTone && shouldModifyColor {
                                ModifiedCommentView(alignment: .center, syllables: syllables, foreColor: foreColor, shouldModifyColor: shouldModifyColor, shouldApplyToneFont: false)
                        } else {
                                Text(verbatim: comment).font(.comment)
                        }
                case .noTones:
                        Text(verbatim: comment.filter({ !($0.isTone) })).font(.comment)
                case .superscript:
                        if isLastTone {
                                ModifiedCommentView(alignment: .top, syllables: syllables, foreColor: foreColor, shouldModifyColor: shouldModifyColor, shouldApplyToneFont: true)
                        } else {
                                Text(verbatim: comment).font(.comment)
                        }
                case .subscript:
                        if isLastTone {
                                ModifiedCommentView(alignment: .bottom, syllables: syllables, foreColor: foreColor, shouldModifyColor: shouldModifyColor, shouldApplyToneFont: true)
                        } else {
                                Text(verbatim: comment).font(.comment)
                        }
                }
        }
}
