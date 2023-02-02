import SwiftUI

struct CandidateBoard: View {

        @EnvironmentObject private var displayObject: DisplayObject

        private let toneStyle: ToneDisplayStyle = AppSettings.toneDisplayStyle
        private let toneColor: ToneDisplayColor = AppSettings.toneDisplayColor
        private let verticalPadding: CGFloat = CGFloat(AppSettings.candidateLineSpacing) / 2.0

        var body: some View {
                let placeholder: DisplayCandidate = displayObject.longest
                VStack(alignment: .leading, spacing: 0) {
                        ForEach(0..<displayObject.items.count, id: \.self) { index in
                                let candidate = displayObject.items[index]
                                let isHighlighted: Bool = index == displayObject.highlightedIndex
                                let foreColor: Color = isHighlighted ? Color.white : Color.primary
                                let backColor: Color = isHighlighted ? Color.accentColor : Color.clear
                                CandidateLabel(candidate: candidate, placeholder: placeholder, index: index, isHighlighted: isHighlighted, toneStyle: toneStyle, toneColor: toneColor, verticalPadding: verticalPadding, foreColor: foreColor, backColor: backColor)
                        }
                }
                .animation(.default, value: displayObject.animationState)
                .padding(8)
                .roundedHUDVisualEffect()
        }
}
