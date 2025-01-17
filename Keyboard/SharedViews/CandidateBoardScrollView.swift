import SwiftUI
import CommonExtensions
import CoreIME

struct CandidateBoardScrollView: View {

        @EnvironmentObject private var context: KeyboardViewController

        @State private var isLongPressActionTriggered: Bool = false
        @State private var isReleaseActionTriggered: Bool = false

        @Namespace private var topID

        var body: some View {
                let characterStandard: CharacterStandard = Options.characterStandard
                let commentStyle: CommentStyle = Options.commentStyle
                let toneStyle: CommentToneStyle = Options.commentToneStyle
                let isCompactKeyboard: Bool = context.keyboardInterface.isCompact
                let rows = context.candidates.boardRows(keyboardWidth: context.keyboardWidth)
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
                        .onChange(of: context.candidateState) { _ in
                                withAnimation {
                                        proxy.scrollTo(topID, anchor: .top)
                                }
                        }
                }
        }
}
