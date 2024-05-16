import SwiftUI

struct CandidateBoard: View {

        @EnvironmentObject private var context: AppContext

        private let commentStyle: CommentDisplayStyle = AppSettings.commentDisplayStyle
        private let toneStyle: ToneDisplayStyle = AppSettings.toneDisplayStyle
        private let toneColor: ToneDisplayColor = AppSettings.toneDisplayColor
        private let lineSpacing: CGFloat = CGFloat(AppSettings.candidateLineSpacing)

        var body: some View {
                let highlightedIndex: Int = context.highlightedIndex
                let orientation: CandidatePageOrientation = AppSettings.candidatePageOrientation
                switch orientation {
                case .vertical:
                        VStack(alignment: .leading, spacing: 0) {
                                ForEach(0..<context.displayCandidates.count, id: \.self) { index in
                                        CandidateLabel(
                                                candidate: context.displayCandidates[index],
                                                index: index,
                                                highlightedIndex: highlightedIndex,
                                                commentStyle: commentStyle,
                                                toneStyle: toneStyle,
                                                toneColor: toneColor,
                                                lineSpacing: lineSpacing
                                        )
                                }
                        }
                        .padding(4)
                        .roundedHUDVisualEffect()
                        .padding(10)
                        .fixedSize()
                case .horizontal:
                        HStack(alignment: .lastTextBaseline, spacing: 0) {
                                ForEach(0..<context.displayCandidates.count, id: \.self) { index in
                                        AltCandidateLabel(
                                                candidate: context.displayCandidates[index],
                                                index: index,
                                                highlightedIndex: highlightedIndex,
                                                commentStyle: commentStyle,
                                                toneStyle: toneStyle,
                                                toneColor: toneColor,
                                                lineSpacing: lineSpacing
                                        )
                                }
                        }
                        .padding(4)
                        .roundedHUDVisualEffect()
                        .padding(10)
                        .fixedSize()
                }
        }
}
