import SwiftUI
import CommonExtensions
import CoreIME

@available(iOS 17.0, *)
@available(iOSApplicationExtension 17.0, *)
struct CandidateBoardScrollViewIOS17: View {

        @EnvironmentObject private var context: KeyboardViewController

        @State private var isLongPressActionTriggered: Bool = false
        @State private var isReleaseActionTriggered: Bool = false

        private let topID: Int = -1000
        @State private var positionID: Int? = nil

        var body: some View {
                let characterStandard: CharacterStandard = Options.characterStandard
                let commentStyle: CommentStyle = Options.commentStyle
                let toneStyle: CommentToneStyle = Options.commentToneStyle
                let isCompactKeyboard: Bool = context.keyboardInterface.isCompact
                let rows = context.candidates.boardRows(keyboardWidth: context.keyboardWidth)
                ScrollView(.vertical) {
                        LazyVStack(spacing: 0) {
                                ForEach(rows) { row in
                                        EmptyView().id(topID)
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
                                                                        // context.triggerHapticFeedback()
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
                                                                        // context.triggerSelectionHapticFeedback()
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
                .scrollPosition(id: $positionID, anchor: .top)
                .defaultScrollAnchor(.top)
                .onChange(of: context.candidatesState) {
                        withAnimation {
                                positionID = topID
                        }
                }
                .sensoryFeedback(.success, trigger: isLongPressActionTriggered, condition: { $0.negative && $1 })
                .sensoryFeedback(.selection, trigger: isReleaseActionTriggered, condition: { $0.negative && $1 })
        }
}
