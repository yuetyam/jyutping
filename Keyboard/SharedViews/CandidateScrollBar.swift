import SwiftUI
import CoreIME

extension Candidate {
        var width: CGFloat {
                switch self.type {
                case .cantonese:
                        return CGFloat(self.text.count * 20 + 28)
                default:
                        guard self.text.count > 1 else { return 48 }
                        return CGFloat(self.text.count * 12)
                }
        }
}

struct CandidateScrollBar: View {

        @EnvironmentObject private var context: KeyboardViewController

        @Namespace private var topID

        @State private var isLongPressActionTriggered: Bool = false
        @State private var isReleaseActionTriggered: Bool = false

        private let expanderWidth: CGFloat = 44

        var body: some View {
                let characterStandard: CharacterStandard = Options.characterStandard
                let commentStyle: CommentStyle = Options.commentStyle
                let commentToneStyle: CommentToneStyle = Options.commentToneStyle
                let isCompactKeyboard: Bool = context.keyboardInterface.isCompact
                HStack(spacing: 0) {
                        ScrollViewReader { proxy in
                                ScrollView(.horizontal) {
                                        LazyHStack(spacing: 0) {
                                                EmptyView().id(topID)
                                                ForEach(context.candidates.indices, id: \.self) { index in
                                                        let candidate = context.candidates[index]
                                                        let text: AttributedString = candidate.text.attributed(for: characterStandard)
                                                        ScrollViewButton(
                                                                longPressTime: 400_000_000, // 0.4s
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
                                                                                        RomanizationLabel(candidate: candidate, toneStyle: commentToneStyle)
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
                                .frame(width: context.keyboardWidth - expanderWidth, height: PresetConstant.toolBarHeight)
                                .onChange(of: context.candidatesState) { _ in
                                        proxy.scrollTo(topID)
                                }
                        }
                        Button {
                                AudioFeedback.modified()
                                context.triggerHapticFeedback()
                                context.updateKeyboardForm(to: .candidateBoard)
                        } label: {
                                ZStack {
                                        ZStack(alignment: .leading) {
                                                Color.interactiveClear
                                                Rectangle().fill(Color.black).opacity(0.3).frame(width: 1, height: 24)
                                        }
                                        Image.downChevron
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 20, height: 20)
                                }
                        }
                        .buttonStyle(.plain)
                        .frame(width: expanderWidth, height: PresetConstant.toolBarHeight)
                }
        }
}
