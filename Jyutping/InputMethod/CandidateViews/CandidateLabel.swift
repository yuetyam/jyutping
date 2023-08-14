import SwiftUI

struct CandidateLabel: View {

        init(candidate: DisplayCandidate, index: Int, highlightedIndex: Int, toneStyle: ToneDisplayStyle, toneColor: ToneDisplayColor, verticalPadding: CGFloat) {
                let isHighlighted: Bool = index == highlightedIndex
                self.candidate = candidate
                self.label = (index == 9) ? "0" : "\(index + 1)"
                self.isHighlighted = isHighlighted
                self.toneStyle = toneStyle
                self.toneColor = toneColor
                self.verticalPadding = verticalPadding
                self.labelForeColor = isHighlighted ? Color.white : Color.secondary
                self.foreColor = isHighlighted ? Color.white : Color.primary
                self.backColor = isHighlighted ? Color.accentColor : Color.clear
        }

        private let candidate: DisplayCandidate
        private let label: String
        private let isHighlighted: Bool
        private let toneStyle: ToneDisplayStyle
        private let toneColor: ToneDisplayColor
        private let verticalPadding: CGFloat
        private let labelForeColor: Color
        private let foreColor: Color
        private let backColor: Color

        var body: some View {
                HStack(spacing: 0) {
                        HStack(spacing: 16) {
                                Text(verbatim: label).font(.label).foregroundColor(labelForeColor)
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
                .background(backColor, in: RoundedRectangle(cornerRadius: 5, style: .continuous))
        }
}
