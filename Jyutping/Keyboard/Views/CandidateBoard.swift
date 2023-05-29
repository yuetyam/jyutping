import SwiftUI
import CoreIME

struct CandidateBoard: View {

        @EnvironmentObject private var context: KeyboardViewController

        @Namespace private var topID

        private let collapseWidth: CGFloat = 44
        private let collapseHeight: CGFloat = 44

        private func rows(of candidates: [Candidate]) -> [[Candidate]] {
                let keyboardWidth: CGFloat = context.keyboardWidth
                var rows: [[Candidate]] = []
                var row: [Candidate] = []
                var rowWidth: CGFloat = 0
                for candidate in candidates {
                        let maxWidth: CGFloat = rows.isEmpty ? (keyboardWidth - collapseWidth) : keyboardWidth
                        let length: CGFloat = candidateWidth(of: candidate)
                        if rowWidth < (maxWidth - length) {
                                row.append(candidate)
                                rowWidth += length
                        } else {
                                rows.append(row)
                                row = [candidate]
                                rowWidth = length
                        }
                }
                return rows
        }
        private func candidateWidth(of candidate: Candidate) -> CGFloat {
                switch candidate.type {
                case .emoji, .symbol:
                        return 44
                default:
                        return CGFloat(candidate.text.count * 20 + 28)
                }
        }

        var body: some View {
                let commentStyle: CommentStyle = Options.commentStyle
                let candidateRows = rows(of: context.candidates)
                ZStack(alignment: .topTrailing) {
                        ScrollViewReader { proxy in
                                ScrollView(.vertical) {
                                        LazyVStack(spacing: 0) {
                                                EmptyView().id(topID)
                                                ForEach(0..<candidateRows.count, id: \.self) { index in
                                                        let rowCandidates: [Candidate] = candidateRows[index]
                                                        HStack(spacing: 0) {
                                                                ForEach(0..<rowCandidates.count, id: \.self) { deepIndex in
                                                                        let candidate = rowCandidates[deepIndex]
                                                                        ZStack {
                                                                                Color.interactiveClear
                                                                                switch commentStyle {
                                                                                case .aboveCandidates:
                                                                                        VStack {
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
                                                                                        .padding(2)
                                                                                case .belowCandidates:
                                                                                        VStack {
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
                                                                                        .padding(2)
                                                                                case .noComments:
                                                                                        Text(verbatim: candidate.text)
                                                                                                .lineLimit(1)
                                                                                                .font(.candidate)
                                                                                                .padding(4)
                                                                                }
                                                                        }
                                                                        .frame(maxWidth: .infinity)
                                                                        .contentShape(Rectangle())
                                                                        .onTapGesture {
                                                                                AudioFeedback.inputed()
                                                                                context.triggerSelectionHapticFeedback()
                                                                                context.operate(.select(candidate))
                                                                                withAnimation {
                                                                                        proxy.scrollTo(topID)
                                                                                }
                                                                        }
                                                                }
                                                                if index == 0 {
                                                                        Color.clear.frame(width: collapseWidth)
                                                                }
                                                        }
                                                        Divider()
                                                }
                                        }
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        Image(systemName: "chevron.up")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .frame(width: collapseWidth, height: collapseHeight)
                                .background(Material.ultraThin, in: RoundedRectangle(cornerRadius: 4, style: .continuous))
                                .contentShape(Rectangle())
                                .onTapGesture {
                                        AudioFeedback.modified()
                                        context.triggerHapticFeedback()
                                        context.updateKeyboardForm(to: context.previousKeyboardForm)
                                }
                }
        }
}
