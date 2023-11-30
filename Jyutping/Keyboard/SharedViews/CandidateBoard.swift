import SwiftUI
import CoreIME

private struct Element: Hashable, Identifiable {
        let identifier: Int
        let candidate: Candidate
        var id: Int {
                return identifier
        }
}
private struct Row: Hashable, Identifiable {
        let identifier: Int
        let elements: [Element]
        var id: Int {
                return identifier
        }
}

struct CandidateBoard: View {

        @EnvironmentObject private var context: KeyboardViewController

        @Namespace private var topID

        private let collapseWidth: CGFloat = 44
        private let collapseHeight: CGFloat = 44

        private let minRowIdentifier: Int = 1000
        private let minElementIdentifier: Int = 5000

        private func rows(of candidates: [Candidate]) -> [Row] {
                let keyboardWidth: CGFloat = context.keyboardWidth
                var rows: [Row] = []
                var cache: [Element] = []
                var rowID: Int = minRowIdentifier
                var rowWidth: CGFloat = 0
                for index in 0..<candidates.count {
                        let elementID: Int = index + minElementIdentifier
                        let candidate = candidates[index]
                        let element = Element(identifier: elementID, candidate: candidate)
                        let maxWidth: CGFloat = rows.isEmpty ? (keyboardWidth - collapseWidth) : keyboardWidth
                        let length: CGFloat = candidate.width
                        if rowWidth < (maxWidth - length) {
                                cache.append(element)
                                rowWidth += length
                        } else {
                                let row = Row(identifier: rowID, elements: cache)
                                rows.append(row)
                                cache = [element]
                                rowID += 1
                                rowWidth = length
                        }
                }
                return rows
        }

        var body: some View {
                let commentStyle: CommentStyle = Options.commentStyle
                let commentToneStyle: CommentToneStyle = Options.commentToneStyle
                let rows = rows(of: context.candidates)
                ZStack(alignment: .topTrailing) {
                        ScrollViewReader { proxy in
                                ScrollView(.vertical) {
                                        LazyVStack(spacing: 0) {
                                                EmptyView().id(topID)
                                                ForEach(rows) { row in
                                                        HStack(spacing: 0) {
                                                                ForEach(row.elements) { element in
                                                                        let candidate = element.candidate
                                                                        ScrollViewButton {
                                                                                AudioFeedback.inputed()
                                                                                context.triggerSelectionHapticFeedback()
                                                                                context.operate(.select(candidate))
                                                                                withAnimation {
                                                                                        proxy.scrollTo(topID)
                                                                                }
                                                                        } label: {
                                                                                ZStack {
                                                                                        Color.interactiveClear
                                                                                        switch commentStyle {
                                                                                        case .aboveCandidates:
                                                                                                VStack(spacing: -2) {
                                                                                                        RomanizationLabel(candidate: candidate, toneStyle: commentToneStyle)
                                                                                                        Text(verbatim: candidate.text)
                                                                                                                .font(.candidate)
                                                                                                                .minimumScaleFactor(0.4)
                                                                                                                .lineLimit(1)
                                                                                                }
                                                                                                .padding(2)
                                                                                        case .belowCandidates:
                                                                                                VStack(spacing: -2) {
                                                                                                        Text(verbatim: candidate.text)
                                                                                                                .font(.candidate)
                                                                                                                .minimumScaleFactor(0.4)
                                                                                                                .lineLimit(1)
                                                                                                        RomanizationLabel(candidate: candidate, toneStyle: commentToneStyle)
                                                                                                }
                                                                                                .padding(2)
                                                                                        case .noComments:
                                                                                                Text(verbatim: candidate.text)
                                                                                                        .font(.candidate)
                                                                                                        .minimumScaleFactor(0.4)
                                                                                                        .lineLimit(1)
                                                                                                        .padding(4)
                                                                                        }
                                                                                }
                                                                                .frame(maxWidth: .infinity)
                                                                        }
                                                                }
                                                                if row.identifier == minRowIdentifier {
                                                                        Color.clear.frame(width: collapseWidth)
                                                                }
                                                        }
                                                        Divider()
                                                }
                                        }
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        Image.upChevron
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
