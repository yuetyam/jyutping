import SwiftUI
import CoreIME
import CommonExtensions

struct HorizontalPageCandidateLabel: View {
        init(isHighlighted: Bool, index: Int, candidate: DisplayCandidate, commentStyle: CommentDisplayStyle, toneStyle: ToneDisplayStyle, toneColor: ToneDisplayColor) {
                self.label = (index == 9) ? "0" : "\(index + 1)"
                self.labelOpacity = isHighlighted ? 1 : 0.75
                self.candidate = candidate
                self.commentStyle = commentStyle
                self.toneStyle = toneStyle
                self.shouldModifyToneColor = toneColor != .normal
        }
        private let label: String
        private let labelOpacity: Double
        private let candidate: DisplayCandidate
        private let commentStyle: CommentDisplayStyle
        private let toneStyle: ToneDisplayStyle
        private let shouldModifyToneColor: Bool
        var body: some View {
                switch candidate.candidate.type {
                case .cantonese:
                        switch commentStyle {
                        case .top:
                                HStack(alignment: .lastTextBaseline, spacing: 2) {
                                        Text(verbatim: label).font(.label).opacity(labelOpacity)
                                        TopCommentStackView(text: candidate.text, romanization: candidate.comment!, toneStyle: toneStyle, shouldModifyToneColor: shouldModifyToneColor)
                                }
                        case .bottom:
                                HStack(alignment: .firstTextBaseline, spacing: 2) {
                                        Text(verbatim: label).font(.label).opacity(labelOpacity)
                                        BottomCommentStackView(text: candidate.text, romanization: candidate.comment!, toneStyle: toneStyle, shouldModifyToneColor: shouldModifyToneColor)
                                }
                        case .right:
                                HStack(spacing: 4) {
                                        Text(verbatim: label).font(.label).opacity(labelOpacity)
                                        Text(verbatim: candidate.text).font(.candidate)
                                        if let comment = candidate.comment {
                                                RightCommentLabel(comment: comment, toneStyle: toneStyle, shouldModifyToneColor: shouldModifyToneColor)
                                        }
                                }
                        case .noComments:
                                HStack(spacing: 4) {
                                        Text(verbatim: label).font(.label).opacity(labelOpacity)
                                        Text(verbatim: candidate.text).font(.candidate)
                                }
                        }
                case .text:
                        HStack(spacing: 4) {
                                Text(verbatim: label).font(.label).opacity(labelOpacity)
                                Text(verbatim: candidate.text).font(.candidate)
                        }
                        .padding(.top, commentStyle == .top ? 8 : 0)
                        .padding(.bottom, commentStyle == .bottom ? 8 : 0)
                case .emoji, .symbol:
                        HStack(spacing: 4) {
                                Text(verbatim: label).font(.label).opacity(labelOpacity)
                                Text(verbatim: candidate.text).font(.candidate)
                                if let comment = candidate.comment {
                                        Text(verbatim: comment).font(.annotation)
                                }
                        }
                        .padding(.top, commentStyle == .top ? 8 : 0)
                        .padding(.bottom, commentStyle == .bottom ? 8 : 0)
                case .compose:
                        HStack(spacing: 4) {
                                Text(verbatim: label).font(.label).opacity(labelOpacity)
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
