import SwiftUI

struct CandidateBoard: View {

        @EnvironmentObject private var context: AppContext

        private let toneStyle: ToneDisplayStyle = AppSettings.toneDisplayStyle
        private let toneColor: ToneDisplayColor = AppSettings.toneDisplayColor
        private let verticalPadding: CGFloat = CGFloat(AppSettings.candidateLineSpacing) / 2.0

        var body: some View {
                let highlightedIndex = context.highlightedIndex
                VStack(alignment: .leading, spacing: 0) {
                        ForEach(0..<context.displayCandidates.count, id: \.self) { index in
                                CandidateLabel(
                                        candidate: context.displayCandidates[index],
                                        index: index,
                                        highlightedIndex: highlightedIndex,
                                        toneStyle: toneStyle,
                                        toneColor: toneColor,
                                        verticalPadding: verticalPadding
                                )
                        }
                }
                .padding(8)
                .roundedHUDVisualEffect()
                .fixedSize()
        }
}
