import SwiftUI

struct CandidateBoard: View {

        @EnvironmentObject private var context: AppContext

        private let pageOrientation: CandidatePageOrientation = AppSettings.candidatePageOrientation
        private let commentStyle: CommentDisplayStyle = AppSettings.commentDisplayStyle
        private let toneStyle: ToneDisplayStyle = AppSettings.toneDisplayStyle
        private let toneColor: ToneDisplayColor = AppSettings.toneDisplayColor
        private let lineSpacing: CGFloat = CGFloat(AppSettings.candidateLineSpacing)

        var body: some View {
                let highlightedIndex: Int = context.highlightedIndex
                let horizontalPageAlignment: VerticalAlignment = {
                        switch commentStyle {
                        case .top:
                                return .lastTextBaseline
                        case .bottom:
                                return .firstTextBaseline
                        case .right:
                                return .center
                        case .noComments:
                                return .center
                        }
                }()
                switch pageOrientation {
                case .horizontal:
                        HStack(alignment: horizontalPageAlignment, spacing: 0) {
                                ForEach(0..<context.displayCandidates.count, id: \.self) { index in
                                        HorizontalPageCandidateLabel(
                                                isHighlighted: index == highlightedIndex,
                                                index: index,
                                                candidate: context.displayCandidates[index],
                                                commentStyle: commentStyle,
                                                toneStyle: toneStyle,
                                                toneColor: toneColor
                                        )
                                        .padding(.vertical, 4)
                                        .padding(.trailing, 4)
                                        .padding(.horizontal, lineSpacing / 2.0)
                                        .foregroundStyle(index == highlightedIndex ? Color.white : Color.primary)
                                        .background(index == highlightedIndex ? Color.accentColor : Color.clear, in: RoundedRectangle(cornerRadius: 5, style: .continuous))
                                }
                        }
                        .padding(4)
                        .roundedHUDVisualEffect()
                        .padding(10)
                        .fixedSize()
                case .vertical:
                        VStack(alignment: .leading, spacing: 0) {
                                ForEach(0..<context.displayCandidates.count, id: \.self) { index in
                                        ZStack(alignment: .leading) {
                                                HStack {
                                                        Color.clear
                                                        Spacer()
                                                        Color.clear
                                                }
                                                .background(index == highlightedIndex ? Color.accentColor : Color.clear, in: RoundedRectangle(cornerRadius: 5, style: .continuous))
                                                VerticalPageCandidateLabel(
                                                        isHighlighted: index == highlightedIndex,
                                                        index: index,
                                                        candidate: context.displayCandidates[index],
                                                        commentStyle: commentStyle,
                                                        toneStyle: toneStyle,
                                                        toneColor: toneColor
                                                )
                                                .padding(.horizontal, 4)
                                                .padding(.vertical, lineSpacing / 2.0)
                                                .foregroundStyle(index == highlightedIndex ? Color.white : Color.primary)
                                                .fixedSize()
                                        }
                                }
                        }
                        .padding(4)
                        .roundedHUDVisualEffect()
                        .padding(10)
                        .fixedSize()
                }
        }
}
