import SwiftUI
import CoreIME

struct HorizontalPageCandidateLabel: View {
        init(isHighlighted: Bool, index: Int, candidate: DisplayCandidate, commentStyle: CommentDisplayStyle, toneStyle: ToneDisplayStyle, toneColor: ToneDisplayColor) {
                let foreColor: Color = isHighlighted ? Color.white : Color.primary
                let shouldModifyToneColor: Bool = toneColor != .normal
                self.label = (index == 9) ? "0" : "\(index + 1)"
                self.labelForeColor = isHighlighted ? Color.white : Color.secondary
                self.candidate = candidate
                self.commentStyle = commentStyle
                self.toneStyle = toneStyle
                self.toneForeColor = shouldModifyToneColor ? foreColor.opacity(0.66) : foreColor
                self.shouldModifyToneColor = shouldModifyToneColor
        }
        private let label: String
        private let labelForeColor: Color
        private let candidate: DisplayCandidate
        private let commentStyle: CommentDisplayStyle
        private let toneStyle: ToneDisplayStyle
        private let toneForeColor: Color
        private let shouldModifyToneColor: Bool
        var body: some View {
                switch candidate.candidate.type {
                case .cantonese:
                        switch commentStyle {
                        case .top:
                                HStack(alignment: .lastTextBaseline, spacing: 8) {
                                        Text(verbatim: label).font(.label).foregroundStyle(labelForeColor)
                                        VStack(alignment: .leading, spacing: 2) {
                                                if let comment = candidate.comment {
                                                        CommentLabel(comment, candidateType: candidate.candidate.type, toneStyle: toneStyle, toneColor: toneForeColor, shouldModifyToneColor: shouldModifyToneColor)
                                                }
                                                Text(verbatim: candidate.text).font(.candidate).tracking(18)
                                        }
                                }
                        case .bottom:
                                HStack(alignment: .firstTextBaseline, spacing: 8) {
                                        Text(verbatim: label).font(.label).foregroundStyle(labelForeColor)
                                        VStack(alignment: .leading, spacing: 2) {
                                                Text(verbatim: candidate.text).font(.candidate).tracking(18)
                                                if let comment = candidate.comment {
                                                        CommentLabel(comment, candidateType: candidate.candidate.type, toneStyle: toneStyle, toneColor: toneForeColor, shouldModifyToneColor: shouldModifyToneColor)
                                                }
                                        }
                                }
                        case .right:
                                HStack(spacing: 8) {
                                        Text(verbatim: label).font(.label).foregroundStyle(labelForeColor)
                                        HStack(spacing: 4) {
                                                Text(verbatim: candidate.text).font(.candidate)
                                                if let comment = candidate.comment {
                                                        CommentLabel(comment, candidateType: candidate.candidate.type, toneStyle: toneStyle, toneColor: toneForeColor, shouldModifyToneColor: shouldModifyToneColor)
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
                        .padding(.top, commentStyle == .top ? 4 : 0)
                        .padding(.bottom, commentStyle == .bottom ? 4 : 0)
                case .emoji, .emojiSequence, .symbol, .symbolSequence:
                        HStack(spacing: 8) {
                                Text(verbatim: label).font(.label).foregroundStyle(labelForeColor)
                                HStack(spacing: 4) {
                                        Text(verbatim: candidate.text).font(.candidate)
                                        if let comment = candidate.comment {
                                                Text(verbatim: comment).font(.annotation)
                                        }
                                }
                        }
                        .padding(.top, commentStyle == .top ? 4 : 0)
                        .padding(.bottom, commentStyle == .bottom ? 4 : 0)
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
        }
}
