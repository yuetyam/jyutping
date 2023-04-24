import SwiftUI

struct CandidateBoard: View {

        @EnvironmentObject private var context: AppContext

        private let toneStyle: ToneDisplayStyle = AppSettings.toneDisplayStyle
        private let toneColor: ToneDisplayColor = AppSettings.toneDisplayColor
        private let verticalPadding: CGFloat = CGFloat(AppSettings.candidateLineSpacing) / 2.0

        var body: some View {
                let placeholder: DisplayCandidate = context.placeholder
                let highlightedIndex = context.highlightedIndex
                VStack(alignment: .leading, spacing: 0) {
                        ForEach(0..<context.displayCandidates.count, id: \.self) { index in
                                let isHighlighted: Bool = index == highlightedIndex
                                let foreColor: Color = isHighlighted ? Color.white : Color.primary
                                let backColor: Color = isHighlighted ? Color.accentColor : Color.clear
                                CandidateLabel(
                                        candidate: context.displayCandidates[index],
                                        placeholder: placeholder,
                                        index: index,
                                        toneStyle: toneStyle,
                                        toneColor: toneColor,
                                        verticalPadding: verticalPadding,
                                        foreColor: foreColor,
                                        backColor: backColor
                                )
                        }
                }
                .padding(8)
                .roundedHUDVisualEffect()
                .fixedSize()
        }
}
