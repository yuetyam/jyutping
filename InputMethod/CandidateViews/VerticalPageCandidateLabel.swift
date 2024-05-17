import SwiftUI
import CoreIME

struct VerticalPageCandidateLabel: View {
        init(isHighlighted: Bool, index: Int, candidate: DisplayCandidate, commentStyle: CommentDisplayStyle, toneStyle: ToneDisplayStyle, toneColor: ToneDisplayColor) {
                let foreColor: Color = isHighlighted ? Color.white : Color.primary
                let shouldModifyToneColor: Bool = toneColor != .normal
                self.label = (index == 9) ? "0" : "\(index + 1)"
                self.labelForeColor = isHighlighted ? Color.white : Color.secondary
                self.candidate = candidate
                self.commentStyle = commentStyle
                self.toneStyle = toneStyle
                self.toneColor = shouldModifyToneColor ? foreColor.opacity(0.66) : foreColor
                self.shouldModifyToneColor = shouldModifyToneColor
        }
        private let label: String
        private let labelForeColor: Color
        private let candidate: DisplayCandidate
        private let commentStyle: CommentDisplayStyle
        private let toneStyle: ToneDisplayStyle
        private let toneColor: Color
        private let shouldModifyToneColor: Bool
        var body: some View {
                HStack(spacing: 0) {
                        switch candidate.candidate.type {
                        case .cantonese:
                                switch commentStyle {
                                case .top:
                                        HStack(alignment: .lastTextBaseline, spacing: 12) {
                                                Text(verbatim: label).font(.label).foregroundStyle(labelForeColor)
                                                VStack(alignment: .leading, spacing: 2) {
                                                        if let comment = candidate.comment {
                                                                CommentLabel(comment, toneStyle: toneStyle, toneColor: toneColor, shouldModifyToneColor: shouldModifyToneColor)
                                                        }
                                                        Text(verbatim: candidate.text).font(.candidate).tracking(18)
                                                }
                                        }
                                case .bottom:
                                        HStack(alignment: .firstTextBaseline, spacing: 12) {
                                                Text(verbatim: label).font(.label).foregroundStyle(labelForeColor)
                                                VStack(alignment: .leading, spacing: 2) {
                                                        Text(verbatim: candidate.text).font(.candidate).tracking(18)
                                                        if let comment = candidate.comment {
                                                                CommentLabel(comment, toneStyle: toneStyle, toneColor: toneColor, shouldModifyToneColor: shouldModifyToneColor)
                                                        }
                                                }
                                        }
                                case .right:
                                        HStack(spacing: 12) {
                                                Text(verbatim: label).font(.label).foregroundStyle(labelForeColor)
                                                Text(verbatim: candidate.text).font(.candidate)
                                                if let comment = candidate.comment {
                                                        CommentLabel(comment, toneStyle: toneStyle, toneColor: toneColor, shouldModifyToneColor: shouldModifyToneColor)
                                                }
                                        }
                                case .noComments:
                                        HStack(spacing: 12) {
                                                Text(verbatim: label).font(.label).foregroundStyle(labelForeColor)
                                                Text(verbatim: candidate.text).font(.candidate)
                                        }
                                }
                        case .text:
                                HStack(spacing: 12) {
                                        Text(verbatim: label).font(.label).foregroundStyle(labelForeColor)
                                        Text(verbatim: candidate.text).font(.candidate)
                                }
                                .padding(.vertical, commentStyle.isVertical ? 4 : 0)
                        case .emoji, .emojiSequence, .symbol, .symbolSequence:
                                HStack(spacing: 12) {
                                        Text(verbatim: label).font(.label).foregroundStyle(labelForeColor)
                                        HStack(spacing: commentStyle.isVertical ? 2 : 12) {
                                                Text(verbatim: candidate.text).font(.candidate)
                                                if let comment = candidate.comment {
                                                        Text(verbatim: comment).font(.annotation)
                                                }
                                        }
                                }
                                .padding(.vertical, commentStyle.isVertical ? 4 : 0)
                        case .compose:
                                HStack(spacing: 12) {
                                        Text(verbatim: label).font(.label).foregroundStyle(labelForeColor)
                                        Text(verbatim: candidate.text).font(.candidate)
                                        if let comment = candidate.comment {
                                                Text(verbatim: comment).font(.annotation)
                                        }
                                        if let secondaryComment = candidate.secondaryComment {
                                                Text(verbatim: secondaryComment).font(.annotation)
                                        }
                                }
                        }
                        Spacer()
                        Color.clear.frame(width: 1, height: 1)
                }
        }
}
