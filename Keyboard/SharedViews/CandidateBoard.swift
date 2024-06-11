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

        @State private var isLongPressActionTriggered: Bool = false
        @State private var isReleaseActionTriggered: Bool = false

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
                let lastRow = Row(identifier: rowID, elements: cache)
                rows.append(lastRow)
                return rows
        }

        var body: some View {
                let characterStandard: CharacterStandard = Options.characterStandard
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
                                                                        let text: AttributedString = candidate.text.attributed(for: characterStandard)
                                                                        ScrollViewButton(
                                                                                longPressTime: 0.4,
                                                                                longPressAction: {
                                                                                        guard !isReleaseActionTriggered else { return }
                                                                                        defer { isLongPressActionTriggered = true }
                                                                                        AudioFeedback.deleted()
                                                                                        context.triggerHapticFeedback()
                                                                                        UserLexicon.removeItem(candidate: candidate)
                                                                                },
                                                                                endAction: {
                                                                                        withAnimation(.default.delay(0.5)) {
                                                                                                isLongPressActionTriggered = false
                                                                                                isReleaseActionTriggered = false
                                                                                        }
                                                                                },
                                                                                releaseAction: {
                                                                                        guard !isLongPressActionTriggered else { return }
                                                                                        defer { isReleaseActionTriggered = true }
                                                                                        AudioFeedback.inputed()
                                                                                        context.triggerSelectionHapticFeedback()
                                                                                        context.operate(.select(candidate))
                                                                                        withAnimation {
                                                                                                proxy.scrollTo(topID)
                                                                                        }
                                                                                }
                                                                        ) {
                                                                                ZStack {
                                                                                        Color.interactiveClear
                                                                                        switch commentStyle {
                                                                                        case .aboveCandidates:
                                                                                                VStack(spacing: -2) {
                                                                                                        RomanizationLabel(candidate: candidate, toneStyle: commentToneStyle)
                                                                                                        Text(text)
                                                                                                                .font(.candidate)
                                                                                                                .minimumScaleFactor(0.4)
                                                                                                                .lineLimit(1)
                                                                                                }
                                                                                                .padding(2)
                                                                                        case .belowCandidates:
                                                                                                VStack(spacing: -2) {
                                                                                                        Text(text)
                                                                                                                .font(.candidate)
                                                                                                                .minimumScaleFactor(0.4)
                                                                                                                .lineLimit(1)
                                                                                                        RomanizationLabel(candidate: candidate, toneStyle: commentToneStyle)
                                                                                                }
                                                                                                .padding(2)
                                                                                        case .noComments:
                                                                                                Text(text)
                                                                                                        .font(.candidate)
                                                                                                        .minimumScaleFactor(0.4)
                                                                                                        .lineLimit(1)
                                                                                                        .padding(4)
                                                                                        }
                                                                                }
                                                                                .frame(minWidth: candidate.width, maxWidth: .infinity, minHeight: collapseHeight)
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
                                .padding(12)
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
