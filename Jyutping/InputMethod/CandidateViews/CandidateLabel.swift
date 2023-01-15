import SwiftUI

struct CandidateLabel: View {

        let candidate: DisplayCandidate
        let placeholder: DisplayCandidate
        let index: Int
        let isHighlighted: Bool
        let toneStyle: ToneDisplayStyle
        let toneColor: ToneDisplayColor
        let lineSpacing: CGFloat
        let foreColor: Color
        let backColor: Color

        var body: some View {
                ZStack(alignment: .leading) {
                        HStack(spacing: 14) {
                                SerialNumberLabel(index)
                                Text(verbatim: placeholder.text).font(.candidate)
                                if let comment = placeholder.comment {
                                        CommentLabel(comment, toneStyle: toneStyle, toneColor: toneColor, foreColor: foreColor)
                                }
                                if let secondaryComment = placeholder.secondaryComment {
                                        Text(verbatim: secondaryComment).font(.comment)
                                }
                        }
                        .hidden()
                        HStack(spacing: 14) {
                                SerialNumberLabel(index)
                                Text(verbatim: candidate.text).font(.candidate).animation(nil, value: 0)
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
