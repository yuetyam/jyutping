import SwiftUI

struct CandidateLabel: View {

        let candidate: DisplayCandidate
        let index: Int
        let toneStyle: ToneDisplayStyle
        let toneColor: ToneDisplayColor
        let verticalPadding: CGFloat
        let foreColor: Color
        let backColor: Color

        var body: some View {
                let serialNumber: String = index == 9 ? "0" : "\(index + 1)"
                HStack(spacing: 0) {
                        HStack(spacing: 16) {
                                Text(verbatim: serialNumber).font(.label)
                                Text(verbatim: candidate.text).font(.candidate)
                                if let comment = candidate.comment {
                                        CommentLabel(comment, toneStyle: toneStyle, toneColor: toneColor, foreColor: foreColor)
                                }
                                if let secondaryComment = candidate.secondaryComment {
                                        Text(verbatim: secondaryComment).font(.comment)
                                }
                        }
                        Spacer()
                        Color.clear.frame(width: 1, height: 1)
                }
                .padding(.leading, 8)
                .padding(.vertical, verticalPadding)
                .foregroundColor(foreColor)
                .background(backColor, in: RoundedRectangle(cornerRadius: 4, style: .continuous))
        }
}
