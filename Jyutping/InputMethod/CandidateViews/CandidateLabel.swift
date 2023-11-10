import SwiftUI

struct CandidateLabel: View {

        init(candidate: DisplayCandidate, index: Int, highlightedIndex: Int, toneStyle: ToneDisplayStyle, toneColor: ToneDisplayColor, verticalPadding: CGFloat) {
                let isHighlighted: Bool = index == highlightedIndex
                let foreColor: Color = isHighlighted ? Color.white : Color.primary
                let shouldModifyToneColor: Bool = toneColor != .normal
                self.candidate = candidate
                self.label = (index == 9) ? "0" : "\(index + 1)"
                self.isHighlighted = isHighlighted
                self.toneStyle = toneStyle
                self.toneColor = shouldModifyToneColor ? foreColor.opacity(0.66) : foreColor
                self.shouldModifyToneColor = shouldModifyToneColor
                self.verticalPadding = verticalPadding
                self.labelForeColor = isHighlighted ? Color.white : Color.secondary
                self.foreColor = foreColor
                self.backColor = isHighlighted ? Color.accentColor : Color.clear
        }

        private let candidate: DisplayCandidate
        private let label: String
        private let isHighlighted: Bool
        private let toneStyle: ToneDisplayStyle
        private let toneColor: Color
        private let shouldModifyToneColor: Bool
        private let verticalPadding: CGFloat
        private let labelForeColor: Color
        private let foreColor: Color
        private let backColor: Color

        var body: some View {
                HStack(spacing: 0) {
                        HStack(spacing: 16) {
                                Text(verbatim: label).font(.label).foregroundStyle(labelForeColor)
                                Text(verbatim: candidate.text).font(.candidate)
                                if let comment = candidate.comment {
                                        CommentLabel(comment, candidateType: candidate.candidate.type, toneStyle: toneStyle, toneColor: toneColor, shouldModifyToneColor: shouldModifyToneColor)
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
                .foregroundStyle(foreColor)
                .background(backColor, in: RoundedRectangle(cornerRadius: 5, style: .continuous))
        }
}
