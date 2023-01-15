import SwiftUI

struct CandidateBoard: View {

        @EnvironmentObject private var displayObject: DisplayObject

        private let toneStyle: ToneDisplayStyle = AppSettings.toneDisplayStyle
        private let toneColor: ToneDisplayColor = AppSettings.toneDisplayColor
        private let lineSpacing: CGFloat = CGFloat(AppSettings.candidateLineSpacing) / 2.0

        var body: some View {
                let longest: DisplayCandidate = displayObject.longest
                VStack(alignment: .leading, spacing: 0) {
                        ForEach(0..<displayObject.items.count, id: \.self) { index in
                                let candidate = displayObject.items[index]
                                let isHighlighted: Bool = index == displayObject.highlightedIndex
                                let foreColor: Color = isHighlighted ? Color.white : Color.primary
                                let backColor: Color = isHighlighted ? Color.accentColor : Color.clear
                                ZStack(alignment: .leading) {
                                        HStack(spacing: 14) {
                                                SerialNumberLabel(7)
                                                Text(verbatim: longest.text).font(.candidate)
                                                if let comment = longest.comment {
                                                        CommentLabel(comment, toneStyle: toneStyle, toneColor: toneColor, foreColor: foreColor)
                                                }
                                                if let secondaryComment = longest.secondaryComment {
                                                        Text(verbatim: secondaryComment).font(.comment)
                                                }
                                        }
                                        .hidden()
                                        HStack(spacing: 14) {
                                                SerialNumberLabel(index)
                                                Text(verbatim: candidate.text).font(.candidate).animation(nil, value: displayObject.animationState)
                                                if let comment = candidate.comment {
                                                        CommentLabel(comment, toneStyle: toneStyle, toneColor: toneColor, foreColor: foreColor)
                                                }
                                                if let secondaryComment = candidate.secondaryComment {
                                                        Text(verbatim: secondaryComment).font(.comment)
                                                }
                                        }
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, lineSpacing)
                                .foregroundColor(foreColor)
                                .background(backColor, in: RoundedRectangle(cornerRadius: 4, style: .continuous))
                        }
                }
                .padding(8)
                .animation(.default, value: displayObject.animationState)
        }
}


struct SerialNumberLabel: View {
        init(_ index: Int) {
                self.number = (index == 9) ? 0 : (index + 1)
        }
        private let number: Int
        var body: some View {
                HStack(spacing: 0) {
                        Text(verbatim: "\(number)").font(.label)
                        Text(verbatim: ".").font(.labelDot)
                }
        }
}


private struct CommentLabel: View {

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
                                                .foregroundColor(shouldModifyColor ? foreColor.opacity(0.7) : foreColor)
                                }
                                Spacer()
                        }
                }
        }

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

