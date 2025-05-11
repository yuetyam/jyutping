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
                let rowAlignment: VerticalAlignment = switch commentStyle {
                case .aboveCandidates: .lastTextBaseline
                case .belowCandidates: .firstTextBaseline
                case .noComments: .center
                }
                let toneStyle: CommentToneStyle = Options.commentToneStyle
                let isCompatibleModeOn: Bool = Options.isCompatibleModeOn
                let isCompactKeyboard: Bool = context.keyboardInterface.isCompact
                let rows = context.candidates.boardRows(keyboardWidth: context.keyboardWidth)
                ScrollView(.vertical) {
                        LazyVStack(spacing: 0) {
                                ForEach(rows) { row in
                                        HStack(alignment: rowAlignment, spacing: 0) {
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
                                                                                        RomanizationLabel(candidate: candidate, toneStyle: toneStyle, compatibleMode: isCompatibleModeOn)
                                                                                        Text(text)
                                                                                                .font(isCompactKeyboard ? .candidate : .iPadCandidate)
                                                                                                .minimumScaleFactor(0.4)
                                                                                                .lineLimit(1)
                                                                                }
                                                                                .padding(.bottom, 1)
                                                                        case .belowCandidates:
                                                                                VStack(spacing: -2) {
                                                                                        Text(text)
                                                                                                .font(isCompactKeyboard ? .candidate : .iPadCandidate)
                                                                                                .minimumScaleFactor(0.4)
                                                                                                .lineLimit(1)
                                                                                        RomanizationLabel(candidate: candidate, toneStyle: toneStyle, compatibleMode: isCompatibleModeOn)
                                                                                }
                                                                        case .noComments:
                                                                                Text(text)
                                                                                        .font(isCompactKeyboard ? .candidate : .iPadCandidate)
                                                                                        .minimumScaleFactor(0.4)
                                                                                        .lineLimit(1)
                                                                        }
                                                                }
                                                                .frame(minWidth: candidate.width, maxWidth: .infinity, minHeight: PresetConstant.collapseHeight)
                                                        }
                                                }
                                        }
                                        .padding(.trailing, row.identifier == CandidateBoardRow.minIdentifier ? PresetConstant.collapseWidth : 0)
                                        Divider()
                                }
                        }
                }
                .scrollPosition($scrollPosition, anchor: .top)
                .defaultScrollAnchor(.top)
                .defaultScrollAnchor(.top, for: .initialOffset)
                .defaultScrollAnchor(.top, for: .alignment)
                .defaultScrollAnchor(.top, for: .sizeChanges)
                .onChange(of: context.candidateState) {
                        withAnimation {
                                scrollPosition.scrollTo(edge: .top)
                        }
                }
                .sensoryFeedback(.success, trigger: isLongPressActionTriggered, condition: { $0.negative && $1 })
                .sensoryFeedback(.selection, trigger: isReleaseActionTriggered, condition: { $0.negative && $1 })
        }
}
