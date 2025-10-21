import SwiftUI
import CommonExtensions
import CoreIME

@available(iOS, deprecated: 17.0, message: "Use newer versions instead")
@available(iOSApplicationExtension, deprecated: 17.0, message: "Use newer versions instead")
struct CandidateBoardScrollView: View {

        @EnvironmentObject private var context: KeyboardViewController

        @State private var isLongPressActionTriggered: Bool = false
        @State private var isReleaseActionTriggered: Bool = false

        @Namespace private var topID

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
                ScrollViewReader { proxy in
                        ScrollView(.vertical) {
                                LazyVStack(spacing: 0) {
                                        EmptyView().id(topID)
                                        ForEach(rows) { row in
                                                HStack(alignment: rowAlignment, spacing: 0) {
                                                        ForEach(row.elements) { element in
                                                                let candidate = element.candidate
                                                                let text: AttributedString = candidate.text.attributed(for: characterStandard)
                                                                let romanization: String? = candidate.isCantonese ? candidate.romanization : nil
                                                                ScrollViewButton(
                                                                        longPressTime: 400_000_000, // 0.4s
                                                                        longPressAction: {
                                                                                guard isReleaseActionTriggered.negative else { return }
                                                                                defer { isLongPressActionTriggered = true }
                                                                                AudioFeedback.deleted()
                                                                                context.triggerHapticFeedback()
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
                                                                                context.triggerSelectionHapticFeedback()
                                                                                context.operate(.select(candidate))
                                                                        }
                                                                ) {
                                                                        ZStack {
                                                                                Color.interactiveClear
                                                                                switch commentStyle {
                                                                                case .aboveCandidates:
                                                                                        VStack(spacing: -2) {
                                                                                                RomanizationLabel(romanization: romanization, toneStyle: toneStyle, compatibleMode: isCompatibleModeOn)
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
                                                                                                RomanizationLabel(romanization: romanization, toneStyle: toneStyle, compatibleMode: isCompatibleModeOn)
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
                        .scrollIndicators(.hidden)
                        .onChange(of: context.candidateState) { _ in
                                withAnimation {
                                        proxy.scrollTo(topID, anchor: .top)
                                }
                        }
                }
        }
}
