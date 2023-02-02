import SwiftUI

struct CandidateLabel: View {

        let candidate: DisplayCandidate
        let placeholder: DisplayCandidate
        let index: Int
        let isHighlighted: Bool
        let toneStyle: ToneDisplayStyle
        let toneColor: ToneDisplayColor
        let verticalPadding: CGFloat
        let foreColor: Color
        let backColor: Color

        var body: some View {
                let serialNumber: String = index == 9 ? "0" : "\(index + 1)"
                ZStack(alignment: .leading) {
                        HStack(spacing: 16) {
                                Text(verbatim: serialNumber).font(.label)
                                Text(verbatim: placeholder.text).font(.candidate).disableAnimation()
                                if let comment = placeholder.comment {
                                        CommentLabel(comment, toneStyle: toneStyle, toneColor: toneColor, foreColor: foreColor)
                                }
                                if let secondaryComment = placeholder.secondaryComment {
                                        Text(verbatim: secondaryComment).font(.comment)
                                }
                        }
                        .hidden()
                        HStack(spacing: 16) {
                                Text(verbatim: serialNumber).font(.label)
                                Text(verbatim: candidate.text).font(.candidate).disableAnimation()
                                if let comment = candidate.comment {
                                        CommentLabel(comment, toneStyle: toneStyle, toneColor: toneColor, foreColor: foreColor)
                                }
                                if let secondaryComment = candidate.secondaryComment {
                                        Text(verbatim: secondaryComment).font(.comment)
                                }
                        }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, verticalPadding)
                .foregroundColor(foreColor)
                .background(backColor, in: RoundedRectangle(cornerRadius: 4, style: .continuous))
        }
}
