import SwiftUI
import CoreIME

extension Candidate {
        var width: CGFloat {
                return CGFloat(self.text.count * 20 + 28)
        }
}

struct CandidateScrollBar: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                let commentStyle: CommentStyle = Options.commentStyle
                let commentToneStyle: CommentToneStyle = Options.commentToneStyle
                HStack(spacing: 0) {
                        ScrollView(.horizontal) {
                                LazyHStack(spacing: 0) {
                                        ForEach(0..<context.candidates.count, id: \.self) { index in
                                                let candidate = context.candidates[index]
                                                ScrollViewButton {
                                                        AudioFeedback.inputed()
                                                        context.triggerSelectionHapticFeedback()
                                                        context.operate(.select(candidate))
                                                } label: {
                                                        ZStack {
                                                                Color.interactiveClear
                                                                switch commentStyle {
                                                                case .aboveCandidates:
                                                                        VStack(spacing: -2) {
                                                                                RomanizationLabel(candidate: candidate, toneStyle: commentToneStyle)
                                                                                Text(verbatim: candidate.text)
                                                                                        .lineLimit(1)
                                                                                        .font(.candidate)
                                                                        }
                                                                        .padding(.horizontal, 1)
                                                                case .belowCandidates:
                                                                        VStack(spacing: -2) {
                                                                                Text(verbatim: candidate.text)
                                                                                        .lineLimit(1)
                                                                                        .font(.candidate)
                                                                                RomanizationLabel(candidate: candidate, toneStyle: commentToneStyle)
                                                                        }
                                                                        .padding(.horizontal, 1)
                                                                case .noComments:
                                                                        Text(verbatim: candidate.text)
                                                                                .lineLimit(1)
                                                                                .font(.candidate)
                                                                                .padding(.horizontal, 1)
                                                                }
                                                        }
                                                        .frame(width: candidate.width)
                                                        .frame(maxHeight: .infinity)
                                                }
                                        }
                                }
                        }
                        .frame(width: context.keyboardWidth - expanderWidth, height: Constant.toolBarHeight)
                        ZStack {
                                Color.interactiveClear
                                HStack {
                                        Rectangle().fill(Color.black).opacity(0.3).frame(width: 1, height: 24)
                                        Spacer()
                                }
                                Image.downChevron
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                        }
                        .frame(width: expanderWidth, height: Constant.toolBarHeight)
                        .contentShape(Rectangle())
                        .onTapGesture {
                                AudioFeedback.modified()
                                context.triggerHapticFeedback()
                                context.updateKeyboardForm(to: .candidateBoard)
                        }
                }
        }

        private let expanderWidth: CGFloat = 44
}
