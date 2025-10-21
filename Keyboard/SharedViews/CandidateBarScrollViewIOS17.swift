import SwiftUI
import CommonExtensions
import CoreIME

@available(iOS, introduced: 17.0, deprecated: 18.0, message: "Use newer versions instead")
@available(iOSApplicationExtension, introduced: 17.0, deprecated: 18.0, message: "Use newer versions instead")
struct CandidateBarScrollViewIOS17: View {

        @EnvironmentObject private var context: KeyboardViewController

        @State private var isLongPressActionTriggered: Bool = false
        @State private var isReleaseActionTriggered: Bool = false

        private let leadingPointID: Int = -1000
        @State private var positionID: Int? = nil

        var body: some View {
                let characterStandard: CharacterStandard = Options.characterStandard
                let commentStyle: CommentStyle = Options.commentStyle
                let toneStyle: CommentToneStyle = Options.commentToneStyle
                let isCompatibleModeOn: Bool = Options.isCompatibleModeOn
                let isCompactKeyboard: Bool = context.keyboardInterface.isCompact
                let romanizationTopPadding: CGFloat = commentStyle.isBelow ? 22 : 0
                let romanizationBottomPadding: CGFloat = commentStyle.isBelow ? 0 : 36
                let textTopPadding: CGFloat = commentStyle.isBelow ? 0 : 2
                let textBottomPadding: CGFloat = commentStyle.isBelow ? 14 : 0
                ScrollView(.horizontal) {
                        LazyHStack(spacing: 0) {
                                EmptyView().id(leadingPointID)
                                ForEach(context.candidates.indices, id: \.self) { index in
                                        let candidate = context.candidates[index]
                                        let text: AttributedString = candidate.text.attributed(for: characterStandard)
                                        let romanization: String? = candidate.isCantonese ? candidate.romanization : nil
                                        ScrollViewButton(
                                                longPressTime: 400_000_000, // 0.4s
                                                longPressAction: {
                                                        guard isReleaseActionTriggered.negative else { return }
                                                        defer { isLongPressActionTriggered = true }
                                                        AudioFeedback.deleted()
                                                        // context.triggerHapticFeedback()
                                                        InputMemory.remove(candidate: candidate)
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
                .scrollPosition(id: $positionID, anchor: .leading)
                .defaultScrollAnchor(.leading)
                .onChange(of: context.candidateState) {
                        withAnimation {
                                positionID = leadingPointID
                        }
                }
                .sensoryFeedback(.success, trigger: isLongPressActionTriggered, condition: { $0.negative && $1 })
                .sensoryFeedback(.selection, trigger: isReleaseActionTriggered, condition: { $0.negative && $1 })
        }
}
