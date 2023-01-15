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
