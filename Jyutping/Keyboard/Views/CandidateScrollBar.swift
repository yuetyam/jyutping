import SwiftUI
import CoreIME

struct CandidateScrollBar: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                HStack(spacing: 0) {
                        ScrollView(.horizontal) {
                                LazyHStack(spacing: 0) {
                                        ForEach(0..<context.candidates.count, id: \.self) { index in
                                                let candidate = context.candidates[index]
                                                ZStack {
                                                        Color.interactiveClear
                                                        VStack {
                                                                Text(verbatim: candidate.isCantonese ? candidate.romanization : String.space)
                                                                        .minimumScaleFactor(0.2)
                                                                        .lineLimit(1)
                                                                        .font(.romanization)
                                                                Text(verbatim: candidate.text)
                                                                        .lineLimit(1)
                                                                        .font(.candidate)
                                                        }
                                                        .padding(1)
                                                }
                                                .frame(width: candidateWidth(of: candidate))
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
                        return CGFloat(candidate.text.count * 20 + 20)
                }
        }
}
