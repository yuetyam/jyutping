import SwiftUI
import CoreIME

struct CandidateScrollBar: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                let commentStyle: CommentStyle = Options.commentStyle
                HStack(spacing: 0) {
                        ScrollView(.horizontal) {
                                LazyHStack(spacing: 0) {
                                        ForEach(0..<context.candidates.count, id: \.self) { index in
                                                let candidate = context.candidates[index]
                                                ZStack {
                                                        Color.interactiveClear
                                                        switch commentStyle {
                                                        case .aboveCandidates:
                                                                VStack(spacing: -2) {
                                                                        if candidate.isCantonese {
                                                                                Text(verbatim: candidate.romanization)
                                                                                        .minimumScaleFactor(0.2)
                                                                                        .lineLimit(1)
                                                                                        .font(.romanization)
                                                                        }
                                                                        Text(verbatim: candidate.text)
                                                                                .lineLimit(1)
                                                                                .font(.candidate)
                                                                }
                                                                .padding(.horizontal, 1)
                                                                .padding(.bottom, 8)
                                                        case .belowCandidates:
                                                                VStack(spacing: -2) {
                                                                        Text(verbatim: candidate.text)
                                                                                .lineLimit(1)
                                                                                .font(.candidate)
                                                                        if candidate.isCantonese {
                                                                                Text(verbatim: candidate.romanization)
                                                                                        .minimumScaleFactor(0.2)
                                                                                        .lineLimit(1)
                                                                                        .font(.romanization)
                                                                        }
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
                switch candidate.type {
                case .emoji, .symbol:
                        return 44
                default:
                        return CGFloat(candidate.text.count * 20 + 28)
                }
        }
}
