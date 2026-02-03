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

        private let savedCommentStyle: CommentStyle = Options.commentStyle
        private let commentScene: CommentScene = Options.commentScene
        private let toneStyle: CommentToneStyle = Options.commentToneStyle
        private let isCompatibleModeOn: Bool = Options.isCompatibleModeOn

        var body: some View {
                let characterStandard: CharacterStandard = context.characterStandard
                let commentStyle: CommentStyle = switch commentScene {
                case .all: savedCommentStyle
                case .reverseLookup: context.isReverseLookup ? savedCommentStyle : .noComments
                case .noneOfAll: .noComments
                }
                let isCompactKeyboard: Bool = context.keyboardInterface.isCompact
                let romanizationTopPadding: CGFloat = commentStyle.isBelow ? 22 : 0
                let romanizationBottomPadding: CGFloat = commentStyle.isBelow ? 0 : 36
                let textTopPadding: CGFloat = commentStyle.isBelow ? 0 : 2
                let textBottomPadding: CGFloat = commentStyle.isBelow ? 14 : 0
                ScrollView(.horizontal) {
                        LazyHStack(spacing: 0) {
                                ForEach(context.candidates.indices, id: \.self) { index in
                                        let candidate = context.candidates[index]
                                        let text: AttributedString = candidate.text.attributed(for: characterStandard)
                                        let romanization: String? = candidate.isCantonese ? candidate.comment : nil
                                        ScrollViewButton(
                                                longPressTime: 400, // 0.4s
                                                longPressAction: {
                                                        guard isReleaseActionTriggered.negative else { return }
                                                        defer { isLongPressActionTriggered = true }
                                                        AudioFeedback.deleted()
                                                        // context.triggerHapticFeedback()
                                                        InputMemory.forget(candidate.lexicon)
                                                },
                                                endAction: {
                                                        Task {
                                                                try await Task.sleep(for: .milliseconds(500)) // 0.5s
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
                                                        RomanizationLabel(romanization: romanization, toneStyle: toneStyle, compatibleMode: isCompatibleModeOn)
                                                                .frame(height: 20)
                                                                .padding(.horizontal, 1)
                                                                .padding(.top, romanizationTopPadding)
                                                                .padding(.bottom, romanizationBottomPadding)
                                                                .opacity(commentStyle.isHidden ? 0 : 1)
                                                        Text(text)
                                                                .font(isCompactKeyboard ? .candidate : .iPadCandidate)
                                                                .minimumScaleFactor(0.4)
                                                                .lineLimit(1)
                                                                .padding(.top, textTopPadding)
                                                                .padding(.bottom, textBottomPadding)
                                                }
                                                .frame(width: candidate.width)
                                                .frame(maxHeight: .infinity)
                                        }
                                }
                        }
                }
                .scrollIndicators(.hidden)
                .scrollPosition($scrollPosition, anchor: .leading)
                .defaultScrollAnchor(.leading)
                .onChange(of: context.candidateState) {
                        withAnimation {
                                scrollPosition.scrollTo(edge: .leading)
                        }
                }
                .sensoryFeedback(.success, trigger: isLongPressActionTriggered, condition: { $0.negative && $1 })
                .sensoryFeedback(.selection, trigger: isReleaseActionTriggered, condition: { $0.negative && $1 })
        }
}
