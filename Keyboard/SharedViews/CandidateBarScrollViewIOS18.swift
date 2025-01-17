import SwiftUI
import CommonExtensions
import CoreIME

@available(iOS 18.0, *)
@available(iOSApplicationExtension 18.0, *)
struct CandidateBarScrollViewIOS18: View {

        @EnvironmentObject private var context: KeyboardViewController

        @State private var isLongPressActionTriggered: Bool = false
        @State private var isReleaseActionTriggered: Bool = false

        @State private var scrollPosition = ScrollPosition()

        var body: some View {
                let characterStandard: CharacterStandard = Options.characterStandard
                let commentStyle: CommentStyle = Options.commentStyle
                let toneStyle: CommentToneStyle = Options.commentToneStyle
                let isCompactKeyboard: Bool = context.keyboardInterface.isCompact
                ScrollView(.horizontal) {
                        LazyHStack(spacing: 0) {
                                ForEach(context.candidates.indices, id: \.self) { index in
                                        let candidate = context.candidates[index]
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
                                                        ZStack(alignment: commentStyle.isBelow ? .bottom : .top) {
                                                                Color.clear
                                                                RomanizationLabel(candidate: candidate, toneStyle: toneStyle)
                                                                        .frame(height: 20)
                                                                        .padding(.horizontal, 1)
                                                                        .padding(.bottom, commentStyle.isBelow ? 6 : 0)
                                                        }
                                                        .opacity(commentStyle.isHidden ? 0 : 1)
                                                        Text(text)
                                                                .font(isCompactKeyboard ? .candidate : .iPadCandidate)
                                                                .minimumScaleFactor(0.4)
                                                                .lineLimit(1)
                                                                .padding(.bottom, commentStyle.isBelow ? 14 : 0)
                                                }
                                                .frame(width: candidate.width)
                                                .frame(maxHeight: .infinity)
                                        }
                                }
                        }
                }
                .scrollPosition($scrollPosition, anchor: .leading)
                .defaultScrollAnchor(.leading)
                .defaultScrollAnchor(.leading, for: .initialOffset)
                .defaultScrollAnchor(.leading, for: .alignment)
                .defaultScrollAnchor(.leading, for: .sizeChanges)
                .onChange(of: context.candidateState) {
                        withAnimation {
                                scrollPosition.scrollTo(edge: .leading)
                        }
                }
                .sensoryFeedback(.success, trigger: isLongPressActionTriggered, condition: { $0.negative && $1 })
                .sensoryFeedback(.selection, trigger: isReleaseActionTriggered, condition: { $0.negative && $1 })
        }
}
