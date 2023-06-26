import SwiftUI
import CoreIME

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
                                                ZStack {
                                                        Color.interactiveClear
                                                        switch commentStyle {
                                                        case .aboveCandidates:
                                                                VStack {
                                                                        RomanizationLabel(candidate: candidate, toneStyle: commentToneStyle)
                                                                        Text(verbatim: candidate.text)
                                                                                .lineLimit(1)
                                                                                .font(.candidate)
                                                                }
                                                                .padding(.horizontal, 1)
                                                                .padding(.bottom, 8)
                                                        case .belowCandidates:
                                                                VStack {
                                                                        Text(verbatim: candidate.text)
                                                                                .lineLimit(1)
                                                                                .font(.candidate)
                                                                        RomanizationLabel(candidate: candidate, toneStyle: commentToneStyle)
                                                                }
                                                                .padding(.horizontal, 1)
                                                                .padding(.bottom, 8)
                                                        case .noComments:
                                                                Text(verbatim: candidate.text)
                                                                        .lineLimit(1)
                                                                        .font(.candidate)
                                                                        .padding(.horizontal, 1)
                                                                        .padding(.bottom, 4)
                                                        }
                                                }
                                                .frame(width: candidateWidth(of: candidate))
                                                .frame(maxHeight: .infinity)
                                                .contentShape(Rectangle())
                                                .onTapGesture {
                                                        AudioFeedback.inputed()
                                                        context.triggerSelectionHapticFeedback()
                                                        context.operate(.select(candidate))
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
                                Image(systemName: "chevron.down")
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

        private func candidateWidth(of candidate: Candidate) -> CGFloat {
                return CGFloat(candidate.text.count * 20 + 28)
        }
}
