import SwiftUI
import CommonExtensions
import CoreIME

@available(iOS 18.0, *)
@available(iOSApplicationExtension 18.0, *)
struct CandidateBoardScrollViewIOS18: View {

        @EnvironmentObject private var context: KeyboardViewController

        @State private var isLongPressActionTriggered: Bool = false
        @State private var isReleaseActionTriggered: Bool = false

        @State private var scrollPosition = ScrollPosition()

        var body: some View {
                let characterStandard: CharacterStandard = Options.characterStandard
                let commentStyle: CommentStyle = Options.commentStyle
                let toneStyle: CommentToneStyle = Options.commentToneStyle
                let isCompactKeyboard: Bool = context.keyboardInterface.isCompact
                let rows = context.candidates.boardRows(keyboardWidth: context.keyboardWidth)
                ScrollView(.vertical) {
                        LazyVStack(spacing: 0) {
                                ForEach(rows) { row in
                                        HStack(spacing: 0) {
                                                ForEach(row.elements) { element in
                                                        let candidate = element.candidate
                                                        let text: AttributedString = candidate.text.attributed(for: characterStandard)
                                                        ScrollViewButton(
                                                                longPressTime: 400_000_000, // 0.4s
                                                                longPressAction: {
                                                                        guard isReleaseActionTriggered.negative else { return }
                                                                        defer { isLongPressActionTriggered = true }
                                                                        AudioFeedback.deleted()
                                                                        context.triggerHapticFeedback()
                                                                        UserLexicon.removeItem(candidate: candidate)
                                                                },
                                                                endAction: {
                                                                        Task {
                                                                                try await Task.sleep(nanoseconds: 500_000_000) // 0.5s
                                                                                isLongPressActionTriggered = false
                                                                                isReleaseActionTriggered = false
                                                                        }
                                                                },
                                                                releaseAction: {
                                                                        guard isLongPressActionTriggered.negative else { return }
                                                                        defer { isReleaseActionTriggered = true }
                                                                        AudioFeedback.inputed()
                                                                        context.triggerSelectionHapticFeedback()
                                                                        context.operate(.select(candidate))
                                                                }
                                                        ) {
                                                                ZStack {
                                                                        Color.interactiveClear
                                                                        switch commentStyle {
                                                                        case .aboveCandidates:
                                                                                VStack(spacing: -2) {
                                                                                        RomanizationLabel(candidate: candidate, toneStyle: toneStyle)
                                                                                        Text(text)
                                                                                                .font(isCompactKeyboard ? .candidate : .iPadCandidate)
                                                                                                .minimumScaleFactor(0.4)
                                                                                                .lineLimit(1)
                                                                                }
                                                                                .padding(2)
                                                                        case .belowCandidates:
                                                                                VStack(spacing: -2) {
                                                                                        Text(text)
                                                                                                .font(isCompactKeyboard ? .candidate : .iPadCandidate)
                                                                                                .minimumScaleFactor(0.4)
                                                                                                .lineLimit(1)
                                                                                        RomanizationLabel(candidate: candidate, toneStyle: toneStyle)
                                                                                }
                                                                                .padding(2)
                                                                        case .noComments:
                                                                                Text(text)
                                                                                        .font(isCompactKeyboard ? .candidate : .iPadCandidate)
                                                                                        .minimumScaleFactor(0.4)
                                                                                        .lineLimit(1)
                                                                                        .padding(4)
                                                                        }
                                                                }
                                                                .frame(minWidth: candidate.width, maxWidth: .infinity, minHeight: PresetConstant.collapseHeight)
                                                        }
                                                }
                                                if row.identifier == CandidateBoardRow.minIdentifier {
                                                        Color.clear.frame(width: PresetConstant.collapseWidth)
                                                }
                                        }
                                        Divider()
                                }
                        }
                }
                .scrollPosition($scrollPosition, anchor: .top)
                .defaultScrollAnchor(.top)
                .defaultScrollAnchor(.top, for: .initialOffset)
                .defaultScrollAnchor(.top, for: .alignment)
                .defaultScrollAnchor(.top, for: .sizeChanges)
                .onChange(of: context.candidatesState) {
                        withAnimation {
                                scrollPosition.scrollTo(edge: .top)
                        }
                }
        }
}