import SwiftUI
import CommonExtensions
import CoreIME

struct CandidateBarScrollView: View {

        @EnvironmentObject private var context: KeyboardViewController

        @State private var isLongPressActionTriggered: Bool = false
        @State private var isReleaseActionTriggered: Bool = false

        @Namespace private var startID

        var body: some View {
                let characterStandard: CharacterStandard = Options.characterStandard
                let commentStyle: CommentStyle = Options.commentStyle
                let toneStyle: CommentToneStyle = Options.commentToneStyle
                let isCompactKeyboard: Bool = context.keyboardInterface.isCompact
                ScrollViewReader { proxy in
                        ScrollView(.horizontal) {
                                LazyHStack(spacing: 0) {
                                        EmptyView().id(startID)
                                        ForEach(context.candidates.indices, id: \.self) { index in
                                                let candidate = context.candidates[index]
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
                                                                        .padding(.horizontal, 1)
                                                                        .padding(.bottom, 12)
                                                                case .belowCandidates:
                                                                        VStack(spacing: -2) {
                                                                                Text(text)
                                                                                        .font(isCompactKeyboard ? .candidate : .iPadCandidate)
                                                                                        .minimumScaleFactor(0.4)
                                                                                        .lineLimit(1)
                                                                                RomanizationLabel(candidate: candidate, toneStyle: toneStyle)
                                                                        }
                                                                        .padding(.horizontal, 1)
                                                                        .padding(.bottom, 8)
                                                                case .noComments:
                                                                        Text(text)
                                                                                .font(isCompactKeyboard ? .candidate : .iPadCandidate)
                                                                                .minimumScaleFactor(0.4)
                                                                                .lineLimit(1)
                                                                                .padding(.horizontal, 1)
                                                                                .padding(.bottom, 8)
                                                                }
                                                        }
                                                        .frame(width: candidate.width)
                                                        .frame(maxHeight: .infinity)
                                                }
                                        }
                                }
                        }
                        .onChange(of: context.candidatesState) { _ in
                                withAnimation {
                                        proxy.scrollTo(startID)
                                }
                        }
                }
        }
}
