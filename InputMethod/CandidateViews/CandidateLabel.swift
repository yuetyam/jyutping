import SwiftUI
import CoreIME

struct CandidateLabel: View {

        init(candidate: DisplayCandidate, index: Int, highlightedIndex: Int, commentStyle: CommentDisplayStyle, toneStyle: ToneDisplayStyle, toneColor: ToneDisplayColor, lineSpacing: CGFloat) {
                let isHighlighted: Bool = index == highlightedIndex
                let foreColor: Color = isHighlighted ? Color.white : Color.primary
                let shouldModifyToneColor: Bool = toneColor != .normal
                self.candidate = candidate
                self.label = (index == 9) ? "0" : "\(index + 1)"
                self.isHighlighted = isHighlighted
                self.commentStyle = commentStyle
                self.toneStyle = toneStyle
                self.toneColor = shouldModifyToneColor ? foreColor.opacity(0.66) : foreColor
                self.shouldModifyToneColor = shouldModifyToneColor
                self.lineSpacing = lineSpacing
                self.labelForeColor = isHighlighted ? Color.white : Color.secondary
                self.foreColor = foreColor
                self.backColor = isHighlighted ? Color.accentColor : Color.clear
        }

        private let candidate: DisplayCandidate
        private let label: String
        private let isHighlighted: Bool
        private let commentStyle: CommentDisplayStyle
        private let toneStyle: ToneDisplayStyle
        private let toneColor: Color
        private let shouldModifyToneColor: Bool
        private let lineSpacing: CGFloat
        private let labelForeColor: Color
        private let foreColor: Color
        private let backColor: Color

        var body: some View {
                HStack(spacing: 0) {
                        switch candidate.candidate.type {
                        case .cantonese:
                                switch commentStyle {
                                case .right:
                                        HStack(spacing: 16) {
                                                Text(verbatim: label).font(.label).foregroundStyle(labelForeColor)
                                                Text(verbatim: candidate.text).font(.candidate)
                                                if let comment = candidate.comment {
                                                        CommentLabel(comment, candidateType: candidate.candidate.type, toneStyle: toneStyle, toneColor: toneColor, shouldModifyToneColor: shouldModifyToneColor)
                                                }
                                        }
                                case .top:
                                        HStack(alignment: .lastTextBaseline, spacing: 16) {
                                                Text(verbatim: label).font(.label).foregroundStyle(labelForeColor)
                                                VStack(alignment: .leading, spacing: 2) {
                                                        if let comment = candidate.comment {
                                                                CommentLabel(comment, candidateType: candidate.candidate.type, toneStyle: toneStyle, toneColor: toneColor, shouldModifyToneColor: shouldModifyToneColor)
                                                        }
                                                        Text(verbatim: candidate.text).font(.candidate).tracking(16)
                                                }
                                        }
                                case .bottom:
                                        HStack(alignment: .firstTextBaseline, spacing: 16) {
                                                Text(verbatim: label).font(.label).foregroundStyle(labelForeColor)
                                                VStack(alignment: .leading, spacing: 2) {
                                                        Text(verbatim: candidate.text).font(.candidate).tracking(16)
                                                        if let comment = candidate.comment {
                                                                CommentLabel(comment, candidateType: candidate.candidate.type, toneStyle: toneStyle, toneColor: toneColor, shouldModifyToneColor: shouldModifyToneColor)
                                                        }
                                                }
                                        }
                                case .noComments:
                                        HStack(spacing: 16) {
                                                Text(verbatim: label).font(.label).foregroundStyle(labelForeColor)
                                                Text(verbatim: candidate.text).font(.candidate)
                                        }
                                }
                        case .text:
                                HStack(spacing: 16) {
                                        Text(verbatim: label).font(.label).foregroundStyle(labelForeColor)
                                        Text(verbatim: candidate.text).font(.candidate)
                                }
                                .padding(.vertical, commentStyle.isVertical ? 4 : 0)
                        case .emoji, .emojiSequence, .symbol, .symbolSequence:
                                HStack(spacing: 16) {
                                        Text(verbatim: label).font(.label).foregroundStyle(labelForeColor)
                                        HStack(spacing: commentStyle.isVertical ? 4 : 16) {
                                                Text(verbatim: candidate.text).font(.candidate)
                                                if let comment = candidate.comment {
                                                        Text(verbatim: comment).font(.annotation)
                                                }
                                        }
                                }
                                .padding(.vertical, commentStyle.isVertical ? 4 : 0)
                        case .compose:
                                HStack(spacing: 16) {
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
                .padding(.horizontal, 8)
                .padding(.vertical, lineSpacing / 2.0)
                .foregroundStyle(foreColor)
                .background(backColor, in: RoundedRectangle(cornerRadius: 5, style: .continuous))
        }
}

/// Candidate Page Horizontal Orientation
struct AltCandidateLabel: View {

        init(candidate: DisplayCandidate, index: Int, highlightedIndex: Int, commentStyle: CommentDisplayStyle, toneStyle: ToneDisplayStyle, toneColor: ToneDisplayColor, lineSpacing: CGFloat) {
                let isHighlighted: Bool = index == highlightedIndex
                let foreColor: Color = isHighlighted ? Color.white : Color.primary
                let shouldModifyToneColor: Bool = toneColor != .normal
                self.candidate = candidate
                self.label = (index == 9) ? "0" : "\(index + 1)"
                self.isHighlighted = isHighlighted
                self.commentStyle = commentStyle
                self.toneStyle = toneStyle
                self.toneColor = shouldModifyToneColor ? foreColor.opacity(0.66) : foreColor
                self.shouldModifyToneColor = shouldModifyToneColor
                self.lineSpacing = lineSpacing
                self.labelForeColor = isHighlighted ? Color.white : Color.secondary
                self.foreColor = foreColor
                self.backColor = isHighlighted ? Color.accentColor : Color.clear
        }

        private let candidate: DisplayCandidate
        private let label: String
        private let isHighlighted: Bool
        private let commentStyle: CommentDisplayStyle
        private let toneStyle: ToneDisplayStyle
        private let toneColor: Color
        private let shouldModifyToneColor: Bool
        private let lineSpacing: CGFloat
        private let labelForeColor: Color
        private let foreColor: Color
        private let backColor: Color

        var body: some View {
                HStack(spacing: 0) {
                        switch candidate.candidate.type {
                        case .cantonese:
                                switch commentStyle {
                                case .right:
                                        HStack(spacing: 8) {
                                                Text(verbatim: label).font(.label).foregroundStyle(labelForeColor)
                                                Text(verbatim: candidate.text).font(.candidate)
                                                if let comment = candidate.comment {
                                                        CommentLabel(comment, candidateType: candidate.candidate.type, toneStyle: toneStyle, toneColor: toneColor, shouldModifyToneColor: shouldModifyToneColor)
                                                }
                                        }
                                case .top:
                                        HStack(alignment: .lastTextBaseline, spacing: 8) {
                                                Text(verbatim: label).font(.label).foregroundStyle(labelForeColor)
                                                VStack(alignment: .leading, spacing: 2) {
                                                        if let comment = candidate.comment {
                                                                CommentLabel(comment, candidateType: candidate.candidate.type, toneStyle: toneStyle, toneColor: toneColor, shouldModifyToneColor: shouldModifyToneColor)
                                                        }
                                                        Text(verbatim: candidate.text).font(.candidate).tracking(16)
                                                }
                                        }
                                case .bottom:
                                        HStack(alignment: .firstTextBaseline, spacing: 8) {
                                                Text(verbatim: label).font(.label).foregroundStyle(labelForeColor)
                                                VStack(alignment: .leading, spacing: 2) {
                                                        Text(verbatim: candidate.text).font(.candidate).tracking(16)
                                                        if let comment = candidate.comment {
                                                                CommentLabel(comment, candidateType: candidate.candidate.type, toneStyle: toneStyle, toneColor: toneColor, shouldModifyToneColor: shouldModifyToneColor)
                                                        }
                                                }
                                        }
                                case .noComments:
                                        HStack(spacing: 8) {
                                                Text(verbatim: label).font(.label).foregroundStyle(labelForeColor)
                                                Text(verbatim: candidate.text).font(.candidate)
                                        }
                                }
                        case .text:
                                HStack(spacing: 8) {
                                        Text(verbatim: label).font(.label).foregroundStyle(labelForeColor)
                                        Text(verbatim: candidate.text).font(.candidate)
                                }
                        case .emoji, .emojiSequence, .symbol, .symbolSequence:
                                HStack(spacing: 8) {
                                        Text(verbatim: label).font(.label).foregroundStyle(labelForeColor)
                                        Text(verbatim: candidate.text).font(.candidate)
                                        if let comment = candidate.comment {
                                                Text(verbatim: comment).font(.annotation)
                                        }
                                }
                                .padding(.vertical, commentStyle.isVertical ? 4 : 0)
                        case .compose:
                                HStack(spacing: 8) {
                                        Text(verbatim: label).font(.label).foregroundStyle(labelForeColor)
                                        HStack(spacing: 4) {
                                                Text(verbatim: candidate.text).font(.candidate)
                                                if let comment = candidate.comment {
                                                        Text(verbatim: comment).font(.annotation).opacity(0.8)
                                                }
                                                if let secondaryComment = candidate.secondaryComment {
                                                        Text(verbatim: secondaryComment).font(.annotation).opacity(0.8)
                                                }
                                        }
                                }
                        }
                        Spacer()
                        Color.clear.frame(width: 1, height: 1)
                }
                .padding(.vertical, 4)
                .padding(.horizontal, lineSpacing / 2.0)
                .foregroundStyle(foreColor)
                .background(backColor, in: RoundedRectangle(cornerRadius: 5, style: .continuous))
        }
}
